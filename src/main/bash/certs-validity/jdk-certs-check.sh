#!/bin/bash

# ---
# Set the following variables prior:
# KEYTOOL=
# KEYSTORE=
# KEYSTORE_PW=

while read -r ALIAS; do
    # ALIAS is in the form: "Alias name: <REST>". We want <REST>.
    ALIAS=$(echo ${ALIAS} | cut -d' ' -f3)

    # read the next line
    read -r UNTIL

    # UNTIL is in the form: "Valid from: ... until: <REST>". We want <REST>
    UNTIL=$(echo ${UNTIL} | sed 's/^.*until: //')

    # convert to epoch
    EPOCH=$(date -d "${UNTIL}" +%s)
    TODAY_EPOCH=$(date +%s)

if [ $EPOCH -lt $TODAY_EPOCH ]; then
  echo "${ALIAS}  -->  ${EPOCH} --> ${UNTIL}"
fi
done < <("${KEYTOOL}"/keytool -list -v -keystore "${KEYSTORE}" -storepass "${KEYSTORE_PW}" | grep -E '^Alias name:|^Valid from:')