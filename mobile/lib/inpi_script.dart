import 'package:webview_flutter/webview_flutter.dart';
void injetarScriptINPI(WebViewController controller, String nome) {
final script = '''
  (function() {
    const oldStyle = document.querySelector('#inpi-style');
    if (oldStyle) oldStyle.remove();

    const style = document.createElement('style');
    style.id = 'inpi-style';
      style.innerHTML = \`
        html, body {
          margin: 0;
          padding: 0;
          width: 100%;
          min-width: 100vw;
          overflow-x: auto;
          box-sizing: border-box;
        }
        body > * {
          margin-left: auto !important;
          margin-right: auto !important;
          max-width: 100%;
        }
      \`;

    document.head.appendChild(style);

    let meta = document.querySelector('meta[name="viewport"]');
    if (!meta) {
      meta = document.createElement('meta');
      document.head.appendChild(meta);
    }
    meta.name = 'viewport';
    meta.content = 'width=device-width, initial-scale=1, maximum-scale=5.0, user-scalable=yes';

  setTimeout(() => {
    const alvo = document.getElementById('principal') || document.body.querySelector('div > div');
    if (alvo) {
      const larguraElemento = alvo.getBoundingClientRect().width;
      const larguraViewport = window.innerWidth;

      const zoomCalculado = larguraViewport / larguraElemento;
      const zoomOutMax = Math.min(zoomCalculado, 1); // máximo de 100% (sem zoom in automático)

      document.body.style.zoom = (zoomOutMax * 80) + '%'; // você usou *80 pra calibrar, pode manter
      document.body.style.transform = 'none';
      document.body.style.transformOrigin = 'top left';

      const scrollX = (alvo.getBoundingClientRect().left + window.scrollX) - ((window.innerWidth - alvo.getBoundingClientRect().width * zoomOutMax) / 2);
      const scrollY = (alvo.getBoundingClientRect().top + window.scrollY);

      window.scrollTo(scrollX, scrollY);
    }
  }, 300);




    document.body.style.transform = 'none';
    document.body.style.transformOrigin = 'top left';

    setTimeout(() => {
      const alvo = document.getElementById('principal') || document.body.querySelector('div > div');
      if (alvo) {
        alvo.scrollIntoView({ behavior: 'auto', block: 'start', inline: 'center' });
      }
    }, 300);


    const url = window.location.href;

      function getByXPath(xpath) {
        return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
      }

      console.log("📍 INPI WebView - Página atual:", url);

      if (url === "https://busca.inpi.gov.br/pePI/") {
        const botao = document.querySelector('input[type="submit"][value*="Continuar"]');
        if (botao) {
          console.log("🟢 Etapa 0: clicando em 'Continuar'");
          botao.click();
        }
        return;
      }

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

      if (url.includes("Pesquisa_classe_basica.jsp")) {
        const campoInput = getByXPath('/html/body/form/div/div/table[2]/tbody/tr[6]/td[2]/font/input');
        const botaoPesquisar = getByXPath('/html/body/form/div/div/table[2]/tbody/tr[11]/td/font/input[1]');
        if (campoInput && botaoPesquisar) {
          campoInput.value = "${nome.replaceAll('"', '\\"')}";
          console.log("🟢 Etapa 3: preenchendo nome e clicando:", campoInput.value);
          botaoPesquisar.click();

          // ✅ Notificar o Flutter que a pesquisa foi enviada
          if (window.NotificadorINPI) {
            NotificadorINPI.postMessage("pesquisa_enviada");
          }
        } else {
          console.warn("🚫 Não encontrou o campo ou botão.");
        }
      }

      // 🔔 Detecta se chegou na tela de resultado final
      if (url.includes("MarcasServletController")) {
        console.log("🟢 Etapa final: resultados carregados!");
        if (window.NotificadorINPI) {
          NotificadorINPI.postMessage("resultado_carregado");
        }
      }

    })();
  ''';

  controller.runJavaScript(script);
}
