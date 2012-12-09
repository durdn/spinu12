class must-have {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }

  /*package { "git-core":*/
    /*ensure => present,*/
  /*}*/

  package { ["vim",
             "screen",
             "tmux",
             "curl",
             "libxslt1-dev",
             "bash"]:
    ensure => present,
    require => Exec["apt-get update"],
  }

  exec {
    "install_cfg":
    command => "curl -Lks git.io/cfg | HOME=/home/vagrant bash",
    cwd => "/home/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    require => Package["curl", "git-core"],
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

rbenv::install { "vagrant":
  group => "vagrant",
  home  => "/home/vagrant",
  require => Exec["apt-get update"],
}

rbenv::compile { "1.9.3-p327":
  user => "vagrant",
  home => "/home/vagrant",
  global => true,
  require => Rbenv::Install["vagrant"],
}

rbenv::gem { ["eco-source"]:
  user => "vagrant",
  ruby => "1.9.3-p327",
  before => Rbenv::Gem["eco"],
  install_params => "--pre",
}

rbenv::gem { ["eco", "builder", "RedCloth", "markaby", "liquid", "less", "radius", "nokogiri", "creole", "ejs"]:
  user => "vagrant",
  ruby => "1.9.3-p327",
  before => Rbenv::Gem["middleman"],
}

include apt
apt::ppa { "ppa:chris-lea/node.js": }
include nodejs

package { "coffee-script":
  ensure   => "1.4.0",
  provider => "npm",
  require => Package["npm"],
}

package { ["libcurl4-openssl-dev"]:
  ensure => present,
  require => Exec["apt-get update"],
}

rbenv::gem { "middleman":
  user => "vagrant",
  ruby => "1.9.3-p327",
  require => Package["coffee-script", "libcurl4-openssl-dev"],
}
