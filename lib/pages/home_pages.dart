import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseapp/pages/add_pages.dart';
import 'package:firebaseapp/pages/details_pages.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

import '../service/Database_service.dart';
import '../widget/text_field_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseService databaseService=DatabaseService();
  Stream?emp;
  getData()async{
    emp=await databaseService.getData();
    setState(() {

    });
  }
  TextEditingController _nameController=TextEditingController();
  TextEditingController _titleController=TextEditingController();
  TextEditingController _desController=TextEditingController();


  TextEditingController _nameController1=TextEditingController();
  TextEditingController _titleController1=TextEditingController();
  TextEditingController _desController1=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _titleController.dispose();
    _desController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amber,
        title: Text("Todo App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: emp,
            builder: (context,AsyncSnapshot sn){


              return sn.hasData?
                  SizedBox(height: MediaQuery.of(context).size.height *0.9,
                  child: ListView.builder(
                      itemCount: sn.data.docs.length,
                      itemBuilder: (context,index){
                    DocumentSnapshot ds=sn.data.docs[index];

                    return  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>
                            DetailsPage(des: ds["des"], name: ds["name"], title: ds["title"])));
                      },
                      child: Container(

                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${ds["name"]}"),
                               Row(
                                 children: [
                                   IconButton(onPressed: (){
                                     _nameController1.text=ds["name"];
                                     _titleController1.text=ds["title"];
                                     _desController1.text=ds["des"];
                                     editEm(ds["id"]);
                                   }, icon: Icon(Icons.edit)),
                                   IconButton(onPressed: ()async{
                                     await   databaseService.delEm(ds["id"]);
                                   }, icon: Icon(Icons.delete))
                                 ],
                               )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                  ):Center(child: CircularProgressIndicator(color: Colors.black,),);


              Container();
            }),
      ),
    floatingActionButton: FloatingActionButton(onPressed: (){
      addEm();
    },child: Icon(Icons.add),),
    );
  }
  
  Future editEm(String id)=>
      showDialog(context: context, builder: (context)=>
      AlertDialog(
        content: Container(
          child: Column(

            children: [
              Text("Update Todo",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 20,),
              CustomField(controller: _nameController1, hintText: 'name',),
              SizedBox(height: 10,),
              CustomField(controller: _titleController1, hintText: 'Title',),
              SizedBox(height: 10,),
              CustomField(controller: _desController1, hintText: 'Description',),
              SizedBox(height: 10,),
              OutlinedButton(onPressed: ()async{
                Map<String,dynamic>data={
                  "name": _nameController1.text,
                  "title": _titleController1.text,
                  "id":id,
                  "des": _desController1.text,
                };
                await databaseService.updateEm(id, data);
                Navigator.pop(context);
              }, child: Text("Update"))
            ],
          ),
        ),
      ));
  Future addEm()=>
      showDialog(context: context, builder: (context)=>
      AlertDialog(
        content: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Text("Add Todo",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 20,),
              CustomField(controller: _nameController, hintText: 'name',),
              SizedBox(height: 10,),
              CustomField(controller: _titleController, hintText: 'Title',),
              SizedBox(height: 10,),
              CustomField(controller: _desController, hintText: 'description',),
              SizedBox(height: 10,),
              OutlinedButton(onPressed: ()async{
                String id =randomAlphaNumeric(10);

                Map<String,dynamic>data={
                  "name": _nameController.text,
                  "title":_titleController.text,
                  "des": _desController.text,
                  "id":id
                };
                if(_nameController.text.isNotEmpty && _desController.text.isNotEmpty && _titleController.text.isNotEmpty){
                  await   DatabaseService().addData(data, id).then((value) {
                    print("check ${value}");

                  });
                }else{
                  Fluttertoast.showToast(
                      msg: "Please complete all field",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );

                }

                Navigator.pop(context);
                _nameController.clear();
                _titleController.clear();
                _desController.clear();


              }, child: Text("Send"))
            ],
          ),
        ),
      ));
}
