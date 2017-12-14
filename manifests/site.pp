node default {
 	
	class{ 'nginx::vhost':
	domain => 'learning.puppet.master.mindtree.in' ,
	internal_hostname => $::networking['fqdn'] ,
	host_protocol => $::networking['dhcp'] ,
	dns => $::networking['domain'] ,
	hostname => $::networking['hostname'] 
	}

	notify { $::networking['fqdn'] : } 
	notify { $::networking['dhcp'] : }
	notify { $::networking['domain'] : }
	notify { $::networking['hostname'] : }
}
