# YSFReflector Bare Metal Installation with nginx

Direct installation on Linux Mint VM (or any Debian/Ubuntu-based system) using **nginx** instead of Apache.

---

## What This Script Does

This is the **bare metal** version - installs directly on your Linux Mint VM:
- ✓ Installs nginx + PHP-FPM
- ✓ Builds YSFReflector from source
- ✓ Installs Dashboard
- ✓ Configures everything automatically
- ✓ Starts services

**No Docker, no containers - just plain Linux installation.**

---

## Why nginx?

✅ **Modern** - Industry standard web server  
✅ **Fast** - Better performance than Apache  
✅ **Lightweight** - Uses less memory  
✅ **Common** - What most people use now  

---

## Quick Start

### On Linux Mint VM:

```bash
# Download the script
wget https://raw.githubusercontent.com/AJ6EE/YSFReflector/main/ysf-nginx-install.sh

# Make it executable
chmod +x ysf-nginx-install.sh

# Run it (needs sudo)
sudo ./ysf-nginx-install.sh AJ6EE "Kevin's Test Node" 42000 "America/Los_Angeles"
```

**That's it!** Open your browser to: `http://YOUR_VM_IP/`

---

## What Gets Installed

### Packages:
- nginx (web server)
- php-fpm (PHP processor)
- php-cli (PHP command line)
- git (for downloading Dashboard)
- build-essential (compilers for YSFReflector)

### Software:
- YSFReflector (binary in /usr/local/bin/)
- YSFReflector Dashboard (web interface in /var/www/html/)

### Services:
- nginx (port 80)
- php-fpm (socket: /run/php/php-fpm.sock)
- YSFReflector (port 42000)

---

## Differences from Apache Version

| Aspect | Apache Version | nginx Version |
|--------|----------------|---------------|
| Web Server | Apache2 | nginx |
| PHP Handler | libapache2-mod-php | php-fpm |
| Config File | /etc/apache2/sites-available/default | /etc/nginx/sites-available/default |
| Restart Command | `systemctl restart apache2` | `systemctl restart nginx` |
| Memory Usage | ~50MB | ~20MB |

Everything else is the same!

---

## Configuration Files

**nginx config:**
```
/etc/nginx/sites-available/default
```

**YSFReflector config:**
```
/etc/YSFReflector.ini
```

**Dashboard config:**
```
/var/www/html/config/config.php
```

**YSFReflector logs:**
```
/var/log/YSFReflector/
```

---

## Service Management

### nginx:
```bash
# Status
sudo systemctl status nginx

# Restart
sudo systemctl restart nginx

# Stop
sudo systemctl stop nginx

# Start
sudo systemctl start nginx

# View logs
sudo tail -f /var/log/nginx/error.log
```

### YSFReflector:
```bash
# Status
sudo /etc/init.d/YSFReflector status

# Restart
sudo /etc/init.d/YSFReflector restart

# Stop
sudo /etc/init.d/YSFReflector stop

# Start
sudo /etc/init.d/YSFReflector start

# View logs
sudo tail -f /var/log/YSFReflector/*.log
```

---

## Testing on Linux Mint VM

### 1. Install
```bash
sudo ./ysf-nginx-install.sh AJ6EE "Test Node" 42000 "America/Los_Angeles"
```

### 2. Check Services
```bash
# Check nginx
systemctl status nginx
curl http://localhost

# Check YSFReflector
ps aux | grep YSFReflector
```

### 3. Access Dashboard
Find your VM's IP:
```bash
ip addr show
# or
hostname -I
```

Open browser to: `http://YOUR_VM_IP/`

---

## Comparing to Original Script

**Original (ysf-fully-automated.sh):**
- Used Apache2
- Used libapache2-mod-php
- Used Puppet for configuration

**This Version (ysf-nginx-install.sh):**
- Uses nginx
- Uses php-fpm
- Direct bash configuration (no Puppet needed)
- Same end result!

