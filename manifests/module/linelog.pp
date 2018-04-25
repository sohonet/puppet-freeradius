# == Define freeradius::module::linelog
#
# Specific define to configure linelog module
#
define freeradius::module::linelog (
  $ensure      = 'present',
  $filename                      = "\${logdir}/linelog",
  $escape_filenames = 'no',
  $permissions                   = '0600',
  $group               = undef,
  $syslog_facility     = undef,
  $syslog_severity     = undef,
  $format                        = 'This is a log message for %{User-Name}',
  $reference                     = 'messages.%{%{reply:Packet-Type}:-default}',
  $messages               = [],
  $accounting_request     = [],
) {
  freeradius::module { "linelog_${name}":
    ensure  => $ensure,
    content => template('freeradius/linelog.erb'),
  }
}
