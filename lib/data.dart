import 'package:invoice_pdf/payment_invoice.dart';

var paymentSummaryList = PaymentSummaryWithDetails(
  invoiceNo: 'INV123',
  date: '2024-12-21',
  clientId: 'CL001',
  clientName: 'Md Abdullah Al Siddik',
  clientPhone: '123-456-7890',
  clientType: 'Regular',
  totalAmount: '1000.00',
  paymentDetails: [
    PaymentDetails(
   
      dateTime: '2024-12-22 10:00 AM',
      paidAmount: '500.00',
      dueAmount: '500.00',
      paymentMethod: 'Credit Card',
    ),
    PaymentDetails(
    
      dateTime: '2024-12-23 03:00 PM',
      paidAmount: '500.00',
      dueAmount: '0.00',
      paymentMethod: 'Debit Card',
    ),
  ],
);
