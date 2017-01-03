include lib/Makehelp
include lib/Makeremote

download-rnaseqv2:
	src/download_rnaseqv2.sh &
download-clinical:
	src/download_clinical.sh &

extract-clinical:
	src/extract_clinical.sh &
extract-rnaseqv2:
	src/extract_rnaseqv2.sh &

