<?php
Kirby::plugin('msenkpiel/iframe', [
    'options' => [
        'label' => 'iFrame',
        'icon' => 'box',
        'title' => 'iFrame',
        'url' => '',
        'breakpoints' => [
            0 => 500
        ]
    ],
    'areas' => [
        'msenkpiel.iframe' => function ($kirby) {
            return [
                'label' => option('msenkpiel.iframe.nav.label'),
                'icon' => option('msenkpiel.iframe.nav.icon'),
                'disabled' => false,
                'menu' => true,
                'link' => 'ms-iframe',
                'views' => [
                    [
                        'pattern' => 'ms-iframe',
                        'action' => function () use ($kirby) {
                            return [
                                'component' => 'msenkpiel.iframe',
                                'title' => option('msenkpiel.iframe.title'),
                                'props' => [
                                    'title' => option('msenkpiel.iframe.title'),
                                    'url' => option('msenkpiel.iframe.url'),
                                    'breakpoints' => option('msenkpiel.iframe.breakpoints')
                                ],
                            ];
                        }
                    ]
                ]
            ];
        }
    ]
]);
