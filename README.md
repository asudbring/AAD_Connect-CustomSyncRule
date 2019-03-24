# Azure Active Directory Connect Custom Sync Rule - Filter on custom or existing Active Directory Attribute

Azure AD Connect by default has the ability to filter objects from on-premises Active Directory using a Group, OU or both.  

**A group, per Microsoft documentation, should only be used in a pilot to test Azure AD Connect:**  

[Group-based filtering](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-configure-filtering#group-based-filtering)

This leaves selecting specific OUs in the Azure AD Connect Install and configuration wizard.  If these options do not meet your requirements, Azure AD Connect has the ability to create custom sync rules within the sync service editor.  

**Editing the built in rules is not recommended or supported and will be overwritten by an Azure AD Connect upgrade:**

[Changes to Synchronization Rules](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-best-practices-changing-default-configuration#changes-to-synchronization-rules)

The built in sync service editor can be used to create a custom rule in the graphical interface. An existing rule can be exported or a new rule can be created through a wizard.  The other option for rule creation is PowerShell.  Hence this repository and the PowerShell script contained within it.  

The purpose of the script is to create a custom sync rule in Azure AD Connect that will filter user objects synchronized from on-premises to Azure Active Directory.

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

* **$RuleName** - Enter the name of the Rule.

* **$ID** - **New-Guid** is executed to generate a unique identifier for the rule.

* **$Description** - Enter Description for Rule.

* **$Connector** - **Get-ADSyncConnector** is executed to retrieve the sync connector configuration.

* **$attribute** - Enter the name of the built in or custom Active Directory Attribute that the user object will contain AllowSync, BlockSync or remain blank.

## Execution

Copy the script to a test Azure AD Connect server or standby staging server and execute from PowerShell to test the results.  This script is meant for demonstration only and should be tested thoroughly in a lab environment and altered to your specifications before implementing in a production environment.

To verify that the filtering is working on the staging server or test server, refer to this document:

[Azure AD Connect: Staging server and disaster recovery](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-staging-server)

For more information on rule creation and instructions on how to add a custom attribute to the sync service refer to this document:

[Azure AD Connect sync: Make a change to the default configuration](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-change-the-configuration)

To create a custom Active Directory Attribute to use for the user objects if one of the built in ones is not suitable, refer to this document:

[How to Create a Custom Attribute in Active Directory](https://social.technet.microsoft.com/wiki/contents/articles/20319.how-to-create-a-custom-attribute-in-active-directory.aspx)

Use this to generate OID for attribute:

[Generate an Object Identifier from Powershell](https://gallery.technet.microsoft.com/scriptcenter/Generate-an-Object-4c9be66a)