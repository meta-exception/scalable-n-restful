<template>
  <v-app>
    <v-toolbar app>
      <v-toolbar-title class="headline text-uppercase">
        <span>Coursework?</span>
        <span class="font-weight-light"> awesome UI/UX edition</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
    </v-toolbar>

    <v-content>
      <Chat />
    </v-content>
  </v-app>
</template>

<script>
import Chat from './components/Chat';

export default {
  name: 'App',
  components: {
    Chat,
  },
  data() {
    return {
    };
  },
};
</script>
