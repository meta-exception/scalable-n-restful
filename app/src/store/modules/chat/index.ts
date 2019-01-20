/* tslint:disable:no-shadowed-variable */
import { ActionTree, GetterTree, Module } from 'vuex';
import { ChatState } from './chatState';
import { State as RootState } from '../../state';
import * as types from '../../mutation-types';
import axios from '../../../api';

const state: ChatState = {
  currentChatHistory: [],
};

const getters: GetterTree<ChatState, RootState> = {
  loggedIn: (state, getters, rootState) => {
    return rootState.access_token;
  },
  currentChatHistory: (state: ChatState) => {
    return state.currentChatHistory;
  },
};

const mutations = {
  [types.CHAT_SET_CURRENT_HISTORY](state: ChatState, history: object[]) {
    state.currentChatHistory = history;
  },
};

const actions: ActionTree<ChatState, RootState> = {
  async loadChatHistory({ commit, rootState }, payload: { toUserId: number }) {
    const { toUserId } = payload;
    const access_token = rootState.access_token;
    try {
      const { data } = await axios.get(`/chats/direct/${toUserId}`, { params: { access_token } });
      commit(types.CHAT_SET_CURRENT_HISTORY, data);
    } catch (err) {
      console.error(err);
    }
  },
  clearChatHistory({ commit }) {
    commit(types.CHAT_SET_CURRENT_HISTORY, []);
  },
  async sendChatMessage({ dispatch, rootState }, payload: { toUserId: number, message: string }) {
    const { toUserId, message } = payload;
    const access_token = rootState.access_token;
    try {
      const msg = await axios.post(`/chats/direct/${toUserId}`, { message }, { params: { access_token } });
      dispatch('loadChatHistory', { toUserId });
    } catch (err) {
      console.error(err);
    }
  },
};

const chat: Module<ChatState, RootState> = {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};

export default chat;
