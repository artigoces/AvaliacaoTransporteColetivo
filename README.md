# AvaliacaoTransporteColetivo
Desenvolvimento de um Aplicativo Móvel de Avaliação do Transporte Coletivo Urbano



Instalação IDE Desenvolvimento: RAD Studio Community Edition

  1. Pré requisitos de hardware para instalação: http://docwiki.embarcadero.com/RADStudio/Rio/en/Installation_Notes
  2 Acesse a página de Download, faça o cadastro para obter a licença da versão Community.  https://www.embarcadero.com/br/products/delphi/starter/free-download. Após o cadastro, você receberá em seu email o serial e link de download do ISO de instalação
  3. Caso não atenda aos requisitos da versão Community, faça download da versão trial de 30 dias: https://www.embarcadero.com/br/products/rad-studio/start-for-free
  4. Instalação:
    a. Após aceitar o termo de uso e política de privacidade, será exibida a tela ‘Input License’
    b. Selecione a opção ‘I already have a product serial number’ e clique em ‘Next’
    c. Na tela ‘Embarcadero Product Registration’, informe o serial recebido no seu email no campo ‘Serial Number’ e clique no botão ‘Register’
    d. Selecione o idioma que deseja instalar a IDE e clique em ‘Next
    e. Na tela ‘Select Features’, você pode optar por remover a instalação do desenvolvimento para OS X, iOS e Windows 64-bit. Apenas a instalação do ‘Android Development Platform’ é obrigatória
    f. A próxima tela pergunta se deseja instalar e configurar o SDK e NDK do Android junto com a instalação da IDE. Caso já possua instalado, você pode configurar posteriormente, como mostra o link: http://docwiki.embarcadero.com/RADStudio/Rio/en/Adding_an_Android_SDK
    9. Demais configurações não precisam ser alteradas, apenas prossiga com a instalação


Compilação Apk

  1. Com a IDE aberta, acesse o menu ‘File/Open Project’, navegue até a pasta onde o código fonte está salvo e selecione o arquivo ‘AppDelphi.dpr’
  2. Acesse o menu ‘Project/Build AppDelphi’ para fazer o build da aplicação
  3. Após concluir o passo acima, acesse novamente o menu ‘Project’, opção ‘Deploy libAppDelphi.so’
  4. Arquivo .apk será gerado na pasta ‘Android\Release\AppDelphi\bin’ dentro do diretório de onde o código fonte foi salvo


Configuração IDE Detecção Dispositivo Android

  Caso queira fazer a depuração do app ou o deploy diretamente em um aparelho Android, a Embarcadero Technologies disponibilizou uma documentação de como configurar o ambiente de desenvolvimento para que a IDE detecte o dispositivo Android conectado na porta USB: http://docwiki.embarcadero.com/RADStudio/Rio/en/Configuring_Your_System_to_Detect_Your_Android_Device


Links Apoio

  Documentação completa de configuração de todo o ambiente de desenvolvimento para Android: http://docwiki.embarcadero.com/RADStudio/Rio/en/Android_Mobile_Application_Development

