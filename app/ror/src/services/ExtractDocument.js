import Api from '@/services/Api'

export default {
  getDocument (identity) {
    return Api().post('getDocument', identity)
  }
}
