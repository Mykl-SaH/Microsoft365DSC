[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "IntuneRoleDefinition" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin@mydomain.com", $secpasswd)


            #Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            #}

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgDeviceManagementRoleDefinition -MockWith {
            }

            Mock -CommandName New-MgDeviceManagementRoleDefinition -MockWith {
            }

            Mock -CommandName Remove-MgDeviceManagementRoleDefinition -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The IntuneRoleDefinition should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        IsBuiltIn = $True
                        allowedResourceActions = @("Microsoft.Intune_Organization_Read","Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update")
                        notallowedResourceActions = @()
                        Ensure                        = "Present"
                        Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementRoleDefinition -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgDeviceManagementRoleDefinition -Exactly 1
            }
        }

        Context -Name "The IntuneRoleDefinition exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        IsBuiltIn = $True
                        allowedResourceActions = @("Microsoft.Intune_Organization_Read","Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update")
                        notallowedResourceActions = @()
                        Ensure                        = "Absent"
                        Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementRoleDefinition -MockWith {
                    return @{
                        Description               = "FakeStringValue"
                        DisplayName               = "FakeStringValue"
                        Id                        = "FakeStringValue"
                        IsBuiltIn                 = $True
                        RolePermissions           = @{
                            ResourceActions           = @{
                                AllowedResourceActions    = @("Microsoft.Intune_Organization_Read","Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update")
                                NotAllowedResourceActions = @()
                            }
                        }
                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementRoleDefinition -Exactly 1
            }
        }
        Context -Name "The IntuneRoleDefinition Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description               = "FakeStringValue"
                        DisplayName               = "FakeStringValue"
                        Id                        = "FakeStringValue"
                        IsBuiltIn                 = $True
                        allowedResourceActions    = @("Microsoft.Intune_Organization_Read","Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update")
                        notallowedResourceActions = @()
                        Ensure                    = "Present"
                        Credential                = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementRoleDefinition -MockWith {
                    return @{
                        Description               = "FakeStringValue"
                        DisplayName               = "FakeStringValue"
                        Id                        = "FakeStringValue"
                        IsBuiltIn                 = $True
                        RolePermissions           = @{
                            ResourceActions           = @{
                                AllowedResourceActions    = @("Microsoft.Intune_Organization_Read","Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update")
                                NotAllowedResourceActions = @()
                            }
                        }
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneRoleDefinition exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        IsBuiltIn = $True
                        allowedResourceActions = @("Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update")
                        notallowedResourceActions = @()
                        Ensure                = "Present"
                        Credential            = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementRoleDefinition -MockWith {
                    return @{
                        Description               = "FakeStringValue"
                        DisplayName               = "FakeStringValue"
                        Id                        = "FakeStringValue"
                        IsBuiltIn                 = $True
                        RolePermissions           = @{
                            ResourceActions           = @{
                                AllowedResourceActions    = @("Microsoft.Intune_Organization_Read","Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update")
                                NotAllowedResourceActions = @()
                            }
                        }
                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementRoleDefinition -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementRoleDefinition -MockWith {
                    return @{
                        Description               = "FakeStringValue"
                        DisplayName               = "FakeStringValue"
                        Id                        = "FakeStringValue"
                        IsBuiltIn                 = $True
                        RolePermissions           = @{
                            ResourceActions           = @{
                                AllowedResourceActions    = @("Microsoft.Intune_Organization_Read","Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update")
                                NotAllowedResourceActions = @()
                            }
                        }
                    }
                }
            }
            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope