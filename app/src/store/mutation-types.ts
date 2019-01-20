
export const SET_ACCESS_TOKEN = 'SET_ACCESS_TOKEN';


const namespaced = true;


const CHAT = 'chat';

const SET_OWNER = 'SET_OWNER';
export const CHAT_SET_OWNER = namespaced ?
  SET_OWNER :
  CHAT + '/' + SET_OWNER;

const SET_CURRENT_HISTORY = 'SET_CURRENT_HISTORY';
export const CHAT_SET_CURRENT_HISTORY = namespaced ?
  SET_CURRENT_HISTORY :
  CHAT + '/' + SET_CURRENT_HISTORY;
