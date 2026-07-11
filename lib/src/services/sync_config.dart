enum AuthState { signedOut, optionalGoogleAvailable }

enum SyncState { localOnly, readyForFirebase, syncing, conflictNeedsReview }

class SyncStatus {
  const SyncStatus({
    required this.authState,
    required this.syncState,
    required this.lastBackupLabel,
  });

  final AuthState authState;
  final SyncState syncState;
  final String lastBackupLabel;

  bool get isSignedIn => authState != AuthState.signedOut;
}

class AdvancedFeatureFlag {
  const AdvancedFeatureFlag({
    required this.title,
    required this.enabled,
    required this.requirement,
  });

  final String title;
  final bool enabled;
  final String requirement;
}

const defaultSyncStatus = SyncStatus(
  authState: AuthState.signedOut,
  syncState: SyncState.readyForFirebase,
  lastBackupLabel: 'Not backed up yet',
);

const futureAdvancedFeatures = [
  AdvancedFeatureFlag(
    title: 'Password vault',
    enabled: false,
    requirement: 'Requires encryption, biometric unlock and secure backup before activation.',
  ),
  AdvancedFeatureFlag(
    title: 'ID documents',
    enabled: false,
    requirement: 'Requires secure file storage, encryption and user-controlled export/delete.',
  ),
  AdvancedFeatureFlag(
    title: 'SMS parsing',
    enabled: false,
    requirement: 'Requires explicit opt-in, privacy review and local-first parsing controls.',
  ),
  AdvancedFeatureFlag(
    title: 'Location history',
    enabled: false,
    requirement: 'Requires explicit opt-in, clear retention controls and background permission review.',
  ),
  AdvancedFeatureFlag(
    title: 'Online AI assistant',
    enabled: false,
    requirement: 'Offline summaries stay active until the user explicitly enables online AI later.',
  ),
];
