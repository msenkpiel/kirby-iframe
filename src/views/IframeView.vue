<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue';

const props = defineProps({
    title: {
        type: String,
        default: 'iFrame',
    },
    url: {
        type: String,
        default: '',
    },
    breakpoints: {
        type: [Array, Object],
        default: () => ({
            0: 500,
        }),
    },
});

const frameElement = ref(null);
const sectionElement = ref(null);

let resizeObserver = null;
let resizeTimeout = null;

const normalizedBreakpoints = computed(() => {
    return Object.entries(props.breakpoints ?? {})
        .map(([width, height]) => ({
            width: Number(width),
            height: Number(height),
        }))
        .filter((breakpoint) => Number.isFinite(breakpoint.width) && Number.isFinite(breakpoint.height))
        .sort((a, b) => a.width - b.width);
});

const setFrameHeight = () => {
    const section = sectionElement.value?.$el ?? sectionElement.value;
    const frame = frameElement.value;

    if (section === undefined || frame === null) {
        return;
    }

    const sectionWidth = section.getBoundingClientRect().width;
    const matchingBreakpoint = normalizedBreakpoints.value.reduce((match, breakpoint) => {
        if (sectionWidth >= breakpoint.width) {
            return breakpoint;
        }

        return match;
    }, normalizedBreakpoints.value[0] ?? null);

    if (matchingBreakpoint !== null) {
        frame.height = String(matchingBreakpoint.height);
    }
};

const scheduleFrameHeight = () => {
    window.clearTimeout(resizeTimeout);
    resizeTimeout = window.setTimeout(setFrameHeight, 100);
};

onMounted(async () => {
    await nextTick();
    setFrameHeight();

    const section = sectionElement.value?.$el ?? sectionElement.value;

    if (section !== undefined && typeof window.ResizeObserver !== 'undefined') {
        resizeObserver = new window.ResizeObserver(scheduleFrameHeight);
        resizeObserver.observe(section);
    }

    window.addEventListener('resize', scheduleFrameHeight);
});

onBeforeUnmount(() => {
    window.clearTimeout(resizeTimeout);
    window.removeEventListener('resize', scheduleFrameHeight);
    resizeObserver?.disconnect();
});

watch(
    () => props.breakpoints,
    () => nextTick(setFrameHeight),
    {
        deep: true,
    },
);
</script>

<template>
    <k-panel-inside>
        <k-header>{{ title }}</k-header>

        <k-section ref="sectionElement">
            <iframe
                v-if="url"
                ref="frameElement"
                class="iframe-view-frame"
                :src="url"
                loading="lazy"
                title="iFrame"
            />

            <k-empty
                v-else
                icon="box"
            >
                No url provided.
            </k-empty>
        </k-section>
    </k-panel-inside>
</template>

<style>
.iframe-view-frame {
    display: block;
    width: 100%;
    border: 0;
}
</style>
