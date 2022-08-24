import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketProvider extends ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketProvider() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io('http://10.0.2.2:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
