# <!-- Build armv7 Specific image with armv7 tag -->
docker build --platform linux/arm/v7 -t jtmb92/ez-backups:armv7 .
# <!-- Build arm64 Specific image with arm64 tag -->
docker build --platform linux/arm64 -t jtmb92/ez-backups:arm64 .
# <!-- Build AMD64 Specific image with amd64 tag -->
docker build --platform linux/amd64 -t jtmb92/ez-backups:amd64 .
# <!-- Build Multiplatform image Specific image with no tag -->
docker buildx build . -t jtmb92/ez-backups --push --platform=linux/arm64,linux/amd64,linux/arm/v7
# <!-- Build Multiplatform image Specific image with latest tag -->
docker buildx build . -t jtmb92/ez-backups:latest --push --platform=linux/arm64,linux/amd64,linux/arm/v7
