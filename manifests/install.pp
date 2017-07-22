#
class easy_ipa::install {

  if $easy_ipa::install_epel {
    ensure_resource(
      'package',
      'epel-release',
      {'ensure' => 'present'},
    )
  }

  if $easy_ipa::manage_host_entry {
    host { $easy_ipa::ipa_server_fqdn:
      ip => $easy_ipa::ip_address,
    }
  }

  # Note: sssd.conf handled by ipa-server-install.
  if $easy_ipa::install_sssd {
    contain 'easy_ipa::install::sssd'
  }

  if $easy_ipa::install_autofs {
    contain 'easy_ipa::install::autofs'
  }

  if $easy_ipa::install_ldaputils {
    package { $easy_ipa::ldaputils_package_name:
      ensure => present,
    }
  }

  if $easy_ipa::install_sssdtools {
    package { $easy_ipa::sssdtools_package_name:
      ensure => present,
    }
  }

  # TODO: Validate role != client and configure_dns_server == true
  if $easy_ipa::final_configure_dns_server {
    $dns_packages = [
      'ipa-server-dns',
      'bind-dyndb-ldap',
    ]
    package{$dns_packages:
      ensure => present,
    }
  }

  if $easy_ipa::install_ipa_server {
    contain 'easy_ipa::install::server'
  }

  if $easy_ipa::install_ipa_client or $easy_ipa::ipa_role == 'client' {
    contain 'easy_ipa::install::client'
  }

}