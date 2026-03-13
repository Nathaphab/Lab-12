import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'contact_model.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // ดึงข้อมูลทั้งหมดมาแสดง
  Future<void> fetchContacts() async {
    _contacts = await _dbHelper.getContacts();
    notifyListeners(); // แจ้งเตือนหน้าจอให้อัปเดตข้อมูล
  }

  // เพิ่มเบอร์โทรใหม่
  Future<void> addContact(String name, String phone) async {
    final newContact = Contact(name: name, phone: phone);
    await _dbHelper.insertContact(newContact);
    await fetchContacts(); // โหลดข้อมูลใหม่หลังจากเพิ่มเสร็จ
  }

  // ลบเบอร์โทร
  Future<void> removeContact(int id) async {
    await _dbHelper.deleteContact(id);
    await fetchContacts(); // โหลดข้อมูลใหม่หลังจากลบเสร็จ
  }
}