<script setup>
import { ref } from 'vue'
import bellLoud from '../assets/bell_loud.png'
import bellMuted from '../assets/bell_muted.png'

defineProps({
  communities: Array,
  active: Object
})

const sections = ref({
  communities: true,
  events: true,
  chats: true
})

const toggleSection = (name) => {
  sections.value[name] = !sections.value[name]
}

const toggleCommunity = (c) => {
  active.has(c) ? active.delete(c) : active.add(c)
}
</script>

<template>
  <aside>

    <!-- COMMUNITIES -->
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

    <!-- EVENTS -->
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

    <!-- CHATS -->
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


  </aside>
</template>

<style scoped>
aside {
  width: 22%;
  background: var(--white);
  border-right: 1px solid var(--border);
  padding: var(--space) 20px;
  display: flex;
  flex-direction: column;
  height: 100%; /* passt sich jetzt Main Layout an */
}


/* SECTION HEADER */
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

/* ITEMS */
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

/* BELL ICON */
.bell {
  width: 16px;
  height: 16px;
  flex-shrink: 0;
}

/* LINES */
.section-line {
  border: none;
  border-bottom: 1px solid var(--border);
  margin: 8px 0;
}

/* FOOTER */
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
