# HelloID-Task-SA-Target-ActiveDirectory-GroupUpdateManager
###########################################################
# Form mapping
$formObject = @{
    GroupIdentity            = $form.GroupIdentity
    ManagerUserPrincipalName = $form.managedBy.UserPrincipalName
}

try {
    Write-Information "Executing ActiveDirectory action: [GroupUpdateManager] for: [$($formObject.GroupIdentity)]"
    Import-Module ActiveDirectory -ErrorAction Stop
    $group = Get-ADgroup -Filter "Name -eq '$($formObject.GroupIdentity)'"
    $manager = Get-ADuser -Filter "UserPrincipalName -eq '$($formObject.ManagerUserPrincipalName)'"
    if (-not($group)) {
        Write-Error  "ActiveDirectory group [$($formObject.GroupIdentity)] does not exist"

    } elseif (-not($manager)) {
        Write-Error "ActiveDirectory account for manager: [$($formObject.ManagerUserPrincipalName)] does not exist"

    } elseif ($null -ne $group -and $null -ne $manager) {
        $null = Set-ADGroup -Identity $group -ManagedBy $manager
        $auditLog = @{
            Action            = 'UpdateResource'
            System            = 'ActiveDirectory'
            TargetIdentifier  = $([string]$group.SID)
            TargetDisplayName = $formObject.GroupIdentity
            Message           = "ActiveDirectory action: [GroupUpdateManager] with Manager [$($formObject.ManagerUserPrincipalName)] for: [$($formObject.GroupIdentity)] executed successfully"
            IsError           = $false
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action: [GroupUpdateManager] with Manager [$($formObject.ManagerUserPrincipalName)] for: [$($formObject.GroupIdentity)] executed successfully"
    }
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'UpdateResource'
        System            = 'ActiveDirectory'
        TargetIdentifier  = $([string]$group.SID)
        TargetDisplayName = $formObject.GroupIdentity
        Message           = "Could not execute ActiveDirectory action: [GroupUpdateManager] with Manager [$($formObject.ManagerUserPrincipalName)] for: [$($formObject.GroupIdentity)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    Write-Information -Tags 'Audit' -MessageData $auditLog
    Write-Error "Could not execute ActiveDirectory action: [GroupUpdateManager] with Manager [$($formObject.ManagerUserPrincipalName)] for: [$($formObject.GroupIdentity)], error: $($ex.Exception.Message)"
}
###########################################################
