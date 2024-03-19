class rapid7_scan_engine::params {

  $first_name                       = undef
  $last_name                        = undef
  $company_name                     = 'Bede Gaming'
  $component_type                   = 'engine'
  $component_mode                   = 'nse'
  $rapid7_scan_engine_user          = 'bedesecrapid7admin'
  $rapid7_scan_engine_password      = 'bedesecrapid7admin'
  $nexus_url                        = "https://ss01-repos.bedegaming.net/repository"
  $engine_to_platform_pairing_token = undef
  $console_ip                       = undef
  $console_port                     = 40815
  $shared_secret                    = undef
  $proxy_uri                        = undef
  $suppress_reboot                  = true
  $service_enable                   = true
  $service_ensure                   = 'running'

  if $::osfamily == 'Debian' {
    if $::lsbdistrelease == '14.04' or $::lsbdistrelease == '16.04' {
      $installer_bin = 'Rapid7Setup-Linux64.bin'
      $installer_checksum = undef
      $installer_uri = "${nexus_url}/bede-files/bede-files/rapid7/${installer_bin}"
      $install_path = '/opt/rapid7'
      $installer_path = "${install_path}/${installer_bin}"
      $varfile_name = 'response.varfile'
      $varfile_path = "${install_path}/${varfile_name}"
    }
  }
  elsif $::osfamily == 'RedHat' {
      $installer_bin = 'Rapid7Setup-Linux64.bin'
      $installer_checksum = undef
      $installer_uri = "${nexus_url}/bede-files/bede-files/rapid7/${installer_bin}"
      $install_path = '/opt/rapid7'
      $installer_path = "${install_path}/${installer_bin}"
      $varfile_name = 'response.varfile'
      $varfile_path = "${install_path}/${varfile_name}"
  }
  else {
    fail('OS Not supported.')
  }

}
