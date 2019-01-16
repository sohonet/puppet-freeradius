# == Define freeradius::module::perl
#
# Create the perl module configuration for FreeRADIUS
#
define freeradius::module::perl (
  $ensure                              = 'present',
  String $moddir                       = "\${modconfdir}/\${.:instance}",
  Optional[String] $key                = undef,
  Optional[String] $perl_filename      = undef,
  Optional[String] $source             = undef,
  Optional[String] $content            = undef,
) {
  $fr_moduleconfigpath = $::freeradius::params::fr_moduleconfigpath
  $fr_group            = $::freeradius::params::fr_group
  $fr_service          = $::freeradius::params::fr_service

  freeradius::module {'perl':
    ensure  => $ensure,
    content => template('freeradius/perl.erb'),
  }

  $manage_dir = $ensure ? {
    'present' => 'directory',
    default   => 'absent',
  }

  file { "$moddir/$perl_filename":
    ensure  => $ensure,
    owner   => 'root',
    group   => $fr_group,
    mode    => '0640',
    source  => $source,
    content => $manage_content,
    require => Freeradius::Module['perl'],
    notify  => Service[$fr_service],
  }
}
