import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/chat_message_model.dart';
import '../../../../../service/api_url.dart';
import '../../../../../Utils/ToastMessage/custom_toast.dart';

class GroupChatController extends GetxController {
  final String groupId;
  
  GroupChatController({required this.groupId});

  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  var myUserId = ''.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
    fetchMessages();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchMessagesSilently();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    messageController.dispose();
    super.onClose();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataStr = prefs.getString('userData');
    if (userDataStr != null) {
      try {
        var userData = jsonDecode(userDataStr);
        myUserId.value = userData['_id'] ?? '';
      } catch (e) {
        // Handle error if needed
      }
    }
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        return;
      }

      var response = await http.get(
        Uri.parse(ApiUrl.groupMessagesUrl(groupId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          var messagesList = data['data'] as List;
          messages.value = messagesList.map((m) => ChatMessageModel.fromJson(m)).toList();
        }
      } else {
        var data = jsonDecode(response.body);
        CustomToast.showError("Error", data['message'] ?? "Failed to fetch messages");
      }
    } catch (e) {
      CustomToast.showError("Error", "Something went wrong while fetching messages");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchMessagesSilently() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) return;

      var response = await http.get(
        Uri.parse(ApiUrl.groupMessagesUrl(groupId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          var messagesList = data['data'] as List;
          messages.value = messagesList.map((m) => ChatMessageModel.fromJson(m)).toList();
        }
      }
    } catch (e) {
      // Ignore errors in silent fetch
    }
  }

  var isSending = false.obs;
  final messageController = TextEditingController();

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      isSending.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        CustomToast.showError("Error", "Authentication token not found");
        return;
      }

      var response = await http.post(
        Uri.parse(ApiUrl.groupMessagesUrl(groupId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "message": text,
          "messageType": "text"
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          messageController.clear();
          // Ideally, append the message from response to the list or re-fetch.
          // Re-fetching is safer because it ensures we have correct sender object format.
          await fetchMessages();
        }
      } else {
        var data = jsonDecode(response.body);
        CustomToast.showError("Error", data['message'] ?? "Failed to send message");
      }
    } catch (e) {
      CustomToast.showError("Error", "Something went wrong while sending message");
    } finally {
      isSending.value = false;
    }
  }
}
