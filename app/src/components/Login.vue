<template>
  <v-card>
    <v-layout align-center justify-center column fill-height>
      <v-flex xs12 sm6 md3>
        <v-text-field
          label="ID"
          required
          data-vv-name="id"
          v-validate="'required|min_value:1'"
          v-model="id"
          :error-messages="errors.collect('id')"
        />
      </v-flex>

      <v-card-actions>
        <v-btn flat color="orange" @click="signIn()">sign in</v-btn>
      </v-card-actions>
    </v-layout>
  </v-card>
</template>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';

@Component
export default class Login extends Vue {
  private id = null;
  constructor() {
    super();
  }

  private signIn() {
    this.$validator.validateAll().then((result) => {
      if (result) {
        this.$store.dispatch('signIn', { id: this.id });
      }
    });
  }
}
</script>
