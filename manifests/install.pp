#
class watchdog::install {

  if $::watchdog::manage_package {
    package { $::watchdog::package_name:
      ensure => $::watchdog::package_ensure,
    }
  }
}
