# Blockmate-OpenAPI

Blockmate uses the `OpenAPI 3.0.0` specification to schematize our docs and to generate our supported client libraries.

## Using the OpenAPI generator

Client code is generated via `openapi-generator-cli` which can be installed in following way:

```bash
npm install -g @openapitools/openapi-generator-cli
```

### Generating Blockmate supported client libraries

The following are commands that we use to generate our supported client libraries:

#### blockmate-csharp

```bash
openapi-generator-cli generate \
-g csharp \
-i openapi.yaml \
-o blockmate-csharp \
-p "packageName=Io.Blockmate,packageGuid={E48FEC6C-7A2D-4E06-8271-4637D7FCBD14}" \
--global-property "apiDocs=false,modelDocs=false,apiTests=false,modelTests=false"
```

#### blockmate-go

```bash
openapi-generator-cli generate \
-g go \
-i openapi.yaml \
-o blockmate-go \
-p "packageName=blockmate,enumClassPrefix=true" \
--global-property "apiTests=false,modelTests=false,apiDocs=false,modelDocs=false"
```

#### blockmate-java

```bash
openapi-generator-cli generate \
-g java \
-i openapi.yaml \
-o blockmate-java \
-p "groupId=io.blockmate,artifactId=blockmate,apiPackage=io.blockmate.client.request,modelPackage=io.blockmate.client.model,dateLibrary=java8,hideGenerationTimestamp=true" \
--library=retrofit2 \
--global-property "apiDocs=false,modelDocs=false,apiTests=false,modelTests=false" \
--type-mappings=BigDecimal=Double
```

#### blockmate-nodejs

```bash
openapi-generator-cli generate \
-g typescript-axios \
-i openapi.yaml \
-o blockmate-nodejs \
-p "npmName=blockmate,supportsES6=true,modelPropertyNaming=original"
```

#### blockmate-php

```bash
openapi-generator-cli generate \
-g php \
-i openapi.yaml \
-o blockmate-php \
-p "packageName=blockmate,invokerPackage=blockmate" \
--global-property "apiTests=false,modelTests=false"
```

#### blockmate-python

```bash
_JAVA_OPTIONS="--add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED" \
openapi-generator-cli generate \
-g python \
-i openapi.yaml \
-o blockmate-python \
-p "packageName=blockmate" \
--global-property "apiTests=false,modelTests=false"
```

#### blockmate-ruby

```bash
openapi-generator-cli generate \
-g ruby \
-i openapi.yaml \
-o blockmate-ruby \
-p 'gemName=blockmate,gemRequiredRubyVersion=">= 2.7.1"' \
--global-property "apiTests=false,modelTests=false" \
--library=faraday
```
