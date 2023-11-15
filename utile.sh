#!/bin/bash

fetchNewSonarIssues() {
	local outputFile=$1
    local projectKey=$2
    local authKey=$3
    local REPO_NAME=$4
    local SOURCE_BRANCH=$5
    local status="UNKNOWN ISSUE"
    local outputFile="sonar_issues.json"

    # Prepare the URL
    local url="https://aaaaaaa.com/sonar/api/issues/search?componentKeys=${projectKey}&s=FILE_LINE&resolved=false&severities=CRITICAL,BLOCKER&sinceLeakPeriod=true&ps=100&facets=severities%2Ctypes&additionalFields=_all"

    # Fetch data using curl
    response=$(curl -s -w "%{http_code}" -X GET -H "Authorization: Basic $authKey" -H "Accept: application/json" -H "Content-Type: application/json" "$url")

    # Extract HTTP status code
    http_code=$(echo $response | tail -n1)
    response=$(echo $response | sed '$d')

    if [ "$http_code" -eq 200 ]; then
        # Write JSON data to file
        echo $response | jq . > $outputFile
        status="OK"
    else
        status="***ISSUE CALLING SONAR REST API for fetching new issues : $response***"
    fi

    echo "Status : $status"
}
