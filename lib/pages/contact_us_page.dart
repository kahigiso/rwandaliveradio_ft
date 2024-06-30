import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/pages/controllers/contact_us_page_controller.dart';
import '../widgets/app_bg.dart';
import '../widgets/input_text.dart';

class ContactUsPage extends StatelessWidget {
  final ContactUsPageController controller = Get.find();

  ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBg(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          elevation: 0,
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contact us",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      //"We will be happy to hear from you.",
                      "Thanks for your interest! To contact us, please use the form below or simply give us a call.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          //"We will be happy to hear from you.",
                          "+1 917-891-5209",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          //"We will be happy to hear from you.",
                          "info@rwandaliveradio.com",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: InputText(
                            labelText: "First name",
                            hintText: "Type your first name...",
                            prefixIcon: Icons.person_2_outlined,
                            onChanged: (firstName) =>
                                controller.setFName(firstName!),
                            validator: (firstName) =>
                                controller.validateFirstName(firstName),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: InputText(
                            labelText: "Last name",
                            hintText: "Type your last name...",
                            prefixIcon: Icons.person_2_outlined,
                            onChanged: (lastName) =>
                                controller.setLName(lastName!),
                            validator: (lastName) =>
                                controller.validateLastName(lastName),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: InputText(
                            labelText: "Email address",
                            hintText: "Type your email address...",
                            prefixIcon: Icons.email_outlined,
                            onChanged: (email) => controller.setEmail(email!),
                            validator: (email) =>
                                controller.validateEmail(email),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: InputText(
                            labelText: "Phone number",
                            hintText: "Type your  phone number...",
                            prefixIcon: Icons.phone_in_talk_outlined,
                            onChanged: (phone) => controller.setPhone(phone!),
                            validator: (phone) =>
                                controller.validatePhone(phone),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InputText(
                      labelText: "What is your inquiry about?",
                      hintText: "Type here what is is your inquiry about...",
                      prefixIcon: Icons.message,
                      onChanged: (phone) => controller.setPhone(phone!),
                      validator: (phone) => controller.validatePhone(phone),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InputText(
                      labelText: "Message",
                      hintText: "Type your  message here...",
                      maxLines: 6,
                      maxLength: 200,
                      onChanged: (message) => controller.setMessage(message!),
                      validator: (message) =>
                          controller.validateMassage(message),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'How would you like to be contacted?',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 14),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio<CommunicationPreference>(
                          value: CommunicationPreference.email,
                          groupValue: controller.communicationPreference,
                          activeColor: Theme.of(context).colorScheme.surface,
                          onChanged: (CommunicationPreference? value) {
                            controller.setCommunicationPreference(value!);
                          },
                        ),
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Radio<CommunicationPreference>(
                          value: CommunicationPreference.phone,
                          groupValue: controller.communicationPreference,
                          activeColor: Theme.of(context).colorScheme.surface,
                          onChanged: (CommunicationPreference? value) {
                            controller.setCommunicationPreference(value!);
                          },
                        ),
                        Text(
                          'Phone',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Send message",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 22),
                        ),
                        ClipOval(
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.withOpacity(0.2),
                            padding: const EdgeInsets.all(10),
                            child: MaterialButton(
                              onPressed: () => controller.send(),
                              color: Theme.of(context).colorScheme.surface,
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                              shape: const CircleBorder(),
                              child: (!controller.isSending)
                                  ? const Icon(
                                      Icons.arrow_forward,
                                      size: 30,
                                    )
                                  : const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
