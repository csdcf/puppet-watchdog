#
class watchdog::install {

  case $::osfamily {
    'RedHat': {
      package { $::watchdog::package_name:
        ensure => $::watchdog::package_ensure,
      }
    }
    default: {}
  }
}
