
package { 'apache2':
	ensure => installed,
}

package { 'php-common':
	ensure => installed,
}

package { 'php-7.1-cgi':
	ensure => installed,
}

package { 'libapache2-mod-php7.1':
	ensure => installed,
}

file  { '/etc/YSFReflector.ini':
	ensure => present,
	source => 'https://github.com/AJ6EE/YSFReflector/blob/main/YSFReflector.ini',
	mode => '0644',
	notify => Service['YSFReflector.sh'],
}

file { '/var/log/YSFReflector/':
	ensure => directory.
	mode => '0755',
}	

service { 'apache2';
	ensure => running'
	enable => true',
}

service { 'YSFReflector';
	ensure => running'
	enable => true',
}

user { "pi":
    ensure => present,
    uid => 1000,
    gid => 1000,
    groups => [www-data],
}







