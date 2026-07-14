# kirby-iframe
Plugin to add an iFrame to Kirby Panel. 

![Desktop Screen](./doc/screen_desktop.png)

## Installation
```
composer require msenkpiel/kirby-iframe
```

## Config options

Due to the iframe security policies, it is not possible to read the height of the iFrame content and embed the frame at the appropriate height. Therefore, you can only define fixed heights for the iFrame. To ensure responsive behavior, it is possible to define breakpoints and corresponding iFrame heights.

![Mobile Screen](./doc/screen_mobile.png)

### Config

```php
// site/config/config.php
return [
    'msenkpiel.iframe' => [
        
         // panel navigation settings
        'label' => 'Navigation Label',
        'icon' => 'box',
        
        // panel frame title
        'title' => 'Frame title',
        
        // iframe url
        'url' => '',
        
        // iframe height based on container width
        'breakpoints' => [
            0 => 500, // mobile
            992 => 3000 // desktop
        ]
    ]
]
```

## Development

You can test the plugin locally without installing Kirby on your machine. The
Docker setup creates a temporary Kirby Plainkit installation, mounts this plugin
into `site/plugins/kirby-iframe` and starts Kirby's built-in PHP server.

### Docker test environment

```sh
make docker-up
```

- Website: <http://localhost:8080>
- Panel: <http://localhost:8080/panel>
- Login: `admin@example.test` / `admin1234`

The default Panel account is only intended for this local test environment. The
Docker setup configures Kirby's public URL as `http://localhost:8080` so Panel
redirects point to the host URL instead of the container bind address.

You can override the credentials, Kirby URL and iframe URL with environment
variables:

```sh
KIRBY_ADMIN_EMAIL=admin@example.test KIRBY_ADMIN_PASSWORD=admin1234 KIRBY_SITE_URL=http://localhost:8080 IFRAME_URL=/iframe-target make docker-up
```

To use a different host port, set both the published port and Kirby's public URL:

```sh
KIRBY_PORT=8081 KIRBY_SITE_URL=http://localhost:8081 make docker-up
```

To test with Kirby 4:

```sh
make docker-up-kirby4
```

To test with the Kirby 6 preview:

```sh
make docker-up-kirby6
```

To remove the temporary Kirby installation and start fresh:

```sh
make docker-reset
```

### Run Kirby-Up

The Panel view is built from a Vue component with kirbyup.

```sh
make install
make dev
make build
```

Run local build and Docker Compose config checks:

```sh
make test
```
