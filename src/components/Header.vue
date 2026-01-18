<template>
  <header class="header">
    <h2>BeeCreative</h2>
    <nav>
      <button @click="$emit('change-section','posts')">Posts</button>
      <button @click="$emit('change-section','nearby')">In deiner Nähe</button>
      <button @click="$emit('change-section','events')">Events</button>
    </nav>
  </header>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({ name: 'Header', emits: ['change-section'] });
</script>

<style scoped>
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  background: var(--header-bg);
  color: white;
}
nav button {
  margin-left: 10px;
  padding: 8px 12px;
  background: var(--primary-yellow);
  color: var(--text-color);
  font-weight: bold;
  border-radius: 8px;
}
</style>
