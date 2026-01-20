<script setup>
import AppHeader from './components/AppHeader.vue'
import AppSidebar from './components/AppSidebar.vue'
import ContentFeed from './components/ContentFeed.vue'
import AppFooter from './components/AppFooter.vue'

import { ref, computed, watch } from 'vue'
import { communities, posts } from './data/dummyData'

const active = ref(
  new Set(JSON.parse(localStorage.getItem('filters')) || communities)
)

watch(active, () => {
  localStorage.setItem('filters', JSON.stringify([...active.value]))
}, { deep: true })

const filteredPosts = computed(() => 
  posts
    .filter(p => active.value.has(p.category))
    .sort((a, b) => {
      const [aH, aM] = a.time.split(':').map(Number)
      const [bH, bM] = b.time.split(':').map(Number)
      return bH - aH || bM - aM
    })
)


</script>

<template>
  <div class="app-container">

    <AppHeader />

    <div class="main-layout">
      <AppSidebar :communities="communities" :active="active" />

      <ContentFeed class="feed" :posts="filteredPosts" />
    </div>

    <AppFooter />
  </div>
</template>

<style>
/* BODY RESET */
html, body, #app {
  margin: 0;
  height: 100%;
  width: 100%;
}

/* APP CONTAINER */
.app-container {
  display: flex;
  flex-direction: column;
  height: 100vh; /* volle Höhe */
}

/* HEADER & FOOTER */
header, footer {
  flex: 0 0 auto;
}

/* MAIN LAYOUT */
.main-layout {
  display: flex;
  flex: 1 1 0;
  overflow: hidden; /* wichtig, damit nur Feed scrollt */
}

/* FEED SCROLL */
.feed {
  flex: 1 1 0;
  overflow-y: auto; /* scroll nur hier */
  padding: 30px;
  background: var(--bg);
}
</style>
