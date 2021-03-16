## Liste de fonctions et de commandes utiles pour l'administrations d'utilisateurs Active Directory

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





