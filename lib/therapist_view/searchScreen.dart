import 'package:flutter/material.dart';
import '../shared_widget/components/components.dart';
import '../therapist_view/YourPatients.dart';

import '../shared_widget/colors.dart';

class SearchScreen extends StatelessWidget {

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:  defaultText(
          text: 'Search',
          fontSize: 20.0,
          isBold: true,
          textColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: searchController,
              keyboardType: TextInputType.text,
              validator: (value){
                if(value == null ||value.isEmpty)
                  {
                    return 'Search must not be empty';
                  }
                return null;
              },
              onChanged: (value){

              },
              decoration:
              InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
