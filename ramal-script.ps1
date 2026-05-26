<# 
=========================================
Estruturação do script (Funcionalidades)
=========================================
#>

<#
==================
Inativa no código
==================

Função para alterar as políticas de execução.
Ela é responsável por restringir a política de execução do 
powershell dentro do escopo do usuário.
#>
function Change-Policy {
    Write-Host "Alterando política para Restrita..."
    Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser -Force
    Write-Host "Política de execução alterada para Restrita."
}

#Função para verificar se o usuário é administrador
function Test-Isadmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent() 
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

<#
Função que verifica se o executor possuí o módulo do Teams instalado, 
se não possuir o mesmo é instalado.
#>
function Install-TeamsModule {
    $moduleName = "MicrosoftTeams"
    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        Write-Host "Modulo '$moduleName' não encontrado. Instalando..."
        try {
            Install-Module -Name $moduleName -Force -Scope CurrentUser
            Write-Host "Modulo '$moduleName' instalado com sucesso."
        }
        catch {
            Write-Host "Erro ao tentar instalar o módulo '$moduleName'. Verifique suas permissões."
            exit
        }
    }
    else {
        Write-Host "Modulo '$moduleName' já está instalado."
    }
}
<#
Função para tentar conectar ao Microsoft Teams.
Caso não consiga lança uma exceção.
#>
function Connect-Teams {
    Write-Host "Conectando ao Microsoft Teams..."
    try {
        $teamsConnection = Connect-MicrosoftTeams
        if ($teamsConnection) {
            Write-Host "Conexão bem-sucedida com o Microsoft Teams."
            return $true
        }
    }
    catch {
        Write-Host "Erro ao conectar ao Microsoft Teams: $_"
    }
    Write-Host "Falha ao conectar ao Microsoft Teams."
    return $false
}

<# 
Função para gerenciar ramais.
Responsável por interagir com o usuário e coletar 
dados essênciais para a atribuição do ramal
#>
function Manage-Ramal {
    param (
        [string]$action
    )

    $user = Read-Host "Insira e-mail do colaborador"
    $ramal = Read-Host "Insira o novo ramal do colaborador"
    Write-Host "Deseja concluir? (S/N)"
    $retry = Read-Host

    if ($retry -eq "S" -or $retry -eq "s") {
        try { 
            Set-CsPhoneNumberAssignment -Identity $user -PhoneNumberType DirectRouting -PhoneNumber $ramal
            Write-Host "O ramal $ramal foi alterado/atribuido com sucesso para o usuário $user."
        }
        catch {
            Write-Host "Erro ao $action o ramal para o usuário $user. Detalhes: $_"
        }
    }
    else {
        Write-Host "Operação cancelada."
    }
}

<#
===========================
Parte Principal do Script
===========================
#>

#Verificar usuário
if (-not (Test-Isadmin)) {
    Write-Host "Este script deve ser executado como administrador."
    Start-Sleep 2
    exit
}

# Chama o método para verificar e instalar o módulo do Teams
Install-TeamsModule

<#
Tentar conectar ao Microsoft Teams com até 3 tentativas.
Após exceder o número de tentativas, lança uma exceção.
#>
$connectionAttempts = 0
$maxAttempts = 3
$teamsConnection = $false

while (-not $teamsConnection -and $connectionAttempts -lt $maxAttempts) {
    $teamsConnection = Connect-Teams
    if (-not $teamsConnection) {
        Write-Host "Deseja tentar novamente? (S/N)"
        $retry = Read-Host
        if ($retry -eq "S" -or $retry -eq "s") {
            $connectionAttempts++
            Write-Host "Tentando novamente... ($connectionAttempts de $maxAttempts)"
        }
        else {
            Write-Host "Saindo do script."
            exit
        }
    }
}

if ($connectionAttempts -ge $maxAttempts -and -not $teamsConnection) {
    Write-Host "Número máximo de tentativas atingido. Saindo do script."
    exit
}

# Menu de opções
Write-Host "Escolha a atividade:"
Write-Host "1 - Alterar/Atribuir Ramal"
Write-Host "0 - Sair do script"

while ($true) {
    $respost = Read-Host

    switch ($respost) {
        "1" {
            Manage-Ramal -action "alterar"
        }
        "0" {
            Write-Host "Saindo do script."
            Start-Sleep -Seconds 2
            exit
        }
        default {
            Write-Host "Opção inválida. Tente novamente."
        }
    }

    Write-Host "Escolha a atividade:"
    Write-Host "1 - Atribuir/Alterar Ramal"
    Write-Host "0 - Sair do script"
}