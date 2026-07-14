import IframeView from './views/IframeView.vue';

const registerPanelPlugin = function () {
    if (typeof window === 'undefined' || typeof window.panel === 'undefined') {
        return;
    }

    window.panel.plugin('msenkpiel/iframe', {
        components: {
            'msenkpiel.iframe': IframeView,
        },
    });
};

registerPanelPlugin();
