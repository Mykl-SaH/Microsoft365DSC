<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicyEmail "AADAuthenticationMethodPolicyEmail-Email"
        {
            Ensure                       = "Absent";
            Id                           = "Email";
            State                        = "disabled"; # Updated Property
            Credential                   = $credsCredential;
        }
    }
}
