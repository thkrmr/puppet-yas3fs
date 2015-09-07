# yas3fs package install
class yas3fs::package {
  assert_private()

  if $::yas3fs::install_pip_package {
    package { 'python-pip':
      ensure        => present,
      allow_virtual => true
    }
    
    $pip_req = Package['python-pip']
  } else {
    $pip_req = undef
  }

  package { 'fuse':
    ensure        => present,
    allow_virtual => true
  }

  if ($::osfamily == 'RedHat') {
    package { 'fuse-libs':
      ensure        => present,
      allow_virtual => true
    }
    $fuse_req = [Package['fuse'], Package['fuse-libs']]
  } else {
    $fuse_req = Package['fuse']
  }

  package { 'yas3fs':
    ensure        => present,
    provider      => 'pip',
    allow_virtual => true,
    source        => 'git+git://github.com/thkrmr/yas3fs@master',
    require       => [$fuse_req, $pip_req],
  }

}
