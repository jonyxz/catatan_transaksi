import 'package:flutter/material.dart';
import 'barang_data.dart';

void main() => runApp(CatatanTransaksiApp());

class CatatanTransaksiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TransaksiPage(),
    );
  }
}

class TransaksiPage extends StatefulWidget {
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final List<Map<String, dynamic>> _barang = barangData;
  int _totalBayar = 0;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var item in _barang) {
      item['jumlah'] = 0;
    }
    _controllers.addAll(_barang.map((_) => TextEditingController(text: '0')));
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _reset() {
    setState(() {
      for (var i = 0; i < _barang.length; i++) {
        _barang[i]['jumlah'] = 0;
        _controllers[i].text = '0';
      }
      _totalBayar = 0;
    });
  }

  void _cetakStruk() {
    setState(() {
      _totalBayar = 0;
      for (var item in _barang) {
        int subtotal = item['harga'] * item['jumlah'];
        _totalBayar += subtotal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catatan Transaksi Toko Komputer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _barang.length,
                itemBuilder: (context, index) {
                  final item = _barang[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Text(item['nama']),
                      subtitle: Text('Harga: Rp ${item['harga']}'),
                      trailing: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllers[index],
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              item['jumlah'] = int.tryParse(value) ?? 0;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Jumlah',
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Struk Pembelian'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _barang
                    .map((item) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item['nama']}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item['harga']} x ${item['jumlah']}'),
                                Text('Rp ${item['harga'] * item['jumlah']}'),
                              ],
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Total Bayar: Rp $_totalBayar',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _reset,
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _cetakStruk,
                  child: Text('Cetak Struk'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
