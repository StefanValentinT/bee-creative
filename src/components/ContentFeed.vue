<script setup>
import ContentCard from './ContentCard.vue'
defineProps({ posts: Array })
</script>

<template>
  <main>
    <ContentCard
      v-for="p in posts"
      :key="p.id"
      :post="p"
    />
  </main>
</template>

<style scoped>
main {
  flex: 1; 
  padding: 0 5%; 
  overflow-y: auto; 
}
</style>
