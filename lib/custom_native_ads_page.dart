import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomNativeAdsPage extends StatefulWidget {
  const CustomNativeAdsPage({super.key});

  @override
  State<CustomNativeAdsPage> createState() => _CustomNativeAdsPageState();
}

class _CustomNativeAdsPageState extends State<CustomNativeAdsPage> {
  final double _nativeAdHeight = Platform.isAndroid ? 320 : 300;
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  /// Loads a native ad.
  void _loadAd() async {
    final String adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/2247696110' : 'ca-app-pub-3940256099942544/3986624511';
    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      factoryId: 'customAdFactory',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          // ignore: avoid_print
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // ignore: avoid_print
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdClicked: (ad) {},
        onAdImpression: (ad) {},
        onAdClosed: (ad) {},
        onAdOpened: (ad) {},
        onAdWillDismissScreen: (ad) {},
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Native Example'),
        ),
        backgroundColor: Colors.white70,
        body: Center(
          child: Column(
            children: [
              Stack(children: [
                SizedBox(height: _nativeAdHeight, width: MediaQuery.of(context).size.width),
                if (_nativeAdIsLoaded && _nativeAd != null)
                  SizedBox(height: _nativeAdHeight, width: MediaQuery.of(context).size.width, child: AdWidget(ad: _nativeAd!))
              ]),
              TextButton(onPressed: _loadAd, child: const Text("Refresh Ad")),
              FutureBuilder(
                  future: MobileAds.instance.getVersionString(),
                  builder: (context, snapshot) {
                    var versionString = snapshot.data ?? "";
                    return Text(versionString);
                  })
            ],
          ),
        ));
  }
}
