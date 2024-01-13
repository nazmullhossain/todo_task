import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
   DetailsPage({super.key,required this.des,required this.name,required this.title});
  String name;
  String title;
  String des;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Details"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child:  Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),

          ),
          child: Column(
            children: [
              Text("${name}",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,

              ),),
              Divider(),
              SizedBox(height: 10,),
              Text("${title}",style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,

              )),
              SizedBox(height: 10,),

              Text("${des}",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,

              )),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
