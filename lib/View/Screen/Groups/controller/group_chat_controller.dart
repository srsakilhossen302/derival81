import 'dart:convert';
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

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
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
          // Reverse the list so the newest message is at the bottom (index 0 for reverse: true ListView)
          messages.value = messagesList.map((m) => ChatMessageModel.fromJson(m)).toList().reversed.toList();
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
}
