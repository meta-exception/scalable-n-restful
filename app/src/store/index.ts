import Vue from 'vue';
import Vuex, { StoreOptions } from 'vuex';
import { State } from './state';
import * as types from './mutation-types';
import chat from './modules/chat';

Vue.use(Vuex);

const store: StoreOptions<State> = {
  state: {
    access_token: null,
  },
  mutations: {
    [types.SET_ACCESS_TOKEN](state, token: number) {
      state.access_token = token;
    },
  },
  actions: {
    async signIn({ commit }, payload: { id: number }) {
      const { id } = payload;
      // TODO: ACTUALLY REQUEST ACCESS_TOKEN
      commit(types.SET_ACCESS_TOKEN, id);
    },
    signOut({ commit }) {
      commit(types.SET_ACCESS_TOKEN, null);
    },
  },
  modules: {
    chat,
  },
  strict: true,
};

export default new Vuex.Store<State>(store);
