import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeatherEvent {
  String key;
  String subject;
  bool completed;
  String userId;

  WeatherEvent(this.subject, this.userId, this.completed);

  WeatherEvent.fromSnapshot(DocumentSnapshot snapshot) :
        key = snapshot["key"],
        userId = snapshot["userId"],
        subject = snapshot["subject"],
        completed = snapshot["completed"];

  toJson() {
    return {
      "userId": userId,
      "subject": subject,
      "completed": completed,
    };
  }
}