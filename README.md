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
* YSFSashboard   C
* Puppet

	
## Setup
We will use the Quick-Install script from YSFReflector.de and my puppet manifest.
Comments are shown with ###
```
$ sudo su -
$  ### First lets build the YSFReflector binary, init script and config file  ### 
$ wget https://register.ysfreflector.de/install.sh
$ chmod a+x install.sh
$ bash ./install.sh   ### type in a node name and description but we will be editing /etc/YSFReflector.ini below
$ git clone https://github.com/AJ6EE/YSFReflector
$ cd YSFReflector
$ edit (vi, nano etc) the YSFReflector.ini file. Edit only the following lines with your information and save the file:
$
*  Name=Your-Callsign  ##your callsign
*  Description=Your-Description   ### your description
*  FileLevel=1   ### This must be 1 or the dashboard will not work
*  Port=41000   ###  your port
$
$  ### Leave the YSFReflector.ini file in the YSFReflector folder. Do not move it to /etc. Puppet will do that
$
$ $ ###  Let's build the Dashboard. Stay in the /root/YSFReflector directory.
$ git clone https://github.com/dg9vh/YSFReflector-Dashboard.git
$ cp -R YSFReflector-Dashboard/* /var/www/html/
$  ### Don't worry about permissions for /var/www/html . Puppet will do that. 
$
$ apt-get install -y puppet
$ puppet apply --noop puppet-V2.pp ### check the output for errors. If no errors run the next command
$ puppet apply puppet-V2.pp
```
