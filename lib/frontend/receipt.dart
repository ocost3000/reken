//         child: DataTable(
//           columns: const <DataColumn>[
//             DataColumn(label: Text("Name")),
//             DataColumn(label: Text("Item")),
//             DataColumn(label: Text("Price")),
//             DataColumn(label: Text(""))
//           ],
//           rows: const <DataRow>[
//             DataRow(cells: <DataCell>[
//               DataCellf
//             ])
//           ],
//         ),

import 'package:flutter/material.dart';

class Receipt extends StatelessWidget {
  const Receipt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
      ),
      body: const Text("TEST"),
    );
  }
}
