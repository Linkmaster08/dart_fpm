library dart_fpm.fcgi.records.name_value_body;

import 'package:dart_fpm/src/fcgi/fcgi.dart';
import 'package:dart_fpm/src/bytereader.dart';
import 'package:dart_fpm/src/bytewriter.dart';
import 'dart:convert';

class FcgiNameValuePairBody extends FcgiRecordBody {

  final FcgiRecordType type;
  final List<FcgiNameValuePair> _entries;
  final int contentLength;

  FcgiNameValuePairBody._(this.type, List<FcgiNameValuePair> entries) :
        _entries = entries,
        contentLength = entries.map((entry) => entry.contentLength)
            .fold(0, (l1, l2) => l1 + l2);

  factory FcgiNameValuePairBody.fromByteStream (FcgiRecordHeader header, ByteReader bytes) {
    List<FcgiNameValuePair> entries = new List();
    int length = 0;
    while (length < header.contentLength) {
      var entry = new FcgiNameValuePair.fromByteStream(bytes);
      entries.add(entry);
      length += entry.contentLength;
    }
    return new FcgiNameValuePairBody._(header.type, entries);
  }

  @override
  List<int> toByteStream() {
    ByteWriter bytes = new ByteWriter();
    _entries.forEach((entry) => bytes.addBytes(entry.toByteStream()));
    return bytes.takeBytes();
  }

  factory FcgiNameValuePairBody.fromMap (FcgiRecordType type, Map<String,
      String> map, {Codec<String, List<int>> codec : UTF8}) {
    List<FcgiNameValuePair> entries = new List();
    map.forEach((key, value) {
      entries.add(new FcgiNameValuePair(codec.encode(key), codec.encode(value)));
    });
    return new FcgiNameValuePairBody._(type, entries);
  }

  Map<String, String> toMap ({Codec<String, List<int>> codec : UTF8}) {
    Map<String, String> map = new Map();
    _entries.forEach((entry) {
      map[codec.decode(entry.name)] = codec.decode(entry.value);
    });
    return map;
  }

}