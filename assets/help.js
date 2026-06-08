const HelpPanel = (() => {
  const panel = document.getElementById("help-panel");
  const backdrop = panel.querySelector(".help-backdrop");
  const closeBtn = panel.querySelector(".help-close");
  const toggleModeBtn = panel.querySelector(".help-toggle-mode");
  const helpBtn = document.getElementById("help");

  let isOpen = false;
  let currentMode = "modal"; // "modal" or "sidepanel"

  const toggle = () => {
    isOpen = !isOpen;
    panel.classList.toggle("hidden", !isOpen);
    if (isOpen) {
      document.addEventListener("keydown", handleKeydown);
    } else {
      document.removeEventListener("keydown", handleKeydown);
    }
  };

  const toggleMode = () => {
    currentMode = currentMode === "modal" ? "sidepanel" : "modal";
    panel.classList.toggle("help-panel--modal", currentMode === "modal");
    panel.classList.toggle("help-panel--sidepanel", currentMode === "sidepanel");
  };

  const handleKeydown = (e) => {
    if (e.key === "?" || (e.shiftKey && e.key === "/")) {
      e.preventDefault();
      toggle();
    } else if (e.key === "Escape" && isOpen) {
      e.preventDefault();
      toggle();
    }
  };

  const init = () => {
    panel.classList.add("help-panel--modal");

    helpBtn.addEventListener("click", toggle);
    closeBtn.addEventListener("click", toggle);
    backdrop.addEventListener("click", toggle);
    toggleModeBtn.addEventListener("click", toggleMode);
    document.addEventListener("keydown", handleKeydown);
  };

  return { init };
})();

document.addEventListener("DOMContentLoaded", HelpPanel.init);
