#!/bin/bash

# Environment selection
ENV=${1:-qa} # Default to qa if no argument provided
echo "Using environment: $ENV"

# Set URLs based on environment
if [ "$ENV" = "qa" ]; then
  BASE_URL="http://internal-cp-clearing-api-qa-alb-2132716703.eu-west-1.elb.amazonaws.com/dci"
  VAULT_ID="d0771c2e-1975-4f34-9b01-22964bc77985"
elif [ "$ENV" = "cert" ]; then
  BASE_URL="http://internal-cp-clearing-alb-ecs-cert-373619750.eu-west-1.elb.amazonaws.com/cp-dci-clearing-api-cert"
  VAULT_ID="08ea1a13-6de7-4ea1-b1fb-104e4665a215"
else
  echo "Unknown environment. Using local config."
  BASE_URL="localhost:5004"
  VAULT_ID="d0771c2e-1975-4f34-9b01-22964bc77985"  
fi

CAPTURE_URL="$BASE_URL/clearing/capture"
REFUND_URL="$BASE_URL/clearing/refund"

# Generate random digits of exact length
generate_random_digits() {
  LC_ALL=C tr -dc '0-9' </dev/urandom | head -c "$1"
}

# Generate random alphanumeric string of exact length
generate_random_alphanum() {
  LC_ALL=C tr -dc 'A-Z0-9' </dev/urandom | head -c "$1"
}

# Generate UUID (plain v4 UUID in lowercase)
generate_uuid() {
  uuidgen | tr '[:upper:]' '[:lower:]'
}

# Generate correlation ID in correct format
generate_correlation_id() {
  # Generate first part: 0 followed by 11 uppercase alphanumeric chars
  local first_part="0$(LC_ALL=C tr -dc 'A-Z0-9' </dev/urandom | head -c 11)"
  # Generate second part: 8 digits
  local second_part="$(generate_random_digits 8)"
  echo "${first_part}:${second_part}"
}

# Generate reference number
generate_reference_number() {
  generate_random_alphanum 8
}

# Generate random amount between min and max
generate_amount() {
  min=$1
  max=$2
  echo $((min + RANDOM % (max - min + 1)))
}

# Current date in ISO format with proper milliseconds
current_date() {
  2023-03-21T14:52:55.000Z
  date -u +"%Y-%m-%dT%H:%M:%S.000Z"
}

base32_encode_guid() {
    local data="$1"
    local b32x="abcdefghifklmnopqrstuvwxyz234567"
    local dst=""
    local i=0

    # Process first 15 bytes in groups of 5
    while [ $i -le 10 ]; do
        # Get byte values
        local byte0=$(printf '%d' "'${data:$i:1}")
        local byte1=$(printf '%d' "'${data:$((i+1)):1}")
        local byte2=$(printf '%d' "'${data:$((i+2)):1}")
        local byte3=$(printf '%d' "'${data:$((i+3)):1}")
        local byte4=$(printf '%d' "'${data:$((i+4)):1}")

        # Exact same bit operations as JavaScript version
        dst+="${b32x:$((byte0 >> 3)):1}"
        dst+="${b32x:$(((byte0 & 0x07) << 2 | byte1 >> 6)):1}"
        dst+="${b32x:$(((byte1 & 0x3E) >> 1)):1}"
        dst+="${b32x:$(((byte1 & 0x01) << 4 | byte2 >> 4)):1}"
        dst+="${b32x:$(((byte2 & 0x0F) << 1 | byte3 >> 7)):1}"
        dst+="${b32x:$(((byte3 & 0x7C) >> 2)):1}"
        dst+="${b32x:$(((byte3 & 0x03) << 3 | (byte4 & 0xE0) >> 5)):1}"
        dst+="${b32x:$((byte4 & 0x1F)):1}"
        
        i=$((i + 5))
    done

    # Handle the last byte (same as JavaScript version)
    local last_byte=$(printf '%d' "'${data:$i:1}")
    dst+="${b32x:$((last_byte >> 3)):1}"
    dst+="${b32x:$((last_byte & 7 << 2)):1}"

    echo "$dst"
}

# Use base32_encode_guid to generate a payment ID
generate_payment_id() {
  local random_data=$(openssl rand 16)
  local encoded_guid=$(base32_encode_guid "$random_data")
  echo "pay_${encoded_guid}"
}

# Similarly, generate an action ID
generate_action_id() {
  local random_data=$(openssl rand 16)
  local encoded_guid=$(base32_encode_guid "$random_data")
  echo "act_${encoded_guid}"
}

