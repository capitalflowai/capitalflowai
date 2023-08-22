import 'dart:convert';

import 'package:CapitalFlowAI/components/cfconstants.dart';
import 'package:CapitalFlowAI/components/cfquestion.dart';
import 'package:CapitalFlowAI/components/cfusermessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CFMidas extends StatefulWidget {
  const CFMidas({super.key});

  @override
  State<CFMidas> createState() => _CFMidasState();
}

class _CFMidasState extends State<CFMidas> {
  String query = "";
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  bool canScroll = false;
  List<List> messages = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        if (!scrollController.position.atEdge) {
          canScroll = true;
        } else {
          if (scrollController.position.pixels != 0) {
            canScroll = false;
          }
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    messageController.dispose();
  }

  void sendQuery() async {
    http.Response response = await http.post(
      Uri.http(CFConstants.cfServerURL, "/midasai"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': query}),
    );
    setState(() {
      messages.add([json.decode(response.body)['message'], false]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 45.0, bottom: 20.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pop();
                        },
                        child: const Icon(FeatherIcons.arrowLeft),
                      ),
                      const Spacer(),
                      const Icon(Icons.smart_toy_rounded),
                      const SizedBox(width: 10.0),
                      Text(
                        "Midas Ai",
                        style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                            fontSize: 25.0,
                            color: Color.fromARGB(255, 51, 105, 255),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 25.0),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 4.0,
                  color: Color.fromARGB(255, 236, 236, 236),
                ),
                messages.isEmpty
                    ? ListView(
                        padding: const EdgeInsets.only(top: 50.0),
                        shrinkWrap: true,
                        children: [
                          SvgPicture.asset("assets/financelogo.svg"),
                          const SizedBox(height: 10.0),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Learn Finance",
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17.0),
                              ),
                            ),
                          ),
                          Align(
                            child: GestureDetector(
                              onTap: () {
                                messageController.text =
                                    "Explain about mutual funds";
                              },
                              child: const CFQuestion(
                                  question: "Explain about mutual funds"),
                            ),
                          ),
                          Align(
                            child: GestureDetector(
                              onTap: () {
                                messageController.text =
                                    "How do I improve my credit score?";
                              },
                              child: const CFQuestion(
                                  question:
                                      "How do I improve my credit score?"),
                            ),
                          ),
                        ],
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final reversedIndex = messages.length - 1 - index;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: CFUserMessage(
                                    message: messages[reversedIndex][0],
                                    isSender: messages[reversedIndex][1]),
                              );
                            },
                          ),
                        ),
                      ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 50),
                child: canScroll
                    ? Padding(
                        padding: EdgeInsets.only(
                          left: 25.0,
                          right: 25.0,
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 100.0,
                        ),
                        child: FloatingActionButton(
                          elevation: 15,
                          mini: true,
                          shape: const CircleBorder(),
                          backgroundColor:
                              const Color.fromARGB(255, 199, 208, 255),
                          onPressed: () {
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.decelerate);
                          },
                          child: const Icon(FeatherIcons.chevronDown),
                        ),
                      )
                    : Container(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 30.0,
                ),
                padding:
                    const EdgeInsets.only(bottom: 5.0, left: 20.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 0),
                      spreadRadius: 3.0,
                      blurRadius: 7.5,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: TextField(
                  controller: messageController,
                  maxLines: null,
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 12.5),
                    isDense: true,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (messageController.text.trim().isNotEmpty) {
                          setState(() {
                            query = messageController.text;
                            messages.add([query, true]);
                            FocusScope.of(context).unfocus();
                            messageController.text = "";
                            sendQuery();
                          });
                        }
                      },
                      child: const Icon(
                        Icons.send_rounded,
                        size: 22.5,
                        color: Color.fromARGB(255, 26, 116, 206),
                      ),
                    ),
                    hintText: "Enter question",
                    enabledBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
