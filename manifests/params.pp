# Default params for locales
class locales::params {
  $lc_ctype          = undef
  $lc_collate        = undef
  $lc_time           = undef
  $lc_numeric        = undef
  $lc_monetary       = undef
  $lc_messages       = undef
  $lc_paper          = undef
  $lc_name           = undef
  $lc_address        = undef
  $lc_telephone      = undef
  $lc_measurement    = undef
  $lc_identification = undef
  $lc_all            = undef

  case $::operatingsystem {
    /(Ubuntu|Debian)/: {

      $default_file      = '/etc/default/locale'
      $locale_gen_cmd    = '/usr/sbin/locale-gen'
      $update_locale_cmd = '/usr/sbin/update-locale'
      $supported_locales = '/usr/share/i18n/SUPPORTED' # ALL locales support

      case $::operatingsystem {
        'Ubuntu': {
          $package     = 'locales'
          case $::lsbdistcodename {
            'hardy': {
              $update_locale_pkg = 'belocs-locales-bin'
            }
            default: {
              $update_locale_pkg = 'libc-bin'
            }
          }
          case $::operatingsystemrelease {
            '16.04': {
              $config_file = '/etc/locale.gen'
            }
            default: {
              $config_file = '/var/lib/locales/supported.d/local'
            }
          }
        }
        'Debian' : {
          $package = 'locales-all'
          # If config_file is not set, we will end up with the error message:
          # Missing title. The title expression resulted in undef at [init.pp
          # at definition of file { $config_file: ]
          # even if this resource is inside the branch of an if which will never
          # be run.
          $config_file = '/etc/locale.gen'
          $update_locale_pkg = 'locales'
        }
        default: {
          $config_file = '/etc/locale.gen'
          $update_locale_pkg = false
        }
      }
    }
    /(RedHat|CentOS)/ : {
      $package = 'glibc-common'
      $local_gen_cmd = undef
      $update_local_pkg = undef
      #$config_file = '/etc/locale.gen'
      $update_locale_cmd = undef
      $config_file = '/var/lib/locales/supported.d/local'
      $update_locale_pkg = false
      if $::operatingsystemmajrelease == '7' {
        $default_file      = '/etc/locale.conf'
      } else {
        $default_file      = '/etc/sysconfig/i18n'
      }
    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }
}
