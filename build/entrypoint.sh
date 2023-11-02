#!/bin/sh

case "$_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_HOLESKY" in
"prysm-holesky.dnp.dappnode.eth")
  echo "Using prysm-holesky.dnp.dappnode.eth"
  JWT_PATH="/security/prysm/jwtsecret.hex"
  ;;
"lighthouse-holesky.dnp.dappnode.eth")
  echo "Using lighthouse-holesky.dnp.dappnode.eth"
  JWT_PATH="/security/lighthouse/jwtsecret.hex"
  ;;
"lodestar-holesky.dnp.dappnode.eth")
  echo "Using lodestar-holesky.dnp.dappnode.eth"
  JWT_PATH="/security/lodestar/jwtsecret.hex"
  ;;
"teku-holesky.dnp.dappnode.eth")
  echo "Using teku-holesky.dnp.dappnode.eth"
  JWT_PATH="/security/teku/jwtsecret.hex"
  ;;
"nimbus-holesky.dnp.dappnode.eth")
  echo "Using nimbus-holesky.dnp.dappnode.eth"
  JWT_PATH="/security/nimbus/jwtsecret.hex"
  ;;
*)
  echo "Using default"
  JWT_PATH="/security/default/jwtsecret.hex"
  ;;
esac

# Check if curl is installed (not installed in ARM64 arch)
if command -v curl >/dev/null 2>&1; then
  # Print the jwt to the dappmanager
  JWT=$(cat $JWT_PATH)
  curl -X POST "http://my.dappnode/data-send?key=jwt&data=${JWT}"
else
  echo "curl is not installed in ARM64 arch. Skipping the JWT post to package info."
fi

exec besu --rpc-ws-host='0.0.0.0' \
  --rpc-http-host='0.0.0.0' \
  --rpc-http-enabled=true \
  --host-allowlist=* \
  --rpc-http-cors-origins=* \
  --engine-rpc-port=8551 \
  --engine-host-allowlist=* \
  --engine-jwt-secret=$JWT_PATH \
  --engine-rpc-enabled=true \
  --metrics-enabled \
  --metrics-host='0.0.0.0' \
  --data-path=/var/lib/besu \
  --p2p-port=$P2P_PORT \
  --network=holesky \
  $EXTRA_OPTS
