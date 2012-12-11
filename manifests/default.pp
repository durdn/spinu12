class must-have {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }

  package { ["vim",
             "screen",
             "tmux",
             "curl",
             "git-core",
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
} 

include must-have
