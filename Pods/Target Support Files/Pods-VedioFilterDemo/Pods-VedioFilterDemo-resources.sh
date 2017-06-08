#!/bin/sh
set -e

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

case "${TARGETED_DEVICE_FAMILY}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}"
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}"
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\""
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\""
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\""
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH"
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "../../HBLocalPod/FeSlideFilterView/done.png"
  install_resource "../../HBLocalPod/FeSlideFilterView/done@2x.png"
  install_resource "GPUImage/framework/Resources/lookup.png"
  install_resource "GPUImage/framework/Resources/lookup_amatorka.png"
  install_resource "GPUImage/framework/Resources/lookup_miss_etikate.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_1.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_2.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/1977blowout.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/1977map.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/amaroMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/blackboard1024.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/brannanBlowout.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/brannanContrast.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/brannanLuma.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/brannanProcess.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/brannanScreen.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/earlybirdBlowout.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/earlyBirdCurves.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/earlybirdMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/earlybirdOverlayMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/edgeBurn.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hefeGradientMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hefeMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hefeMetal.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hefeSoftLight.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hudsonBackground.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hudsonMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/inkwellMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/kelvinMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/lomoMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/nashvilleMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/overlayMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/riseMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/sierraMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/sierraVignette.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/softLight.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/sutroCurves.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/sutroEdgeBurn.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/sutroMetal.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/toasterColorShift.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/toasterCurves.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/toasterMetal.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/toasterOverlayMapWarm.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/toasterSoftLight.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/valenciaGradientMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/valenciaMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/vignetteMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/waldenMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/xproMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle"
  install_resource "SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "../../HBLocalPod/FeSlideFilterView/done.png"
  install_resource "../../HBLocalPod/FeSlideFilterView/done@2x.png"
  install_resource "GPUImage/framework/Resources/lookup.png"
  install_resource "GPUImage/framework/Resources/lookup_amatorka.png"
  install_resource "GPUImage/framework/Resources/lookup_miss_etikate.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_1.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_2.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/1977blowout.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/1977map.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/amaroMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/blackboard1024.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/brannanBlowout.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/brannanContrast.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/brannanLuma.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/brannanProcess.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/brannanScreen.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/earlybirdBlowout.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/earlyBirdCurves.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/earlybirdMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/earlybirdOverlayMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/edgeBurn.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hefeGradientMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hefeMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hefeMetal.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hefeSoftLight.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hudsonBackground.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/hudsonMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/inkwellMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/kelvinMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/lomoMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/nashvilleMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/overlayMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/riseMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/sierraMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/sierraVignette.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/softLight.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/sutroCurves.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/sutroEdgeBurn.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/sutroMetal.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/toasterColorShift.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/toasterCurves.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/toasterMetal.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/toasterOverlayMapWarm.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/toasterSoftLight.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/valenciaGradientMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/valenciaMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/vignetteMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/waldenMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle/xproMap.png"
  install_resource "../../HBLocalPod/PPSliderCaptureView/HBGPUImageFilters/Filters/GPUImage.InstagramFilter.bundle"
  install_resource "SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
