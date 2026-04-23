# Image Cache Sync — Performance Test Summary

## What we tested

Two metrics were measured across image sizes of 300 MB, 1 GB, 3 GB, and 10 GB, on both AWS (ECR) and GCP (GAR):

- **Sync time** — how long it takes to replicate an image from the source registry (mock-artifactory) to the cloud-local cache registry, triggered via the sync-gate `/batch` endpoint and measured until the manifest is confirmed visible in the cache.
- **Pull time** — how long the kubelet takes to pull the image from the cache registry onto a node, derived from Kubernetes `Pulling` → `Pulled` event timestamps.

## Test images

Images were built synthetically using `crane append` on top of a minimal busybox base. Each tag adds one additional layer of random data. The `1gb`–`10gb` tags are cumulative — `3gb` has three 1 GB layers, `10gb` has ten, and so on. The `300mb` image was created separately with a single ~300 MB layer, using the same approach but with a smaller payload. All images were pushed into the mock-artifactory (source) registry from Cloud Shell (GCP) or a workstation with ECR access (AWS), and reused across runs.

## How pull times were isolated

Each pull measurement used a fresh cluster node — provisioned on demand by GKE Node Auto Provisioning or EKS Karpenter. This guarantees no layer caching on disk, so times reflect a cold pull from the registry. The node pool was allowed to drain fully between image sizes before the next test began.

## How times were measured

### Sync time

Before each run the target tag is deleted from the cache registry, and the script waits until the deletion is confirmed (up to 10 s). A client-side wall-clock timer starts immediately before the POST to sync-gate, and stops the moment `crane manifest` returns a valid response from the cache registry. The loop polls every 5 seconds with a 600 s timeout.

```bash
# delete from cache so sync is forced
crane delete "$CACHE_REPO/benchmark:$SIZE"

# start timer and trigger sync
T0=$(date +%s.%N)
curl -s -X POST http://localhost:8080/batch \
  -H 'Content-Type: application/json' \
  -d "{\"images\": [\"$MOCK_REPO/benchmark:$SIZE\"]}"

# poll until manifest appears
until crane manifest "$CACHE_REPO/benchmark:$SIZE" &>/dev/null; do sleep 5; done
T1=$(date +%s.%N)

ELAPSED=$(awk -v a="$T1" -v b="$T0" 'BEGIN{printf "%.1f", a-b}')
```

This captures the full end-to-end time: sync-gate receives the request, publishes to the queue, sync-worker picks it up, runs `crane copy`, and the manifest becomes visible in the destination registry.

### Pull time

A pod is created in the cluster with the cache-registry image as its only container. Once the pod reaches `Running`, Kubernetes event timestamps are read for the `Pulling` and `Pulled` reasons, filtered by pod UID to exclude stale events from any prior pod that reused the same name. Pull time is the difference between those two timestamps in whole seconds.

```bash
# wait for pod Running, then extract event timestamps
EVENTS=$(kubectl get events -n "$NAMESPACE" \
  --field-selector involvedObject.name="$POD_NAME" -o json)

PULLING_TIME=$(echo "$EVENTS" | jq -r \
  --arg uid "$POD_UID" \
  '.items[] | select(.involvedObject.uid==$uid)
           | select(.reason=="Pulling")
           | (.eventTime // .firstTimestamp)' | tail -1)

PULLED_TIME=$(echo "$EVENTS" | jq -r \
  --arg uid "$POD_UID" \
  '.items[] | select(.involvedObject.uid==$uid)
           | select(.reason=="Pulled")
           | (.eventTime // .firstTimestamp)' | tail -1)

PULL_TIME=$(( $(date -d "$PULLED_TIME" +%s) - $(date -d "$PULLING_TIME" +%s) ))
```

## Charts

See the attached charts for sync times and pull times — each chart covers both AWS and GCP side by side.
