import 'package:flutter_ads_demo/app_open_ad_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    print('AdmobPage: OpenAd startListening');
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    print('AdmobPage: OpenAd New AppState state: $appState');
    if (appState == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}
