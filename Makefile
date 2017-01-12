include config/make.help
include config/make.local

download-rnaseqv2:
	src/download_rnaseqv2.sh &
download-clinical:
	src/download_clinical.sh &

extract-clinical:
	src/extract_clinical.sh &
extract-rnaseqv2:
	src/extract_rnaseqv2.sh &

process-clinical:
	${RCMD} src/process_clinical.R log/current/process_clinical.Rout
	gzip data/current/clin*.tsv

