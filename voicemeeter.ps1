# Obtient le processus audiodg
$audiodgProcess = Get-Process -Name audiodg -ErrorAction SilentlyContinue

# Obtient le processus voicemeeter, il n'est pas exactement "voicemeeter" mais il doit contenir "voicemeeter"
$voicemeeterProcess = Get-Process | Where-Object {$_.ProcessName -like "*voicemeeter*"}

# Vérifie si le processus audiodg est en cours d'exécution
if ($audiodgProcess -eq $null -or $voicemeeterProcess -eq $null) {
    Write-Host "Le processus audiodg ou voicemeeter n'est pas en cours d'execution." -ForegroundColor Red
} else {
    # Obtient le nombre total de cœurs du processeur
    $numberOfCores = (Get-WmiObject Win32_ComputerSystem).NumberOfLogicalProcessors

    # Calcule l'affinité pour le dernier cœur du processeur
    $lastCoreAffinity = [math]::Pow(2, $numberOfCores - 1)

    # Convertit l'affinité en type [IntPtr]
    $lastCoreAffinity = [IntPtr]::new($lastCoreAffinity)

    # Définit l'affinité et la priorité du processus audiodg et voicemeeter
    $audiodgProcess.ProcessorAffinity = $lastCoreAffinity
    $audiodgProcess.PriorityClass = "High"
    $voicemeeterProcess.ProcessorAffinity = $lastCoreAffinity
    $voicemeeterProcess.PriorityClass = "High"

    Write-Host "Laffinite et la priorite du processus audiodg et voicemeeter ont ete modifiees." -ForegroundColor Green
}