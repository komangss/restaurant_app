import 'dart:convert';

void main() {
  var s = '[{name: p}, {name: p2}]';
  List<dynamic> s2 = List<dynamic>.from(jsonDecode(s)); 
  print(jsonDecode(s));
}