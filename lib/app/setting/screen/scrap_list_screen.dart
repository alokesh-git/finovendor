import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finobadivendor/common/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/dialog.dart';
import '../../../provider/auth_provider.dart';

class ScrapListScreen extends StatefulWidget {
  const ScrapListScreen({super.key});

  @override
  State<ScrapListScreen> createState() => _ScrapListScreenState();
}

class _ScrapListScreenState extends State<ScrapListScreen> {
  List<QueryDocumentSnapshot> materialList = [];
  List<QueryDocumentSnapshot> materialUnitList = [];
  QueryDocumentSnapshot? snapUnitList;
  QueryDocumentSnapshot? snapList;
  TextEditingController _price = TextEditingController();
  List<Map> selectedMaterialList = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllMaterialList();
    getAllMaterialUnitList();

  }

  void getAllMaterialList()async{
   QuerySnapshot data = await FirebaseFirestore.instance.collection("ScrapList").get();
   materialList = data.docs;
   setState((){});
  }
  void getAllMaterialUnitList()async{
   QuerySnapshot data = await FirebaseFirestore.instance.collection("Unit").get();
   materialUnitList = data.docs;
   
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
      surfaceTintColor: Colors.white,
       backgroundColor: Colors.green.shade500,
       centerTitle: true,
        title: Text("Materials List",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 24),)
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
            width: size.width * 0.7,
            padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
               BoxShadow(
              offset: Offset(1,1 ),
              blurRadius: 2,
              color: Colors.black54,
              )
              ]    
            ),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(border: InputBorder.none),
                  hint: Text("Search Materials"),
                  items: materialList.map((e) => DropdownMenuItem(child: Text(e["ScrapName"]),value: e,)).toList(), onChanged: (val){
                              setState((){ snapList = val;});
                }),
                              ),
                              CircleAvatar(child: IconButton(icon:Icon(Icons.add),onPressed: (){
                                if(snapList != null){
                                  showDialog(barrierColor: Colors.transparent,barrierDismissible: false,context: context, builder: (context) => Center(
                                    child: Material(
                                      child: Container(
                                        width: size.width * 0.6,
                                        height: size.height * 0.45,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                           BoxShadow(
                                          offset: Offset(5, 5),
                                          blurRadius: 10,
                                          color: Colors.black54,
                                          )
                                          ]
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [Text(snapList!["ScrapName"]),IconButton(  icon:Icon(CupertinoIcons.clear),onPressed: (){Navigator.pop(context);},)],
                                          ),
                                          CircleAvatar(
                                            radius: 55,
                                            backgroundImage: NetworkImage(snapList!["Image"]),
                                          ),
                                      
                                          Card(
                                            
                                            child: TextField(
                                              controller: _price,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: "Prices",
                                                contentPadding: EdgeInsets.only(left: 18),
                                                border: InputBorder.none
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                                            child: DropdownButtonFormField(
                                                              decoration: InputDecoration(border: InputBorder.none),
                                                              hint: Text("Select Unit"),
                                                              items: materialUnitList.map((e) => DropdownMenuItem(child: Text(e["UnitName"]),value: e,)).toList(), onChanged: (val){
                                                                          setState((){ snapUnitList = val;});
                                                            }),
                                          ),
                                          ElevatedButton(onPressed: (){
                                            if(_price.text.trim().isEmpty || snapUnitList == null){
                                              snapUnitList == null?Notify.showNotify("PLease Select Unit"):Notify.showNotify("PLease type price");
                                            }else{
                                             Provider.of<AuthanticationProvider>(context,listen:false).saveMaterial({
                                              "Image": snapList!["Image"],
                                              "MaterialName": snapList!["ScrapName"],
                                              "Price":_price.text,
                                              "Unit":snapUnitList!["UnitName"]
                                             });
                                             snapList == null;
                                             snapUnitList = null;
                                             _price.clear();
                                             Navigator.pop(context);
                                             setState((){});
                                            }
                                          }, child: Text("Add"))
                                        ]),
                                      ),
                                    ),
                                  ),);
                                 
                                }else{
                                  Notify.showNotify("Please Select Material");
                                }
                              },))
              ],
            ),
            SizedBox(height:30),
        Expanded(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("venderMaster").doc(FirebaseAuth.instance.currentUser!.uid).collection("Materials").snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            
            return ListView.builder(itemCount: snapshot.data!.docs.length,itemBuilder: (context, index) =>  Card(
                clipBehavior: Clip.hardEdge,
                child: ListTile(
                  tileColor: Colors.green.shade50,
                  leading: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(snapshot.data!.docs[index]["Image"]),
                  ),
                  
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Text(snapshot.data!.docs[index]["MaterialName"])),
                        Chip(label: Text('${snapshot.data!.docs[index]["Price"]}/${snapshot.data!.docs[index]["Unit"]}'), ),

                    ],
                  ),
                  
                  trailing: Container(
                   padding: EdgeInsets.zero,
                   height: 25,
                   width: 20,
                     child: PopupMenuButton(
                       icon: Icon(Icons.more_vert),
                        padding: EdgeInsets.zero,
                                 itemBuilder: (BuildContext context) {
                                   return [
                                     PopupMenuItem(
                                       value: 'delete',
                                       child: Text('Delete'),
                                     ),
                                     PopupMenuItem(
                                       value: 'update',
                                       child: Text('Update'),
                                     ),
                                   ];
                                 },
                                 onSelected: (String value) {
                                   switch (value) {
                                     case 'delete':
                                       showDialogReuseable(context: context,title: "Delete",content: Text("Are you Sure ?"),yesText: "Delete",yesFunc: (){Provider.of<AuthanticationProvider>(context,listen: false).delteMaterial(snapshot.data!.docs[index].id);Navigator.pop(context);});
                                       break;
                                     case 'update':
                                     _price.text = snapshot.data!.docs[index]["Price"];
                                     snapUnitList = materialUnitList.singleWhere((ele) => ele["UnitName"] ==  snapshot.data!.docs[index]["Unit"]  ,);
                                      updateMaerial(snapshot.data!.docs[index]["MaterialName"],snapshot.data!.docs[index]["Image"],snapshot.data!.docs[index].id);
                                      
                                       break;
                                   }
                                 },
                               ),
                   ),
                ),
              ),);
          }
        ))
        ],
        ),
      ),
    );
  }

  void updateMaerial(String materialname,String image,String id){
      showDialog(barrierColor: Colors.transparent,barrierDismissible: false,context: context, builder: (context) => Center(
                                    child: Material(
                                      child: Container(
                                        width: 220,
                                        height:350,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                           BoxShadow(
                                          offset: Offset(5, 5),
                                          blurRadius: 10,
                                          color: Colors.black54,
                                          )
                                          ]
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [Text(materialname),IconButton(  icon:Icon(CupertinoIcons.clear),onPressed: (){ _price.clear();
                                     snapUnitList = null; Navigator.pop(context);},)],
                                          ),
                                          CircleAvatar(
                                            radius: 55,
                                            backgroundImage: NetworkImage(image),
                                          ),
                                      
                                          Card(
                                            
                                            child: TextField(
                                              controller: _price,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: "Prices",
                                                contentPadding: EdgeInsets.only(left: 18),
                                                border: InputBorder.none
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                                            child: DropdownButtonFormField(
                                              value: snapUnitList,
                                                              decoration: InputDecoration(border: InputBorder.none),
                                                              hint: Text("Select Unit"),
                                                              items: materialUnitList.map((e) => DropdownMenuItem(child: Text(e["UnitName"]),value: e,)).toList(), onChanged: (val){
                                                                          setState((){ snapUnitList = val;});
                                                            }),
                                          ),
                                          ElevatedButton(onPressed: (){
                                            if(_price.text.trim().isEmpty || snapUnitList == null){
                                              snapUnitList == null?Notify.showNotify("PLease Select Unit"):Notify.showNotify("PLease type price");
                                            }else{
                                             Provider.of<AuthanticationProvider>(context,listen:false).updateMaterial({
                                              "Image": image,
                                              "MaterialName": materialname,
                                              "Price":_price.text,
                                              "Unit":snapUnitList!["UnitName"]
                                             },id);
                                             snapUnitList = null;
                                             _price.clear();
                                             Navigator.pop(context);
                                             setState((){});
                                            }
                                          }, child: Text("Update"))
                                        ]),
                                      ),
                                    ),
                                  ),);
                               
  }
}