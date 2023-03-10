flutter clean
cd ./ios
rm -rf Pods
rm -rf .symlinks
flutter pub get
# arch -x86_64 pod - for M1
arch -x86_64 pod repo update
arch -x86_64 pod install
cd ..
flutter pub get
flutter run