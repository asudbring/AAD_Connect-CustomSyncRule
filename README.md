# Azure AD Connect Custom Sync Rule - Filter on custom Active Directory Attribute

Azure AD Connect by default has the ability to filter objects from on-premises Active Directory using a Group or by OU or both.  A group, per Microsoft Docs, should only be used in a pilot.  That leaves checking specific OUs in the Azure AD Connect Install Wizard.  If these options do not meet your requirements, Azure AD Connect has the ability to create custom sync rules within the sync service editor.  Editing the built in rules is not recommended or supported and will be overwritten on Azure AD Connect upgrade.  The built in sync service editor can be used to create a custom rule in the graphical interface. An existing rule can be exported or a new rule can be created from scratch.  The other option for rule creation is PowerShell.  Hence this repository and the PowerShell script contained within it.  

The purpose of this script is to create a custom sync rule in Azure AD Connect that will filter user objects synchronized from on-premises to Azure Active Directory.

When the rule is implemented, only user objects that contain **AllowSync** in an Active Directory attribute defined in the rule, will sync to Azure Active Directory.  If the attribute contains **BlockSync** or is empty, that object will not be synced to Azure AD.

## Variables

```powershell
### Enter Variables for commands ###
$RuleName = 'Custom Rule Name'
$ID = New-Guid
$Description = 'Custom Rule Description'
$Connector = Get-ADSyncConnector
$attribute = 'customAttribute1'
```

* **$RuleName** - Enter the name of the Rule

* **$ID** - **New-Guid** is executed to generate a unique identifier for the rule.

* **$Description** - Enter Description for Rule

* **Connector** - **Get-ADSyncConnector** is executed to retrieve the sync connector configuration

* **$attribute** - Enter the name of the built in or custom Active Directory Attribute that the user object will contain AllowSync, BlockSync or remain blank.

## Execution

Copy the script to a test Azure AD Connect server or standby staging server and execute from PowerShell to test the results.  This script is meant for demonstration only and should be tested thoroughly in a lab environment and altered to your specifications before implementing in a production environment.

To verify that the filtering is working on the staging server or test server, refer to this document:

[Azure AD Connect: Staging server and disaster recovery](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-staging-server)

For more information on rule creation and instructions on how to add a custom attribute to the sync service refer to this document:

[Azure AD Connect sync: Make a change to the default configuration](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-change-the-configuration)