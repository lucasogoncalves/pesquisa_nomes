function reloadPaginaPrincipal(delay = 1500) {
  setTimeout(() => {
    if (window.name !== "utils") {
      console.log("🔁 Recarregando a página principal...");
      location.reload();
    }
  }, delay);
}
