const HelpPanel = (() => {
  const panel = document.getElementById("help-panel");
  const backdrop = panel.querySelector(".help-backdrop");
  const closeBtn = panel.querySelector(".help-close");
  const toggleModeBtn = panel.querySelector(".help-toggle-mode");
  const helpBtn = document.getElementById("help");

  const STORAGE_KEY = "teepee-help-mode";

  let isOpen = false;
  let currentMode = localStorage.getItem(STORAGE_KEY) || "modal";

  const toggle = () => {
    isOpen = !isOpen;
    panel.classList.toggle("hidden", !isOpen);
  };

  const toggleMode = () => {
    currentMode = currentMode === "modal" ? "sidepanel" : "modal";
    panel.classList.toggle("help-panel--modal", currentMode === "modal");
    panel.classList.toggle("help-panel--sidepanel", currentMode === "sidepanel");
    localStorage.setItem(STORAGE_KEY, currentMode);
  };

  const handleKeydown = (e) => {
    if ((e.key === "?" || (e.shiftKey && e.key === "/")) ||
        (e.key === "Escape" && isOpen)) {
      e.preventDefault();
      e.stopPropagation();
      toggle();
    }
  };

  const init = () => {
    panel.classList.add(`help-panel--${currentMode}`);

    helpBtn.addEventListener("click", toggle);
    closeBtn.addEventListener("click", toggle);
    backdrop.addEventListener("click", toggle);
    toggleModeBtn.addEventListener("click", toggleMode);
    document.addEventListener("keydown", handleKeydown);
  };

  return { init };
})();

document.addEventListener("DOMContentLoaded", HelpPanel.init);
