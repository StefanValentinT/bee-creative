<script setup>
defineProps({ post: Object })
</script>

<template>
  <article class="card">
    <h2>{{ post.title }}</h2>

    <img v-if="post.type === 'image'" :src="post.image" />
    <p v-else>{{ post.text }}</p>

    <div class="meta">
      <small>{{ post.category }}</small>
      <small>{{ post.time }}</small>
    </div>
  </article>
</template>

<style scoped>
.card {
  background: var(--white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 20px;
  margin-bottom: 30px;
}
img {
  width: 100%;
  border-radius: 8px;
  margin: 15px 0;
}
.meta {
  display: flex;
  justify-content: space-between;
}
</style>
