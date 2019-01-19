/* tslint:disable:no-shadowed-variable */
import { ActionTree, GetterTree, Module } from 'vuex';
import { ChatState } from './chatState';
import { State as RootState } from '../../state';
import * as types from '../../mutation-types';
import axios from '../../../api/axios';

const state: ChatState = {
  currentChatHistory: [],
};

const getters: GetterTree<ChatState, RootState> = {
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
  async loadChatHistory({ commit }, payload: { fromUserId: number, toUserId: number }) {
    const { fromUserId, toUserId } = payload;
    try {
      const { data } = await axios.get(`/chats/direct/${toUserId}`, { params: { access_token: fromUserId } });
      commit(types.CHAT_SET_CURRENT_HISTORY, data);
    } catch (err) {
      console.error(err);
    }
  },
  async sendChatMessage({ dispatch }, payload: { fromUserId: number, toUserId: number, message: string }) {
    const { fromUserId, toUserId, message } = payload;
    try {
      const msg = await axios.post(`/chats/direct/${toUserId}`, { message }, { params: { access_token: fromUserId } });
      dispatch('loadChatHistory', { fromUserId, toUserId });
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
