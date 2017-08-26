#!/bin/bash

script_file=$( basename "${BASH_SOURCE[0]}" )

if [ -f source_env.sh ]; then
    dos2unix -q source_env.sh || exit 1
    . source_env.sh
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


current_folder=$( pwd )
echo "${script_file}: running in: \"$current_folder\""
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



mkdir -p "${TMP_BASE_FOLDER}/unpack_patch" || exit 1

exit_code=0
cd "${TMP_BASE_FOLDER}/unpack_patch" || exit 1

# Unpacking all source archives
if [ ! -f "_unpacked_ready_" ]; then
    exit_code=1
    echo "${script_file}: Unpacking..."
    echo "${script_file}: Cleaning previous run" && rm -rf ../unpack_patch/* &&\
        echo "${script_file}: Unpacking $boost_tar" && tar --checkpoint=10000 -zxf  "$boost_tar" &&\
        echo "${script_file}: Unpacking $bzip2_tar" && tar -zxf "$bzip2_tar" &&\
        echo "${script_file}: Unpacking $zlib_tar" && tar -zxf "$zlib_tar" &&\
        touch _unpacked_ready_ && exit_code=0
else
    echo "${script_file}: Skipping unpacking"
fi

# Patching if needed and copying Boost to the destination folder
if [ "$exit_code" = "0" ]; then
    boost_source_folder=${SOURCE_BASE_FOLDER}/${boost_base_folder}
    if [ ! -d "$boost_source_folder" ]; then
        if [ -d "${SOURCE_BASE_FOLDER}/${boost_base_folder}_patches" ]; then
            exit_code=1
            echo "${script_file}: Copying Boost to patch..."
                mkdir -p patch_boost && rm -rf patch_boost/* &&\
                cd patch_boost &&\
                cp -r ../$boost_base_folder a &&\
                exit_code=0
            patch_id=0

            # See https://www.cyberciti.biz/tips/handling-filenames-with-spaces-in-bash.html
            # for the way the loop looks like
            find "${SOURCE_BASE_FOLDER}/${boost_base_folder}_patches/"*.patch -print0 | while read -d $'\0' patch_file; do
                if [ "$exit_code" = "0" ]; then
                    patch_id=$((patch_id+1))
                    exit_code=1
                    # Patches coming from https://github.com/boostorg need to have paths adjusted as:
                    # - from "a/include/boost/.." to "a/boost/"
                    # - TBD for patches of source files
                    echo "${script_file}: Patching Boost with \"${patch_file}\"" &&\
                        cp -f "${patch_file}" ${patch_id}_o.patch &&\
                        sed 's/a\/include\/boost\//a\/boost\//g' ${patch_id}_o.patch > ${patch_id}_a.patch &&\
                        patch -f -p0 --no-backup-if-mismatch < ${patch_id}_a.patch &&\
                        exit_code=0
                fi
            done
            if [ "$exit_code" = "0" ]; then
                exit_code=1
                echo "${script_file}: Copying patched Boost to destination..." &&\
                    rm -rf "${boost_source_folder}_tmp" &&\
                    cp -r a "${boost_source_folder}_tmp" &&\
                    cd .. &&\
                    exit_code=0
            fi
        else
            exit_code=1
            echo "${script_file}: Copying unpacked Boost to destination..." &&\
                rm -rf "${boost_source_folder}_tmp" &&\
                cp -r ./$boost_base_folder "${boost_source_folder}_tmp" &&\
                exit_code=0
        fi
        
        exit_code=1
        mv "${boost_source_folder}_tmp" "${boost_source_folder}" &&\
            exit_code=0
    fi

    if [ "$exit_code" = "0" ]; then
        echo "${script_file}: Boost is ready in: \"${boost_source_folder}\""
    fi
fi

# Copying bzip2 to the destination folder
if [ "$exit_code" = "0" ]; then
    bzip2_source_folder=${SOURCE_BASE_FOLDER}/${bzip2_base_folder}
    if [ ! -d "$bzip2_source_folder" ]; then
        exit_code=1
        echo "${script_file}: Copying unpacked bzip2 to destination..." &&\
            rm -rf "${bzip2_source_folder}_tmp" &&\
            cp -r ./$bzip2_base_folder "${bzip2_source_folder}_tmp" &&\
            mv "${bzip2_source_folder}_tmp" "${bzip2_source_folder}" &&\
            exit_code=0
    fi
    if [ "$exit_code" = "0" ]; then
        echo "${script_file}: bzip2 is ready in: \"${bzip2_source_folder}\""
    fi
fi

# Copying zlib to the destination folder
if [ "$exit_code" = "0" ]; then
    zlib_source_folder=${SOURCE_BASE_FOLDER}/${zlib_base_folder}
    if [ ! -d "$zlib_source_folder" ]; then
        exit_code=1
        echo "${script_file}: Copying unpacked zlib to destination..." &&\
            rm -rf "${zlib_source_folder}_tmp" &&\
            cp -r ./$zlib_base_folder "${zlib_source_folder}_tmp" &&\
            mv "${zlib_source_folder}_tmp" "${zlib_source_folder}" &&\
            exit_code=0
    fi
    if [ "$exit_code" = "0" ]; then
        echo "${script_file}: zlib is ready in: \"${zlib_source_folder}\""
    fi
fi


cd "$current_folder"
exit $exit_code

