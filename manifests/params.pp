#
class watchdog::params {

  $period = 60

  $min_memory              = 12800
  $realtime                = yes
  $priority                = 1

  case $::osfamily {
    'RedHat': {
      # Linux requires something in userland to keep tickling /dev/watchdog
      $manage_package = true
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
      $manage_package = false
      $package_name   = undef
      $package_ensure = 'absent'
      $service_enable = true
      $service_ensure = 'running'
      $service_manage = true
      $service_name   = 'watchdogd'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
