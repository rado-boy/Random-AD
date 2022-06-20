Random-AD

Powershell script made by me to automate mass-creation of simple user accounts in an AD environment

If ran without editing script block, it won't do anything besides print generated info for one user in a table; run New-User with "Commit" property to create the account in AD

Just in case it is not obviouos, if you want the script to do anything besides generate user info it must be ran under a domain user with permission to create new accounts

NOTE: This script has NOT been tested in an AD environment (yet)


Credits:

Random name generation achieved by making web requests to psuedorandom.name
 - https://github.com/treyhunner/pseudorandom.name

passwords.txt file created by randomly selecting parts of this list
 - https://github.com/danielmiessler/SecLists/blob/master/Passwords/Common-Credentials/10-million-password-list-top-1000000.txt
