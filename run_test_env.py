#!/usr/bin/env python3
"""
Lightweight Test Runner: FluffyChat Web + Tuwunel Homeserver
Starts Tuwunel backend on port 8008 and serves FluffyChat Web on port 8080
with a transparent Matrix API reverse proxy.
"""

import http.client
import http.server
import json
import mimetypes
import os
import signal
import subprocess
import sys
import time
import urllib.parse

WEB_DIR = "/home/adnanshah6908/fluffychat/build/web"
TUWUNEL_BIN = "/home/adnanshah6908/bin/tuwunel"
TUWUNEL_CONFIG = "/home/adnanshah6908/tuwunel/tuwunel.toml"
TUWUNEL_HOST = "127.0.0.1"
TUWUNEL_PORT = 8008
PROXY_PORT = 8080

mimetypes.add_type("application/wasm", ".wasm")
mimetypes.add_type("application/javascript", ".js")
mimetypes.add_type("application/json", ".json")

tuwunel_proc = None

def cleanup(sig=None, frame=None):
    global tuwunel_proc
    print("\n[Test Runner] Shutting down Tuwunel...", flush=True)
    if tuwunel_proc and tuwunel_proc.poll() is None:
        tuwunel_proc.send_signal(signal.SIGINT)
        try:
            tuwunel_proc.wait(timeout=10)
        except subprocess.TimeoutExpired:
            tuwunel_proc.kill()
    print("[Test Runner] Clean exit.", flush=True)
    sys.exit(0)

signal.signal(signal.SIGINT, cleanup)
signal.signal(signal.SIGTERM, cleanup)

class TestAppHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_DIR, **kwargs)

    def do_OPTIONS(self):
        self.send_response(200)
        self._add_cors_headers()
        self.send_header('Content-Length', '0')
        self.end_headers()

    def do_GET(self):
        if self._is_matrix():
            self._proxy()
        elif self.path in ('/config.json', '/assets/config.json'):
            self._serve_config()
        elif self.path.startswith('/.well-known/matrix/client'):
            self._serve_well_known()
        else:
            clean_path = self.path.split('?')[0].split('#')[0].lstrip('/')
            full_path = os.path.join(WEB_DIR, clean_path)
            if not os.path.exists(full_path) or os.path.isdir(full_path):
                self.path = '/index.html'
            super().do_GET()

    def do_POST(self):
        if self._is_matrix():
            self._proxy()
        else:
            self.send_error(405)

    def do_PUT(self):
        if self._is_matrix():
            self._proxy()
        else:
            self.send_error(405)

    def do_DELETE(self):
        if self._is_matrix():
            self._proxy()
        else:
            self.send_error(405)

    def _is_matrix(self):
        return self.path.startswith('/_matrix')

    def _add_cors_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization')

    def _serve_config(self):
        host = self.headers.get('Host', f'127.0.0.1:{PROXY_PORT}')
        cfg = {
            "applicationName": "FluffyChat",
            "defaultHomeserver": host,
            "presetHomeserver": host,
            "welcomeText": "Simple, secure & privacy-first messaging",
            "sendTypingNotifications": True,
            "sendPublicReadReceipts": True,
            "shareOnlineStatus": True,
            "showPresences": True,
            "shareKeysWith": "all",
            "noEncryptionWarningShown": False,
            "enableSoftLogout": False,
            "doubleTapToReact": True
        }
        body = json.dumps(cfg, indent=2).encode('utf-8')
        self.send_response(200)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.send_header('Content-Length', str(len(body)))
        self._add_cors_headers()
        self.end_headers()
        self.wfile.write(body)

    def _serve_well_known(self):
        host = self.headers.get('Host', f'127.0.0.1:{PROXY_PORT}')
        proto = 'https' if ('cloudshell.dev' in host or self.headers.get('X-Forwarded-Proto') == 'https') else 'http'
        resp = {"m.homeserver": {"base_url": f"{proto}://{host}/"}}
        body = json.dumps(resp).encode('utf-8')
        self.send_response(200)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.send_header('Content-Length', str(len(body)))
        self._add_cors_headers()
        self.end_headers()
        self.wfile.write(body)

    def _proxy(self):
        try:
            content_length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(content_length) if content_length > 0 else None

            conn = http.client.HTTPConnection(TUWUNEL_HOST, TUWUNEL_PORT, timeout=30)
            headers = {k: v for k, v in self.headers.items() if k.lower() not in ('host', 'content-length')}
            headers['Host'] = f"{TUWUNEL_HOST}:{TUWUNEL_PORT}"
            if body is not None:
                headers['Content-Length'] = str(len(body))

            conn.request(self.command, self.path, body=body, headers=headers)
            res = conn.getresponse()
            res_body = res.read()

            self.send_response(res.status)
            for k, v in res.getheaders():
                if k.lower() not in ('transfer-encoding', 'content-length', 'access-control-allow-origin'):
                    self.send_header(k, v)
            self.send_header('Content-Length', str(len(res_body)))
            self._add_cors_headers()
            self.end_headers()
            self.wfile.write(res_body)
            conn.close()
        except Exception as e:
            self.send_response(502)
            self._add_cors_headers()
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            err_msg = json.dumps({"errcode": "M_UNKNOWN", "error": f"Proxy error: {str(e)}"}).encode('utf-8')
            self.send_header('Content-Length', str(len(err_msg)))
            self.end_headers()
            self.wfile.write(err_msg)

    def log_message(self, format, *args):
        # Keep logs clean
        sys.stderr.write(f"[Web 8080] {format % args}\n")

def main():
    global tuwunel_proc

    print("[1/2] Starting Tuwunel homeserver...", flush=True)
    tuwunel_proc = subprocess.Popen(
        [TUWUNEL_BIN, "-c", TUWUNEL_CONFIG],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

    print("Waiting for Tuwunel on port 8008...", flush=True)
    for _ in range(30):
        try:
            conn = http.client.HTTPConnection(TUWUNEL_HOST, TUWUNEL_PORT, timeout=1)
            conn.request("GET", "/_matrix/client/versions")
            res = conn.getresponse()
            if res.status == 200:
                print("Tuwunel is UP on port 8008!", flush=True)
                conn.close()
                break
            conn.close()
        except Exception:
            time.sleep(0.5)
    else:
        print("ERROR: Tuwunel failed to start on port 8008.", flush=True)
        cleanup()

    print(f"[2/2] Starting FluffyChat Web on port {PROXY_PORT}...", flush=True)
    server_address = ('0.0.0.0', PROXY_PORT)
    httpd = http.server.ThreadingHTTPServer(server_address, TestAppHandler)
    print(f"FluffyChat Web + Tuwunel ready at http://127.0.0.1:{PROXY_PORT}/", flush=True)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        cleanup()

if __name__ == "__main__":
    main()
