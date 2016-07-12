library dart_fpm.fcgi.records.begin_request_body;

import 'package:dart_fpm/src/fcgi/fcgi.dart';
import 'package:dart_fpm/src/fcgi/fcgi_const.dart';
import 'package:dart_fpm/src/bytereader.dart';

class FcgiBeginRequestBody extends FcgiRecordBody {

  final FcgiRequestRole role;
  final int flags;

  FcgiBeginRequestBody._(this.role, this.flags);

  bool get keepAlive => flags & FCGI_KEEP_CONN != 0;

  factory FcgiBeginRequestBody.fromByteStream (ByteReader bytes) {
    FcgiBeginRequestBody body = new FcgiBeginRequestBody._(
        new FcgiRequestRole.fromValue(bytes.nextShort),
        bytes.nextByte);
    bytes.skip(5);
    return body;
  }

  @override
  FcgiRecordType get type => FcgiRecordType.BEGIN_REQUEST;
}