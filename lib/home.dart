import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:invoice_pdf/controller.dart';
import 'package:invoice_pdf/data.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final PaymentInvoiceController controller =
      Get.put(PaymentInvoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await controller.generatePaymentInvoice(data: paymentSummaryList);
            },
            child: const Text("Click")),
      ),
    );
  }
}
