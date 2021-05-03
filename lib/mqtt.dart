import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_server_client.dart';
import 'post.dart';
import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

String titleBar         = 'MQTT';
String broker           = 'm15.cloudmqtt.com';
int port                = 1883;
String username         = '';
String passwd           = '';
String clientIdentifier = 'steevenm888';

mqtt.MqttClient client;
mqtt.MqttConnectionState connectionState;

StreamSubscription subscription;

void _connect() async {
  /// First create a client, the client is constructed with a broker name, client identifier
  /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
  /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
  /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
  /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
  /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
  /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
  /// of 1883 is used.
  /// If you want to use websockets rather than TCP see below.
  ///
  client = mqtt.MqttClient(broker, '');
  client.port = port;

  /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
  /// for details.
  /// To use websockets add the following lines -:
  /// client.useWebSocket = true;
  /// client.port = 80;  ( or whatever your WS port is)
  /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.

  /// Set logging on if needed, defaults to off
  client.logging(on: true);

  /// If you intend to use a keep alive value in your connect message that is not the default(60s)
  /// you must set it here
  client.keepAlivePeriod = 30;

  /// Add the unsolicited disconnection callback
  client.onDisconnected = _onDisconnected;

  /// Create a connection message to use or use the default one. The default one sets the
  /// client identifier, any supplied username/password, the default keepalive interval(60s)
  /// and clean session, an example of a specific one below.
  final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
      .withClientIdentifier(clientIdentifier)
  // Must agree with the keep alive set above or not set
      .startClean() // Non persistent session for testing
      .keepAliveFor(30)
  // If you set this you must set a will message
      .withWillTopic('test/test')
      .withWillMessage('lamhx message test')
      .withWillQos(mqtt.MqttQos.atMostOnce);
  print('MQTT client connecting....');
  client.connectionMessage = connMess;

  /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
  /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
  /// never send malformed messages.

  try {
    await client.connect(username, passwd);
  } catch (e) {
    print(e);
    _disconnect();
  }

  /// Check if we are connected
  if (client.connectionState == mqtt.MqttConnectionState.connected) {
    print('MQTT client connected');
//    setState(() {
//      connectionState = client.connectionState;
//    });
  } else {
    print('ERROR: MQTT client connection failed - '
        'disconnecting, state is ${client.connectionState}');
    _disconnect();
  }

  /// The client has a change notifier object(see the Observable class) which we then listen to to get
  /// notifications of published updates to each subscribed topic.
  subscription = client.updates.listen(_onMessage);
}

void _disconnect() {
  client.disconnect();
  _onDisconnected();
}

void _onDisconnected() {
//  setState(() {
//    topics.clear();
//    connectionState = client.connectionState;
//    client = null;
//    subscription.cancel();
//    subscription = null;
//  });
  print('MQTT client disconnected');
}

void _onMessage(List<mqtt.MqttReceivedMessage> event) {
  print(event.length);
  final mqtt.MqttPublishMessage recMess =
  event[0].payload as mqtt.MqttPublishMessage;
  final String message =
  mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

  /// The above may seem a little convoluted for users only interested in the
  /// payload, some users however may be interested in the received publish message,
  /// lets not constrain ourselves yet until the package has been in the wild
  /// for a while.
  /// The payload is a byte buffer, this will be specific to the topic
  print('MQTT message: topic is <${event[0].topic}>, '
      'payload is <-- ${message} -->');
  print(client.connectionState);
//  setState(() {
//    messages.add(Message(
//      topic: event[0].topic,
//      message: message,
//      qos: recMess.payload.header.qos,
//    ));
//    try {
//      messageController.animateTo(
//        0.0,
//        duration: Duration(milliseconds: 400),
//        curve: Curves.easeOut,
//      );
//    } catch (_) {
//      // ScrollController not attached to any scroll views.
//    }
//  });
}

void _subscribeToTopic(String topic) {
  if (connectionState == mqtt.MqttConnectionState.connected) {
//    setState(() {
//      if (topics.add(topic.trim())) {
//        print('Subscribing to ${topic.trim()}');
//        client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
//      }
//    });
  }
}

void _unsubscribeFromTopic(String topic) {
  if (connectionState == mqtt.MqttConnectionState.connected) {
//    setState(() {
//      if (topics.remove(topic.trim())) {
//        print('Unsubscribing from ${topic.trim()}');
//        client.unsubscribe(topic);
//      }
//    });
  }
}