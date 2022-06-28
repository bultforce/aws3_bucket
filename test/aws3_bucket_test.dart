import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aws3_bucket/aws3_bucket.dart';

void main() {
  const MethodChannel channel = MethodChannel('aws3_bucket');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Aws3Bucket.platformVersion, '42');
  });
}
