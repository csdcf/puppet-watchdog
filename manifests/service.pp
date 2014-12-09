#
class watchdog::service {

  $period = $::watchdog::period
  $tickle = floor($period / 3)

  if $::watchdog::service_manage {
    case $::osfamily {
      'OpenBSD': {
        service { $::watchdog::service_name:
          ensure     => $::watchdog::service_ensure,
          enable     => $::watchdog::service_enable,
          flags      => "-i ${tickle} -p ${period}",
          hasstatus  => true,
          hasrestart => true,
        }
      }
      default: {
        service { $::watchdog::service_name:
          ensure     => $::watchdog::service_ensure,
          enable     => $::watchdog::service_enable,
          hasstatus  => true,
          hasrestart => true,
        }
      }
    }
  }
}
