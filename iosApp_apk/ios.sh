rm iosApp.ipa
sign=$(security find-identity -p codesigning -v |grep VG6JHJ2J8L |awk '{print $2}')
echo "开发者账号id:"
echo $sign
mobile=$(find ./Payload/iosApp.app -name "*.mobileprovision")
echo $mobile
rm $mobile
#rm entitlements.plist
mobile=$(find . -name "*.mobileprovision")
echo $mobile
cp $mobile ./Payload/iosApp.app/embedded.mobileprovision

#security cms -D -i $mobile  > profile.plist
#/usr/libexec/PlistBuddy -x -c 'Print :Entitlements' profile.plist > entitlements.plist
cat entitlements.plist
rm -rf ./Payload/Tips.app/_CodeSignature

#----------------------------------------
# 6. 重签名第三方 FrameWorks
TARGET_APP_FRAMEWORKS_PATH="./Payload/iosApp.app/Frameworks"
if [ -d "$TARGET_APP_FRAMEWORKS_PATH" ];
then
for FRAMEWORK in "$TARGET_APP_FRAMEWORKS_PATH/"*
do

#签名
/usr/bin/codesign --force --sign $sign --entitlements entitlements.plist "$FRAMEWORK"
done
fi

/usr/bin/codesign --force --sign $sign --entitlements entitlements.plist ./Payload/iosApp.app/iosApp
zip -r iosApp.ipa  Payload
