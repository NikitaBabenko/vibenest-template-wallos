# Wallos on VibeNest

This public fork preserves the Wallos source and GPL-3.0 license while adding a
small VibeNest deployment profile for the 256 MB Free server.

## Pinned upstream

- Wallos release: `v5.8.1`
- Upstream revision: `844cea04e3025f75494e954aaa67af7386d4840a`
- Runtime image: `bellamy/wallos:5.8.1`
- Pinned multi-platform digest:
  `sha256:0f049dbab45b9f8e8d43b84fd1b77ef9e55909bd1a384a0f4fe8597ab68a1d5d`

The adapter image inherits the matching official image and adds only PHP
runtime configuration. This keeps the deployment build small; it does not
compile Wallos or PHP extensions on the application server.

## Free-server profile

- PHP-FPM uses `ondemand` with at most 2 workers.
- PHP request memory is capped at 64 MB.
- Uploads are capped at 64 MB (`post_max_size` is 66 MB).
- Nginx, PHP-FPM and Wallos cron jobs still run as upstream designed.
- Internal HTTP port is 80.

The 64 MB upload limit is intentionally lower than upstream's 256 MB default.
It supports normal logo uploads and modest backup restores while leaving headroom
inside a 256 MB container. Large restores should use a larger hardware tier.

## Persistent state

Two named volumes are required and declared by `docker-compose.yaml`:

- `wallos-db` -> `/var/www/html/db` for SQLite data, migrations and settings.
- `wallos-logos` -> `/var/www/html/images/uploads/logos` for uploaded service
  logos and avatars.

Back up both volumes. Losing either volume loses user data or uploaded assets.

## First run and privacy

The first visitor creates the owner account. After that, Wallos defaults to
closed registrations. Create the owner account immediately after deployment,
use a unique password and keep the instance URL private until onboarding is
complete. Do not put real financial records in a public demo.

## Optional integrations

The core subscription tracker works without paid API keys. Currency exchange
updates via Fixer, AI recommendations, SMTP and third-party notification
channels are optional and require the user's own configuration. VibeNest does
not include or proxy credentials for those services.

## License and upstream

- Upstream: https://github.com/ellite/Wallos
- Release: https://github.com/ellite/Wallos/releases/tag/v5.8.1
- License: [GNU GPL v3](LICENSE.md)

Changes in this fork are clearly marked in this file and in the adapter
Dockerfile. Wallos remains Copyright its upstream contributors and is provided
without warranty under GPL-3.0.

