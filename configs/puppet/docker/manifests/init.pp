class docker {

  if $::osfamily == 'Debian' {


    include ::apt



    apt::key { '9DC858229FC7DD38854AE2D88D81803C0EBFCD88':
      source => 'https://download.docker.com/linux/debian/gpg',
    } ->
    apt::source { 'docker':
      architecture => 'amd64',
      location     => 'https://download.docker.com/linux/debian',
      repos        => 'stable',
      release      => $::lsbdistcodename,
    } ->
    package { 'docker-ce':
      require => Exec['apt_update'],
    }


  }



  file { '/etc/profile.d/alias_docker.sh':
    owner   => 'root',
    mode    => '0555',
    replace => 'yes',
    source  => 'puppet:///modules/docker/alias.sh',

  }


}


