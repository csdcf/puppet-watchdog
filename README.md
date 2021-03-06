# watchdog

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-watchdog.svg?branch=master)](https://travis-ci.org/bodgit/puppet-watchdog)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-watchdog/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-watchdog?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/watchdog.svg)](https://forge.puppetlabs.com/bodgit/watchdog)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-watchdog.svg)](https://gemnasium.com/bodgit/puppet-watchdog)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with watchdog](#setup)
    * [What watchdog affects](#what-watchdog-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with watchdog](#beginning-with-watchdog)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: watchdog](#class-watchdog)
    * [Examples](#examples)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages a hardware watchdog.
This is usually implemented as a kernel device and optionally a userspace
process to periodically reset the device to prevent it rebooting the machine.

## Module Description

This module ensures that the watchdog is enabled and configured to reset the
machine if it has not been reset after the specified period.
If a userspace process is required to reset the watchdog then this will be
configured to run periodically.

## Setup

### What watchdog affects

* The package containing the watchdog daemon.
* The service controlling the watchdog daemon.

### Setup Requirements

This module assumes that the appropriate hardware device is already configured
and accessible.
This could be as simple as loading a kernel module or as complex as compiling
a whole new kernel from scratch.

### Beginning with watchdog

```puppet
include ::watchdog
```

## Usage

### Classes and Defined Types

#### Class: `watchdog`

**Parameters within `watchdog`:**

##### `manage_package`

Whether to manage the package resource or not.

##### `package_ensure`

Intended state of the package providing the watchdog daemon.

##### `package_name`

The package name that provides the watchdog daemon.

##### `period`

The watchdog timeout period.
If it has not been reset after this period then the machine is rebooted.

##### `service_enable`

Whether to enable the watchdog service.

##### `service_ensure`

Intended state of the watchdog service.

##### `service_manage`

Whether to manage the watchdog service or not.

##### `service_name`

The name of the watchdog service.

### Examples

If you want to use something else to manage the watchdog daemon, you can do:
can do:

```puppet
class { '::watchdog':
  service_manage => false,
}
```

If you are on a platform that doesn't require a userspace process to reset
the watchdog, you can do:

```puppet
class { '::watchdog':
  service_ensure => stopped,
  service_enable => false,
}
```

## Reference

### Classes

#### Public Classes

* [`watchdog`](#class-watchdog): Main class for installing the watchdog.

#### Private Classes

* `watchdog::config`: Main class for watchdog configuration/management.
* `watchdog::install`: Handles package installation.
* `watchdog::params`: Different configuration data for different systems.
* `watchdog::service`: Handles the watchdog service.

## Limitations

There is no standard for watchdog timeout periods so it's potentially tricky
to ship a default value that works on all hardware however hopefully a period
of 60 seconds should work in 99% of cases.

This module has been built on and tested against Puppet 3.0 and higher.

The module has been tested on:

* RedHat Enterprise Linux 5/6/7
* OpenBSD 5.6/5.7/5.8/5.9 (anything as far back as 4.9 should work)

Testing on other platforms has been light and cannot be guaranteed.

## Development

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-watchdog).
