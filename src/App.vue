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
:root {
  --header-height: 120px;
  --sidebar-width: 260px;
  --sidebar-padding: 5%;
  --toggle-size: 44px;
  --toggle-shadow: 4px 0 6px -2px rgba(0, 0, 0, 0.2);
}

html, body, #app {
  margin: 0;
  height: 100%;
  width: 100%;
  
}

.app-container {
  display: flex;
  flex-direction: column;
  height: 100vh
}

header, footer {
  flex: 0 0 auto;
}

.main-layout {
  display: flex;   
  flex: 1 1 0;     
  min-height: 0;  
}


.feed {
  flex: 1;            
  padding: 0 5%;       
  overflow-y: auto;
  height: 100%; 
  box-sizing: border-box;
  min-height: 0;
  -webkit-overflow-scrolling: touch;
}

</style>
