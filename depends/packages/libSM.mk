package=libSM
$(package)_version=1.2.2
$(package)_download_path=https://src.fedoraproject.org/repo/pkgs/libSM/libSM-1.2.2.tar.bz2/499a7773c65aba513609fe651853c5f3/
$(package)_file_name=$(package)-$($(package)_version).tar.bz2
$(package)_sha256_hash=0baca8c9f5d934450a70896c4ad38d06475521255ca63b717a6510fdb6e287bd
$(package)_dependencies=xtrans xproto libICE

define $(package)_set_vars
  $(package)_config_opts=--without-libuuid  --without-xsltproc  --disable-docs --disable-static
  $(package)_config_opts_linux=--with-pic
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
