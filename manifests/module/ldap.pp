# Configure LDAP support for FreeRADIUS
define freeradius::module::ldap (
  $basedn,
  $ensure                                    = 'present',
  $server                                    = ['localhost'],
  $port                                      = 389,
  $identity                                  = undef,
  $password                                  = undef,
  $sasl                                      = {},
  $valuepair_attribute                       = undef,
  $update                                    = undef,
  $edir                                      = undef,
  $edir_autz                                 = undef,
  $user_base_dn                              = "\${..base_dn}",
  $user_filter                               = '(uid=%{%{Stripped-User-Name}:-%{User-Name}})',
  $user_sasl                                 = {},
  $user_scope                                = undef,
  $user_sort_by                              = undef,
  $user_access_attribute                     = undef,
  $user_access_positive                      = undef,
  $group_base_dn                             = "\${..base_dn}",
  $group_filter                              = '(objectClass=posixGroup)',
  $group_scope                               = undef,
  $group_name_attribute                      = undef,
  $group_membership_filter                   = undef,
  $group_membership_attribute                = 'memberOf',
  $group_cacheable_name                      = undef,
  $group_cacheable_dn                        = undef,
  $group_cache_attribute                     = undef,
  $group_attribute                           = undef,
  $profile_filter                            = undef,
  $profile_default                           = undef,
  $profile_attribute                         = undef,
  $client_base_dn                            = "\${..base_dn}",
  $client_filter                             = '(objectClass=radiusClient)',
  $client_scope                              = undef,
  $read_clients                              = undef,
  $dereference                               = undef,
  $chase_referrals                           = 'yes',
  $rebind                                    = 'yes',
  $use_referral_credentials                  = 'no',
  $session_tracking                          = undef,
  $timeout                                   = 10,
  $timelimit                                 = 3,
  $idle                                      = 60,
  $probes                                    = 3,
  $interval                                  = 3,
  $ldap_debug                                = '0x0028',
  $starttls                                  = 'no',
  $cafile                                    = undef,
  $certfile                                  = undef,
  $keyfile                                   = undef,
  $random_file                               = undef,
  $requirecert                               = 'allow',
  $start                                     = '${thread[pool].start_servers}',
  $min                                       = '${thread[pool].min_spare_servers}',
  $max                                       = '${thread[pool].max_servers}',
  $spare                                     = '${thread[pool].max_spare_servers}',
  $uses                                      = 0,
  $retry_delay                               = 30,
  $lifetime                                  = 0,
  $idle_timeout                              = 60,
  $connect_timeout                           = 3.0,
) {
  $fr_package          = $::freeradius::params::fr_package
  $fr_service          = $::freeradius::params::fr_service
  $fr_modulepath       = $::freeradius::params::fr_modulepath
  $fr_basepath         = $::freeradius::params::fr_basepath
  $fr_group            = $::freeradius::params::fr_group

  # Validate our inputs
  # Hostnames
  $serverarray = any2array($server)
  unless is_array($serverarray) {
    fail('$server must be an array of hostnames or IP addresses')
  }

  # FR3.0 format server = 'ldap1.example.com, ldap1.example.com, ldap1.example.com'
  # FR3.1 format server = 'ldap1.example.com'
  #              server = 'ldap2.example.com'
  #              server = 'ldap3.example.com'
  $serverconcatarray = $::freeradius_version ? {
    /^3\.0\./ => any2array(join($serverarray, ',')),
    default   => $serverarray,
  }

  # Generate a module config, based on ldap.conf
  file { "${fr_basepath}/mods-available/${name}":
    ensure  => $ensure,
    mode    => '0640',
    owner   => 'root',
    group   => $fr_group,
    content => template('freeradius/ldap.erb'),
    require => [Package[$fr_package], Group[$fr_group]],
    notify  => Service[$fr_service],
  }
  file { "${fr_modulepath}/${name}":
    ensure => link,
    target => "../mods-available/${name}",
  }
}
