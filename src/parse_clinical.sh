#!/bin/bash
# Extract clinical data

function transpose () {
    file=$1

    awk '
    BEGIN {
    FS="\t"
    }

    {
        for (i=1; i<=NF; i++)  {
            a[NR,i] = $i
        }
    }

    NF>p { p = NF }

    END {
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=NR; i++){
            str=str"\t"a[i,j];
        }
        print str
    }
    }' ${file} > temp
    mv temp ${file}
}

# -C change directory
# --wildcards extract only certain file
# --strip-components put the extracted file in current folder
mkdir -p data/current/clinical
find  data/raw/ -name *Clinical*tar.gz -exec \
    tar -xzf {} -C data/current/clinical \
        --wildcards *clin\.merged\.txt \
        --strip-components 1 \;

# Transpose the file
for file in $(find data/current/clinical -name '*clin.merged.txt')
do
    transpose ${file}
    gzip ${file}
done

