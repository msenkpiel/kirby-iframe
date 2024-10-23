# kirby-iframe
Plugin to add an iFrame to Kirby CMS

## Installation
```
composer require msenkpiel/kirby-iframe
```

## Config options
```
msenkpiel.iframe = [
    
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
```

