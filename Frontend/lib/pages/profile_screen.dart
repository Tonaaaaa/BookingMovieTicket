import 'dart:io';
import 'package:bookingmovieticket/controllers/auth_controller.dart';
import 'package:bookingmovieticket/controllers/profile_controller.dart';
import 'package:bookingmovieticket/utils/mytheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  File? _imageFile;

  final picker = ImagePicker();

  // Thêm biến theo dõi trạng thái thay đổi của thông tin
  String initialUsername = '';
  String initialPhone = '';

  bool isInfoChanged = false;

  @override
  void initState() {
    super.initState();
    Get.put(ProfileController());

    // Tải dữ liệu người dùng từ Firestore khi khởi tạo
    ProfileController.instance
        .loadUserData(AuthController.instance.user!.uid)
        .then((_) {
      setState(() {
        usernameController.text = ProfileController.instance.username.value;
        phoneController.text = ProfileController.instance.phone.value;
        initialUsername = usernameController.text;
        initialPhone = phoneController.text;
      });
    });

    // Lắng nghe sự thay đổi trên các TextEditingController
    usernameController.addListener(_checkInfoChanged);
    phoneController.addListener(_checkInfoChanged);
  }

  // Hàm kiểm tra xem thông tin có thay đổi hay không
  void _checkInfoChanged() {
    setState(() {
      isInfoChanged = (usernameController.text != initialUsername ||
          phoneController.text != initialPhone);
    });
  }

  // Hàm chọn ảnh từ thư viện hoặc máy ảnh
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Cập nhật ảnh đã chọn
      });
    }
  }

  // Lưu ảnh vào bộ nhớ cục bộ
  Future<void> _saveImageToLocal() async {
    if (_imageFile == null) {
      return;
    }
    try {
      final directory = await getApplicationDocumentsDirectory();
      String fileName = path.basename(_imageFile!.path);
      File localFile = File('${directory.path}/$fileName');

      // Lưu ảnh vào bộ nhớ cục bộ
      await _imageFile!.copy(localFile.path);

      // Cập nhật đường dẫn ảnh vào Firestore
      ProfileController.instance.updateAvatarUrl(localFile.path);
    } catch (e) {
      Get.snackbar("Error", "Failed to save image: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? email = AuthController.instance.user?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Avatar
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _imageFile == null
                      ? (ProfileController.instance.avatarUrl.value.isNotEmpty
                          ? FileImage(
                              File(ProfileController.instance.avatarUrl.value))
                          : NetworkImage(
                              AuthController.instance.user?.photoURL ??
                                  'https://www.example.com/default-avatar.png'))
                      : FileImage(_imageFile!) as ImageProvider,
                  child: _imageFile == null
                      ? Icon(Icons.camera_alt, color: Colors.white, size: 40)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Username
            const Text("Username",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Obx(() {
              return TextFormField(
                controller: usernameController,
                readOnly: !ProfileController.instance.isEdit.value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: MyTheme.primaryColor),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      ProfileController.instance.toggleEdit();
                    },
                    child: Icon(Icons.edit, color: MyTheme.primaryColor),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              );
            }),

            const SizedBox(height: 15),

            // Email (Chỉ hiển thị)
            const Text("Email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: TextEditingController()..text = email ?? "N/A",
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email, color: MyTheme.primaryColor),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),

            const SizedBox(height: 15),

            // Phone
            const Text("Phone",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Obx(() {
              return TextFormField(
                controller: phoneController,
                readOnly: !ProfileController.instance.isEdit.value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone, color: MyTheme.primaryColor),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      ProfileController.instance.toggleEdit();
                    },
                    child: Icon(Icons.edit, color: MyTheme.primaryColor),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              );
            }),

            const SizedBox(height: 30),

            // Nút Save Changes
            ElevatedButton.icon(
              onPressed: isInfoChanged
                  ? () {
                      if (ProfileController.instance.isEdit.value) {
                        String newUsername = usernameController.text;
                        String newPhone = phoneController.text;
                        ProfileController.instance.saveProfile(
                          AuthController.instance.user!.uid,
                          newUsername,
                          newPhone,
                        );
                      }
                      _saveImageToLocal();

                      // Hiển thị thông báo khi lưu thành công
                      Get.snackbar("Success", "Lưu thông tin thành công",
                          backgroundColor: Colors.green,
                          colorText: Colors.white);
                    }
                  : null, // Disable if no changes
              icon: Icon(Icons.save, color: Colors.white),
              label: Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nút Log Out
            ElevatedButton.icon(
              onPressed: () async {
                Get.dialog(
                  AlertDialog(
                    title: Text("Đăng xuất",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    content: Text("Bạn có muốn đăng xuất tài khoản?",
                        style: TextStyle(fontSize: 16)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Không",
                            style: TextStyle(
                                fontSize: 16, color: MyTheme.primaryColor)),
                      ),
                      TextButton(
                        onPressed: () async {
                          AuthController.instance.signOut();
                          Get.back();
                        },
                        child: Text("Có",
                            style: TextStyle(
                                fontSize: 16, color: MyTheme.redTextColor)),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              label: Text('Đăng xuất',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
