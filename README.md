
# HelloID-Task-SA-Target-ActiveDirectory-GroupUpdateManager

## Prerequisites

- [ ] The HelloID SA on-premises agent installed

- [ ] The ActiveDirectory module is installed on the server where the HelloID SA on-premises agent is running.

## Description

This code snippet executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hashtable are required to update the manager with the `Set-ADGroup` cmdlet, while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

```json
{
    "GroupIdentity": "TestGroup1",
    "managedBy": {
        "UserPrincipalName" : "john.doe@Tools.com"
    }
}
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hashtable is appropriately adjusted to match your form fields.
> > The field **GroupIdentity** accepts different values [See the Microsoft Docs page](https://learn.microsoft.com/en-us/powershell/module/activedirectory/set-adgroup?view=windowsserver2022-ps)


2. Imports the ActiveDirectory module.

3. Retrieve the groups object using the `Get-ADGroup` cmdlet using a filter with the name property. ```-Filter "Name -eq '$($formObject.GroupIdentity)'"```

4. Retrieve the manager account object using the `Get-ADUser` cmdlet.

5. Update the manager using the `$group` object retrieved from step 3 and the `$manager` object from step 4
