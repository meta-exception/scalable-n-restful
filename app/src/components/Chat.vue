<template>
  <v-card>
    <v-toolbar>
      <v-btn flat icon @click="signOut()">
        <v-icon>backspace</v-icon>
      </v-btn>

      <v-toolbar-title>Chat</v-toolbar-title>

      <v-spacer />

      <v-layout align-baseline>
        <v-flex xs1>
          <span>to @</span>
        </v-flex>

        <v-flex xs1>
          <v-text-field
            data-vv-name="id"
            v-validate="'required|min_value:1'"
            v-model="toUserId"
          />
        </v-flex>
      </v-layout>

      <v-spacer />

      <v-btn icon @click="loadChatHistory()" :disabled="!toUserId">
        <v-icon>refresh</v-icon>
      </v-btn>
    </v-toolbar>

    <v-list three-line style="overflow: auto; max-height: calc(100vh - 285px); min-height: calc(100vh - 285px);">
      <template v-for="(item, index) in chatHistory">
        <v-list-tile
          :key="item.title"
          avatar
          @click=""
        >

          <v-list-tile-avatar>@{{ item.author_id }}</v-list-tile-avatar>

          <v-list-tile-content>
            <v-list-tile-title>

              <v-tooltip bottom>
                <span slot="activator">{{ new Date(item.send_at).toLocaleTimeString('it-IT') }}</span>
                <span>{{ new Date(item.send_at).toLocaleDateString('it-IT') }}</span>
              </v-tooltip>

              <v-icon v-if="item.status === 2">done</v-icon>
              <v-icon v-else-if="item.status === 3">done_all</v-icon>
            </v-list-tile-title>

            <v-list-tile-sub-title style="word-wrap: break-word;">
              {{ item.body }}
            </v-list-tile-sub-title>
          </v-list-tile-content>
        </v-list-tile>
      </template>
    </v-list>

    <v-layout row fill-height wrap>
      <v-flex grow>
        <v-textarea
          box
          label="Write a message..."
          v-model="message"
        />
      </v-flex>
      <v-flex shrink>
        <v-layout align-end justify-end column fill-height>
          <v-btn
            style="margin-top: 0px; margin-bottom: 27px;"
            depressed
            block
            small
            @click="sendChatMessage()"
            :disabled="!message"
          >
            <v-icon dark>send</v-icon>
          </v-btn>
        </v-layout>
      </v-flex>
    </v-layout>
  </v-card>
</template>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';

@Component
export default class Chat extends Vue {
  private toUserId = null;
  private message = '';
  constructor() {
    super();
  }

  private beforeMount() {
    this.$store.dispatch('chat/clearChatHistory');
  }

  get chatHistory() {
    return this.$store.getters['chat/currentChatHistory'];
  }

  private sendChatMessage() {
    this.$validator.validateAll().then((result) => {
      if (result) {
        this.$store.dispatch('chat/sendChatMessage', {
          toUserId: this.toUserId,
          message: this.message,
        });
      }
    });
  }

  private loadChatHistory() {
    this.$validator.validateAll().then((result) => {
      if (result) {
        this.$store.dispatch('chat/loadChatHistory', { toUserId: this.toUserId });
      }
    });
  }

  private signOut() {
    this.$store.dispatch('signOut');
  }

}
</script>
