# == Class: rapid7_scan_engine
#
# Full description of class rapid7_scan_engine here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { rapid7_scan_engine:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class rapid7_scan_engine (

  $first_name                       = $::rapid7_scan_engine::params::first_name,
  $last_name                        = $::rapid7_scan_engine::params::last_name,
  $company_name                     = $::rapid7_scan_engine::params::company_name,
  $component_mode                   = $::rapid7_scan_engine::params::component_mode,
  $rapid7_scan_engine_user          = $::rapid7_scan_engine::params::rapid7_scan_engine_user,
  $rapid7_scan_engine_password      = $::rapid7_scan_engine::params::rapid7_scan_engine_password,
  $engine_to_platform_pairing_token = $::rapid7_scan_engine::params::engine_to_platform_pairing_token,
  $console_ip                       = $::rapid7_scan_engine::params::console_ip,
  $console_port                     = $::rapid7_scan_engine::params::console_port,
  $shared_secret                    = $::rapid7_scan_engine::params::shared_secret,
  $proxy_uri                        = $::rapid7_scan_engine::params::proxy_uri,
  $suppress_reboot                  = $::rapid7_scan_engine::params::suppress_reboot,
  $installer_checksum               = $::rapid7_scan_engine::params::installer_checksum,
  $nexus_url                        = $::rapid7_scan_engine::params::nexus_url,
  $installer_uri                    = $::rapid7_scan_engine::params::installer_uri,
  $install_path                     = $::rapid7_scan_engine::params::install_path,
  $service_enable                   = $::rapid7_scan_engine::params::service_enable,
  $service_ensure                   = $::rapid7_scan_engine::params::service_ensure,

) inherits ::rapid7_scan_engine::params {

  $valid_component_type_re = '(typical|console|engine)'
  validate_re($component_type, $valid_component_type_re,
  "Component type ${component_type} needs to be one of the following: typical, console, engine")

  $rapid7_scan_engine_init = $component_type ? {
    'engine'            => $::osfamily ? {
      'Debian' =>  $::lsbdistcodename ? {
        'trusty' => 'rapid7_scan_engineengine.rc',
        'xenial' => 'rapid7_scan_engineengine.service',
        'bionic' => 'rapid7_scan_engineengine.service',
      },
      'RedHat' => 'nexposeengine',
    },
    /(console|typical)/ => $::osfamily ? {
      'Debian' =>  $::lsbdistcodename ? {
        'trusty' => 'rapid7_scan_engineconsole.rc',
        'xenial' => 'rapid7_scan_engineconsole.service',
        'bionic' => 'rapid7_scan_engineconsole.service',
      },
      'RedHat' => 'nexposeconsole',
    }
  }

  case $component_type {
    'engine': {
      $console_bool    = false
      $engine_bool     = true
      $service_process = 'nse.sh'
    }
    'console', 'typical': {
      $console_bool    = true
      $engine_bool     = false
      $service_process = 'nsc.sh'
    }
  }

  class { '::rapid7_scan_engine::install':
    component_type => $component_type,
  }

  class { '::rapid7_scan_engine::service':
    service_name   => $rapid7_scan_engine_init,
    service_enable => $service_enable,
    service_ensure => $service_ensure,
  }

  contain '::rapid7_scan_engine::install'
  contain '::rapid7_scan_engine::service'

  Class['::rapid7_scan_engine::install']
  -> Class['::rapid7_scan_engine::service']
}
