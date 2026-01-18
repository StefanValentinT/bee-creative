<template>
  <section>
    <div v-for="(post,index) in posts" :key="index">
      <PostCard :post="post" />
    </div>
  </section>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
import PostCard from './PostCard.vue';

export default defineComponent({
  name: 'FeedSection',
  components: { PostCard },
  props: {
    category: { type: String, required: true },
  },
  setup(props) {
    const dummyPosts = ref([
      { author: 'Cicero', text: 'Lorem ipsum!' },
      
    ]);
    return { posts: dummyPosts };
  },
});
</script>

<style scoped>
section {
  padding: 20px;
  max-width: 600px;
  margin: auto;
}
</style>
