import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:invoice_pdf/payment_invoice.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PaymentInvoiceController extends GetxController {
  Map<String, String> paymentSummary = {};
  List<PaymentDetails> paymentDetails = [];

  Future<void> generatePaymentInvoice(
      {required PaymentSummaryWithDetails data}) async {
    // Summary Data
    paymentSummary = {
      'Invoice No': data.invoiceNo,
      'Date': data.date,
      'Client ID': data.clientId,
      'Client Name': data.clientName,
      'Client Phone': data.clientPhone,
      'Client Type': data.clientType,
      'Total Amount': data.totalAmount,
    };

    // Payment Details Data
    paymentDetails = data.paymentDetails;

    // Create PDF Document
    final PdfDocument document = PdfDocument();
    document.pageSettings.setMargins(20, 20, 20, 20);
    final PdfPage page = document.pages.add();

    final boldFont =
        PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);

    final regularFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final blackBrush = PdfBrushes.black;
    final grayBrush = PdfBrushes.gray;

    final tableHeaderColor = PdfColor(0, 43, 91);

    // Title
    page.graphics.drawString(
      "Advocate Office Management System",
      PdfStandardFont(PdfFontFamily.helvetica, 22),
      bounds: Rect.fromLTWH(0, 10, page.getClientSize().width, 30),
      brush: blackBrush,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );

    // Address
    page.graphics.drawString(
      "House- 482 (4'th Floor), Road- 03, Sector- 12, Uttara, Dhaka",
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(10, 40, page.getClientSize().width - 20, 30),
      brush: blackBrush,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );

    // Draw a horizontal line divider
    page.graphics.drawLine(
      PdfPen(PdfColor(169, 169, 169), width: 0.5),
      const Offset(10, 70),
      Offset(page.getClientSize().width - 10, 70),
    );

    // Page Title
    page.graphics.drawString(
      "Payment Invoice",
      boldFont,
      bounds: Rect.fromLTWH(0, 80, page.getClientSize().width, 30),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      ),
    );

    // Header Section
    double yOffset = 110;
    for (var entry in paymentSummary.entries) {
      page.graphics.drawString(
        "${entry.key}:",
        boldFont,
        bounds: Rect.fromLTWH(10, yOffset, 150, 20),
      );
      page.graphics.drawString(
        entry.value,
        regularFont,
        bounds: Rect.fromLTWH(160, yOffset, 300, 20),
      );
      yOffset += 20;
    }

    // Payment Details Table
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);
    grid.headers.add(1);

    final headerRow = grid.headers[0];
    headerRow.cells[0].value = "SL";
    headerRow.cells[1].value = "Date & Time";
    headerRow.cells[2].value = "Payment Method";
    headerRow.cells[3].value = "Paid Amount";
    headerRow.cells[4].value = "Due Amount";

    headerRow.style = PdfGridRowStyle(
      backgroundBrush: PdfSolidBrush(tableHeaderColor),
      textBrush: PdfBrushes.white,
      font: boldFont,
    );

    // Adjust column widths to make SL cell wider
    grid.columns[0].width = 50; // Set width for 'SL' column
    grid.columns[1].width = 120; // Set width for 'Date & Time' column
    grid.columns[2].width = 120; // Set width for 'Payment Method' column
    grid.columns[3].width = 120; // Set width for 'Paid Amount' column
    grid.columns[4].width = 120; // Set width for 'Due Amount' column

    for (var detail in paymentDetails) {
      final row = grid.rows.add();
      row.cells[0].value = grid.rows.count.toString();
      row.cells[1].value = detail.dateTime;
      row.cells[2].value = detail.paymentMethod;
      row.cells[3].value = detail.paidAmount;
      row.cells[4].value = detail.dueAmount;
    }

    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 5, right: 5, top: 5, bottom: 5),
      font: regularFont,
    );

    // Draw the grid
    yOffset += 20;
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(10, yOffset, page.getClientSize().width - 20, 0),
    );

    // Signature Section
    // Calculate new yOffset based on the number of rows
    double gridHeight = grid.rows.count * 30.0; // Approx height of each row
    yOffset += gridHeight + 100;
    page.graphics.drawString(
      "Client Signature",
      boldFont,
      bounds: Rect.fromLTWH(60, yOffset + 25, 200, 20),
      brush: blackBrush,
    );

    page.graphics.drawString(
      "Authorized Signature",
      boldFont,
      bounds: Rect.fromLTWH(
          page.getClientSize().width - 160, yOffset + 25, 200, 20),
      brush: blackBrush,
    );

    // Line for Authorized Signature
    page.graphics.drawLine(
      PdfPen(PdfColor(0, 0, 0), width: 1),
      Offset(10, yOffset + 20),
      Offset(200, yOffset + 20),
    );

    // Line for Client Signature
    page.graphics.drawLine(
      PdfPen(PdfColor(0, 0, 0), width: 1),
      Offset(page.getClientSize().width - 210, yOffset + 20),
      Offset(page.getClientSize().width - 10, yOffset + 20),
    );

    // Footer
    page.graphics.drawString(
      "Thank you for your payment!",
      boldFont,
      bounds: Rect.fromLTWH(
          0, PdfPageSize.a4.height - 80, page.getClientSize().width, 20),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      ),
    );

    page.graphics.drawString(
      "Developed by Classic IT      Visit us : www.classicit.com.bd",
      regularFont,
      bounds: Rect.fromLTWH(
          0, PdfPageSize.a4.height - 60, page.getClientSize().width, 20),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      ),
    );

    // Save the document
    final List<int> bytes = await document.save();
    document.dispose();

    // Save and open
    if (kIsWeb) {
      _saveAndOpenWeb(bytes, "PaymentInvoice.pdf");
    } else {
      _saveAndOpenMobile(bytes, "PaymentInvoice.pdf");
    }
  }

  Future<void> _saveAndOpenWeb(List<int> bytes, String fileName) async {
    final base64 = base64Encode(bytes);
    final anchor = html.AnchorElement(
      href: 'data:application/pdf;base64,$base64',
    )
      ..setAttribute('download', fileName)
      ..click();
  }

  Future<void> _saveAndOpenMobile(List<int> bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
  }
}
