#!/bin/bash
set -e
script_file=$( basename "${BASH_SOURCE[0]}" )

if [ -f source_env.sh ]; then
    dos2unix -q source_env.sh
    . source_env.sh
fi

if [ -z "$BIN_BASE_FOLDER" ]; then
    echo ${script_file}: BIN_BASE_FOLDER not set
    exit 1
fi
if [ -z "$SOURCE_BASE_FOLDER" ]; then
    echo ${script_file}: SOURCE_BASE_FOLDER not set
    exit 1
fi
if [ -z "$TMP_BASE_FOLDER" ]; then
    echo ${script_file}: TMP_BASE_FOLDER not set
    exit 1
fi
if [ -z "$BOOST_VERSION" ]; then
    echo ${script_file}: BOOST_VERSION not set
    exit 1
fi
if [ -z "$BZIP2_VERSION" ]; then
    echo ${script_file}: BZIP2_VERSION not set
    exit 1
fi
if [ -z "$ZLIB_VERSION" ]; then
    echo ${script_file}: ZLIB_VERSION not set
    exit 1
fi

# Command line parameters
skip_boost_bootstrap=0
for arg in "$@"; do
    if [ "$arg" = "--skip_boost_bootstrap" ]; then
        skip_boost_bootstrap=1
    fi
done


current_folder=$( pwd )
echo "${script_file}: running in: \"$current_folder\""
echo "${script_file}: BIN_BASE_FOLDER=\"$BIN_BASE_FOLDER\""
echo "${script_file}: SOURCE_BASE_FOLDER=\"$SOURCE_BASE_FOLDER\""
echo "${script_file}: TMP_BASE_FOLDER=\"$TMP_BASE_FOLDER\""

# Archive files to unpack.
# Here we hardcode whether an archive file is in the format "name_version" or "name-version" and
# the way it was compressed (its file extension).
boost_base_folder=boost_$BOOST_VERSION
boost_tar="${SOURCE_BASE_FOLDER}/${boost_base_folder}.tar.gz"
if [ ! -f "$boost_tar" ]; then
    echo ${script_file}: "\"$boost_tar\" missing"
    exit 1
fi

bzip2_base_folder=bzip2-$BZIP2_VERSION
bzip2_tar="${SOURCE_BASE_FOLDER}/${bzip2_base_folder}.tar.gz"
if [ ! -f "$bzip2_tar" ]; then
    echo ${script_file}: "\"$bzip2_tar\" missing"
    exit 1
fi

zlib_base_folder=zlib-$ZLIB_VERSION
zlib_tar="${SOURCE_BASE_FOLDER}/${zlib_base_folder}.tar.gz"
if [ ! -f "$zlib_tar" ]; then
    echo ${script_file}: "\"$zlib_tar\" missing"
    exit 1
fi


mkdir -p "${TMP_BASE_FOLDER}/unpack_patch"
cd "${TMP_BASE_FOLDER}/unpack_patch"

# Unpacking all source archives
if [ ! -f "_unpacked_ready_" ]; then
    echo "${script_file}: Unpacking..."
    echo "${script_file}: Cleaning previous run" && rm -rf ../unpack_patch/*
    echo "${script_file}: Unpacking $boost_tar" && tar --checkpoint=10000 -zxf  "$boost_tar"
    echo "${script_file}: Unpacking $bzip2_tar" && tar -zxf "$bzip2_tar"
    echo "${script_file}: Unpacking $zlib_tar" && tar -zxf "$zlib_tar"
    touch _unpacked_ready_
else
    echo "${script_file}: Skipping unpacking"
fi

# Patching if needed and copying Boost to the destination folder
boost_source_folder=${SOURCE_BASE_FOLDER}/${boost_base_folder}
if [ ! -d "$boost_source_folder" ]; then
    if [ -d "${SOURCE_BASE_FOLDER}/${boost_base_folder}_patches" ]; then
        
        echo "${script_file}: Copying Boost to patch..."
        mkdir -p patch_boost && rm -rf patch_boost/*
        cd patch_boost
        cp -r ../$boost_base_folder a
            
        patch_id=0
        # See https://www.cyberciti.biz/tips/handling-filenames-with-spaces-in-bash.html
        # for the way the loop looks like
        find "${SOURCE_BASE_FOLDER}/${boost_base_folder}_patches/"*.patch -print0 | while read -d $'\0' patch_file; do
            patch_id=$((patch_id+1))
            # Patches coming from https://github.com/boostorg need to have paths adjusted as:
            # - from "a/include/boost/.." to "a/boost/"
            # - TBD for patches of source files
            echo "${script_file}: Patching Boost with \"${patch_file}\""
            cp -f "${patch_file}" ${patch_id}_o.patch
            sed 's/a\/include\/boost\//a\/boost\//g' ${patch_id}_o.patch > ${patch_id}_a.patch
            patch -f -p0 --no-backup-if-mismatch < ${patch_id}_a.patch
        done
        echo "${script_file}: Copying patched Boost to destination..."
        rm -rf "${boost_source_folder}_tmp"
        cp -r a "${boost_source_folder}_tmp"
        cd ..
    else
        echo "${script_file}: Copying unpacked Boost to destination..."
        rm -rf "${boost_source_folder}_tmp"
        cp -r ./$boost_base_folder "${boost_source_folder}_tmp"
    fi
    
    mv "${boost_source_folder}_tmp" "${boost_source_folder}"
fi
echo "${script_file}: Boost is ready in: \"${boost_source_folder}\""

# Running Boost bootstrap.bat if not told not to do so
if [ "$skip_boost_bootstrap" != "0" ]; then
    echo "${script_file}: Skipping Boost.bootstrap"
elif [ -f "$BIN_BASE_FOLDER/b2" -a -f "$BIN_BASE_FOLDER/bjam" ]; then
    echo "${script_file}: Skipping already run Boost.bootstrap"
else
    echo "${script_file}: Running Boost.bootstrap.."
    cd $BOOST_SOURCE_FOLDER/tools/build && sh bootstrap.sh && cd -
    mkdir -p "$BIN_BASE_FOLDER"
    cp "$BOOST_SOURCE_FOLDER/tools/build/b2" "$BIN_BASE_FOLDER/b2"
    cp "$BOOST_SOURCE_FOLDER/tools/build/bjam" "$BIN_BASE_FOLDER/bjam"
fi

# Copying bzip2 to the destination folder
bzip2_source_folder=${SOURCE_BASE_FOLDER}/${bzip2_base_folder}
if [ ! -d "$bzip2_source_folder" ]; then
    echo "${script_file}: Copying unpacked bzip2 to destination..."
    rm -rf "${bzip2_source_folder}_tmp"
    cp -r ./$bzip2_base_folder "${bzip2_source_folder}_tmp"
    mv "${bzip2_source_folder}_tmp" "${bzip2_source_folder}"
fi
echo "${script_file}: bzip2 is ready in: \"${bzip2_source_folder}\""

# Copying zlib to the destination folder
zlib_source_folder=${SOURCE_BASE_FOLDER}/${zlib_base_folder}
if [ ! -d "$zlib_source_folder" ]; then
    echo "${script_file}: Copying unpacked zlib to destination..."
    rm -rf "${zlib_source_folder}_tmp"
    cp -r ./$zlib_base_folder "${zlib_source_folder}_tmp"
    mv "${zlib_source_folder}_tmp" "${zlib_source_folder}"
fi
echo "${script_file}: zlib is ready in: \"${zlib_source_folder}\""


# All done
echo ${script_file}: successful
