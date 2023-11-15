import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mvcreqres/models/base_model.dart';

@JsonSerializable()
@immutable
final class AuthResponseModel implements BaseModel<AuthResponseModel> {
  final int? id;
  final String? token;

  const AuthResponseModel({
    this.id,
    this.token,
  });


  @override
  AuthResponseModel fromJson(Map<String, dynamic> json) =>  AuthResponseModel(
    id: json['id'] as int?,
    token: json['token'] as String?,
  );


  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'token': token,
  };
}