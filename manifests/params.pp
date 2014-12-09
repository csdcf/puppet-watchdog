#
class watchdog::params {

  $period = 60

  case $::osfamily {
    'RedHat': {
      # Linux requires something in userland to keep tickling /dev/watchdog
      $package_name   = 'watchdog'
      $package_ensure = 'installed'
      $service_enable = true
      $service_ensure = 'running'
      $service_manage = true
      $service_name   = 'watchdog'
    }
    'OpenBSD': {
      # OpenBSD can can tickle the watchdog device from within the kernel or
      # use watchdogd(8) which is part of the base system to test that
      # process scheduling is still functioning
      $package_name   = undef
      $package_ensure = 'absent'
      $service_enable = true
      $service_ensure = 'running'
      $service_manage = true
      $service_name   = 'watchdogd'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.") # lint:ignore:80chars
    }
  }
}
