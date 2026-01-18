<template>
  <div class="post-card">
    <h3>{{ post.author }}</h3>
    <p>{{ post.text }}</p>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue';
interface Post {
  author: string;
  text: string;
}
export default defineComponent({
  name: 'PostCard',
  props: {
    post: { type: Object as PropType<Post>, required: true },
  },
});
</script>

<style scoped>
.post-card {
  background: white;
  border-radius: 12px;
  padding: 15px;
  margin: 10px 0;
  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}
</style>
