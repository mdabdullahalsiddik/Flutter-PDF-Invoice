import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:invoice_pdf/controller.dart';
import 'package:invoice_pdf/data.dart';
import 'package:invoice_pdf/monye.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final PaymentReceiptPdf controller = Get.put(PaymentReceiptPdf());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await controller.generateTwoReceipts(
                {
                  "mrNo": "12345", // Money receipt number
                  "date": "2024-12-22", // Date of receipt
                  "name": "Md. Abdullah Al Siddik", // Payer's name
                  "contact": "01737374083", // Payer's contact number
                  "caseId": "CASE1001", // Case ID (if applicable)
                  "caseType": "Civil", // Case type (if applicable)
                  "paymentMethod":
                      "Bkash", // Purpose of the payment
                  "amount": "5000.00", // Amount received
                },
              );
            },
            child: const Text("Click")),
      ),
    );
  }
}
