
package { 'apache2':
	ensure => installed,
}

package { 'php-common':
	ensure => installed,
}

package { 'php7.1-cgi':
	ensure => installed,
}

package { 'libapache2-mod-php7.1':
	ensure => installed,
}

file  { '/etc/YSFReflector.ini':
	ensure => present,
	source => '/root/YSFReflector/YSFReflector.ini',
	mode => '0644',
}

file { '/var/log/YSFReflector/':
	ensure => directory,
	mode => '0755',
}	

service { 'apache2':
	ensure => running,
	enable => true,
}

service { 'YSFReflector.sh':
	ensure => running,
	enable => true,
}

user { "pi":
    ensure => present,
    uid => 1000,
    gid => 1000,
    groups => [www-data],
}

file  { '/var/www/html/index.html':
	ensure => absent,
}

file { "/var/www/html":
  ensure => directory,
  recurse => true,
  owner => "www-data",
  group => "www-data",
  mode => '0755', 
  }



