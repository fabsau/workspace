#!/bin/bash

# Function to get metrics from the JSON
get_metric_values() {
    local JSON=$1

    local entries=$(echo "$JSON" | jq -r '. | length') # Get the count of entries in JSON

	# For every entry in JSON, extract required values and print them in Prometheus Exposition format
    for ((i=0;i<$entries;i++)); do
        local SERVER=$(jq -r ".[$i].server.name" <<< "$JSON") # Server name

		# Extract various server metric values
        local ID=$(jq -r ".[$i].server.id" <<< "$JSON")
        local URL=$(jq -r ".[$i].server.url" <<< "$JSON")
        local DOWNLOAD=$(jq -r ".[$i].download" <<< "$JSON")
        local UPLOAD=$(jq -r ".[$i].upload" <<< "$JSON")
        local PING=$(jq -r ".[$i].ping" <<< "$JSON")
        local JITTER=$(jq -r ".[$i].jitter" <<< "$JSON")
        local BYTES_SENT=$(jq -r ".[$i].bytes_sent" <<< "$JSON")
        local BYTES_RECEIVED=$(jq -r ".[$i].bytes_received" <<< "$JSON")
		
		# Extract client metric values
        local IP=$(jq -r ".[$i].client.ip" <<< "$JSON")
        local HOSTNAME=$(jq -r ".[$i].client.hostname" <<< "$JSON")
        local CITY=$(jq -r ".[$i].client.city" <<< "$JSON")
        local POSTAL=$(jq -r ".[$i].client.postal" <<< "$JSON")
        local REGION=$(jq -r ".[$i].client.region" <<< "$JSON")
        local COUNTRY=$(jq -r ".[$i].client.country" <<< "$JSON")
        local LOC=$(jq -r ".[$i].client.loc" <<< "$JSON")
        local ORG=$(jq -r ".[$i].client.org" <<< "$JSON")
        local TIMEZONE=$(jq -r ".[$i].client.timezone" <<< "$JSON")

		# Print metrics in Prometheus format
		echo "# HELP librespeed_server_info Information about the Librespeed server."
		echo "# TYPE librespeed_server_info gauge"
		echo "librespeed_server_info{server=\"$SERVER\", url=\"$URL\", server_type=\"$SERVER_TYPE\"} 1"
		
		echo "# HELP librespeed_download Download speed in Mbps."
		echo "# TYPE librespeed_download gauge"
		echo "librespeed_download{server=\"$SERVER\"} $DOWNLOAD"
		
		echo "# HELP librespeed_upload Upload speed in Mbps."
		echo "# TYPE librespeed_upload gauge"
		echo "librespeed_upload{server=\"$SERVER\"} $UPLOAD"
		
		echo "# HELP librespeed_ping Ping in ms."
		echo "# TYPE librespeed_ping gauge"
		echo "librespeed_ping{server=\"$SERVER\"} $PING"
		
		echo "# HELP librespeed_jitter Jitter in ms."
		echo "# TYPE librespeed_jitter gauge"
		echo "librespeed_jitter{server=\"$SERVER\"} $JITTER"

		echo "# HELP librespeed_bytes_received Bytes received during the test."
		echo "# TYPE librespeed_bytes_received gauge"
		echo "librespeed_bytes_received{server=\"$SERVER\"} $BYTES_RECEIVED"
		
		echo "# HELP librespeed_bytes_sent Bytes sent during the test."
		echo "# TYPE librespeed_bytes_sent gauge"
		echo "librespeed_bytes_sent{server=\"$SERVER\"} $BYTES_SENT"
		
		echo "# HELP librespeed_client_info Information about the Librespeed client."
		echo "# TYPE librespeed_client_info gauge"
		echo "librespeed_client_info{server=\"$SERVER\", ip=\"$IP\", hostname=\"$HOSTNAME\", org=\"$ORG\"} 1"
		
		echo "# HELP librespeed_client_location_info Location information about the Librespeed client."
		echo "# TYPE librespeed_client_location_info gauge"
		echo "librespeed_client_location_info{server=\"$SERVER\", city=\"$CITY\", postal=\"$POSTAL\", region=\"$REGION\", country=\"$COUNTRY\", loc=\"$LOC\", timezone=\"$TIMEZONE\"} 1"
	done
}

# This function runs the librespeed-cli test and then calls get_metric_values with the result.
run_tests() {
    local TEST_RESULT=$(librespeed-cli --json $1)
	local SERVER_TYPE=$2
    get_metric_values "$TEST_RESULT" "$SERVER_TYPE"
}

# Fetch ids from CUSTOM_SERVER_FILE if file exists and has content
declare -A VALID_IDS=()
all_ids=""
if [[ -f "$CUSTOM_SERVER_FILE" ]] && [[ -s "$CUSTOM_SERVER_FILE" ]]; then
	# Read each id from the file and store it in a map and a comma-separated string
  while read -r id; do
    VALID_IDS[$id]=1
    all_ids+="${id},"
  done < <(jq -r '.[].id' "$CUSTOM_SERVER_FILE")
  all_ids="${all_ids%?}"
fi

# Break SPECIFIC_SERVER_IDS into an array and validate whether each id exists in CUSTOM_SERVER_FILE
IFS=',' read -ra SERVER_ID_ARRAY <<< "${SPECIFIC_SERVER_IDS:-$all_ids}"
tests_to_run=()
for id in "${SERVER_ID_ARRAY[@]}"; do
  if [[ -z ${VALID_IDS[$id]} ]]; then
    # SPECIFIC_SERVER_IDS is not in CUSTOM_SERVER_FILE
    echo "ERROR: Server id $id is not found in CUSTOM_SERVER_FILE. Please check your configuration."
    exit 1
  else
    tests_to_run+=($id)
  fi
done

# If no valid server ids are found and USE_PUBLIC_TEST_SERVER is FALSE, then exit
if [[ ${#tests_to_run[@]} -eq 0 ]] && [[ "${USE_PUBLIC_TEST_SERVER}" = "FALSE" ]]; then
  echo "ERROR: No servers available for testing! This is due to the absence of valid server IDs and the setting of USE_PUBLIC_TEST_SERVER to FALSE. Please verify your CUSTOM_SERVER_FILE or alter USE_PUBLIC_TEST_SERVER to TRUE."
  exit 1
fi

# If USE_PUBLIC_TEST_SERVER is TRUE, perform test on public server
if [[ $USE_PUBLIC_TEST_SERVER = "TRUE" ]]; then
  run_tests "$CUSTOM_ARGS" "public"
fi

# Run tests for each valid id from SPECIFIC_SERVER_IDS
for id in "${tests_to_run[@]}"; do
  run_tests "--local-json $CUSTOM_SERVER_FILE --server $id $CUSTOM_ARGS" "custom"
done