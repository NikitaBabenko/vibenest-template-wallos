# VibeNest runtime adapter for Wallos 5.8.1.
#
# The upstream source tree and GPL-3.0 license remain in this fork. Runtime is
# based on the matching official release image so a deploy does not recompile
# PHP extensions on a 256 MB application slot. The multi-platform image digest
# pins the exact upstream artifact published for v5.8.1.
FROM bellamy/wallos:5.8.1@sha256:0f049dbab45b9f8e8d43b84fd1b77ef9e55909bd1a384a0f4fe8597ab68a1d5d

LABEL org.opencontainers.image.source="https://github.com/NikitaBabenko/vibenest-template-wallos" \
      org.opencontainers.image.documentation="https://github.com/NikitaBabenko/vibenest-template-wallos/blob/main/VIBENEST.md" \
      org.opencontainers.image.licenses="GPL-3.0" \
      org.opencontainers.image.version="5.8.1-vibenest.1" \
      org.opencontainers.image.revision="844cea04e3025f75494e954aaa67af7386d4840a"

# The upstream image uses 15 dynamic PHP workers and 256 MB uploads. On the
# VibeNest Free profile (256 MB RAM / 0.5 vCPU), two on-demand workers keep the
# idle footprint small and cap request concurrency. A 64 MB request ceiling is
# enough for ordinary logo uploads and modest backup restores without letting a
# single request consume the whole container budget.
COPY vibenest/php-fpm.conf /usr/local/etc/php-fpm.d/zzzz-vibenest.conf
COPY vibenest/php.ini /usr/local/etc/php/conf.d/zzzz-vibenest.ini

EXPOSE 80
