// ignore_for_file: use_build_context_synchronously, unused_import

import 'package:uitapp/screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uitapp/screens/auth_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String?> authenticateUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://26.100.34.245/login'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      return "";
    }
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:
            true, // Cho phép tự điều chỉnh kích thước khi bàn phím hiển thị
        body: Center(
          // Đảm bảo nội dung ở giữa màn hình
          child: SingleChildScrollView(
            // Sử dụng SingleChildScrollView để cho phép cuộn nếu cần
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.asset('assets/images/logo-uit.png')),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: widget.usernameController,
                      obscureText: false,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Username",
                          hintStyle: TextStyle(color: Colors.grey[500])),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: widget.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF262DE1)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey[500])),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                              activeColor: const Color(0xFF262DE1),
                            ),
                            const Text("Keep me logged in")
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: Color(0xFF262DE1)),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color(0xFF262DE1),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: InkWell(
                          onTap: () async {
                            var token = await widget.authenticateUser(
                                widget.usernameController.text,
                                widget.passwordController.text);
                            if (token!.isNotEmpty) {
                              AuthService().setToken(token);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Thông báo"),
                                    content: const Text(
                                        "Tài khoản và mật khẩu không chính xác"),
                                    actions: [
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: const Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
