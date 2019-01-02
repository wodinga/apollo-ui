FRAMEWORK_SEARCH_PATHS="/Users/drg62sf/Library/Developer/Xcode/DerivedData/ApolloUI-erzottzjczfibkbmzajhmainnjun/Build/Products/Debug  "/Users/drg62sf/Library/Developer/Xcode/DerivedData/ApolloUI-erzottzjczfibkbmzajhmainnjun/Build/Products/Debug/Apollo""

APOLLO_FRAMEWORK_PATH="$(eval find $FRAMEWORK_SEARCH_PATHS -name 'Apollo.framework' -maxdepth 1)"

if [ -z "$APOLLO_FRAMEWORK_PATH" ]; then
echo "error: Couldn't find Apollo.framework in FRAMEWORK_SEARCH_PATHS; make sure to add the framework to your project."
exit 1
fi

#cd "${SRCROOT}/${TARGET_NAME}"
cd "${SRCROOT}"
$APOLLO_FRAMEWORK_PATH/Versions/Current/Resources/check-and-run-apollo-cli.sh codegen:generate --queries="$(find . -name '*.graphql')" --schema=schema.json API.swift
