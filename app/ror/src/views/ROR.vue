<template>
  <div>
    <v-select
          :items="items"
          label="Standard"
        ></v-select>
  </div>
</template>

<script>
export default {
  name: 'ROR',
  components: {},
  data () {
    return {
      items: ['abc']
    }
  }
}
</script>
