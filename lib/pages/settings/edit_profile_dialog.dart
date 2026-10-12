// SPDX-FileCopyrightText: 2026-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/widgets/avatar.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

class EditProfileDialog extends StatefulWidget {
  final Client client;
  final String initialDisplayName;
  final String initialUsername;
  final void Function()? onAvatarTap;

  const EditProfileDialog({
    required this.client,
    required this.initialDisplayName,
    required this.initialUsername,
    this.onAvatarTap,
    super.key,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nameController;
  String? _nameError;
  bool _isSaving = false;

  static const List<String> _forbiddenWords = [
    'fuck',
    'shit',
    'bitch',
    'porn',
    'sex',
    'nude',
    'asshole',
    'cunt',
    'dick',
    'pussy',
    'nigger',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialDisplayName);
    _nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateName);
    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    final raw = _nameController.text.trim();
    final lower = raw.toLowerCase();

    String? error;
    if (raw.isEmpty) {
      error = 'Display name cannot be empty';
    } else if (raw.length > 50) {
      error = 'Display name must be 50 characters or fewer';
    } else {
      for (final word in _forbiddenWords) {
        if (lower.contains(word)) {
          error = 'Name contains prohibited content';
          break;
        }
      }
    }

    if (error != _nameError) {
      setState(() {
        _nameError = error;
      });
    }
  }

  Future<void> _save() async {
    _validateName();
    if (_nameError != null) return;

    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final client = widget.client;
      if (client.userID != null) {
        await client.setProfileField(
          client.userID!,
          'displayname',
          {'displayname': name},
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Display name updated successfully')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update display name: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullMxid = widget.client.userID ?? '@${widget.initialUsername}';

    final canSave = !_isSaving && _nameError == null && _nameController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        actions: [
          TextButton(
            onPressed: canSave ? _save : null,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: canSave ? theme.colorScheme.primary : theme.disabledColor,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Avatar(
                    name: _nameController.text.isNotEmpty
                        ? _nameController.text
                        : widget.initialUsername,
                    size: Avatar.defaultSize * 2.2,
                  ),
                  if (widget.onAvatarTap != null)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: theme.colorScheme.primary,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          color: theme.colorScheme.onPrimary,
                          icon: const Icon(Icons.camera_alt),
                          onPressed: widget.onAvatarTap,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.onAvatarTap != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: widget.onAvatarTap,
                child: Text(
                  'Change profile photo',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Display Name field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
                hintText: 'Enter your name or nickname',
                prefixIcon: const Icon(Icons.person_outline),
                suffixIcon: _nameError != null
                    ? const Icon(Icons.error_outline, color: Colors.red)
                    : (_nameController.text.trim().isNotEmpty
                        ? const Icon(Icons.check_circle_outline, color: Colors.green)
                        : null),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: _nameError,
                helperText: 'Visible to everyone in chats and groups',
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (canSave) _save();
              },
            ),
            const SizedBox(height: 20),

            // Permanent Username / Matrix ID Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock_outline, size: 18, color: theme.colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        'Username (Matrix ID)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Permanent',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    fullMxid,
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'In decentralized Matrix protocol, your Matrix ID (@username) is permanent upon registration and cannot be renamed. You can change your Display Name above anytime.',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Bottom Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: canSave ? _save : null,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(
                  _isSaving ? 'Saving...' : 'Save Changes',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
