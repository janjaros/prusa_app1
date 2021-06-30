class user_prusa_admin {

  user { 'prusa_admin':
    ensure => 'present',
    groups => ['sudo', ],
    home   => '/home/prusa_admin',
    shell  => '/bin/bash',
  }

  #vytvori home folder
  file { '/home/prusa_admin':
    ensure  => 'directory',
    owner   => 'prusa_admin',
    mode    => '0751',
    replace => 'no'
  }

  file { '/home/prusa_admin/.ssh':
    ensure  => 'directory',
    owner   => 'prusa_admin',
    mode    => '0700',
    replace => 'no'
  }

  ssh_authorized_key { 'prusa_admin':
    user    => 'prusa_admin',
    type    => 'ssh-ed25519',
    key     => 'AAAAC3NzaC1lZDI1NTE5AAAAIIhPd7qHzXBp41QIhXz8HUBq6QjuyGanfXYVPzn9kM6w',
    require => File["/home/prusa_admin/.ssh"],
  }

  file { '/etc/sudoers.d/sudo_prusa_admin':
    owner   => 'root',
    mode    => '0550',
    replace => 'yes',
    source  => 'puppet:///modules/user_prusa_admin/sudo_prusa_admin',
  }


}
