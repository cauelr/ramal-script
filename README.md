# 📞 Automação de Atribuição de Ramais Microsoft Teams

## 📖 Sobre o Projeto

Este script foi desenvolvido com o objetivo de otimizar e facilitar o processo de atribuição e alteração de ramais no Microsoft Teams.

Anteriormente, todo o processo era realizado manualmente através da execução de comandos PowerShell diretamente no terminal.  
Com esta automação, o procedimento passou a ser executado através de um arquivo `.exe`, tornando a operação mais simples, rápida e padronizada para o técnico final.

---

## ⚙️ Funcionalidades

- Verificação automática de privilégios administrativos
- Instalação automática do módulo `MicrosoftTeams`
- Conexão automática ao Microsoft Teams
- Sistema de tentativas de reconexão
- Menu interativo no terminal
- Alteração/Atribuição de ramais via `DirectRouting`
- Confirmação antes da execução das alterações

---

## 🛠️ Tecnologias Utilizadas

- PowerShell
- Microsoft Teams PowerShell Module

---

## 📋 Pré-requisitos

Antes de executar o script, é necessário:

- Windows com PowerShell habilitado
- Permissão de administrador
- Conta com permissões administrativas no Microsoft Teams
- Conexão com a internet

---

## 📦 Instalação do Módulo Microsoft Teams

O próprio script verifica automaticamente se o módulo está instalado.

Caso não esteja, ele executará:

```powershell
Install-Module -Name MicrosoftTeams -Force -Scope CurrentUser
```

---

## ▶️ Como Utilizar

### 1. Execute o arquivo `.exe`

O programa deve ser executado como administrador.

---

### 2. Realize login no Microsoft Teams

Ao iniciar, será aberta a autenticação do Microsoft Teams.

---

### 3. Escolha uma opção no menu

```text
1 - Alterar/Atribuir Ramal
0 - Sair do script
```

---

### 4. Informe os dados do colaborador

O sistema solicitará:

- E-mail do colaborador
- Novo ramal

Exemplo:

```text
Insira e-mail do colaborador:
usuario@empresa.com

Insira o novo ramal do colaborador:
1020
```

---

### 5. Confirme a operação

```text
Deseja concluir? (S/N)
```

Após confirmação, o ramal será atribuído ao usuário.

---

## 📄 Comando Utilizado

O script utiliza o seguinte comando do Microsoft Teams:

```powershell
Set-CsPhoneNumberAssignment `
    -Identity usuario@empresa.com `
    -PhoneNumberType DirectRouting `
    -PhoneNumber +551140000000
```

---

## 🔒 Segurança

O script:

- Exige execução como administrador
- Limita tentativas de conexão
- Trabalha com política de execução restrita
- Possui tratamento básico de erros

---

## 📌 Observações

- O usuário utilizado na autenticação deve possuir permissões adequadas no Microsoft Teams.
- Os ramais devem seguir o padrão aceito pelo ambiente de telefonia configurado.
- O script foi pensado para ambientes corporativos com telefonia integrada ao Microsoft Teams via Direct Routing.

---

## 🚀 Melhorias Futuras

- Interface gráfica (GUI)
- Consulta de ramais disponíveis
- Logs automáticos
- Histórico de alterações
- Integração com Active Directory
- Suporte a remoção de ramais

---

## 👨‍💻 Autor

Desenvolvido para automatizar processos internos de telefonia corporativa utilizando Microsoft Teams e PowerShell.
