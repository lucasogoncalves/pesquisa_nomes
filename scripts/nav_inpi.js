// ==UserScript==
// @name         INPI - Automação Navegação (com XPath)
// @namespace    http://inpi.gov.br/
// @version      2.1
// @description  Automatiza cliques na busca por marca do INPI
// @match        https://busca.inpi.gov.br/pePI/
// @match        https://busca.inpi.gov.br/pePI/servlet/LoginController*
// @match        https://busca.inpi.gov.br/pePI/jsp/marcas/Pesquisa_num_processo.jsp
// @match        https://busca.inpi.gov.br/pePI/jsp/marcas/Pesquisa_classe_basica.jsp
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function () {
  const url = window.location.href;
  const nomeLS = localStorage.getItem("nome_para_verificar");

  console.log("📍 Página atual:", url);

  // Impede reexecução na mesma URL
  if (sessionStorage.getItem("etapa_concluida") === url) {
    console.log("⏹️ Etapa já executada nesta página.");
    return;
  }
  sessionStorage.setItem("etapa_concluida", url);

  // Etapa 0: Página inicial, clica em "Continuar"
  if (url === "https://busca.inpi.gov.br/pePI/") {
    const botao = document.querySelector('input[type="submit"][value*="Continuar"]');
    if (botao) {
      console.log("🟢 Etapa 0: clicando em 'Continuar'");
      botao.click();
    }
    return;
  }

  // Etapa 1: Selecionar a área "Marca"
  if (url.includes("LoginController")) {
    const area = [...document.querySelectorAll('area')].find(a =>
      a.href.includes("marcas/Pesquisa_num_processo.jsp")
    );
    if (area) {
      console.log("🟢 Etapa 1: clicando na área 'Marca'");
      window.location.href = area.href;
    }
    return;
  }

  // Etapa 2: Clicar no link 'Marca'
  if (url.includes("Pesquisa_num_processo.jsp")) {
    const link = [...document.querySelectorAll('a')].find(a =>
      a.innerText.trim().toLowerCase() === 'marca' &&
      a.href.includes('Pesquisa_classe_basica.jsp')
    );
    if (link) {
      console.log("🟢 Etapa 2: clicando no link 'Marca'");
      link.click();
    }
    return;
  }

  // Etapa 3: Preencher e enviar (via XPath)
  if (url.includes("Pesquisa_classe_basica.jsp")) {
    const nome = nomeLS;

    if (!nome) {
      navigator.clipboard.readText().then(texto => {
        preencherCampos(texto.trim());
      });
    } else {
      preencherCampos(nome.trim());
    }

    function getByXPath(xpath) {
      return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
    }

    function preencherCampos(nome) {
      const campoInput = getByXPath('/html/body/form/div/div/table[2]/tbody/tr[6]/td[2]/font/input');
      const botaoPesquisar = getByXPath('/html/body/form/div/div/table[2]/tbody/tr[11]/td/font/input[1]');

      if (campoInput && botaoPesquisar && nome) {
        console.log("🟢 Etapa 3: preenchendo nome e clicando em pesquisar:", nome);
        campoInput.value = nome;
        botaoPesquisar.click();
      } else {
        console.warn("🚫 Não foi possível encontrar o campo ou botão de pesquisa.");
      }
    }

    return;
  }
})();
