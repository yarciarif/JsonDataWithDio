import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_http/model/user_model.dart';

class RemoteAPI extends StatefulWidget {
  const RemoteAPI({super.key});

  @override
  State<RemoteAPI> createState() => _RemoteAPIState();
}

class _RemoteAPIState extends State<RemoteAPI> {
  Future<List<UserModel>> _tumUserlar() async {
    try {
      debugPrint('Future 5 saniyelik işlemi başlıyor');
      await Future.delayed(const Duration(seconds: 3), () {
        debugPrint('Future işlemi bitti!');
      });
      var response =
          await Dio().get('https://jsonplaceholder.typicode.com/users');
      List<UserModel> userList = [];
      if (response.statusCode == 200) {
        userList =
            (response.data as List).map((e) => UserModel.fromMap(e)).toList();
      }
      return userList;
    } on DioError catch (e) {
      return Future.error(e.message);
    }
  }
  //DART DATA CLASS GENERATOR EKLENECEK

  //FUTURE LAR BUILD CALISIRKEN YENI BIR METHOD TANIMLAYIP O FUTURE I BUILDIN ICINDE CAGIRMAK GEREKIYOR.

  late final Future<List<UserModel>> _userList;

  @override
  void initState() {
    super.initState();
    _userList = _tumUserlar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote API with Dio'),
      ),
      body: Center(
        child: FutureBuilder<List<UserModel>>(
          future: _userList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var userlar = snapshot.data!;
              return ListView.builder(
                itemCount: userlar.length,
                itemBuilder: (context, index) {
                  var user = userlar[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.company.toString()),
                    leading: CircleAvatar(child: Text(user.id.toString())),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
