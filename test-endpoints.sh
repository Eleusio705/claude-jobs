#!/bin/bash

# Test all claude-jobs endpoints
# Usage: ./test-endpoints.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

FAILED=0
PASSED=0

test_endpoint() {
    local company=$1
    local url=$2

    printf "Testing %-15s ... " "$company"

    response=$(curl -s -w "\n%{http_code}" --max-time 30 "$url" 2>/dev/null) || {
        echo -e "${RED}FAILED${NC} (connection error)"
        FAILED=$((FAILED + 1))
        return 0
    }

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" != "200" ]; then
        echo -e "${RED}FAILED${NC} (HTTP $http_code)"
        FAILED=$((FAILED + 1))
        return 0
    fi

    # Validate response looks like job data by checking for common job-related fields
    # This handles various API structures (arrays, nested objects, different field names)
    if echo "$body" | grep -qiE '"(title|name|position|role)".*:.*"[^"]+"|"(location|office|city)".*:.*"[^"]+"'; then
        # Try to estimate job count by counting title/position occurrences
        job_count=$(echo "$body" | grep -oiE '"(title|name)"[[:space:]]*:[[:space:]]*"[^"]+"' | wc -l | tr -d ' ')
        if [ "$job_count" -eq 0 ]; then
            job_count="?"
        fi
        echo -e "${GREEN}OK${NC} (~$job_count jobs)"
        PASSED=$((PASSED + 1))
    elif echo "$body" | grep -qE '^\[.*\]$|"jobs"'; then
        # Looks like JSON array or has jobs key but couldn't find typical fields
        echo -e "${YELLOW}OK${NC} (structure unclear)"
        PASSED=$((PASSED + 1))
    elif echo "$body" | grep -qiE '<title>.*jobs|careers.*</title>|class=".*job|posting|position.*"'; then
        # HTML job board page
        echo -e "${GREEN}OK${NC} (HTML job board)"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}FAILED${NC} (invalid response)"
        FAILED=$((FAILED + 1))
    fi

    return 0
}

echo "Testing claude-jobs endpoints..."
echo ""

