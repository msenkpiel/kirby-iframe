panel.plugin("msenkpiel/iframe", {
    components: {
        'msenkpiel.iframe': {
            template: `
				<k-panel-inside>
				        <k-header> {{ title }} </k-header>
						<k-section ref="sectionElement">
							<iframe
							    v-if="url"
							    :src="url"
							    loading="lazy"
							    ref="frameElement"
							    style="width: 100%"
                            />
                            <div v-else>
                                No url provided.
                            </div>
						</k-section>
				</k-panel-inside>
			`,
            props: {
                title: String,
                url: String,
                breakpoints: Array
            },
            mounted: function () {

                this.$nextTick(function () {

                    const section = this.$refs.sectionElement;
                    const frame = this.$refs.frameElement;
                    let intervalId = null;
                    let frameHeight = 0;

                    const setFrameHeight = () => {
                        for (const breakpointWidth in this.breakpoints) {
                            if (section.$el.getBoundingClientRect().width >= breakpointWidth) {
                                frame.height = this.breakpoints[breakpointWidth];
                            }
                        }
                    }

                    window.addEventListener('resize', (event) => {
                        clearTimeout(intervalId);
                        intervalId = setTimeout(setFrameHeight, 500);
                    });

                    setFrameHeight();
                });
            }
        },
    },
});
