<template>
  <div>
    <p>{{ currentYellowNum }}</p>
    <img
      data-cheese-index="0"
      width="60"
      height="60"
      @click="handleSubmit(0)"
      :src="currentYellowNum >= 0 ? '/clicked.png' :'/unclicked.png'"
    />
    <img
      data-cheese-index="1"
      width="60"
      height="60"
      @click="handleSubmit(1)"
      :src="currentYellowNum >= 1 ? '/clicked.png' :'/unclicked.png'"
    />
    <img
      data-cheese-index="2"
      width="60"
      height="60"
      @click="handleSubmit(2)"
      :src="currentYellowNum >= 2 ? '/clicked.png' :'/unclicked.png'"
    />
    <img
      data-cheese-index="3"
      width="60"
      height="60"
      @click="handleSubmit(3)"
      :src="currentYellowNum >= 3 ? '/clicked.png' :'/unclicked.png'"
    />
    <img
      data-cheese-index="4"
      width="60"
      height="60"
      @click="handleSubmit(4)"
      :src="currentYellowNum >= 4 ? '/clicked.png' :'/unclicked.png'"
    />
    <img
      data-cheese-index="5"
      width="60"
      height="60"
      @click="handleSubmit(5)"
      :src="currentYellowNum >= 5 ? '/clicked.png' :'/unclicked.png'"
    />
    <img
      data-cheese-index="6"
      width="60"
      height="60"
      @click="handleSubmit(6)"
      :src="currentYellowNum >= 6 ? '/clicked.png' :'/unclicked.png'"
    />
    <img
      data-cheese-index="7"
      width="60"
      height="60"
      @click="handleSubmit(7)"
      :src="currentYellowNum >= 7 ? '/clicked.png' :'/unclicked.png'"
    />
    <img
      data-cheese-index="8"
      width="60"
      height="60"
      @click="handleSubmit(8)"
      :src="currentYellowNum >= 8 ? '/clicked.png' :'/unclicked.png'"
    />
    <img
      data-cheese-index="9"
      width="60"
      height="60"
      @click="handleSubmit(9)"
      :src="currentYellowNum >= 9 ? '/clicked.png' :'/unclicked.png'"
    />
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      message: "Vue!",
      currentYellowNum: -1
    };
  },
  created() {
    console.log("きたyお");
  },
  methods: {
    async handleSubmit(num) {
      this.currentYellowNum = num;
      const { data } = await axios.post("http://localhost:3000/rates", {
        currentYellowNum
      });
    }
  }
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
