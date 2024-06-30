

class ContactUsModel {
  final String fName;
  final String lName;
  final String email;
  final String phone;
  final String message;
  final String communicationPreference;

  ContactUsModel(this.fName, this.lName, this.email, this.phone, this.message, this.communicationPreference);

  @override
  String toString() {
    return 'ContactUsModel{fName: $fName, lName: $lName, email: $email, phone: $phone, message: $message, communicationPreference: $communicationPreference}';
  }
}
