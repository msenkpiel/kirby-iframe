#!/usr/bin/env sh
set -eu

APP_DIR="/var/www/html"
PLUGIN_SOURCE="/plugin"
PLUGIN_TARGET="${APP_DIR}/site/plugins/kirby-iframe"

KIRBY_VERSION="${KIRBY_VERSION:-^5}"
KIRBY_ADMIN_EMAIL="${KIRBY_ADMIN_EMAIL:-admin@example.test}"
KIRBY_ADMIN_PASSWORD="${KIRBY_ADMIN_PASSWORD:-admin1234}"
IFRAME_URL="${IFRAME_URL:-/iframe-target}"

if [ ! -f "${APP_DIR}/kirby/router.php" ]; then
    echo "Installing Kirby Plainkit..."
    composer create-project --no-interaction --prefer-dist getkirby/plainkit "${APP_DIR}"

    if [ -n "${KIRBY_VERSION}" ]; then
        composer --working-dir="${APP_DIR}" require --no-interaction --prefer-dist "getkirby/cms:${KIRBY_VERSION}"
    fi
fi

mkdir -p "${APP_DIR}/site/plugins"
rm -rf "${PLUGIN_TARGET}"
ln -s "${PLUGIN_SOURCE}" "${PLUGIN_TARGET}"

mkdir -p "${APP_DIR}/site/config"
cat > "${APP_DIR}/site/config/config.php" <<'PHP'
<?php

return [
    'debug' => true,
    'panel' => [
        'install' => false
    ],
    'msenkpiel.iframe' => [
        'label' => 'iFrame Test',
        'icon' => 'box',
        'title' => 'iFrame Test',
        'url' => getenv('IFRAME_URL') ?: '/iframe-target',
        'breakpoints' => [
            0 => 500,
            768 => 720,
            1200 => 900
        ]
    ],
    'routes' => [
        [
            'pattern' => 'iframe-target',
            'action' => function () {
                return new Kirby\Cms\Response(
                    '<!doctype html><html lang="en"><head><meta charset="utf-8"><title>Kirby iframe target</title><style>body{font-family:system-ui,sans-serif;margin:0;padding:2rem;background:#f4f6f8;color:#17202a}main{max-width:48rem;margin:auto}code{background:#fff;padding:.15rem .3rem;border-radius:.25rem}</style></head><body><main><h1>Kirby iframe target</h1><p>This local page is rendered inside the <code>kirby-iframe</code> Panel area.</p></main></body></html>',
                    'text/html'
                );
            }
        ]
    ]
];
PHP

php "${APP_DIR}/vendor/autoload.php" >/dev/null 2>&1 || true
php <<'PHP'
<?php

require '/var/www/html/vendor/autoload.php';

$kirby = new Kirby\Cms\App([
    'roots' => [
        'index' => '/var/www/html',
        'site' => '/var/www/html/site'
    ]
]);

$email = getenv('KIRBY_ADMIN_EMAIL') ?: 'admin@example.test';
$password = getenv('KIRBY_ADMIN_PASSWORD') ?: 'admin1234';

$kirby->impersonate('kirby');

if ($kirby->users()->findBy('email', $email) === null) {
    $kirby->users()->create([
        'email' => $email,
        'name' => 'admin',
        'password' => $password,
        'role' => 'admin',
        'language' => 'en'
    ]);

    echo "Created Kirby Panel admin: {$email}\n";
} else {
    echo "Kirby Panel admin already exists: {$email}\n";
}
PHP

echo "Starting Kirby on http://0.0.0.0:8000"
exec php -S 0.0.0.0:8000 "${APP_DIR}/kirby/router.php"
