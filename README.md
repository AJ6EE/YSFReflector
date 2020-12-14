## YSFReflector setup using puppet by AJ6EE

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)

## General info
This project is for using Puppet to create a YSFReflector node.
	
## Technologies
Project is created with:
* YSMReflector

	
## Setup
We will use the Quick-Install sctipt and my puppet manifest.
```
$ sudo su -
$ git clone https://github.com/AJ6EE/YSFReflector
$ cd YSFReflector
$ chmod a+x install.sh
$ edit the YSFReflector.ini for your node. Set the: Name:  Description: Logging: Port:
$ apt-get install -y puppet
$ puppet apply --noop puppet-V2.pp ### check the output for errors. If no errors run the next command
$ puppet apply puppet-V2.pp
```