# All companies (alphabetical)
test_endpoint "affirm" "https://boards-api.greenhouse.io/v1/boards/affirm/jobs"
test_endpoint "airbnb" "https://boards-api.greenhouse.io/v1/boards/airbnb/jobs"
test_endpoint "airtable" "https://boards-api.greenhouse.io/v1/boards/airtable/jobs"
test_endpoint "algolia" "https://boards-api.greenhouse.io/v1/boards/algolia/jobs"
test_endpoint "amplitude" "https://boards-api.greenhouse.io/v1/boards/amplitude/jobs"
test_endpoint "anthropic" "https://boards-api.greenhouse.io/v1/boards/anthropic/jobs"
test_endpoint "anyscale" "https://jobs.ashbyhq.com/anyscale"
test_endpoint "applovin" "https://boards-api.greenhouse.io/v1/boards/applovin/jobs"
test_endpoint "asana" "https://boards-api.greenhouse.io/v1/boards/asana/jobs"
test_endpoint "axiom" "https://boards-api.greenhouse.io/v1/boards/axiom/jobs"
test_endpoint "benchling" "https://boards-api.greenhouse.io/v1/boards/benchling/jobs"
test_endpoint "block" "https://boards-api.greenhouse.io/v1/boards/block/jobs"
test_endpoint "brex" "https://boards-api.greenhouse.io/v1/boards/brex/jobs"
test_endpoint "calendly" "https://boards-api.greenhouse.io/v1/boards/calendly/jobs"
test_endpoint "carta" "https://boards-api.greenhouse.io/v1/boards/carta/jobs"
test_endpoint "chime" "https://boards-api.greenhouse.io/v1/boards/chime/jobs"
test_endpoint "circleci" "https://boards-api.greenhouse.io/v1/boards/circleci/jobs"
test_endpoint "cloudflare" "https://boards-api.greenhouse.io/v1/boards/cloudflare/jobs"
test_endpoint "cockroachlabs" "https://boards-api.greenhouse.io/v1/boards/cockroachlabs/jobs"
test_endpoint "cohere" "https://jobs.ashbyhq.com/cohere"
test_endpoint "coinbase" "https://boards-api.greenhouse.io/v1/boards/coinbase/jobs"
test_endpoint "contentful" "https://boards-api.greenhouse.io/v1/boards/contentful/jobs"
test_endpoint "coursera" "https://boards-api.greenhouse.io/v1/boards/coursera/jobs"
test_endpoint "databricks" "https://boards-api.greenhouse.io/v1/boards/databricks/jobs"
test_endpoint "datadog" "https://boards-api.greenhouse.io/v1/boards/datadog/jobs"
test_endpoint "deel" "https://jobs.ashbyhq.com/deel"
test_endpoint "descript" "https://boards-api.greenhouse.io/v1/boards/descript/jobs"
test_endpoint "discord" "https://boards-api.greenhouse.io/v1/boards/discord/jobs"
test_endpoint "dollarshaveclub" "https://boards-api.greenhouse.io/v1/boards/dollarshaveclub/jobs"
test_endpoint "dropbox" "https://boards-api.greenhouse.io/v1/boards/dropbox/jobs"
test_endpoint "duolingo" "https://boards-api.greenhouse.io/v1/boards/duolingo/jobs"
test_endpoint "elastic" "https://boards-api.greenhouse.io/v1/boards/elastic/jobs"
test_endpoint "faire" "https://boards-api.greenhouse.io/v1/boards/faire/jobs"
test_endpoint "fastly" "https://boards-api.greenhouse.io/v1/boards/fastly/jobs"
test_endpoint "fetch" "https://boards-api.greenhouse.io/v1/boards/fetch/jobs"
test_endpoint "figma" "https://boards-api.greenhouse.io/v1/boards/figma/jobs"
test_endpoint "fivetran" "https://boards-api.greenhouse.io/v1/boards/fivetran/jobs"
test_endpoint "flexport" "https://boards-api.greenhouse.io/v1/boards/flexport/jobs"
test_endpoint "gitlab" "https://boards-api.greenhouse.io/v1/boards/gitlab/jobs"
test_endpoint "grammarly" "https://boards-api.greenhouse.io/v1/boards/grammarly/jobs"
test_endpoint "gusto" "https://boards-api.greenhouse.io/v1/boards/gusto/jobs"
test_endpoint "hightouch" "https://boards-api.greenhouse.io/v1/boards/hightouch/jobs"
test_endpoint "instacart" "https://boards-api.greenhouse.io/v1/boards/instacart/jobs"
test_endpoint "intercom" "https://boards-api.greenhouse.io/v1/boards/intercom/jobs"
test_endpoint "labelbox" "https://boards-api.greenhouse.io/v1/boards/labelbox/jobs"
test_endpoint "lattice" "https://boards-api.greenhouse.io/v1/boards/lattice/jobs"
test_endpoint "launchdarkly" "https://boards-api.greenhouse.io/v1/boards/launchdarkly/jobs"
test_endpoint "linear" "https://jobs.ashbyhq.com/linear"
test_endpoint "liveperson" "https://boards-api.greenhouse.io/v1/boards/liveperson/jobs"
test_endpoint "lucidmotors" "https://boards-api.greenhouse.io/v1/boards/lucidmotors/jobs"
test_endpoint "lyft" "https://boards-api.greenhouse.io/v1/boards/lyft/jobs"
test_endpoint "marqeta" "https://boards-api.greenhouse.io/v1/boards/marqeta/jobs"
test_endpoint "mercury" "https://boards-api.greenhouse.io/v1/boards/mercury/jobs"
test_endpoint "mixpanel" "https://boards-api.greenhouse.io/v1/boards/mixpanel/jobs"
test_endpoint "mongodb" "https://boards-api.greenhouse.io/v1/boards/mongodb/jobs"
test_endpoint "moveworks" "https://boards-api.greenhouse.io/v1/boards/moveworks/jobs"
test_endpoint "netlify" "https://boards-api.greenhouse.io/v1/boards/netlify/jobs"
test_endpoint "nextdoor" "https://boards-api.greenhouse.io/v1/boards/nextdoor/jobs"
test_endpoint "notion" "https://jobs.ashbyhq.com/notion"
test_endpoint "nuro" "https://boards-api.greenhouse.io/v1/boards/nuro/jobs"
test_endpoint "okta" "https://boards-api.greenhouse.io/v1/boards/okta/jobs"
test_endpoint "openai" "https://jobs.ashbyhq.com/openai"
test_endpoint "pagerduty" "https://boards-api.greenhouse.io/v1/boards/pagerduty/jobs"
test_endpoint "palantir" "https://api.lever.co/v0/postings/palantir"
test_endpoint "peloton" "https://boards-api.greenhouse.io/v1/boards/peloton/jobs"
test_endpoint "pendo" "https://boards-api.greenhouse.io/v1/boards/pendo/jobs"
test_endpoint "perplexity" "https://jobs.ashbyhq.com/perplexity"
test_endpoint "pinterest" "https://boards-api.greenhouse.io/v1/boards/pinterest/jobs"
test_endpoint "plaid" "https://api.lever.co/v0/postings/plaid"
test_endpoint "postman" "https://boards-api.greenhouse.io/v1/boards/postman/jobs"
test_endpoint "ramp" "https://jobs.ashbyhq.com/ramp"
test_endpoint "reddit" "https://boards-api.greenhouse.io/v1/boards/reddit/jobs"
test_endpoint "retool" "https://boards-api.greenhouse.io/v1/boards/retool/jobs"
test_endpoint "revenuecat" "https://jobs.ashbyhq.com/revenuecat"
test_endpoint "robinhood" "https://boards-api.greenhouse.io/v1/boards/robinhood/jobs"
test_endpoint "salesloft" "https://boards-api.greenhouse.io/v1/boards/salesloft/jobs"
test_endpoint "samsara" "https://boards-api.greenhouse.io/v1/boards/samsara/jobs"
test_endpoint "scaleai" "https://boards-api.greenhouse.io/v1/boards/scaleai/jobs"
test_endpoint "seatgeek" "https://boards-api.greenhouse.io/v1/boards/seatgeek/jobs"
test_endpoint "sendbird" "https://boards-api.greenhouse.io/v1/boards/sendbird/jobs"
test_endpoint "sentry" "https://sentry.io/jobs/list.json"
test_endpoint "sofi" "https://boards-api.greenhouse.io/v1/boards/sofi/jobs"
test_endpoint "spotify" "https://api.lever.co/v0/postings/spotify"
test_endpoint "squarespace" "https://boards-api.greenhouse.io/v1/boards/squarespace/jobs"
test_endpoint "stripe" "https://boards-api.greenhouse.io/v1/boards/stripe/jobs"
test_endpoint "tailscale" "https://boards-api.greenhouse.io/v1/boards/tailscale/jobs"
test_endpoint "taskrabbit" "https://boards-api.greenhouse.io/v1/boards/taskrabbit/jobs"
test_endpoint "thumbtack" "https://boards-api.greenhouse.io/v1/boards/thumbtack/jobs"
test_endpoint "toast" "https://boards-api.greenhouse.io/v1/boards/toast/jobs"
test_endpoint "twilio" "https://boards-api.greenhouse.io/v1/boards/twilio/jobs"
test_endpoint "twitch" "https://boards-api.greenhouse.io/v1/boards/twitch/jobs"
test_endpoint "udemy" "https://boards-api.greenhouse.io/v1/boards/udemy/jobs"
test_endpoint "vanta" "https://jobs.ashbyhq.com/vanta"
test_endpoint "vercel" "https://boards-api.greenhouse.io/v1/boards/vercel/jobs"
test_endpoint "veriff" "https://boards-api.greenhouse.io/v1/boards/veriff/jobs"
test_endpoint "waymo" "https://boards-api.greenhouse.io/v1/boards/waymo/jobs"
test_endpoint "webflow" "https://boards-api.greenhouse.io/v1/boards/webflow/jobs"
test_endpoint "yext" "https://boards-api.greenhouse.io/v1/boards/yext/jobs"
test_endpoint "ziprecruiter" "https://boards-api.greenhouse.io/v1/boards/ziprecruiter/jobs"
test_endpoint "zscaler" "https://boards-api.greenhouse.io/v1/boards/zscaler/jobs"

echo ""
echo "Results: $PASSED passed, $FAILED failed"

if [ $FAILED -gt 0 ]; then
    exit 1
fi
