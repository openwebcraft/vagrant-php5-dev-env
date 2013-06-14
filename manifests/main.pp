include apt

group { 'puppet':
	ensure => present
}

apt::source { "dotdeb":
     location => "http://packages.dotdeb.org",
     release => 'squeeze',
     repos => 'all',
     key => '89DF5277',
     key_source => "http://www.dotdeb.org/dotdeb.gpg"
}

apt::source { "dotdeb-php54":
     location => "http://packages.dotdeb.org",
     release => 'squeeze-php54',
     repos => 'all',
     key => '89DF5277',
     key_source => "http://www.dotdeb.org/dotdeb.gpg"
}

exec { 'apt-get update':
	command => '/usr/bin/apt-get update'
}

package { 'nginx':
	ensure => present,
	require => [Apt::Source['dotdeb'], Exec['apt-get update']]
}

package { 'php5-cli':
	ensure => present,
	require => [Apt::Source['dotdeb'], Apt::Source['dotdeb-php54'], Exec['apt-get update']]
}

package { 'php5-fpm':
	ensure => present,
	require => [Apt::Source['dotdeb'], Apt::Source['dotdeb-php54'], Exec['apt-get update']]
}

service { 'nginx':
	ensure => running,
	require => Package['nginx']
}

service { 'php5-fpm':
	ensure => running,
	require => Package['php5-fpm']
}

file { 'vagrant-nginx':
	path => '/etc/nginx/sites-available/vagrant',
	ensure => file,
	replace => true,
	require => Package['nginx'],
	source => 'puppet:///templates/nginx/vagrant',
    notify => Service['nginx']
}

file { 'default-nginx-disable':
	path => '/etc/nginx/sites-enabled/default',
	ensure => absent,
	require => Package['nginx']
}

file { 'vagrant-nginx-enable':
	path => '/etc/nginx/sites-enabled/vagrant',
	target => '/etc/nginx/sites-available/vagrant',
	ensure => link,
	notify => Service['nginx'],
	require => [
		File['vagrant-nginx'],
		File['default-nginx-disable']
	]
}

file { 'vagrant-php5-fpm':
	path => '/etc/php5/fpm/pool.d/vagrant.conf',
	ensure => file,
	replace => true,
	require => Package['php5-fpm'],
	source => 'puppet:///templates/php5-fpm/vagrant',
    notify => Service['php5-fpm']
}

file { 'default-php5-fpm-disable':
	path => '/etc/php5/fpm/pool.d/www.conf',
	ensure => absent,
	require => Package['php5-fpm']
}