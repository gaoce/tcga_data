include lib/Makehelp
include lib/Makeremote

download-rnaseqv2:
	src/download_rnaseqv2.sh &
download-clinical:
	src/download_clinical.sh &

parse-clinical:
	src/parse_clinical.sh &
parse-rnaseqv2:
	src/parse_rnaseqv2.sh &
