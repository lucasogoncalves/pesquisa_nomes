function verificar() {
  const nome = document.getElementById("nomeInput").value.trim();
  if (!nome) {
    alert("Digite um nome.");
    return;
  }

  // Gera slug (sem acentos, espaços e símbolos)
  const slugify = str => str
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/\s+/g, "")
    .replace(/[^a-z0-9]/g, "");

  const nomeSlug = slugify(nome);

  // Atualiza o histórico (mantém nome original)
  const historico = JSON.parse(localStorage.getItem("historico") || "[]");
  if (!historico.includes(nome)) {
    historico.push(nome);
    localStorage.setItem("historico", JSON.stringify(historico));
  }

  // Abre a aba auxiliar (janela nomeada para não duplicar)
  window.open("utilities.html", "utils", "width=400,height=400");

  // Abas das plataformas com nomeSlug
  const urls = [
    `https://busca.inpi.gov.br/pePI`,
    `https://www.hostinger.com.br/domain-name-results?domain=${nomeSlug}.com&from=domain-name-search`,
    `https://www.google.com/maps/search/${encodeURIComponent(nome)}`,
    `https://www.instagram.com/${nomeSlug}`,
    `https://www.tiktok.com/@${nomeSlug}`,
    `https://www.facebook.com/${nomeSlug}`,
    `https://www.youtube.com/@${nomeSlug}`
  ];

  // Abre todas as URLs em nova aba
  urls.forEach(url => {
    window.open(url, "_blank", "noopener,noreferrer");
  });

  // Salva nome original para uso futuro (INPI)
  localStorage.setItem("nome_para_verificar", nome);

  // Recarrega a principal
  reloadPaginaPrincipal();
}

window.onload = () => {
  if (typeof carregarHistorico === "function") {
    carregarHistorico();
  }

  // Se recarregou a página com base em uma pesquisa anterior, limpa o marcador
  if (localStorage.getItem("aguarda_reload") === "true") {
    localStorage.removeItem("aguarda_reload");
  }

  // Garante que a função verificar só seja disparada ao clique do botão
  const botao = document.getElementById("btnVerificar");
  if (botao) {
    botao.onclick = verificar;
  }
};
