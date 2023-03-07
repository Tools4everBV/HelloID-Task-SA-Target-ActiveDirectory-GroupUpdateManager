# HelloID-Task-SA-Target-ActiveDirectory-GroupUpdateManager
###########################################################
# Form mapping
$formObject = @{
    GroupName                = $form.groupName
    ManagerUserPrincipalName = $form.managedBy.UserPrincipalName
}

try {
    Write-Information "Executing ActiveDirectory action: [GroupUpdateManager] for: [$($formObject.GroupName)]"
    Import-Module ActiveDirectory -ErrorAction Stop
    $group = Get-ADgroup -Filter "Name -eq '$($formObject.GroupName)'"
    $manager = Get-ADuser -Filter "UserPrincipalName -eq '$($formObject.ManagerUserPrincipalName)'"
    if (-not($group)) {
        Write-Error  "ActiveDirectory group [$($formObject.GroupName)] does not exist"

    } elseif (-not($manager)) {
        Write-Error "ActiveDirectory account for manager: [$($formObject.managerUserPrincipalName)] does not exist"

    } elseif ($null -ne $group -and $null -ne $manager) {
        $null = Set-ADGroup -Identity $group -ManagedBy $manager
        $auditLog = @{
            Action            = 'UpdateResource'
            System            = 'ActiveDirectory'
            TargetIdentifier  = $([string]$group.SID)
            TargetDisplayName = $formObject.GroupName
            Message           = "ActiveDirectory action: [GroupUpdateManager] with Manager [$($formObject.ManagerUserPrincipalName)] for: [$($formObject.GroupName)] executed successfully"
            IsError           = $false
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action: [GroupUpdateManager] with Manager [$($formObject.ManagerUserPrincipalName)] for: [$($formObject.GroupName)] executed successfully"
    }
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'UpdateResource'
        System            = 'ActiveDirectory'
        TargetIdentifier  = $([string]$group.SID)
        TargetDisplayName = $formObject.GroupName
        Message           = "Could not execute ActiveDirectory action: [GroupUpdateManager] with Manager [$($formObject.ManagerUserPrincipalName)] for: [$($formObject.GroupName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    Write-Information -Tags 'Audit' -MessageData $auditLog
    Write-Error "Could not execute ActiveDirectory action: [GroupUpdateManager] with Manager [$($formObject.ManagerUserPrincipalName)] for: [$($formObject.GroupName)], error: $($ex.Exception.Message)"
}
###########################################################
