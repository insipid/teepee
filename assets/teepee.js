// Light wrapper around v86, with default configuration, so the HTML
// file can just have the more-specific JS stuff
//
function TeePee(options) {
  const containerId = options.containerId || "screen";

  const SCREEN_WIDTH = 720;
  const SCREEN_HEIGHT = 400;

  function fitToViewport() {
    vm.screen_set_scale(1, 1);
    const sx = window.innerWidth  / SCREEN_WIDTH;
    const sy = window.innerHeight / SCREEN_HEIGHT;
    // grow until one side hits the edge; minimally & equally
    const scale = Math.min(sx, sy);
    vm.screen_set_scale(scale, scale);
  }

  DEFAULT_CONFIG = {
    screen: {
      container: document.getElementById(containerId),
      encoding: "cp437", // lol, memories
      use_graphical_text: true,
      scale: 1,
      ansi: true,
    },

    bios: { url: "assets/seabios.bin" },
    vga_bios: { url: "assets/vgabios.bin" },
    wasm_path: "assets/v86.wasm",

    boot_order: 0x231,
    autostart: true,
    log_level: -1,
  };

  const vm = new V86(Object.assign({}, DEFAULT_CONFIG, options));

  vm.fitToViewport = fitToViewport;
  vm.fullscreen = function() {
    document.getElementById("screen").requestFullscreen();
  };

  return vm;
}
