import 'package:finobadivendor/app/setting/screen/myvehicle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'scrap_list_screen.dart';
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyVehicalScreen(),));
                },
                tileColor: Colors.green.shade200,
                leading: CircleAvatar(child: Icon(CupertinoIcons.car)),
                title: Text("My Vehicle"),
                subtitle: Text("Manage your Vehicle"),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ScrapListScreen(),));
                },
                tileColor: Colors.green.shade200,
                leading: CircleAvatar(child: Icon(Icons.list)),
                title: Text("Materials List"),
                subtitle: Text("Manage your scrap material list"),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            )
          ],
        ),
      ),
    );
  }
}