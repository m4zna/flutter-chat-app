// To parse this JSON data, do
//
//     final mensajesResponse = mensajesResponseFromJson(jsonString);

import 'dart:convert';

MensajesResponse mensajesResponseFromJson(String str) => MensajesResponse.fromJson(json.decode(str));

String mensajesResponseToJson(MensajesResponse data) => json.encode(data.toJson());

class MensajesResponse {
  bool ok;
  String miId;
  List<Mensaje> mensajes;

  MensajesResponse({
    required this.ok,
    required this.miId,
    required this.mensajes,
  });

  factory MensajesResponse.fromJson(Map<String, dynamic> json) => MensajesResponse(
    ok: json["ok"],
    miId: json["miId"],
    mensajes: List<Mensaje>.from(json["mensajes"].map((x) => Mensaje.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "miId": miId,
    "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
  };
}

class Mensaje {
  String de;
  String para;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;

  Mensaje({
    required this.de,
    required this.para,
    required this.mensaje,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
    de: json["de"],
    para: json["para"],
    mensaje: json["mensaje"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "de": de,
    "para": para,
    "mensaje": mensaje,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
