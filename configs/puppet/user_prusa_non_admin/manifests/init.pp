class user_prusa_non_admin {

  user { 'prusa_non_admin':
    ensure   => 'present',
    home     => '/home/prusa_non_admin',
    shell    => '/bin/bash',
    password => '$6$vb1tLY1qiY$1qN99LNR4XLvtExWu1o3CLMwCPMFHAbCvEeEVxuJjia/GRpBGwOv4Azvbm2Wgmi9UA4Hl1SPtvV7RqWVYttsm.',
  }

  #vytvori home folder
  file { '/home/prusa_non_admin':
    ensure  => 'directory',
    owner   => 'prusa_non_admin',
    mode    => '0751',
    replace => 'no'
  }

  file { '/home/prusa_non_admin/.ssh':
    ensure  => 'directory',
    owner   => 'prusa_non_admin',
    mode    => '0700',
    replace => 'no'
  }

  ssh_authorized_key { 'prusa_non_admin':
    user    => 'prusa_non_admin',
    type    => 'ssh-ed25519',
    key     => 'AAAAC3NzaC1lZDI1NTE5AAAAIEBTg8KKBP/VbPH+VAYLqhGjCBoGBqNPj63BbTFP3Bov',
    require => File["/home/prusa_non_admin/.ssh"],
  }
}