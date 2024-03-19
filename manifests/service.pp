class rapid7_scan_engine::service (

  $service_name,
  $service_enable = true,
  $service_ensure = 'running',

) {

  service { $service_name:
    enable     => $service_enable,
    ensure     => $service_ensure,
    hasstatus  => false,
    status     => "pgrep ${::rapid7_scan_engine::service_process}",
    require    => Exec['install_rapid7_scan_engine'],
  }

}
