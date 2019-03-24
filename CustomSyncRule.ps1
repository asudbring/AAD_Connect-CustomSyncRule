## Commands to create custom sync rule in Azure AD connect to filter accounts.  
###############################################################################################
## Rule Definition
## If 'customAttribue1' contains BlockSync AND NotContain AllowSync then DO NOT SYNC to AAD ##
###############################################################################################

### Enter Variables for commands ###
$RuleName = 'Custom Rule Name'
$ID = New-Guid
$Description = 'Custom Rule Description'
$Connector = Get-ADSyncConnector
$attribute = 'customAttribute1'

## This creates the new rule and names it and declares what object it's working on, in this case it's user/person so the rule will only work on user objects and puts the information in the variable $syncrule ##
New-ADSyncRule `
-Name $RuleName `
-Identifier $ID `
-Description $Description `
-Direction 'Inbound' `
-Precedence 77 `
-PrecedenceAfter '00000000-0000-0000-0000-000000000000' `
-PrecedenceBefore '00000000-0000-0000-0000-000000000000' `
-SourceObjectType 'user' `
-TargetObjectType 'person' `
-Connector $Connector[1].Identifier `
-LinkType 'Join' `
-SoftDeleteExpiryInterval 0 `
-ImmutableTag '' `
-OutVariable syncRule

## This adds the sync rule flow mapping to the variable
Add-ADSyncAttributeFlowMapping `
-SynchronizationRule $syncRule[0] `
-Source @('True') `
-Destination 'cloudFiltered' `
-FlowType 'Constant' `
-ValueMergeType 'Update' `
-OutVariable syncRule

## This adds the first rule that is firing off the "customAttribute1" and has "BlockSync" for the value and puts it in variable $condition0
New-Object `
-TypeName 'Microsoft.IdentityManagement.PowerShell.ObjectModel.ScopeCondition' `
-ArgumentList $attribute,'BlockSync','CONTAINS' `
-OutVariable condition0

## This adds the second rule that is firing off the "customAttribute1" and has either "AllowSync" or "NOTCONTAINS" and puts it in the variable #condition1
New-Object `
-TypeName 'Microsoft.IdentityManagement.PowerShell.ObjectModel.ScopeCondition' `
-ArgumentList $attribute,'AllowSync','NOTCONTAINS' `
-OutVariable condition1

## This builds the rule and the condtions to the rule and puts it in variable #syncrule
Add-ADSyncScopeConditionGroup `
-SynchronizationRule $syncRule[0] `
-ScopeConditions @($condition0[0],$condition1[0]) `
-OutVariable syncRule

## Adds the Rule
Add-ADSyncRule -SynchronizationRule $syncRule[0]

## Retrieves the setting of the rule
Get-ADSyncRule -Identifier $ID