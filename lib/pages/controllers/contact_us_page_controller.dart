import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/models/contact_us_model.dart';
enum CommunicationPreference { phone, email }
class ContactUsPageController extends GetxController {
  final _formKey = GlobalKey<FormState>();
  final RxBool _isSending = false.obs;
  final RxString _fName = ("").obs;
  final RxString _lName = ("").obs;
  final RxString _email = ("").obs;
  final RxString _phone = ("").obs;
  final RxString _message = ("").obs;
  final Rx<CommunicationPreference> _communicationPreference = (CommunicationPreference.email).obs;

  bool get isSending => _isSending.value;
  CommunicationPreference get communicationPreference => _communicationPreference.value;

  GlobalKey<FormState> get formKey => _formKey;

  void setFName(String fName) {
    _fName.value = fName;
  }

  void setLName(String lName) {
    _lName.value = lName;
  }

  void setEmail(String email) {
    _email.value = email;
  }

  void setPhone(String phone) {
    _phone.value = phone;
  }

  void setMessage(String message) {
    _message.value = message;
  }

  void setCommunicationPreference(CommunicationPreference pref) {
    _communicationPreference.value = pref;
  }


  String? validateFirstName(String? firstName) {
    if (_isValidateName(firstName)) {
      return null;
    }
    return "Enter a correct first name ...";
  }

  String? validateLastName(String? lastName) {
    if (_isValidateName(lastName)) {
      return null;
    }
    return "Enter a correct last name ...";
  }

  String? validateEmail(String? email) {
    if (email!.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(email)) {
      return "Enter a correct email ...";
    } else {
      return null;
    }
  }

  String? validatePhone(String? phone) {
    if (phone!.isEmpty) {
      //|| !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(phone)) {
      return "Enter a correct phone number ...";
    } else {
      return null;
    }
  }

  String? validateInquiry(String? inquiry) {
    if (inquiry!.isEmpty || inquiry.length < 10) {
      //|| !RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])[A-Za-z0-9]+$').hasMatch(message)) {
      return "Enter a correct reason ...";
    } else {
      return null;
    }
  }

  String? validateMassage(String? message) {
    if (message!.isEmpty || message.length < 10) {
      //|| !RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])[A-Za-z0-9]+$').hasMatch(message)) {
      return "Enter a correct message";
    } else {
      return null;
    }
  }

  bool _isValidateName(String? name) {
    if (name!.isEmpty ||
        name.length < 3 ||
        !RegExp(r'^[a-z A-Z]+$').hasMatch(name)) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> send() async {
    _isSending.value = true;
    await Future<void>.delayed(const Duration(seconds: 4));
    if (formKey.currentState!.validate()) {
      final contactUs = ContactUsModel(_fName.value, _lName.value, _email.value, _phone.value, _message.value, _communicationPreference.value.name);
      print("contactUs ${contactUs.toString()}");
      formKey.currentState?.reset();
      setCommunicationPreference(CommunicationPreference.email);
      _isSending.value = false;
      return;
    } else {
      _isSending.value = false;
    }
  }
}
