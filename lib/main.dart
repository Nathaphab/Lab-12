import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contact_provider.dart';

void main() {
  runApp(
    // เรียกใช้งาน Provider ตั้งแต่เริ่มเปิดแอป
    ChangeNotifierProvider(
      create: (context) => ContactProvider()..fetchContacts(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ชุมชนอุ่นใจ',
      // --- ส่วนที่ปรับแต่งธีม (Theme) ของแอป ---
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // ธีมสีหลัก
          primary: const Color(0xFF00695C),
          secondary: Colors.deepOrangeAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00695C),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00695C),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // ฟังก์ชันแสดง Popup สำหรับเพิ่มข้อมูล
  void _showAddContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เพิ่มเบอร์ติดต่อ', style: TextStyle(color: Color(0xFF00695C), fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ/หน่วยงาน',
                  prefixIcon: Icon(Icons.business), // เพิ่มไอคอนหน้าช่องกรอก
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'เบอร์โทรศัพท์',
                  prefixIcon: Icon(Icons.phone), // เพิ่มไอคอนหน้าช่องกรอก
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00695C),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                  // สั่งให้ Provider บันทึกข้อมูล
                  Provider.of<ContactProvider>(context, listen: false)
                      .addContact(nameController.text, phoneController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // สีพื้นหลังแอป
      appBar: AppBar(
        title: const Text('สมุดโทรศัพท์ ชุมชนอุ่นใจ', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      // ส่วนแสดงผลรายการเบอร์โทร
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) {
          if (provider.contacts.isEmpty) {
            return const Center(child: Text('ยังไม่มีข้อมูลเบอร์โทรศัพท์', style: TextStyle(fontSize: 16, color: Colors.grey)));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 80), // เว้นที่ว่างด้านล่างไม่ให้ปุ่มทับการ์ด
            itemCount: provider.contacts.length,
            itemBuilder: (context, index) {
              final contact = provider.contacts[index];
              return Card(
                elevation: 2, // เงาของการ์ด
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // ขอบการ์ดโค้งมน
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  // --- ส่วนที่แก้ไขไอคอนรูปคน ---
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFE0F2F1), // สีพื้นหลังไอคอน (เขียวอ่อน)
                    child: Icon(Icons.contact_emergency, color: Color(0xFF00796B), size: 28), // ไอคอนติดต่อฉุกเฉิน
                  ),
                  title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text(contact.phone, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      // สั่งให้ Provider ลบข้อมูล
                      provider.removeContact(contact.id!);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      // ปุ่ม + มุมขวาล่าง
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}