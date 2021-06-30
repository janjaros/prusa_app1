class prusa_packages {

  # always install these packages
  $always_installed = [  'curl', 'jq', 'sudo', 'wget', 'vim', 'nano','apache2-utils']
  package { $always_installed: ensure => installed }


}