# Send capture request
send_capture_request() {
  local amount=$(generate_amount 1000 10000)
  local payment_id=$(generate_payment_id)
  local action_id=$(generate_action_id)
  local transaction_id=$(generate_uuid)
  local reference_number=$(generate_reference_number)
  local correlation_id=$(generate_correlation_id)
  local current_timestamp=$(current_date)

  echo "Sending capture request with transaction_id: $transaction_id"
  echo "Using correlation_id: $correlation_id"

  local json_payload=$(
    cat <<EOF
{
  "correlation_id": "$correlation_id",
  "payment_id": "$payment_id",
  "action_id": "$action_id",
  "transaction_id": "$transaction_id",
  "authorization_date": "2023-03-21T14:52:55.000Z",
  "capture_date": "2024-03-21T14:52:55.000Z",
  "authorization_amount": $amount,
  "capture_amount": $amount,
  "currency_exponent": 2,
  "acceptor_city": "AmsterdamCity of length 26",
  "acceptor_country_iso2": "GB",
  "acceptor_name": "CKO*Acceptor Name of Length 36 Chars",
  "acceptor_phone_number": "12345678901234567890",
  "acceptor_postal_code": "W12 DXXX 11",
  "acceptor_state": "AcceptorState Len 20",
  "acceptor_street_address": "Acceptor Street Information 35 char",
  "acquirer_auth_code": "123456",
  "acquirer_country_iso2": "GB",
  "acquirer_pos_information": "0005100006600826E14 5AB",
  "action_code": 5,
  "authorization_response_code": "081",
  "card_acceptor_id": "X43210987654321",
  "cardholder_authentication_verification_value": "0456",
  "cavv_result": "06",
  "currency_iso3": "GBP",
  "customer_reference_number": "123456789012345678901234567890",
  "electronic_commerce_indicator": "5",
  "intes_code": "1234",
  "is_gwc": true,
  "merchant_category_code": "5816",
  "original_network_reference_id": "123456789012345",
  "process_as_mit": false,
  "processing_profile_key": "pp_dhlsq6ilxghuhnzzyz6fhfn7ey",
  "reference_number": "$reference_number",
  "sca_exemption_indicator": "01",
  "surcharge_fee": "",
  "transaction_indicator": "U",
  "transaction_type": 1,
  "vault_id": "$VAULT_ID"
}
EOF
  )

  # Send the request using curl with explicit charset and verbose output
  curl -v -X POST "$CAPTURE_URL" \
    -H "Content-Type: application/json; charset=utf-8" \
    -H "Accept: application/json" \
    --data-binary "$(echo -n "$json_payload" | iconv -f utf8 -t utf8)" \
    2>&1

  echo -e "\n"
}

# Send refund request
send_refund_request() {
  local amount=$(generate_amount 500 5000)
  local payment_id=$(generate_payment_id)
  local action_id=$(generate_action_id)
  local transaction_id=$(generate_uuid)
  local reference_number=$(generate_reference_number)
  local correlation_id=$(generate_correlation_id)
  local original_transaction_id=$(generate_uuid)
  local current_timestamp=$(current_date)

  echo "Sending refund request with transaction_id: $transaction_id"
  echo "Using correlation_id: $correlation_id"

  local json_payload=$(
    cat <<EOF
{
  "correlation_id": "$correlation_id",
  "payment_id": "$payment_id",
  "action_id": "$action_id",
  "transaction_id": "$transaction_id",
  "authorization_date": "$current_timestamp",
  "refund_date": "$current_timestamp",
  "authorization_amount": $amount,
  "refund_amount": $amount,
  "currency_exponent": 2,
  "acceptor_city": "AmsterdamCity of length 26",
  "acceptor_country_iso2": "GB",
  "acceptor_name": "CKO*Acceptor Name of Length 36 Chars",
  "acceptor_phone_number": "12345678901234567890",
  "acceptor_postal_code": "W12 DXXX 11",
  "acceptor_state": "AcceptorState Len 20",
  "acceptor_street_address": "Acceptor Street Information 35 char",
  "acquirer_auth_code": "123456",
  "acquirer_country_iso2": "GB",
  "acquirer_pos_information": "0005100006600826E14 5AB",
  "action_code": 5,
  "authorization_response_code": "081",
  "card_acceptor_id": "X43210987654321",
  "currency_iso3": "GBP",
  "customer_reference_number": "123456789012345678901234567890",
  "intes_code": "1234",
  "is_gwc": true,
  "merchant_category_code": "5816",
  "original_transaction_id": "$original_transaction_id",
  "processing_profile_key": "pp_dhlsq6ilxghuhnzzyz6fhfn7ey",
  "reference_number": "$reference_number",
  "transaction_type": 2,
  "vault_id": "3f98fa8f-a2f8-4383-8a74-4d40a551fb78"
}
EOF
  )

  # Send the request using curl with explicit charset and verbose output
  curl -v -X POST "$REFUND_URL" \
    -H "Content-Type: application/json; charset=utf-8" \
    -H "Accept: application/json" \
    --data-binary "$(echo -n "$json_payload" | iconv -f utf8 -t utf8)" \
    2>&1

  echo -e "\n"
}

# Main script
echo "Sending requests to DCI Clearing API"
echo "Base URL: $BASE_URL"
echo "------------------------------------"

# Number of requests to send
CAPTURE_COUNT=${2:-5} # Default to 3 captures if not specified
REFUND_COUNT=${3:-2}  # Default to 2 refunds if not specified

# Send capture requests
echo "Sending $CAPTURE_COUNT capture requests..."
for i in $(seq 1 $CAPTURE_COUNT); do
  send_capture_request
  sleep 0.5 # Add a small delay between requests
done

# Send refund requests
# echo "Sending $REFUND_COUNT refund requests..."
# for i in $(seq 1 $REFUND_COUNT); do
#  send_refund_request
#  sleep 0.5 # Add a small delay between requests
# done

echo "All requests completed"

