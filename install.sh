#!/bin/bash
### YSFReflector-Installation-Script
#
# This script installes a YSFReflector on a Debian-like Linux-System
# with modification of YSFReflector.ini and creation of all necessary
# scripts to start and run the reflector.
#
# written 2018-01-15 by Kim Huebel, DG9VH
#
# Changelog:
# 2018-01-15: initial shot
#
###
echo Checking prerequisites
ERROR=0
dpkg -s git &> /dev/null
if [ $? -eq 0 ]; then
    echo "Package git is installed!"
else
    echo "Package git is NOT installed!"
    ERROR=1
fi
dpkg -s build-essential &> /dev/null
if [ $? -eq 0 ]; then
    echo "Package build-essential is installed!"
else
    echo "Package build-essential is NOT installed!"
    ERROR=1
fi
if [ $ERROR == 1 ]; then
    echo "Please install missing packages!"
    exit 1
fi
echo Cloning repository from github
git clone https://github.com/g4klx/YSFClients.git
echo
echo compiling
cd YSFClients/YSFReflector/
make clean all
echo
echo Copying ini-file
sudo cp YSFReflector.ini /etc/YSFReflector.ini
echo
echo Name of Reflector - 16 characters maximum length:
read -r name
sudo sed -i -e "s/16 characters max/${name}/g" /etc/YSFReflector.ini
echo Description of Reflector - 14 characters maxmimum length:
read -r description
sudo sed -i -e "s/14 characters max/${description}/g" /etc/YSFReflector.ini
sudo groupadd mmdvm
sudo useradd mmdvm -g mmdvm -s /sbin/nologin
sudo cp YSFReflector /usr/local/bin/YSFReflector
sudo mkdir /var/log/YSFReflector
sudo chown mmdvm /var/log/YSFReflector
sudo sed -i -e "s/FilePath=./FilePath=\/var\/log\/YSFReflector/g" /etc/YSFReflector.ini
cat > YSFReflector.sh << EOF
#!/bin/bash
### BEGIN INIT INFO
#
# Provides:             YSFReflector
# Required-Start:       \$all
# Required-Stop:        
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Example startscript YSFReflector

#
### END INIT INFO
## Fill in name of program here.
PROG="YSFReflector"
PROG_PATH="/usr/local/bin/"
PROG_ARGS="/etc/YSFReflector.ini"
PIDFILE="/var/run/YSFReflector.pid"
USER="root"

start() {
      if [ -e \$PIDFILE ]; then
          ## Program is running, exit with error.
          echo "Error! \$PROG is currently running!" 1>&2
          exit 1
      else
          cd \$PROG_PATH
          ./\$PROG \$PROG_ARGS
          echo "\$PROG started"
          touch \$PIDFILE
      fi
}

stop() {
      if [ -e \$PIDFILE ]; then
          ## Program is running, so stop it
         echo "\$PROG is running"
         rm -f \$PIDFILE
         killall \$PROG
         echo "\$PROG stopped"
      else
          ## Program is not running, exit with error.
          echo "Error! \$PROG not started!" 1>&2
          exit 1
      fi
}

## Check to see if we are running as root first.
## Found at
## http://www.cyberciti.biz/tips/shell-root-user-check-script.html
if [ "\$(id -u)" != "0" ]; then
      echo "This script must be run as root" 1>&2
      exit 1
fi

case "\$1" in
      start)
          start
          exit 0
      ;;
      stop)
          stop
          exit 0
      ;;
      reload|restart|force-reload)
          stop
          sleep 5
          start
          exit 0
      ;;
      **)
          echo "Usage: \$0 {start|stop|reload}" 1>&2
          exit 1
      ;;
esac
exit 0
### END
EOF
sudo cp YSFReflector.sh /etc/init.d/YSFReflector.sh
sudo chmod +x /etc/init.d/YSFReflector.sh
sudo insserv YSFReflector.sh
echo
echo "Congrats, now you can start your reflector with" 
echo "sudo /etc/init.d/YSFReflector.sh start"
