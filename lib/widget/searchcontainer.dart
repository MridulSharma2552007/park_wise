import 'package:flutter/material.dart';

class Searchcontainer extends StatelessWidget {
  const Searchcontainer({super.key});

  @override
  Widget build(BuildContext context) {
    return 
  
        Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.3),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                
                hint: Center(child: Text('Search')),
                border: InputBorder.none
              ),
            ),
          ),
        );
      
  }
}
