# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]
# Uncomment to disable net tests - the server is sometimes down
export NO_NET=1

# Compile libs for macOS 10.9 or later
export MACOSX_DEPLOYMENT_TARGET="10.9"
export NETCDF_VERSION="4.7.4"
export HDF5_VERSION="1.12.0"

source h5py-wheels/config.sh

function build_libs {
    build_hdf5
    build_curl
    build_netcdf2
}

function pip_opts {
    echo "--find-links https://3f23b170c54c2533c070-1c8a9b3114517dc5fe17b7c3f8c63a43.ssl.cf2.rackcdn.com"
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    cp ../netcdf4-python/test/* .
    python run_all.py
}

function build_netcdf2 {
    if [ -e netcdf-stamp ]; then return; fi
    build_hdf5
    build_curl
    fetch_unpack https://github.com/Unidata/netcdf-c/archive/v${NETCDF_VERSION}.tar.gz
    echo "build_netcdf2"
    (cd netcdf-c-${NETCDF_VERSION} \
        && export LIBS="-lm -lhdf5_hl -lhdf5 -ldl -lz -lcurl -lm"
        && ./configure --prefix=$BUILD_PREFIX --enable-dap \
        && make -j4 \
        && make install)
    touch netcdf-stamp
}
