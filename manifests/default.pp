class must-have {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }

  package { "git-core":
    ensure => present,
  }

  package { "vim":
    ensure => present,
  }

  package { "screen":
    ensure => present,
  }

  package { "tmux":
    ensure => present,
  }
}

include must-have
