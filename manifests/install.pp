class rapid7_scan_engine::install (

  $component_type,
  $proxy_uri = undef,

) {

  package { 'screen':
    ensure => present,
  }

  file { 'rapid7_directory':
    ensure => directory,
    path   => $::rapid7_scan_engine::install_path,
    owner  => 'root',
    group  => 'root',
  }

  file { 'rapid7_scan_engine_directory':
    ensure  => directory,
    path    => "${::rapid7_scan_engine::install_path}/rapid7_scan_engine",
    require => Exec['install_rapid7_scan_engine'],
  }

  file { 'response_varfile':
    ensure  => file,
    path    => $::rapid7_scan_engine::varfile_path,
    content => template('rapid7_scan_engine/response.varfile.erb'),
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
  }

  file { 'rapid7_scan_engine_installer':
    path    => "${::rapid7_scan_engine::installer_path}",
    mode    => '0750',
    require => Archive["${::rapid7_scan_engine::installer_path}"],
    owner   => 'root',
    group   => 'root',
  }

  archive { $::rapid7_scan_engine::installer_path:
    source       => $::rapid7_scan_engine::installer_uri,
    require      => File['rapid7_directory'],
    creates      => $::rapid7_scan_engine::installer_path,
    cleanup      => false,
    proxy_server => $proxy_uri,
  }

  exec { 'install_rapid7_scan_engine':
    command => "${::rapid7_scan_engine::installer_path} -q -varfile ${::rapid7_scan_engine::varfile_path}",
    require => File['response_varfile'],
    creates => "${::rapid7_scan_engine::install_path}/rapid7_scan_engine",
  }

}
