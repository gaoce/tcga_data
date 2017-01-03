#!/bin/bash

# -C change directory
# --wildcards extract only certain file
# --strip-components put the extracted file in current folder
mkdir -p data/current/rnaseqv2
find  data/raw/ -name *rnaseqv2__illuminahiseq*tar.gz -exec \
    tar -xzf {} -C data/current/rnaseqv2 \
        --wildcards *data\.txt \
        --strip-components 1 \;

# Remove the distracting 2nd line, gzip the output
for file in $(find data/current/rnaseqv2 -name *data.txt); do
    cat ${file} | sed -e '2d' | gzip >${file}.gz
    rm ${file}
done