---

## Troubleshooting

### nginx won't start:
```bash
# Check config syntax
sudo nginx -t

# View logs
sudo tail -f /var/log/nginx/error.log

# Check if something is on port 80
sudo netstat -tulpn | grep :80
```

### Dashboard shows blank page:
```bash
# Check PHP-FPM is running
systemctl status php*-fpm

# Check PHP-FPM logs
sudo tail -f /var/log/php*-fpm.log

# Check nginx error log
sudo tail -f /var/log/nginx/error.log
```

### YSFReflector won't start:
```bash
# Check the binary exists
ls -la /usr/local/bin/YSFReflector

# Check config exists
cat /etc/YSFReflector.ini

# Try manual start
sudo /usr/local/bin/YSFReflector /etc/YSFReflector.ini
```

### Dashboard shows PHP errors:
```bash
# Check permissions
sudo chown -R www-data:www-data /var/www/html/
sudo chown -R www-data:www-data /var/log/YSFReflector/

# Check PHP socket
ls -la /run/php/php*-fpm.sock
```

---

## Uninstall (Clean Removal)

If you want to remove everything:

```bash
# Stop services
sudo systemctl stop nginx
sudo /etc/init.d/YSFReflector stop

# Remove packages
sudo apt-get remove --purge nginx php-fpm php-cli

# Remove files
sudo rm -rf /var/www/html/*
sudo rm -rf /var/log/YSFReflector/
sudo rm -f /etc/YSFReflector.ini
sudo rm -f /usr/local/bin/YSFReflector
sudo rm -f /etc/init.d/YSFReflector
sudo rm -rf /root/YSFReflector

# Clean up
sudo apt-get autoremove
```

---

## Next Steps After Testing

Once you verify it works on your Mint VM:

1. **Test connectivity** - Connect from your radio
2. **Register your reflector** - https://register.ysfreflector.de/
3. **Consider Docker** - For when you want isolation
4. **Plan for K3s** - When your new PC arrives

---

## Advantages of This Approach

**Good for:**
- ✓ Learning how it works
- ✓ Testing before committing
- ✓ Systems where Docker isn't available
- ✓ Understanding the components
- ✓ Direct access to all files

**Not as good for:**
- ✗ Running multiple instances
- ✗ Easy cleanup/removal
- ✗ Isolation from host system
- ✗ Portability to other systems

That's why Docker exists! But for learning and testing, bare metal is perfect.

---

## Performance on Linux Mint VM

**Typical resource usage:**
- nginx: ~20MB RAM
- php-fpm: ~30MB RAM
- YSFReflector: ~30MB RAM
- **Total: ~80MB RAM**

Perfect for a VM!

---

## FAQ

**Q: Can I run this on Raspberry Pi?**  
A: Yes! Same script works on Raspberry Pi OS.

**Q: Can I use Apache instead?**  
A: Yes, see the original ysf-fully-automated.sh script.

**Q: Does this work on other distros?**  
A: Yes, any Debian/Ubuntu-based system. May need tweaks for RHEL/Fedora.

**Q: Can I change the port later?**  
A: Yes, edit `/etc/YSFReflector.ini` and restart YSFReflector.

**Q: How do I update YSFReflector?**  
A: Re-run the install.sh script from register.ysfreflector.de

---

## Summary

**To install:**
```bash
sudo ./ysf-nginx-install.sh CALLSIGN "DESCRIPTION" [PORT] [TIMEZONE]
```

**To access:**
```
http://YOUR_IP/
```

**To manage:**
```bash
systemctl {status|restart|stop|start} nginx
/etc/init.d/YSFReflector {status|restart|stop|start}
```

That's it! Simple, direct, and uses modern nginx.

**73 de AJ6EE** 📻

---

*Note: This is the BARE METAL version. For Docker deployment with nginx, see the Docker files.*
