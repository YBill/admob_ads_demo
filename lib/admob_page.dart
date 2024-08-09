import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobPage extends StatefulWidget {
  const AdmobPage(this.screenWidth, this.screenHeight, {super.key});

  final double screenWidth;
  final double screenHeight;

  @override
  State<AdmobPage> createState() => _AdmobPageState();
}

class _AdmobPageState extends State<AdmobPage> {
  BannerAd? _bannerAd;
  bool? _isBannerAdLoaded;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  NativeAd? _nativeAd;
  bool? _nativeAdIsLoaded;

  Future<void> _loadBannerAd() async {
    _isBannerAdLoaded = false;
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716';
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.sizeOf(context).width.truncate());
    if (size == null) {
      print('AdmobPage: BannerAd loadBannerAd size is null');
      return;
    }
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      // size: AdSize(width: widget.screenWidth.toInt(), height: 50),
      size: size,
      // size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          print('AdmobPage: BannerAd onAdLoaded ad: ${ad.responseInfo}');
          _isBannerAdLoaded = true;
          setState(() {});
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          print('AdmobPage: BannerAd onAdFailedToLoad, error: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (ad) {
          print('AdmobPage: BannerAd onAdOpened');
        },
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (ad) {
          print('AdmobPage: BannerAd onAdClosed');
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (ad) {
          print('AdmobPage: BannerAd onAdImpression');
        },
        onAdWillDismissScreen: (ad) {
          print('AdmobPage: BannerAd onAdWillDismissScreen');
        },
        onPaidEvent: (ad, value, precision, currencyCode) {
          print('AdmobPage: BannerAd onPaidEvent, value: $value, precision: $precision, currencyCode: $currencyCode');
        },
        onAdClicked: (ad) {
          print('AdmobPage: BannerAd onAdClicked');
        },
      ),
    )..load();
  }

  void _loadInterstitialAd() {
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/1033173712' : 'ca-app-pub-3940256099942544/4411468910';
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {
              print('AdmobPage: InterstitialAd onAdShowedFullScreenContent');
            },
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {
              print('AdmobPage: InterstitialAd onAdImpression');
            },
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              print('AdmobPage: InterstitialAd onAdFailedToShowFullScreenContent error: $err');
              ad.dispose();
            },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              print('AdmobPage: InterstitialAd onAdDismissedFullScreenContent');
              ad.dispose();
            },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {
              print('AdmobPage: InterstitialAd onAdClicked');
            });

            print('AdmobPage: InterstitialAd onAdLoaded ad: $ad');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
            _interstitialAd?.show();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            print('AdmobPage: InterstitialAd onAdFailedToLoad error: $error');
          },
        ));
  }

  void _loadRewardedAd() {
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/5224354917' : 'ca-app-pub-3940256099942544/1712485313';
    RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {
              print('AdmobPage: RewardedAd onAdShowedFullScreenContent');
            },
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {
              print('AdmobPage: RewardedAd onAdImpression');
            },
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              print('AdmobPage: RewardedAd onAdFailedToShowFullScreenContent');
              ad.dispose();
            },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              print('AdmobPage: RewardedAd onAdDismissedFullScreenContent');
              ad.dispose();
            },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {
              print('AdmobPage: RewardedAd onAdClicked');
            });

            print('AdmobPage: RewardedAd onAdLoaded ad: $ad');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
            _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
              // Reward the user for watching an ad.
              print('AdmobPage: RewardedAd onUserEarnedReward ad: $ad, rewardItem: [${rewardItem.type}|${rewardItem.amount}]');
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            print('AdmobPage: RewardedAd onAdFailedToLoad error: $error');
          },
        ));
  }

  void _loadRewardedInterstitialAd() {
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/5354046379' : 'ca-app-pub-3940256099942544/6978759866';
    RewardedInterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {
              print('AdmobPage: RewardedInterstitialAd onAdShowedFullScreenContent');
            },
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {
              print('AdmobPage: RewardedInterstitialAd onAdImpression');
            },
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              print('AdmobPage: RewardedInterstitialAd onAdFailedToShowFullScreenContent error: $err');
              ad.dispose();
            },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              print('AdmobPage: RewardedInterstitialAd onAdDismissedFullScreenContent');
              ad.dispose();
            },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {
              print('AdmobPage: RewardedInterstitialAd onAdClicked');
            });

            print('AdmobPage: RewardedInterstitialAd onAdLoaded ad: $ad');
            // Keep a reference to the ad so you can show it later.
            _rewardedInterstitialAd = ad;
            _rewardedInterstitialAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
              // Reward the user for watching an ad.
              print('AdmobPage: RewardedInterstitialAd onUserEarnedReward ad: $ad, rewardItem = $rewardItem');
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            print('AdmobPage: RewardedInterstitialAd onAdFailedToLoad error: $error');
          },
        ));
  }

  void _loadNativeAd() async {
    final String adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/2247696110' : 'ca-app-pub-3940256099942544/3986624511';
    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print('AdmobPage: NativeAd Template onAdLoaded ad: $ad');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('AdmobPage: NativeAd Template onAdFailedToLoad ad: $ad');
          ad.dispose();
        },
        onAdClicked: (ad) {
          print('AdmobPage: NativeAd Template onAdClicked');
        },
        onAdImpression: (ad) {
          print('AdmobPage: NativeAd Template onAdImpression');
        },
        onAdClosed: (ad) {
          print('AdmobPage: NativeAd Template onAdClosed');
        },
        onAdOpened: (ad) {
          print('AdmobPage: NativeAd Template onAdOpened');
        },
        onAdWillDismissScreen: (ad) {
          print('AdmobPage: NativeAd Template onAdWillDismissScreen');
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          print('AdmobPage: NativeAd Template onPaidEvent, valueMicros = $valueMicros, precision = $precision, currencyCode = $currencyCode');
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        // 背景
        mainBackgroundColor: const Color(0xfffffbed),
        // 下载按钮文字
        callToActionTextStyle: NativeTemplateTextStyle(textColor: Colors.white, style: NativeTemplateFontStyle.monospace, size: 16.0),
        primaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black, style: NativeTemplateFontStyle.bold, size: 16.0),
        secondaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black, style: NativeTemplateFontStyle.italic, size: 16.0),
        tertiaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black, style: NativeTemplateFontStyle.normal, size: 16.0),
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Admob'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                TextButton(
                    onPressed: () {
                      _loadBannerAd();
                    },
                    child: const Text(
                      'Show Banner',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                TextButton(
                    onPressed: () {
                      _loadNativeAd();
                    },
                    child: const Text(
                      'Show Native',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                TextButton(
                    onPressed: () {
                      _loadInterstitialAd();
                    },
                    child: const Text(
                      'Show Interstitial',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                TextButton(
                    onPressed: () {
                      _loadRewardedAd();
                    },
                    child: const Text(
                      'Show Rewarded',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                TextButton(
                    onPressed: () {
                      _loadRewardedInterstitialAd();
                    },
                    child: const Text(
                      'Show RewardedInterstitial',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNativeAdWidget(),
                _buildBannerAdWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerAdWidget() {
    Widget child;
    if (_bannerAd != null) {
      print('AdmobPage: screenWidth = ${widget.screenWidth}, screenHeight = ${widget.screenHeight}, '
          'adWidth = ${_bannerAd!.size.width.toDouble()}, adHeight = ${_bannerAd!.size.height.toDouble()}');
      child = SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      if (_isBannerAdLoaded == null) {
        child = Container();
      } else {
        child = const Text(
          'Banner Ad Loading...',
          style: TextStyle(color: Colors.black, fontSize: 16),
        );
      }
    }
    return SafeArea(
      child: child,
    );
  }

  Widget _buildNativeAdWidget() {
    Widget child;
    if (_nativeAd != null) {
      child = Container(
        color: Colors.red,
        child: _nativeAdWidget(),
      );
    } else {
      if (_nativeAdIsLoaded == null) {
        child = Container();
      } else {
        child = const Text(
          'Native Ad Loading...',
          style: TextStyle(color: Colors.black, fontSize: 16),
        );
      }
    }
    return SafeArea(
      child: child,
    );
  }

  Widget _nativeAdWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    const double adAspectRatioMedium = (370 / 355);
    /*return SizedBox(
      width: screenWidth,
      height: screenWidth * adAspectRatioMedium,
      child: AdWidget(ad: _nativeAd!),
    );*/

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 320,
        minHeight: 320,
        maxWidth: screenWidth,
        maxHeight: screenWidth,
      ),
      child: AdWidget(ad: _nativeAd!),
    );

    /*return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 320, // minimum recommended width
        minHeight: 320, // minimum recommended height
        maxWidth: 400,
        maxHeight: 400,
      ),
      child: AdWidget(ad: _nativeAd!),
    );*/
  }
}
