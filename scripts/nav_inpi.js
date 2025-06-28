// ==UserScript==
// @name         Automação INPI
// @namespace    http://inpi.gov.br/
// @version      1.0
// @description  Automatiza o fluxo até o formulário de busca de marcas
// @match        https://busca.inpi.gov.br/pePI/jsp/*
// @grant        none
// ==/UserScript==

(function () {
  const nome = localStorage.getItem("nome_para_verificar");
  if (!nome) return;

  let etapa = 0;

  const interval = setInterval(() => {
    const url = window.location.href;

    // Etapa 0 – Clicar em "Continuar..."
    if (etapa === 0 && document.querySelector('a[href*="javascript:document.forms[0].submit()"]')) {
      console.log("Etapa 0: clicando em Continuar...");
      document.querySelector('a[href*="javascript:document.forms[0].submit()"]').click();
      etapa = 1;
      return;
    }

    // Etapa 1 – Clicar no ícone "Marca"
    if (etapa === 1 && document.querySelector('img[alt="Marca"]')) {
      console.log("Etapa 1: clicando em Marca...");
      document.querySelector('img[alt="Marca"]').closest("a").click();
      etapa = 2;
      return;
    }

    // Etapa 2 – Clicar no link "Marca" na seção “Consultar por:”
    if (etapa === 2 && document.querySelector('a[href*="Pesquisa_classe_basica.jsp"]')) {
      console.log("Etapa 2: clicando em Consultar por: Marca...");
      const links = [...document.querySelectorAll('a')];
      const linkMarca = links.find(l => l.innerText.trim().toLowerCase() === 'marca');
      if (linkMarca) {
        linkMarca.click();
        etapa = 3;
      }
      return;
    }

    // Etapa 3 – Preencher o campo e pesquisar
    if (etapa === 3 && document.querySelector('input[name="expressao"]')) {
      console.log("Etapa 3: preenchendo e pesquisando...");
      document.querySelector('input[name="expressao"]').value = nome;

      // Marcar como busca "Radical"
      const tipoRadical = document.querySelector('input[name="tipoBusca"][value="radical"]');
      if (tipoRadical) tipoRadical.checked = true;

      // Clicar no botão pesquisar
      const botoes = document.querySelectorAll('input[type="button"]');
      for (let btn of botoes) {
        if (btn.value.toLowerCase().includes("pesquisar")) {
          btn.click();
          clearInterval(interval);
          return;
        }
      }
    }
  }, 500);
})();
