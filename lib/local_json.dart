import 'dart:convert';

import 'package:flutter/material.dart';

import 'model/araba_model.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({super.key});

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  //FUTURE ILE ISLEM YAPARKEN BEKLETME SAGLAYABILIYORUZ ASYNC VE AWAIT ISLEMLERI ILE
  Future<List<Araba>> arabalarJsonOku() async {
    try {
      /* await Future.delayed(Duration(seconds: 5), () {
        return Future.error('5 SANİYE SONRA HATA ÇIKTI');
      }); */
      /* debugPrint('Future 5 saniyelik işlemi başlıyor');
      await Future.delayed(const Duration(seconds: 5), () {
        debugPrint('Future işlemi bitti!');
      }); */
      String okunanString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/arabalar.json');
      var jsonObject = jsonDecode(okunanString);
      /* print(okunanString);

    List arabaListesi = jsonObject;
    print(arabaListesi[0]['model'][1]['model_adi']); */

      List<Araba> tumArabalar = (jsonObject as List)
          .map((arabaMap) => Araba.fromMap(arabaMap))
          .toList();
      debugPrint(tumArabalar.length.toString());
      debugPrint(tumArabalar[1].model[1].modelAdi);

      return tumArabalar;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e.toString());
    }
  }

  String _title = 'JSON VERİLERİ';

  //OLUSTURDUGUMUZ FUTURE U BİR BUTONA BASTIGIMIZDA TEKRAR TEKRAR ÇALIŞTIRIP MEMORYİ MEŞGUL ETMEMEK ADINA FUTURE TİPİNDE BİR DEĞİŞKEN TANIMLAYIP BUNU OLUSTURDUGUMUZ ARABALARJSONOKU METHODUNUN YERİNE ÇAĞIRIYORUZ.

  late final Future<List<Araba>> listeyiDoldur;

  @override
  void initState() {
    super.initState();
    listeyiDoldur = arabalarJsonOku();
  }

  @override
  Widget build(BuildContext context) {
    /*arabalarJsonOku(); */
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _title = 'Burayı buton değiştirdi';
          });
        },
      ),
      body: FutureBuilder<List<Araba>>(
        future: listeyiDoldur,
        initialData: [
          Araba(
            arabaAdi: 'BMW',
            ulke: 'Almanya',
            kurulusYil: '1916',
            model: [
              Model(modelAdi: '3.30 Serisi', fiyat: '1', benzinli: true),
            ],
          ),
        ],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Araba> arabaListesi = snapshot.data!;
            return ListView.builder(
                itemCount: arabaListesi.length,
                itemBuilder: (context, index) {
                  Araba oankiAraba = arabaListesi[index];
                  return ListTile(
                      title: Text(oankiAraba.arabaAdi),
                      subtitle: Text(oankiAraba.model[0].modelAdi),
                      leading: CircleAvatar(
                        child: Text(
                          oankiAraba.ulke,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                      ));
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
