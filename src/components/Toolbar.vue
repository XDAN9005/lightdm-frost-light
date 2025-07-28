<template>
  <div class="toolbar">
    <font-awesome-icon @click="shutdown()" v-if="canShutdown" class="toolbar__icon"
                       :icon="['fas', 'power-off']"></font-awesome-icon>
    <font-awesome-icon @click="restart()" v-if="canRestart" class="toolbar__icon"
                       :icon="['fas', 'redo-alt']"></font-awesome-icon>
    <font-awesome-icon @click="suspend()" v-if="canSuspend" class="toolbar__icon"
                       :icon="['fas', 'moon']"></font-awesome-icon>
    <font-awesome-icon @click="hibernate()" v-if="canHibernate" class="toolbar__icon"
                       :icon="['fas', 'bed']"></font-awesome-icon>
    <font-awesome-icon class="toolbar__icon" :icon="['fas', 'users']"
                       v-on:click="$emit('displayUserChooser')"></font-awesome-icon>
  </div>
</template>

<script>
import {FontAwesomeIcon} from "@fortawesome/vue-fontawesome";

export default {
  components: {FontAwesomeIcon},
  name: "Toolbar",
  data: () => {
    return {
      canShutdown: window.lightdm.can_shutdown,
      canRestart: window.lightdm.can_restart,
      canSuspend: window.lightdm.can_suspend,
      canHibernate: window.lightdm.can_hibernate
    }
  },
  emits: [
    'displayUserChooser'
  ],
  methods: {
    shutdown() {
      window.lightdm.shutdown()
    },
    restart() {
      window.lightdm.restart()
    },
    suspend() {
      window.lightdm.suspend()
    },
    hibernate() {
      window.lightdm.hibernate()
    }
  }
}
</script>

<style lang="sass" scoped>
.toolbar
  display: flex
  justify-content: center
  background: linear-gradient(183.1deg, rgba(0,0,0,0.5) 6.21%, rgba(0,0,0,0.7) 97.59%)
  box-shadow: .5rem .5rem 1rem 0 #000000A0
  border-radius: 1rem
  padding: .5rem 0
  width: 100%

  .toolbar__icon
    color: var(--font-color)
    cursor: pointer
    font-size: 2rem
    padding: .3rem .6rem
    filter: drop-shadow(.25rem .25rem .35rem #00000080)
    transition: .4s transform
</style>
