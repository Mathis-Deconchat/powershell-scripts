### Liste de fonctions et de commandes utiles pour l'administrations d'utilisateurs Active Directory

## Check des dépendences
try {
    Import-Module ActiveDirectory
    Write-Host "✔ Import du module ActiveDiretory OK 😊"  
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host $ErrorMessage
    Write-Host "Module Active Directory introuvable 😢"
    Write-Host "https://docs.microsoft.com/en-us/powershell/module/addsadministration/?view=win10-ps"
    Exit;
}

## Liste de tout les utilisateurs actifs
Get-ADUser -filter { enabled -eq $true }

## Lister les utilisateurs inactifs
Get-ADUser -filter { enabled -eq $false }

## Informations sur un utilisateur
$username = ""
Get-ADUser $username

## Informations sur les utilisateurs d'une OU en particulier
$ou = ''
Get-ADUser -SearchBase $ou -Filter *

## Exporter les utilisateurs actifs en CSV
$csvParam = @{
    Delimiter         = ';'
    Encoding          = 'utf8'
    Force             = $true
    NoTypeInformation = $true
}

$date = Get-Date -format 'yyyyMMdd_HHmmss'

$path = "./$date" + "export-user-actifs.csv"

Get-ADUser -filter { enabled -eq $true } | Export-Csv @csvParam -Path $path


## Lister les dates d'expirations des mots de passe de tout les utilisateurs actifs et avec une date d'expiration pour le mot de passe
Get-ADUser -filter { Enabled -eq $True -and PasswordNeverExpires -eq $False } –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property "Displayname", @{Name = "ExpiryDate"; Expression = { [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") } }

## Lister les utilisateurs ayant le mot de passe qui expire dans X jours
$daysToExpire = 7
Get-ADUser -filter { Enabled -eq $True -and PasswordNeverExpires -eq $False } -Properties "DisplayName", "samAccountname", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property "Displayname", "samAccountName" @{Name = "ExpiryDate"; Expression = { [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") } } |
Where-Object { $_.ExpiryDate -lt (Get-Date).AddDays($daysToExpire) -and $_.ExpiryDate -gt (Get-Date) }

## Lister les comptes expirés
Search-ADAccount -AccountExpired -UsersOnly | 
Where-Object { (Get-AdUser $_.DistinguishedName) | Where-Object { 
        $_.enabled -eq $true } } | 
Select-Object Name, SamAccountName, DistinguishedName, AccountExpirationDate













