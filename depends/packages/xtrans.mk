package=xtrans
$(package)_version=1.3.4
$(package)_download_path=https://src.fedoraproject.org/repo/pkgs/xorg-x11-xtrans-devel/xtrans-1.3.4.tar.bz2/a615e17d9fee6f097fc3b716eacb3dca/
$(package)_file_name=$(package)-$($(package)_version).tar.bz2
$(package)_sha256_hash=054d4ee3efd52508c753e9f7bc655ef185a29bd2850dd9e2fc2ccc33544f583a
$(package)_dependencies=

define $(package)_set_vars
$(package)_config_opts_linux=--with-pic --disable-static
endef

define $(package)_config_cmds
  $($(package)_autoconf)
endef

define $(package)_build_cmds
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef
