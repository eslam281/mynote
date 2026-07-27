import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/note_model.dart';

class PdfService {
  static Future<void> exportNote(NoteModel note) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(note.title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Category: ${note.category ?? "None"}', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text(note.content, style: const pw.TextStyle(fontSize: 14)),
              if (note.attachments.isNotEmpty) ...[
                pw.SizedBox(height: 30),
                pw.Text('Attachments:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('${note.attachments.length} file(s) attached to this note in the app.'),
              ],
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
