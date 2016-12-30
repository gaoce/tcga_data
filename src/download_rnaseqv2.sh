#!/bin/bash

cd data/raw

# -b: batch, no question asked
# -o: only, filter key words
../../lib/firehose_get -b \
    -o rnaseqv2*RSEM_genes_normalized__data.Level_3 \
    stddata 2016_01_28 \
    &>../../log/current/download_rnaseqv2.log
