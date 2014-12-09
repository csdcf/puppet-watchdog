# == Class: watchdog
#
# This class manages a hardware watchdog.
#
# === Parameters
#
# [*package_ensure*]
#   Intended state of the package providing the watchdog daemon.
#   Default: installed
#
# [*package_name*]
#   The package name that provides the watchdog daemon.
#   Default: watchdog
#
# [*period*]
#   The watchdog timeout period.
#   Default: 60
#
# [*service_enable*]
#   Whether to enable the watchdog service.
#   Default: true
#
# [*service_ensure*]
#   Intended state of the watchdog service.
#   Default: running
#
# [*service_manage*]
#   Whether to manage the watchdog service or not.
#   Default: true
#
# [*service_name*]
#   The name of the watchdog service.
#   Default: watchdog
#
# === Variables
#
# None.
#
# === Examples
#
#  class { 'watchdog': }
#
# === Authors
#
# Matt Dainty <matt@bodgit-n-scarper.com>
#
# === Copyright
#
# Copyright 2014 Matt Dainty, unless otherwise noted.
#
class watchdog (
  $package_ensure = $::watchdog::params::package_ensure,
  $package_name   = $::watchdog::params::package_name,
  $period         = $::watchdog::params::period,
  $service_enable = $::watchdog::params::service_enable,
  $service_ensure = $::watchdog::params::service_ensure,
  $service_manage = $::watchdog::params::service_manage,
  $service_name   = $::watchdog::params::service_name
) inherits ::watchdog::params {

  validate_string($package_ensure)
  validate_string($package_name)
  validate_re($period, '^\d+$')
  validate_bool($service_enable)
  validate_re($service_ensure, '^(running|stopped)$')
  validate_bool($service_manage)
  validate_string($service_name)

  include ::watchdog::install
  include ::watchdog::config
  include ::watchdog::service

  anchor { 'watchdog::begin': }
  anchor { 'watchdog::end': }

  Anchor['watchdog::begin'] -> Class['::watchdog::install']
    ~> Class['::watchdog::config'] ~> Class['::watchdog::service']
    -> Anchor['watchdog::end']
}
