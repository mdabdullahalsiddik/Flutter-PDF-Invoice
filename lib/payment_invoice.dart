class PaymentSummaryWithDetails {
  final String invoiceNo;
  final String date;
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String clientType;
  final String totalAmount;
  final List<PaymentDetails> paymentDetails;

  PaymentSummaryWithDetails({
    required this.invoiceNo,
    required this.date,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    required this.clientType,
    required this.totalAmount,
    required this.paymentDetails,
  });

  // Factory method to create a PaymentSummaryWithDetails from a map
  factory PaymentSummaryWithDetails.fromMap(Map<String, dynamic> map) {
    var paymentDetailsList = (map['Payment Details'] as List?)
        ?.map((item) => PaymentDetails.fromMap(item))
        .toList() ?? [];

    return PaymentSummaryWithDetails(
      invoiceNo: map['Invoice No'] ?? '',
      date: map['Date'] ?? '',
      clientId: map['Client ID'] ?? '',
      clientName: map['Client Name'] ?? '',
      clientPhone: map['Client Phone'] ?? '',
      clientType: map['Client Type'] ?? '',
      totalAmount: map['Total Amount'] ?? '',
      paymentDetails: paymentDetailsList,
    );
  }

  // Method to convert PaymentSummaryWithDetails to a map
  Map<String, dynamic> toMap() {
    return {
      'Invoice No': invoiceNo,
      'Date': date,
      'Client ID': clientId,
      'Client Name': clientName,
      'Client Phone': clientPhone,
      'Client Type': clientType,
      'Total Amount': totalAmount,
      'Payment Details': paymentDetails.map((item) => item.toMap()).toList(),
    };
  }
}

class PaymentDetails {

  final String dateTime;
  final String paidAmount;
  final String dueAmount;
  final String paymentMethod;

  PaymentDetails({
  
    required this.dateTime,
    required this.paidAmount,
    required this.dueAmount,
    required this.paymentMethod,
  });

  // Factory method to create PaymentDetails from a map
  factory PaymentDetails.fromMap(Map<String, dynamic> map) {
    return PaymentDetails(
      
      dateTime: map['DateTime'] ?? '',
      paidAmount: map['Paid Amount'] ?? '',
      dueAmount: map['Due Amount'] ?? '',
      paymentMethod: map['Payment Method'] ?? '',
    );
  }

  // Method to convert PaymentDetails to a map
  Map<String, dynamic> toMap() {
    return {
 
      'DateTime': dateTime,
      'Paid Amount': paidAmount,
      'Due Amount': dueAmount,
      'Payment Method': paymentMethod,
    };
  }
}
