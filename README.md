## YSFReflector setup on Raspberry Pi 3 using YSFReflector.de script and puppet by AJ6EE

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)

## General info
This project is for using YSFReflector.de script and Puppet to create a YSFReflector node.
	
## Technologies
Project is created with:
* YSFReflector   https://register.ysfreflector.de/
* YSFDashboard   https://github.com/dg9vh/YSFReflector-Dashboard
* Puppet	 https://puppet.com

	
## Setup
We will use the Quick-Install script from https://register.ysfreflector.de , 
YSFReflector-Dashboard from https://github.com/dg9vh/YSFReflector-Dashboard and my puppet manifests.
Comments are shown with ###
```
$ ### lets be root
$ sudo su - 
$ ### Build the YSFReflector binary, init script and config file  ### 
$ wget https://register.ysfreflector.de/install.sh
$ chmod a+x install.sh
$ bash ./install.sh   ### type in a node name and description but we will be editing /etc/YSFReflector.ini below.
$
$ ###  Rename the YSFReflector init script so puppet can hopefully start it. See NOTE: at the EOF.
$ mv /etc/init.d/YSFReflector.sh /etc/init.d/YSFReflector
$ 
$ ### Get my code and be ready to do some puppet magic later on.
$ git clone https://github.com/AJ6EE/YSFReflector
$ cd YSFReflector
$ ### Edit (vi, nano etc) the YSFReflector.ini file. Edit only the following lines with your information and save the file:
$
*   Name=Your-Callsign  ### Your-Callsign
*   Description=Your-Description   ### Your Node Description. 18 characters MAX
*   FileLevel=1   ### This must be 1 or the dashboard will not work
*   Port=41000   ###  Your Port. Default=41000
$
$ ### Leave the YSFReflector.ini file in the YSFReflector folder. Do not move it to /etc. Puppet will do that.
$ ###  Let's build the Dashboard. Stay in the /root/YSFReflector directory.
$ git clone https://github.com/dg9vh/YSFReflector-Dashboard.git
$ cp -R YSFReflector-Dashboard/* /var/www/html/
$ ### Don't worry about permissions for /var/www/html . Puppet will do that later. 
$
$ apt-get install -y puppet
$ puppet apply --noop puppet-V2.pp ### pre flight check. If no errors run the next command
$ puppet apply puppet-V2.pp  
$ ### This will install apache2, php etc and start apache2 and hopefully the YSFReflector service. Also move YSFReflcetor.ini to /etc
$
$ ### Go to http://ip-address-of-node/setup.php  ### the fields look like they are filled in but you have to type in all fields
$ ### just as they are shown. Save when done.
$ ###Your Dashboard is now done but we need to remove the setup.php file:
$ puppet apply --noop puppet-drop-setup.pp  ### pre flight check. If no errors run the next command
$ puppet apply puppet-drop-setup.pp
$ 
$ ### Note: I have inconsistencies with puppet starting the YSFReflector service. 
$ ### You can use 'ps ax | grep YSF' to see if it is running or just:
$
$ /etc/init.d/YSFReflector start
$
$ ### That is all :) Your node is up and running! Congratulations!  73 de AJ6EE
```
