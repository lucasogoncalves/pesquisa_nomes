function carregarHistorico() {
  const historico = JSON.parse(localStorage.getItem("historico") || "[]");
  const favoritos = JSON.parse(localStorage.getItem("favoritos") || "{}");
  const plataformas = ["INPI", "Domínio", "Maps", "Instagram", "TikTok", "Facebook", "YouTube"];
  const tabela = document.getElementById("historico");

  tabela.innerHTML = "";

  const header = tabela.insertRow();
  header.insertCell().innerText = "Nome";
  header.insertCell().innerText = "🔷"; // Cabeçalho da coluna do botão 🔘/🔵
  plataformas.forEach(p => header.insertCell().innerText = p);
  header.insertCell().innerText = "⭐";
  header.insertCell().innerText = "Excluir";

  [...historico].reverse().forEach(nome => {

    const row = tabela.insertRow();
    row.insertCell().innerText = nome;

    // 🔘/🔵 Botão de marcação visual
    const toggleCell = row.insertCell();
    const toggleBtn = document.createElement("span");
    toggleBtn.innerText = "🔘";
    toggleBtn.style.cursor = "pointer";
    toggleBtn.style.fontSize = "18px";
    toggleBtn.title = "Marcar ou desmarcar todos";
    toggleBtn.onclick = () => {
      const allChecked = plataformas.every((_, i) => {
        const checkbox = row.cells[i + 2].querySelector("input"); // +2 por causa de Nome + Toggle
        return checkbox?.checked;
      });

      plataformas.forEach((_, i) => {
        const checkbox = row.cells[i + 2].querySelector("input");
        if (checkbox) checkbox.checked = !allChecked;
      });

      toggleBtn.innerText = allChecked ? "🔘" : "🔵";
    };
    toggleCell.appendChild(toggleBtn);

    // Caixas de seleção por plataforma
    plataformas.forEach(p => {
      const cell = row.insertCell();
      const id = `${p}-${nome}`;
      const checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.checked = JSON.parse(localStorage.getItem("marcados") || "{}")[id] || false;
      checkbox.addEventListener("change", () => {
        const marcados = JSON.parse(localStorage.getItem("marcados") || "{}");
        marcados[id] = checkbox.checked;
        localStorage.setItem("marcados", JSON.stringify(marcados));
      });
      cell.appendChild(checkbox);
    });

    // ⭐ Favorito
    const favCell = row.insertCell();
    const star = document.createElement("span");
    star.classList.add("star");
    star.innerText = favoritos[nome] ? "★" : "☆";
    star.style.cursor = "pointer";
    star.style.fontSize = "20px";
    star.onclick = () => {
      favoritos[nome] = !favoritos[nome];
      localStorage.setItem("favoritos", JSON.stringify(favoritos));
      star.innerText = favoritos[nome] ? "★" : "☆";
    };
    favCell.appendChild(star);



    // Excluir
    const cellExcluir = row.insertCell();
    const botaoExcluir = document.createElement("button");
    botaoExcluir.innerText = "Excluir";
    botaoExcluir.onclick = () => {
      const novoHistorico = historico.filter(n => n !== nome);
      localStorage.setItem("historico", JSON.stringify(novoHistorico));
      delete favoritos[nome];
      localStorage.setItem("favoritos", JSON.stringify(favoritos));
      carregarHistorico();
    };
    cellExcluir.appendChild(botaoExcluir);
  });
}
