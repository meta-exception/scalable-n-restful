import Vue from 'vue';
import Vuex from 'vuex';
import { State } from './state';
import chat from './modules/chat';

Vue.use(Vuex);

export default new Vuex.Store<State>({
  modules: {
    chat,
  },
  strict: true,
});
