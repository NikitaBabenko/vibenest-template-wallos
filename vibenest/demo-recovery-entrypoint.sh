#!/bin/sh
set -eu

# One-time recovery path for the private VibeNest validation instance. The
# secret is injected transiently through the deployment environment and is
# never stored in the repository or database in plaintext.
if [ -n "${VIBENEST_DEMO_RECOVERY_PASSWORD:-}" ] && [ -f /var/www/html/db/wallos.db ]; then
  php -r '
    $db = new SQLite3("/var/www/html/db/wallos.db");
    $db->busyTimeout(5000);
    $hash = password_hash(getenv("VIBENEST_DEMO_RECOVERY_PASSWORD"), PASSWORD_DEFAULT);
    $stmt = $db->prepare("UPDATE user SET password = :password WHERE username = :username");
    $stmt->bindValue(":password", $hash, SQLITE3_TEXT);
    $stmt->bindValue(":username", "vibenest-demo-owner", SQLITE3_TEXT);
    if (!$stmt->execute()) {
      fwrite(STDERR, "Demo recovery failed.\n");
      exit(1);
    }
  '
fi

unset VIBENEST_DEMO_RECOVERY_PASSWORD
exec /var/www/html/startup.sh
