import 'package:band_name_app/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('ServerStatus: ${socketProvider.serverStatus}'),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketProvider.socket.emit('emitir-mensaje',
              {'nombre': 'Flutter', 'mensaje': 'hola desde flutter'});
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
