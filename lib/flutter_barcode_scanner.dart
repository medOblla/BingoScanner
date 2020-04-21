import 'dart:async';
import 'package:flutter/services.dart';

enum ScanMode { QR, BARCODE, DEFAULT }

class FlutterBarcodeScanner {
  static const MethodChannel _channel =
      const MethodChannel('flutter_barcode_scanner');

  static const EventChannel _eventChannel =
      const EventChannel('flutter_barcode_scanner_receiver');

  static Stream _onBarcodeReceiver;

  static Future<String> scanBarcode(String lineColor, String cancelButtonText,
      bool isShowFlashIcon, ScanMode scanMode) async {
    if (null == cancelButtonText || cancelButtonText.isEmpty)
      cancelButtonText = "Cancel";

    if (scanMode == null) {
      scanMode = ScanMode.QR;
    }
    Map params = <String, dynamic>{
      "lineColor": lineColor,
      "cancelButtonText": cancelButtonText,
      "isShowFlashIcon": isShowFlashIcon,
      "isContinuousScan": false,
      "scanMode": scanMode.index
    };

    String barcodeResult = await _channel.invokeMethod('scanBarcode', params);
    if (null == barcodeResult) {
      barcodeResult = "";
    }
    return barcodeResult;
  }

  static Stream getBarcodeStreamReceiver(String lineColor,
      String cancelButtonText, bool isShowFlashIcon, ScanMode scanMode) {
    if (null == cancelButtonText || cancelButtonText.isEmpty)
      cancelButtonText = "Cancel";

    if (scanMode == null) {
      scanMode = ScanMode.QR;
    }

    Map params = <String, dynamic>{
      "lineColor": lineColor,
      "cancelButtonText": cancelButtonText,
      "isShowFlashIcon": isShowFlashIcon,
      "isContinuousScan": true,
      "scanMode": scanMode.index
    };

    _channel.invokeMethod('scanBarcode', params);
    if (_onBarcodeReceiver == null) {
      _onBarcodeReceiver = _eventChannel.receiveBroadcastStream();
    }
    return _onBarcodeReceiver;
  }
}
