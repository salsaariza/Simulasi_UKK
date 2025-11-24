import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


Future<void> printSimpleInvoice(String text) async {
final doc = pw.Document();
doc.addPage(pw.Page(build: (context) => pw.Center(child: pw.Text(text))));
await Printing.layoutPdf(onLayout: (format) async => doc.save());
}