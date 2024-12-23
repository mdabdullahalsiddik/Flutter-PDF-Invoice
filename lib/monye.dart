import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as https;

class PaymentReceiptPdf extends GetxController {
  // Method to generate two receipts
  Future<void> generateTwoReceipts(Map<String, dynamic> receiptData) async {
    final PdfDocument document = PdfDocument();
    document.pageSettings.setMargins(10, 10, 10, 10);

    final PdfPage page = document.pages.add();
    final PdfGraphics graphics = page.graphics;
    final Size pageSize =
        Size(page.getClientSize().width, page.getClientSize().height);

    final PdfFont headerFont =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final PdfFont subHeaderFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final PdfFont titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
    final PdfFont fieldFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final PdfFont footerFont =
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.italic);
    final PdfFont signatureFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    await _drawProfileImage(page);
    // Draw the first receipt
    double yPosition = 0;
    _drawReceipt(graphics, pageSize, yPosition, receiptData, headerFont,
        subHeaderFont, titleFont, fieldFont, footerFont, signatureFont);

    // Draw the second receipt below the first
    // yPosition += pageSize.height / 2;
    // _drawReceipt(graphics, pageSize, yPosition, receiptData, headerFont,
    //     subHeaderFont, titleFont, fieldFont, footerFont, signatureFont);

    final List<int> bytes = await document.save();
    document.dispose();

    if (kIsWeb) {
      _saveAndOpenWeb(bytes, 'MoneyReceipt.pdf');
    } else {
      _saveAndOpenMobile(bytes, 'MoneyReceipt.pdf');
    }
  }

  Future<double> _drawProfileImage(
    PdfPage page,
  ) async {
    const String imageUrl = 'assets/logo.png';
    final ByteData data = await rootBundle.load(imageUrl);
    final Uint8List bytes = data.buffer.asUint8List();

    final PdfBitmap image = PdfBitmap(bytes);
    page.graphics.drawImage(image, const Rect.fromLTWH(0, 0, 80, 80));

    return 0;
    // const String imageUrl =
    //     'https://img.icons8.com/?size=100&id=64717&format=png&color=000000';
    // final response = await https.get(Uri.parse(imageUrl));
    // if (response.statusCode == 200) {
    //   final PdfBitmap image = PdfBitmap(response.bodyBytes);
    //   page.graphics.drawImage(image, const Rect.fromLTWH(0, 0, 80, 80));
    // }
    // return 0;
  }
}

// Method to draw each receipt
void _drawReceipt(
  PdfGraphics graphics,
  Size pageSize,
  double yOffset,
  Map<String, dynamic> receiptData,
  PdfFont headerFont,
  PdfFont subHeaderFont,
  PdfFont titleFont,
  PdfFont fieldFont,
  PdfFont footerFont,
  PdfFont signatureFont,
) {
  graphics.drawString(
    'MONEY RECEIPT',
    titleFont,
    bounds: const Rect.fromLTWH(50, 40, 300, 30),
    format: PdfStringFormat(alignment: PdfTextAlignment.right),
  );
  graphics.drawString(
    'Advocate Office',
    headerFont,
    bounds: Rect.fromLTWH(pageSize.width - 300, yOffset, 300, 20),
    format: PdfStringFormat(alignment: PdfTextAlignment.right),
  );

  graphics.drawString(
    'Email: info@classicit.com',
    subHeaderFont,
    bounds: Rect.fromLTWH(pageSize.width - 300, yOffset + 20, 300, 20),
    format: PdfStringFormat(alignment: PdfTextAlignment.right),
  );
  graphics.drawString(
    'Contact: 01737374083',
    subHeaderFont,
    bounds: Rect.fromLTWH(pageSize.width - 300, yOffset + 40, 300, 20),
    format: PdfStringFormat(alignment: PdfTextAlignment.right),
  );

  double yPosition = yOffset + 110;
  const double lineSpacing = 30;

  // Draw fields using the helper function
  _drawMrNoField(graphics, pageSize, yPosition, receiptData["mrNo"], headerFont,
      fieldFont);

  _drawDateField(graphics, pageSize, yPosition, receiptData["date"], headerFont,
      fieldFont);
  yPosition += lineSpacing;

  _drawNameField(graphics, pageSize, yPosition, receiptData["name"], headerFont,
      fieldFont);

  _drawContactField(graphics, pageSize, yPosition, receiptData["contact"],
      headerFont, fieldFont);
  yPosition += lineSpacing;

  _drawCaseIDField(graphics, pageSize, yPosition, receiptData["caseId"],
      headerFont, fieldFont);

  _drawCaseTypeField(graphics, pageSize, yPosition, receiptData["caseType"],
      headerFont, fieldFont);

  _drawAmountField(graphics, pageSize, yPosition, receiptData["amount"],
      headerFont, fieldFont);
  yPosition += lineSpacing;

  _drawPaymentMethodField(graphics, pageSize, yPosition,
      receiptData["paymentMethod"], headerFont, fieldFont);
  yPosition += lineSpacing * 2;

  graphics.drawString(
    'visit us: www.classicit.com',
    signatureFont,
    bounds: Rect.fromLTWH(
        0, yOffset + pageSize.height / 2 - 120, pageSize.width / 2 - 20, 20),
  );

  graphics.drawString(
    'Authorized Signature',
    signatureFont,
    bounds: Rect.fromLTWH(pageSize.width - 150,
        yOffset + pageSize.height / 2 - 120, pageSize.width / 2 - 20, 20),
  );
  // Line for Client Signature
  graphics.drawLine(
    PdfPen(PdfColor(0, 0, 0), width: 1),
    Offset(pageSize.width - 20, yOffset + pageSize.height / 2 - 120),
    Offset(400, yOffset + pageSize.height / 2 - 120),
  );
}

