# from multiple sources and scripts (mostly from DeckerSU)
berkeleydb() {
    MIL_ROOT=$(pwd)
    MIL_PREFIX="${MIL_ROOT}/db4"
    
    mkdir -p $MIL_PREFIX
    wget -N 'https://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
    echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef db-4.8.30.NC.tar.gz' | sha256sum -c
    tar -xzvf db-4.8.30.NC.tar.gz
    
    cat <<-EOL >atomic-builtin-test.cpp
        #include <stdint.h>
        #include "atomic.h"

        int main() {
        db_atomic_t *p; atomic_value_t oldval; atomic_value_t newval;
        __atomic_compare_exchange(p, oldval, newval);
        return 0;
        }
EOL
    if g++ atomic-builtin-test.cpp -I./db-4.8.30.NC/dbinc -DHAVE_ATOMIC_SUPPORT -DHAVE_ATOMIC_X86_GCC_ASSEMBLY -o atomic-builtin-test 2>/dev/null; then
        echo "No changes to bdb source are needed ..."
        rm atomic-builtin-test 2>/dev/null
    else
        echo "Updating atomic.h file ..."
        sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' db-4.8.30.NC/dbinc/atomic.h
    fi
    
    cd db-4.8.30.NC/build_unix/
    ../dist/configure -enable-cxx -disable-shared -with-pic -prefix=$MIL_PREFIX
    make install
    
    cd $MIL_ROOT
}

buildMIL() {

	make -C ${PWD}/depends v=1 NO_PROTON=0 NO_QT=0 HOST=$(depends/config.guess) -j10

	./autogen.sh

	CXXFLAGS="-g0 -O2" \
	CONFIG_SITE="$PWD/depends/$(depends/config.guess)/share/config.site"

	./configure LDFLAGS="-L${MIL_PREFIX}/lib/" CPPFLAGS="-I${MIL_PREFIX}/include/" --with-gui=yes --disable-tests --disable-bench --without-miniupnpc --enable-experimental-asm --enable-static --disable-shared
    make -j$(nproc)
}
berkeleydb
buildMIL
echo "Done building MIL!"
