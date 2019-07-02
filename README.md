# AvaliacaoTransporteColetivo
Desenvolvimento de um Aplicativo Móvel de Avaliação do Transporte Coletivo Urbano



<h3>Instalação IDE Desenvolvimento: RAD Studio Community Edition</h3>
</br>
<ol>
  <li>Pré requisitos de hardware para instalação: http://docwiki.embarcadero.com/RADStudio/Rio/en/Installation_Notes</li>
  <li>Acesse a página de Download e faça o cadastro para obter a licença da versão Community: https://www.embarcadero.com/br/products/delphi/starter/free-download.</li> 
  <li>Após o cadastro, você receberá em seu email o serial e link de download do ISO de instalação</li>
  <li>Caso não atenda aos requisitos da versão Community, faça download da versão trial de 30 dias: https://www.embarcadero.com/br/products/rad-studio/start-for-free </br>
  <li>Instalação:
    <ol>
      <li>Após aceitar o termo de uso e política de privacidade, será exibida a tela ‘Input License’</li>
      <li>Selecione a opção ‘I already have a product serial number’ e clique em ‘Next’</li>
      <li>Na tela ‘Embarcadero Product Registration’, informe o serial recebido no seu email no campo ‘Serial Number’ e clique no botão ‘Register’</li>
      <li>Selecione o idioma que deseja instalar a IDE e clique em ‘Next</li>
      <li>Na tela ‘Select Features’, você pode optar por remover a instalação do desenvolvimento para OS X, iOS e Windows 64-bit. Apenas a instalação do ‘Android Development Platform’ é obrigatória</li>
      <li>A próxima tela pergunta se deseja instalar e configurar o SDK e NDK do Android junto com a instalação da IDE. Caso já possua instalado, você pode configurar posteriormente, como mostra o link: http://docwiki.embarcadero.com/RADStudio/Rio/en/Adding_an_Android_SDK</li>
      <li>Demais configurações não precisam ser alteradas, apenas prossiga com a instalação</li>
    </ol>  
  </li>
</ol>  
</br>
</br>
<h3>Compilação Apk</h3>
</br>
<ol>
  <li>Com a IDE aberta, acesse o menu ‘File/Open Project’, navegue até a pasta onde o código fonte está salvo e selecione o arquivo ‘AppDelphi.dpr’</li>
  <li>Acesse o menu ‘Project/Build AppDelphi’ para fazer o build da aplicação</li>
  <li>Após concluir o passo acima, acesse novamente o menu ‘Project’, opção ‘Deploy libAppDelphi.so’</li>
  <li>Arquivo .apk será gerado na pasta ‘Android\Release\AppDelphi\bin’ dentro do diretório de onde o código fonte foi salvo</li>
</ol>  
</br>
</br>
<h3>Configuração IDE Detecção Dispositivo Android</h3>
</br>
  Caso queira fazer a depuração do app ou o deploy diretamente em um aparelho Android, a Embarcadero Technologies disponibilizou uma documentação de como configurar o ambiente de desenvolvimento para que a IDE detecte o dispositivo Android conectado na porta USB: http://docwiki.embarcadero.com/RADStudio/Rio/en/Configuring_Your_System_to_Detect_Your_Android_Device
</br>
</br>
<h3>Links Apoio</h3>
</br>
  Documentação completa de configuração de todo o ambiente de desenvolvimento para Android: http://docwiki.embarcadero.com/RADStudio/Rio/en/Android_Mobile_Application_Development
</br>
</br>
Autor da unit U_MsgD.pas: https://github.com/JonatanSouza04/Firemonkey-Dialogs-Material-Design


