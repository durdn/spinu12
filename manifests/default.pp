class must-have {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }

  /*package { "git-core":*/
    /*ensure => present,*/
  /*}*/

  package { "vim":
    ensure => present,
  }

  package { "screen":
    ensure => present,
  }

  package { "tmux":
    ensure => present,
  }

  package { "curl":
    ensure => present,
  }

  package { "bash":
    ensure => present,
  }

  exec {
    "install_cfg":
    command => "curl -Lks git.io/cfg | HOME=/home/vagrant bash",
    cwd => "/home/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    require => Package["curl"],
    logoutput => true,
    creates => "/home/vagrant/.cfg",
  }

  exec {
    "install_submodules":
    command => "cd /home/vagrant/.cfg && git submodule update --init",
    provider => "shell",
    cwd => "/home/vagrant/.cfg",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    require => Exec["install_cfg"],
    logoutput => "true",
    creates => "/home/vagrant/.cfg/.vim/bundle/scrooloose-nerdtree",
  }
} 

include must-have
include apt

apt::ppa { "ppa:chris-lea/node.js": }

include nodejs

package { "coffee-script":
  ensure   => latest,
  provider => 'npm',
  require => Package['npm'],
}

rbenv::install { "vagrant":
  group => 'vagrant',
  home  => '/home/vagrant',
}

rbenv::compile { "1.9.3-p327":
  user => "vagrant",
  home => "/home/vagrant",
  global => true,
}

rbenv::gem { "middleman":
  user => "vagrant",
  ruby => "1.9.3-p327",
  require => Package["coffee-script"],
}
