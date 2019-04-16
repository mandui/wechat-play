import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

void main() {
  var bytes = utf8.encode("SOmething looooooooooooooger"); // data being hashed

  var digest = sha1.convert(bytes);

  // Digest as bytes: [136, 67, 215, 249, 36, 22, 33, 29, 233, 235, 185, 99, 255, 76, 226, 129, 37, 147, 40, 120]
  print("Digest as bytes: ${digest.bytes}");
  // Digest as hex string: 8843d7f92416211de9ebb963ff4ce28125932878
  print("Digest as hex string: $digest");
  // Digest as toString: 8843d7f92416211de9ebb963ff4ce28125932878
  print("Digest as hex string: ${digest.toString()}");
}