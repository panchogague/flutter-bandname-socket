import 'package:band_name_app/models/band.dart';
import 'package:band_name_app/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.socket.on('active-bands', (data) {
      bands = (data as List).map((e) => Band.fromMap(e)).toList();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    final socketProvider = Provider.of<SocketProvider>(context);
    socketProvider.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketProvider.serverStatus == ServerStatus.online
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : const Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: [
          _ShowGraph(bands),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (_, i) => _bandTile(bands[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) =>
          socketProvider.socket.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: const EdgeInsets.only(left: 8),
        color: Colors.red,
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delete Band',
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {
          socketProvider.socket.emit('vote-band', {'id': band.id});
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New band name'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () => addBandToList(textController.text),
            textColor: Colors.blue,
            elevation: 5,
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  addBandToList(String name) {
    if (name.length > 1) {
      final socketProvider =
          Provider.of<SocketProvider>(context, listen: false);
      socketProvider.socket.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }
}

class _ShowGraph extends StatelessWidget {
  const _ShowGraph(
    this.bands, {
    Key? key,
  }) : super(key: key);

  final List<Band> bands;

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {};

    for (var b in bands) {
      dataMap.putIfAbsent(b.name, () => b.votes.toDouble());
    }

    return SizedBox(
        width: double.infinity, height: 200, child: PieChart(dataMap: dataMap));
  }
}
