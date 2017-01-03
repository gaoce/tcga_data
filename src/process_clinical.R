# Combine all relevant clinical info into one files
# Prepare a file specific for survival analysis

library(dplyr)
library(readr)
library(tidyr)
library(foreach)
library(stringr)
library(doParallel)

files = dir('data/current/clinical', full.names = T)
registerDoParallel(20)
clin = foreach(f = files, .combine = rbind) %do% {
    read_tsv(f, col_types = cols(.default = 'c')) %>%
        dplyr::rename(barcode = patient.bcr_patient_barcode,
                      disease = admin.disease_code) %>%
        dplyr::mutate(barcode = toupper(barcode),
                      disease = toupper(disease)) %>%
        tidyr::gather('key', 'value', -barcode)
}

event_status = clin %>%
    dplyr::filter(str_detect(key, 'vital_status'), !is.na(value)) %>%
    dplyr::group_by(barcode) %>%
    dplyr::summarise(event_status = ifelse('dead' %in% value, 1L, 0L))

days_to_death = clin %>%
    dplyr::filter(str_detect(key, 'days_to_death'), !is.na(value)) %>%
    dplyr::group_by(barcode) %>%
    dplyr::mutate(value = as.integer(value)) %>%
    dplyr::summarise(days_to_death = max(value))

days_to_last_followup = clin %>%
    dplyr::filter(str_detect(key, 'days_to_last_followup'), !is.na(value)) %>%
    dplyr::group_by(barcode) %>%
    dplyr::mutate(value = as.integer(value)) %>%
    dplyr::summarise(days_to_last_followup = max(value))

# Cancer type
disease = clin %>%
    dplyr::filter(key == 'disease') %>%
    dplyr::select(barcode, cancer = value)

# Clinical information for survival analysis
clin_surv = event_status %>%
    dplyr::left_join(days_to_death,         by = 'barcode') %>%
    dplyr::left_join(days_to_last_followup, by = 'barcode') %>%
    dplyr::mutate(days_2_event = ifelse(event_status == 1,
                                        days_to_death,
                                        days_to_last_followup)) %>%
    dplyr::select(barcode, event_status, days_2_event) %>%
    dplyr::left_join(disease, by = 'barcode')

write_tsv(clin_surv, 'data/current/clin_surv.tsv')
write_tsv(clin,      'data/current/clin_info.tsv')

