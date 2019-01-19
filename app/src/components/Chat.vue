<template>
  <v-layout>
    <v-flex xs12 sm6 offset-sm3>
      <v-card flat class="mx-auto">
        <v-toolbar color="cyan" dark>
          <v-toolbar-side-icon />

          <v-toolbar-title>Inbox</v-toolbar-title>

          <v-text-field
            v-model="fromUserId"
            label="fromUserId"
            solo
          />

          <v-text-field
            v-model="toUserId"
            label="toUserId"
            solo
          />

          <v-spacer />

          <v-btn icon @click="loadChatHistory()">
            <v-icon>refresh</v-icon>
          </v-btn>
        </v-toolbar>

        <v-list three-line style="overflow: auto; max-height: calc(100vh - 328px);">
          <template v-for="(item, index) in chatHistory">
            <v-list-tile
              :key="item.title"
              avatar
              @click=""
            >
              <v-list-tile-content>
                <v-list-tile-title>
                  {{ item.author_id }}

                  <v-tooltip bottom>
                    <span slot="activator">{{ new Date(item.send_at).toLocaleTimeString('it-IT') }}</span>
                    <span>{{ new Date(item.send_at).toLocaleDateString('it-IT') }}</span>
                  </v-tooltip>

                  <v-icon v-if="item.status === 2">done</v-icon>
                  <v-icon v-else-if="item.status === 3">done_all</v-icon>
                </v-list-tile-title>
                <v-list-tile-sub-title>{{ item.body }}</v-list-tile-sub-title>
              </v-list-tile-content>
            </v-list-tile>
          </template>
        </v-list>

        <v-card-actions>
          <v-spacer />

          <v-btn
            absolute
            style="bottom: -15px;"
            dark
            fab
            small
            bottom
            right
            @click="sendChatMessage()"
          >
            <v-icon>send</v-icon>
          </v-btn>
        </v-card-actions>
      </v-card>

      <v-textarea
        box
        label="Write a message..."
        v-model="message"
      />
    </v-flex>
  </v-layout>
</template>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';

@Component
export default class Chat extends Vue {
  private fromUserId = 0;
  private toUserId = 0;
  private message = '';
  constructor() {
    super();
  }

  get chatHistory() {
    return this.$store.getters['chat/currentChatHistory'];
  }

  private sendChatMessage() {
    this.$store.dispatch('chat/sendChatMessage', {
      fromUserId: this.fromUserId,
      toUserId: this.toUserId,
      message: this.message,
    });
  }

  private loadChatHistory() {
    this.$store.dispatch('chat/loadChatHistory', { fromUserId: this.fromUserId, toUserId: this.toUserId });
  }

}
</script>