// Helper function to draw  field with an underline

void _drawMrNoField(
  PdfGraphics graphics,
  Size pageSize,
  double yPosition,
  String mrNo,
  PdfFont fieldFont,
  PdfFont titleFont,
) {
  graphics.drawString(
    'MR No :',
    titleFont,
    bounds: Rect.fromLTWH(0, yPosition, 50, 20),
  );

  graphics.drawString(
    mrNo,
    fieldFont,
    bounds: Rect.fromLTWH(50, yPosition, 100, 20),
  );
}

void _drawDateField(
  PdfGraphics graphics,
  Size pageSize,
  double yPosition,
  String date,
  PdfFont fieldFont,
  PdfFont titleFont,
) {
  graphics.drawString(
    'Date :',
    titleFont,
    bounds: Rect.fromLTWH(pageSize.width - 130, yPosition, 50, 20),
  );

  graphics.drawString(
    date,
    fieldFont,
    bounds: Rect.fromLTWH(pageSize.width - 100, yPosition, 300, 20),
  );
}

void _drawNameField(
  PdfGraphics graphics,
  Size pageSize,
  double yPosition,
  String name,
  PdfFont fieldFont,
  PdfFont titleFont,
) {
  graphics.drawString(
    'Received payment with thanks from',
    titleFont,
    bounds: Rect.fromLTWH(0, yPosition, 150, 20),
  );

  graphics.drawString(
    name,
    fieldFont,
    bounds: Rect.fromLTWH(155, yPosition - 3, 300, 20),
  );

  graphics.drawLine(
    PdfPen(PdfColor(128, 128, 128)),
    Offset(150, yPosition + 12),
    Offset(pageSize.width - 180, yPosition + 12),
  );
}

void _drawContactField(
  PdfGraphics graphics,
  Size pageSize,
  double yPosition,
  String contact,
  PdfFont fieldFont,
  PdfFont titleFont,
) {
  graphics.drawString(
    ', Contact No',
    titleFont,
    bounds: Rect.fromLTWH(pageSize.width - 170, yPosition, 300, 20),
  );

  graphics.drawString(
    contact,
    fieldFont,
    bounds: Rect.fromLTWH(pageSize.width - 105, yPosition - 3, 300, 20),
  );

  graphics.drawLine(
    PdfPen(PdfColor(128, 128, 128)),
    Offset(pageSize.width - 100, yPosition + 12),
    Offset(pageSize.width - 20, yPosition + 12),
  );
}

void _drawCaseIDField(
  PdfGraphics graphics,
  Size pageSize,
  double yPosition,
  String caseId,
  PdfFont fieldFont,
  PdfFont titleFont,
) {
  graphics.drawString(
    'Case ID:',
    titleFont,
    bounds: Rect.fromLTWH(0, yPosition, 50, 20),
  );

  graphics.drawString(
    caseId,
    fieldFont,
    bounds: Rect.fromLTWH(55, yPosition - 3, 300, 20),
  );

  graphics.drawLine(
    PdfPen(PdfColor(128, 128, 128)),
    Offset(50, yPosition + 12),
    Offset(130, yPosition + 12),
  );
}

void _drawCaseTypeField(
  PdfGraphics graphics,
  Size pageSize,
  double yPosition,
  String caseType,
  PdfFont fieldFont,
  PdfFont titleFont,
) {
  graphics.drawString(
    ', Case Type',
    titleFont,
    bounds: Rect.fromLTWH(140, yPosition, 300, 20),
  );

  graphics.drawString(
    caseType,
    fieldFont,
    bounds: Rect.fromLTWH(205, yPosition - 3, 300, 20),
  );

  graphics.drawLine(
    PdfPen(PdfColor(128, 128, 128)),
    Offset(200, yPosition + 12),
    Offset(350, yPosition + 12),
  );
}

void _drawAmountField(
  PdfGraphics graphics,
  Size pageSize,
  double yPosition,
  String amount,
  PdfFont fieldFont,
  PdfFont titleFont,
) {
  graphics.drawString(
    ', Amount of:',
    titleFont,
    bounds: Rect.fromLTWH(360, yPosition, 80, 20),
  );

  graphics.drawString(
    "$amount BDT",
    fieldFont,
    bounds: Rect.fromLTWH(pageSize.width - 150, yPosition - 3, 100, 20),
  );

  graphics.drawLine(
    PdfPen(PdfColor(128, 128, 128)),
    Offset(pageSize.width - 155, yPosition + 12),
    Offset(pageSize.width - 20, yPosition + 12),
  );
}

void _drawPaymentMethodField(
  PdfGraphics graphics,
  Size pageSize,
  double yPosition,
  String paymentMethod,
  PdfFont fieldFont,
  PdfFont titleFont,
) {
  graphics.drawString(
    'with',
    titleFont,
    bounds: Rect.fromLTWH(0, yPosition, 30, 20),
  );

  graphics.drawString(
    paymentMethod,
    fieldFont,
    bounds: Rect.fromLTWH(35, yPosition - 3, 100, 20),
  );

  graphics.drawLine(
    PdfPen(PdfColor(128, 128, 128)),
    Offset(30, yPosition + 12),
    Offset(130, yPosition + 12),
  );
}

// Web: Save and download the PDF file
Future<void> _saveAndOpenWeb(List<int> bytes, String fileName) async {
  final base64 = base64Encode(bytes);
  final html.AnchorElement anchor =
      html.AnchorElement(href: 'data:application/pdf;base64,$base64')
        ..setAttribute('download', fileName)
        ..click();
}

// Mobile: Save and open the PDF file
Future<void> _saveAndOpenMobile(List<int> bytes, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/$fileName');
  await file.writeAsBytes(bytes);
  OpenFile.open(file.path);
}
