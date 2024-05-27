import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:lista_de_compras/utils/model/user_model.dart';
import 'package:lista_de_compras/utils/pdf/save_document.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class GeneratePdfApi {
  static Future<File> generatePdfApi(
    String titlePdf,
    String itemName,
    String itemQtd,
    String itemPrice,
    String qtd,
    double totalPrice,
  ) async {
    final pdf = pw.Document();

    final imageBytes = await rootBundle.load('assets/icons/shopping-icon.png');
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());


    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Image(image, width: 42, height: 42),
                  pw.SizedBox(width: 12),
                  pw.Text(
                    'Compras',
                    style: pw.TextStyle(
                      fontSize: 26,
                      color: PdfColors.blueGrey,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 32),
              // Subtítulos
              pw.Text(
                'Histórico da lista: $titlePdf',
                style: const pw.TextStyle(fontSize: 20),
              ),
              pw.Text(
                DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                style: const pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.blueGrey400,
                ),
              ),
              pw.SizedBox(height: 32),
              // Valor total
              pw.Text(
                'R\$ ${totalPrice.toStringAsFixed(2)}',
                style: const pw.TextStyle(fontSize: 24),
              ),
              // Nome do usuário
              pw.SizedBox(height: 32),
              pw.Text(
                'Nome:',
                style: const pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.blueGrey400,
                ),
              ),
              pw.Text(
                '${UserModel.nameUserLogged} ${UserModel.lastNameUserLogged}',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.Divider(
                height: 42,
                color: PdfColors.blueGrey200,
              ),
              pw.Text(
                'Dados da lista:',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                pw.Text(
                  itemName,
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.Text(
                  itemQtd,
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.Text(
                  itemPrice,
                  style: const pw.TextStyle(fontSize: 16),
                ),
              ])
                ],
              ),
            ],
          ),
      );
    return SaveAndOpenDocument.savePdf(name: '$titlePdf.pdf', pdf: pdf);
  }
}
