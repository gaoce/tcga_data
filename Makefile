include lib/Makehelp
include lib/Makeremote

download-rnaseqv2:
	src/download_rnaseqv2.sh &
download-clinical:
	src/download_clinical.sh &
