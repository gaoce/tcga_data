#!/bin/bash

cd data/raw

# -b: batch, no question asked
# -o: only, filter key words
../../lib/firehose_get -b \
    -o Merge_Clinical.Level_1 \
    stddata 2016_01_28 \
    &>../../log/current/download_clinical.log

