// s_inpi.js

(function () {
  // Aguarda a página carregar completamente
  window.addEventListener("load", () => {
    const nome = localStorage.getItem("nome_para_verificar");
    if (!nome) return;

    // Preenche o campo da marca com o nome
    const input = document.querySelector('input[name="expressao"]');
    if (!input) return;

    input.value = nome;

    // Marca a opção de pesquisa "Radical" (ou troque por "Exata" se preferir)
    const tipoRadical = document.querySelector('input[name="tipoBusca"][value="radical"]');
    if (tipoRadical) tipoRadical.checked = true;

    // Clica no botão de pesquisar (input[name="submit"] não existe, então usamos o botão correto)
    const botoes = document.querySelectorAll('input[type="button"]');
    for (let btn of botoes) {
      if (btn.value.toLowerCase().includes("pesquisar")) {
        btn.click();
        break;
      }
    }
  });
})();
