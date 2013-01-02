define append_if_no_such_line($file, $line, $refreshonly = 'false') {
   exec { "/bin/echo '$line' >> '$file'":
      unless      => "/bin/grep -Fxqe '$line' '$file'",
      path        => "/bin",
      refreshonly => $refreshonly,
   }
}

class must-have {
  include apt
  apt::ppa { "ppa:webupd8team/java": }

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    require => Apt::Ppa["ppa:webupd8team/java"],
  }

  package { ["vim",
             "screen",
             "tmux",
             "curl",
             "git-core",
             "bash",
             "oracle-java7-installer"]:
    ensure => present,
    require => Exec["apt-get update"],
  }

  exec {
    "accept_license":
    command => "echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections",
    cwd => "/home/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    before => Package["oracle-java7-installer"],
    logoutput => true,
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
    "download_stash":
    command => "curl -L http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-2.0.1.tar.gz | tar zx",
    cwd => "/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    require => Exec["install_cfg"],
    logoutput => true,
    creates => "/vagrant/atlassian-stash-2.0.1",
  }

  exec {
    "create_stash_home":
    command => "mkdir -p /vagrant/stash-home",
    cwd => "/vagrant",
    user => "vagrant",
    path    => "/usr/bin/:/bin/",
    require => Exec["download_stash"],
    logoutput => true,
    creates => "/vagrant/stash-home",
  }

  append_if_no_such_line{ motd:
    file => "/etc/motd",
    line => "Run Stash with: STASH_HOME=/vagrant/stash-home /vagrant/atlassian-stash-2.0.1/bin/start-stash.sh"
  }
}

include must-have
