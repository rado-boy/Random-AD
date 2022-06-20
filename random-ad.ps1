function New-Name {
    # Pulls a random full name from pseudoramdom.name and returns it
    $NameRequest = Invoke-WebRequest pseudorandom.name 
    return $($NameRequest.ParsedHtml.getElementsByTagName('h1')).innertext 
}

function Get-Password {
    # Pulls a random password from provided passwords.txt and returns it
    $PasswordList = Get-Content passwords.txt
    return $(Get-Random -InputObject $PasswordList)
}
function Get-Department {
    # Pulls a random department name from provided departments.txt and returns it
    $DepartmentList = Get-Content departments.txt
    return $(Get-Random -InputObject $DepartmentList)
}

function New-User {
    <# Generates all needed information for a new user account and creates it in AD
    Property: Amount
        How many users to create
        Default: 1

    Property: CompanyName
        Name of Company - used for name of Domain and UPN
        Default: example

    Property: Print
        Print the generated user info to console (bool)
        Default: False
    Property: Commit
        Whether or not to actually create user in AD (mostly for testing in a non-AD enabled environment)
        Default: False
    #> 
    [CmdletBinding()]
	param(
		[Parameter()] [string] $Amount = 1,
        [Parameter()] [string] $CompanyName = 'example',
        [Parameter()] [bool] $Print = $False,
        [Parameter()] [bool] $Commit = $False
	)

    for ($i = 1;$i -le $Amount;$i++) { 
    # Account creation loop - runs amount of times specified in Amount property
        # Account variables
        $FullName = New-Name
        $FirstName, $LastName = $FullName.Split()
        $RandomID = Get-Random -Minimum 1 -Maximum 999
        $SamAccountName = "$FirstName$LastName$RandomID"
        $UPN = "$SamAccountName@$CompanyName.com"
        $Password = Get-Password
        $Department = Get-Department

        # Dump account variables into a new object
        $User = New-Object -TypeName PSObject
        $d = [ordered]@{`
            Name=$FullName;`
            GivenName=$FirstName;`
            Surname=$LastName;`
            SamAccountName=$SamAccountName;`
            UserPrincipalName=$UPN;`
            Path="OU=Users,DC=$CompanyName,DC=com";`
            AccountPassword=$Password;`
            Department=$Department;`
            Enabled=$True`
        }
        $User | Add-Member -NotePropertyMembers $d -TypeName User

        # Print output as table if Print property is True
        if ($Print -eq $True) {
            $User | Select-Object -Property * | Format-Table
        }

        # Do the deed if Commit property is True
        # If you wanted to output to a file or something, you could do it here by just replacing New-ADUser command
        if ($Commit -eq $True) {
            New-ADUser $User
        }

    }
}

#Script Block
New-User -Print $True