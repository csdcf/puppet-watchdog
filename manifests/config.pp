#
class watchdog::config {

  $period = $::watchdog::period
  $tickle = floor($period / 3)

  case $::osfamily {
    'RedHat': {
      file { '/etc/watchdog.conf':
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        content => template('watchdog/watchdog.conf.erb'),
      }
    }
    'OpenBSD': {
      if $::watchdog::service_manage {
        sysctl { 'kern.watchdog.period':
          ensure => absent,
        }
        sysctl { 'kern.watchdog.auto':
          ensure    => present,
          permanent => yes,
          value     => 0,
        }
      } else {
        sysctl { 'kern.watchdog.period':
          ensure    => present,
          permanent => yes,
          value     => $period,
        }
        sysctl { 'kern.watchdog.auto':
          ensure    => present,
          permanent => yes,
          value     => 0,
        }
      }
    }
    default: {}
  }
}
