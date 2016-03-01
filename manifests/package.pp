# yas3fs package install
class yas3fs::package {
  assert_private()

  if $::yas3fs::install_pip_package {
    package { $::yas3fs::pip_package_name:
      ensure        => present,
      alias         => 'yas3fs-python-pip',
      allow_virtual => true
    }
    
    $pip_req = Package['yas3fs-python-pip']
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
  
  if $pip_req == undef {
    $yas3fs_require = $fuse_req
  } else {
    $yas3fs_require = [$fuse_req, $pip_req]
  }

  package { 'yas3fs':
    ensure        => present,
    provider      => 'pip',
    allow_virtual => true,
    source        => 'git+git://github.com/danilop/yas3fs@83d9f3a',
    require       => $yas3fs_require,
  }

}
