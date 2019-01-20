<template>
  <v-app>
    <v-toolbar app>
      <v-toolbar-title class="headline text-uppercase">
        <span>Coursework?</span>
        <span class="font-weight-light"> awesome UI/UX edition</span>
      </v-toolbar-title>
      <v-spacer/>

      <span v-if="loggedIn">you logged in as: {{ this.loggedIn }}</span>

    </v-toolbar>

    <v-content>
      <Login v-if="!loggedIn" />
      <Chat v-else />
    </v-content>
  </v-app>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';

import Chat from './components/Chat.vue';
import Login from './components/Login.vue';

@Component({
  components: {
    Chat,
    Login,
  },
})
export default class App extends Vue {
  get loggedIn() {
    return this.$store.getters['chat/loggedIn'];
  }
}
</script>
