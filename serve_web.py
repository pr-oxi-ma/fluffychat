#!/usr/bin/env python3
import http.server
import json
import mimetypes
import os
import sys

WEB_DIR = "/home/adnanshah6908/fluffychat/build/web"
PORT = 8080

mimetypes.add_type("application/wasm", ".wasm")
mimetypes.add_type("application/javascript", ".js")
mimetypes.add_type("application/json", ".json")

class SPAHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_DIR, **kwargs)

    def do_GET(self):
        if self.path.startswith('/.well-known/matrix/client'):
            body = json.dumps({"m.homeserver": {"base_url": "https://hs.llc.qzz.io"}}).encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.send_header('Content-Length', str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return

        clean_path = self.path.split('?')[0].split('#')[0].lstrip('/')
        full_path = os.path.join(WEB_DIR, clean_path)
        if not os.path.exists(full_path) or os.path.isdir(full_path):
            self.path = '/index.html'
        return super().do_GET()

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'credentialless')
        clean = self.path.split('?')[0].split('#')[0].rstrip('/')
        if clean.endswith('.html') or clean.endswith('.js') or clean.endswith('.wasm') or clean.endswith('.json') or clean == '' or clean == '/':
            self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
            self.send_header('Pragma', 'no-cache')
            self.send_header('Expires', '0')
        else:
            self.send_header('Cache-Control', 'public, max-age=3600')
        super().end_headers()

if __name__ == '__main__':
    server = http.server.ThreadingHTTPServer(('0.0.0.0', PORT), SPAHandler)
    print(f"Serving FluffyChat Web on port {PORT}...", flush=True)
    server.serve_forever()
