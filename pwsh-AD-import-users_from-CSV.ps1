<#----------------------------------
    .SYNOPSIS  
        Import number of users from a CSV file. CSV file attached as separate file as sample
    .NOTES 
	   Created to import massive set of users, either dummy or from backup into a new on-premises Active Directory
    .AUTHOR
        Dexter
    .LOGIC
        For loop goes through CSV file with as many rows that have information
    .FUNCTIONS
	   
    .VERSION
        1.0
    .EXAMPLE USAGE
	   Run this from either ISE, VS Code, or just as a regular .ps1 file. Make sure you have values in your .CSV, and put the correct path
----------------------------------#>


# Import active directory module for running AD cmdlets
Import-Module activedirectory

#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv "D:\import\CSV_files\AD_users.csv"

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
#Read user data from each field in each row and assign the data to a variable as below
    $City         	=$User.City         
    $Company      	=$User.Company
    $Description    =$User.Description      
    $Department   	=$User.Department   
    $Email        	=$User.Email        
    $Employeeid   	=$User.Employeeid 
    $GivenName    	=$User.GivenName
    $MobilePhone    =$User.MobilePhone
    $Office         =$User.Office
    $OfficePhone  	=$User.OfficePhone  
    $Password     	=$User.Password     
    $Path         	=$User.Path
    $Postalcode     =$User.Postalcode
    $State        	=$User.State        
    $Streetaddress	=$User.Streetaddress
    $SurName      	=$User.SurName      
    $Title        	=$User.Title
    $Username = $GivenName + "." + $Surname # change username to your preference in AD

    #Check to see if the user already exists in AD
if (Get-ADUser -F {SamAccountName -eq $Username})
    {    #If user does exist, give a warning
		 Write-Warning "A user account with username $Username already exist in AD."
	}
	else
    {
        #User does not exist then proceed to create the new user account
		#Account will be created in the OU provided by the $Path variable read from the CSV file
        New-ADUser `
            -City $City `
            -Company $Company `
            -Description $Description `
            -Department $Department `
            -Email $Email `
            -EmployeeID $EmployeeID ` #Optional field
            -GivenName $GivenName `
            -MobilePhone $MobilePhone `
            -Office $Office ` #Optional field
            -OfficePhone $OfficePhone ` #Optional field
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) `
            -Path $Path ` # OU path in your Active Directory
            -Postalcode $Postalcode ` #Optional field
            -State $State ` #Optional field
            -Streetaddress $Streetaddress ` #Optional field
            -SurName $SurName `
            -Title $Title ` #Optional field
            -SamAccountName $Username `
            -UserPrincipalName "$Username@domain.com" ` # change to your domain!
            -Name "$GivenName $SurName" `
            -DisplayName "$GivenName $SurName" `
            -Enabled $true
    }
}




<#--------------Sample .CSV headings below that work in this:
City,Company,Department,Description,Email,EmployeeID,GivenName,MobilePhone,Office,OfficePhone,Password,Path,Postalcode,State,StreetAddress,SurName,Title
Citadel of Ricks,Today NewsPaper,Department of Home Wreckin',Super Descriptor,Dudelove@duder-me.com,C-137,Jerry,587-111-2222,Michigan Office,403-555-1111,H@nnur1biI,"OU=DTAB-Users,DC=dtab,DC=org",90210,Minnesota,127-B Basement Suite 8,Smith,Marketing Dude (not really)

For some reason, this will NOT take the -Country $Country, it always fails or shows that field isn't valid. So DON'T use it.
-----------------#>