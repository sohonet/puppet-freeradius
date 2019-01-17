
# == Define: freeradius::module::detail
#
define freeradius::module::detail (
  $ensure            = 'present',
  $filename          = "\${radacctdir}/%{%{Packet-Src-IP-Address}:-%{Packet-Src-IPv6-Address}}/detail-%Y%m%d",
  $escape_filenames  = 'no',
  $permissions       = '0600',
  $group             = undef,
  $header            = '%t',
  $locking           = undef,
  $log_packet_header = undef,
  $suppress          = [],
) {
  if $suppress {
    validate_array($suppress)
  }

  freeradius::module {"detail.${name}":
    ensure  => $ensure,
    content => template('freeradius/detail.erb'),
  }
}
