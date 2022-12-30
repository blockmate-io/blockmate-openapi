#!/bin/bash
set -e

function generateCsharp() {
    relativePath=$1
    openapi-generator-cli generate \
    -g csharp \
    -i openapi.yaml \
    -o "$relativePath/blockmate-csharp" \
    -p "packageName=Io.Blockmate,packageGuid={E48FEC6C-7A2D-4E06-8271-4637D7FCBD14}" \
    --global-property "apiDocs=false,modelDocs=false,apiTests=false,modelTests=false"
}

function generateGo() {
    relativePath=$1
    openapi-generator-cli generate \
    -g go \
    -i openapi.yaml \
    -o "$relativePath/blockmate-go" \
    -p "packageName=blockmate,enumClassPrefix=true" \
    --global-property "apiTests=false,modelTests=false,apiDocs=false,modelDocs=false"
}

function generateJava() {
    relativePath=$1
    openapi-generator-cli generate \
    -g java \
    -i openapi.yaml \
    -o "$relativePath/blockmate-java" \
    -p "groupId=io.blockmate,artifactId=blockmate,apiPackage=io.blockmate.client.request,modelPackage=io.blockmate.client.model,dateLibrary=java8,hideGenerationTimestamp=true,openApiNullable=false" \
    --library=retrofit2 \
    --global-property "apiDocs=false,modelDocs=false,apiTests=false,modelTests=false" \
    --type-mappings=BigDecimal=Double
}

function generateNodejs() {
    relativePath=$1
    openapi-generator-cli generate \
    -g typescript-axios \
    -i openapi.yaml \
    -o "$relativePath/blockmate-nodejs" \
    -p "npmName=blockmate,supportsES6=true,modelPropertyNaming=original"
}

function generatePhp() {
    relativePath=$1
    openapi-generator-cli generate \
    -g php \
    -i openapi.yaml \
    -o "$relativePath/blockmate-php" \
    -p "packageName=blockmate,invokerPackage=blockmate" \
    --global-property "apiTests=false,modelTests=false"
}

function generatePython() {
    relativePath=$1
    _JAVA_OPTIONS="--add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED" \
    openapi-generator-cli generate \
    -g python \
    -i openapi.yaml \
    -o "$relativePath/blockmate-python" \
    -p "packageName=blockmate" \
    --global-property "apiTests=false,modelTests=false"
}

function generateRuby() {
    relativePath=$1
    openapi-generator-cli generate \
    -g ruby \
    -i openapi.yaml \
    -o "$relativePath/blockmate-ruby" \
    -p 'gemName=blockmate,gemRequiredRubyVersion=">= 2.7.1"' \
    --global-property "apiTests=false,modelTests=false" \
    --library=faraday
}

function handleLanguage() {
    relativePath=$1
    commitMessage=$2
    dryRun=$3
    language=$4

    pwd=$(pwd)
    cd "$relativePath/blockmate-$language"
    git checkout main
    git pull
    cd "$pwd"

    if [[ "$language" == "csharp" ]]; then
        generateCsharp "$relativePath"
    elif [[ "$language" == "go" ]]; then
        generateGo "$relativePath"
    elif [[ "$language" == "java" ]]; then
        generateJava "$relativePath"
    elif [[ "$language" == "nodejs" ]]; then
        generateNodejs "$relativePath"
    elif [[ "$language" == "php" ]]; then
        generatePhp "$relativePath"
    elif [[ "$language" == "python" ]]; then
        generatePython "$relativePath"
    elif [[ "$language" == "ruby" ]]; then
        generateRuby "$relativePath"
    else
        echo "Unexpected language $language"
    fi

    if [[ "$dryRun" == "false" ]]; then
        cd "$relativePath/blockmate-$language"
        handleGitOperations
        cd "$pwd"
    fi
}

function handleGitOperations() {
    git add .
    git commit -m "$commitMessage"
    git push
}

function usage() {
    echo "Usage: $0 [-r relative-path] [-m commit-message]"
    echo "  -r, --relative-path   Relative path to language repositories"
    echo "  -m, --commit-message  Commit message"
    echo "  -d, --dry-run         If \"true\" it only generates, if \"false\" it also commits and pushes to Git"
    echo ""
    echo "Example: $0 --relative-path \"..\" --commit-message \"My commit message\" --dry-run \"true\""
    exit 1
}

while [[ "$#" -gt 0 ]]; do case $1 in
    -r|--relative-path) relativePath="$2"; shift;shift;;
    -m|--commit-message) commitMessage="$2";shift;shift;;
    -d|--dry-run) dryRun="$2";shift;shift;;
    *) usage;;
esac; done

if [ -z "$relativePath" ]; then
    usage
fi

if [ -z "$commitMessage" ]; then
    usage
fi

if [ -z "$dryRun" ]; then
    usage
fi

if [[ "$dryRun" != "true" && "$dryRun" != "false" ]]; then
    usage
fi

handleLanguage "$relativePath" "$commitMessage" "$dryRun" "csharp"
handleLanguage "$relativePath" "$commitMessage" "$dryRun" "go"
handleLanguage "$relativePath" "$commitMessage" "$dryRun" "java"
handleLanguage "$relativePath" "$commitMessage" "$dryRun" "nodejs"
handleLanguage "$relativePath" "$commitMessage" "$dryRun" "php"
handleLanguage "$relativePath" "$commitMessage" "$dryRun" "python"
handleLanguage "$relativePath" "$commitMessage" "$dryRun" "ruby"

# commit and push also changes in this repository
if [[ "$dryRun" == "false" ]]; then
    handleGitOperations
fi
