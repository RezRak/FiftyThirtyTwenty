import 'package:flutter/material.dart';
import 'main.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Initialization"),
      ),
      body: Center(

        child: Column(
  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Monthly Income"),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Income',
              )
            ),
            ElevatedButton(onPressed: onPressed, child: Text("Add")),

            Text("Essentials"),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              )
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              )
            ),
            ElevatedButton(onPressed: onPressed, child: Text("Add")),

            Text("Wants"),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              )
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              )
            ),
            ElevatedButton(onPressed: onPressed, child: Text("Add")),

            Text("Savings"),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              )
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              )
            ),
            ElevatedButton(onPressed: onPressed, child: Text("Add")),
            
          ],
      
        )
      
      
      
      
      //   ListView.builder(
        
        
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(recipes[index]['Name']!),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => DetailsScreen(recipe: recipes[index]),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}