<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import bellLoud from '../assets/bell_loud.png'
import bellMuted from '../assets/bell_muted.png'

defineProps({
  communities: Array,
  active: Object,
})

const isOpen = ref(false)

const toggleSidebar = () => {
  isOpen.value = !isOpen.value
}

const handleClickOutside = (e) => {
  const sidebar = document.querySelector('.sidebar')
  const button = document.querySelector('.sidebar-toggle')

  if (
    isOpen.value &&
    sidebar &&
    !sidebar.contains(e.target) &&
    !button.contains(e.target)
  ) {
    isOpen.value = false
  }
}


onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})

const sections = ref({
  communities: true,
  events: true,
  chats: true,
})

const toggleSection = (name) => {
  sections.value[name] = !sections.value[name]
}

const toggleCommunity = (c) => {
  active.has(c) ? active.delete(c) : active.add(c)
}
</script>


<template>
  <div class="sidebar-container">
    <button
      class="sidebar-toggle"
      :class="{ open: isOpen }"
      @click.stop="toggleSidebar"
    >
      ☰
    </button>
  <aside class="sidebar" :class="{ open: isOpen }" @click.stop>


  <div class="sidebar-content" @click.stop>
    <section class="sidebar-section">
      <div class="section-header" @click="toggleSection('communities')">
        <span class="arrow">{{ sections.communities ? '▼' : '▶' }}</span>
        <h3>Communities</h3>
      </div>

      <div v-show="sections.communities">
        <div
          v-for="c in communities"
          :key="c"
          class="item"
          @click="toggleCommunity(c)"
        >
          <img
            class="bell"
            :src="active.has(c) ? bellLoud : bellMuted"
            alt="bell"
          />
          <span>{{ c }}</span>
        </div>
      </div>

      <hr class="section-line" />
    </section>




    <section class="sidebar-section">
      <div class="section-header" @click="toggleSection('events')">
        <span class="arrow">{{ sections.events ? '▼' : '▶' }}</span>
        <h3>Events</h3>
      </div>

      <div v-show="sections.events">
        <div class="item plain">Workshop</div>
        <div class="item plain">Exhibition</div>
      </div>

      <hr class="section-line" />
    </section>

    <section class="sidebar-section">
      <div class="section-header" @click="toggleSection('chats')">
        <span class="arrow">{{ sections.chats ? '▼' : '▶' }}</span>
        <h3>Chats</h3>
      </div>

      <div v-show="sections.chats">
        <div class="item plain">Photographers</div>
        <div class="item plain">Beginners</div>
      </div>

      <hr class="section-line" />
    </section>
    </div>


  </aside>
  </div>
</template>

<style>
.sidebar-container {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  z-index: 20; 
}


.sidebar {
  width: 260px;
  height: 100%;
  background: var(--white);
  border-right: 1px solid var(--border);
  transform: translateX(-220px); 
  transition: transform 0.3s ease;
  position: relative;
}

.sidebar-content {
  padding: 10%;
  box-sizing: border-box;
}


.sidebar.open {
  transform: translateX(0);
}


.sidebar-toggle {
  position: absolute;
  top: 20px;
  left: 40px; 
  width: 44px;
  height: 44px;
  background: var(--white);
  border-radius: 0 12px 12px 0;
  border: none;
  cursor: pointer;
  font-size: 20px;
  box-shadow: 4px 0 6px -2px rgba(0,0,0,0.2);
  transition: left 0.3s ease;
}


.sidebar-toggle.open {
  left: 260px; 
}

.section-header {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  user-select: none;
  padding-bottom: 6px;
}

.arrow {
  font-size: 0.8rem;
  width: 14px;
}

h3 {
  font-size: 0.85rem;
  text-transform: uppercase;
  margin: 0;
}

.item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 6px 0 6px 18px;
  cursor: pointer;
}

.item:hover {
  background: rgba(0,0,0,0.04);
}

.item.plain {
  padding-left: 32px;
}

.bell {
  width: 16px;
  height: 16px;
  flex-shrink: 0;
}

.section-line {
  border: none;
  border-bottom: 1px solid var(--border);
  margin: 8px 0;
}

.sidebar-footer {
  margin-top: auto;
  padding-top: 20px;
  text-align: center;
}

blockquote {
  font-size: 1.1rem;
  font-weight: 600;
}
</style>
