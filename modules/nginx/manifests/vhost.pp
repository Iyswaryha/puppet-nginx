class nginx::vhost($domain='UNSET' ,$root='UNSET' ,$internal_hostname='NIL' ,$host_protocol='NIL' ,$dns='NIL' ,$hostname='NIL'){
	include nginx

	$default_parent_root="/home/ubuntu/sites_puppet"

	if $domain == 'UNSET' {
	
		$vhost_domain=$name
	}
	else {
	
		$vhost_domain=$domain
	}

	if $root == 'UNSET' {

		$vhost_root="$default_parent_root/$name"
	}
	else {

		$vhost_root=$root
	}

	# create the conf file from the template

	file { "/etc/nginx/sites-available/${vhost_domain}.conf " :
		content =>template('nginx/vhost.erb'),
		require => Package['nginx'],
	}

	file{ "/etc/nginx/sites-enabled/${vhost_domain}.conf" :
		ensure => link,
		target => "/etc/nginx/sites-available/${vhost_domain}.conf",
		notify => Exec['reload nginx'],
	}
	
	$dir_tree = [ "$default_parent_root" , "$vhost_root" ]
	file { $dir_tree :
		ensure => 'directory',
		mode => '777',
		owner =>'ubuntu',
		group =>'ubuntu',
	}->
	file{ ["$vhost_root/index.html"]:
		owner => 'ubuntu',
		group => 'ubuntu',
		source => "puppet:///modules/nginx/index-html" ,
		mode => '755',
	}->
	file{ ["$vhost_root/systeminfo.html"]:
		owner => 'ubuntu' ,
		group => 'ubuntu' ,
		content => template('nginx/system-info-html.erb') ,
		mode => '755',
	}
}

	

