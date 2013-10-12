# == Class: freebox::ftp
#
# See README.md for more details.
#
class freebox::configuration::ftp(
  $enabled               = undef,
  $allow_anonymous       = undef,
  $allow_anonymous_write = undef,
  $password              = undef,
) {
  freebox_ftp_conf {
    'enabled':
      value => $enabled;
    'allow_anonymous':
      value => $allow_anonymous;
    'allow_anonymous_write':
      value => $allow_anonymous_write;
    'password':
      value => $password;
  }
}
