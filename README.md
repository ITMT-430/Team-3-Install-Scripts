# Team-3-Install-Scripts
These scripts assist in building infrastructure.
All scripts are executed through the main deployment script (deploy-environment.sh).

##Before you run the script:
  1.  From a Debian machine, please switch to the root user.
  2.  Ensure that you have your eucalyptus credential file handy.
  3.  Ensure that you have the "Team3-new" private key identity added to the root user.
  4.  Be ready to open a new terminal window as the root user at certain parts of the script that require connection verrification.
  5.  Run the script **As The Root User!!!**.
    * Some of the eucalyptus functions that this script uses will not work well when run under a standard user using sudo.
    * Basic preliminary investigation has been done as to why, but nothing has been found yet.
    * Current workaround is to run as the root user.
  
##Script usage:
Rather than downloading the script, you can use curl to run the most up-to-date script.


**Syntax: "bash <(curl -s https://raw.githubusercontent.com/ITMT-430/Team-3-Install-Scripts/master/deploy-environment.sh)"**


If you want to download the script and run it that way, you can download the "deploy-environment.sh" script.  Please note that running the script by any other means than the command above *should* work, but it has not been tested, and is not supported.