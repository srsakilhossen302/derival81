import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/create_group_controller.dart';
import '../controller/group_controller.dart';
import '../model/group_model.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CreateGroupController controller = Get.put(CreateGroupController());
    final GroupController groupController = Get.find<GroupController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 24.h),
          _buildStepper(controller),
          SizedBox(height: 24.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildBasicInfoForm(controller, groupController),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 50.h, 24.w, 24.h),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          center: Alignment(0.5, -0.6),
          radius: 1.2,
          colors: [
            Color(0xFF6773FF),
            Color(0xFF1A227F),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 8.w),
          Text(
            'Create Group',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(CreateGroupController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(
        children: [
          _buildStepCircle(1, controller),
          _buildStepLine(),
          _buildStepCircle(2, controller),
          _buildStepLine(),
          _buildStepCircle(3, controller),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, CreateGroupController controller) {
    return Obx(() {
      bool isCompleted = controller.currentStep.value > step;
      bool isActive = controller.currentStep.value == step;
      return Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: isActive || isCompleted ? const Color(0xFF1A227F) : const Color(0xFFE2E8F0),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$step',
            style: TextStyle(
              color: isActive || isCompleted ? Colors.white : const Color(0xFF94A3B8),
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildStepLine() {
    return Expanded(
      child: Container(
        height: 2.h,
        color: const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildBasicInfoForm(CreateGroupController controller, GroupController groupController) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 24.h),
          _buildTextField(
            label: 'Group Name',
            hint: 'e.g., Family Savings Circle',
            icon: Icons.groups_outlined,
            controller: controller.groupNameController,
          ),
          SizedBox(height: 24.h),
          _buildTextField(
            label: 'Description',
            hint: 'Describe the purpose of this group...',
            icon: Icons.description_outlined,
            controller: controller.descriptionController,
            maxLines: 4,
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Mock group creation logic
                if (controller.groupNameController.text.isNotEmpty) {
                  groupController.groups.add(
                    GroupModel(
                      id: DateTime.now().toString(),
                      name: controller.groupNameController.text,
                      status: 'Active',
                      membersCount: 1,
                      totalAmount: 0.0,
                    ),
                  );
                  Get.back(); // Return to previous screen
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A227F),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF475569),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF94A3B8)),
              hintText: hint,
              hintStyle: TextStyle(color: const Color(0xFF94A3B8), fontSize: 14.sp),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
        ),
      ],
    );
  }
}
