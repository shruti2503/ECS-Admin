// ignore_for_file: prefer_const_constructors

import 'package:ecsadmin/database/database.dart';
import 'package:ecsadmin/pages/home/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(database: MongoDatabase())..add(LoadStudentsEvent()),
      child: HomePageView(),
    );
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late DateTime _selectedDate = DateTime.now();
  final DatePickerController _controller = DatePickerController();

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => _controller.jumpToSelection());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle cellStyle = TextStyle(color: Colors.white);
    TextStyle rowHeaderStyle = TextStyle(color: Colors.greenAccent);

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF125252),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    //Appbar
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text(
                            "ECS Academy",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF6fddaf).withOpacity(0.9),
                            ),
                          ),
                        ),
                        Align(
                          widthFactor: 10,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            color: Color(0xFF6fddaf),
                            onPressed: () =>
                                Navigator.pushNamed(context, "/qr_page"),
                            icon: Icon(Icons.qr_code),
                          ),
                        ),
                      ],
                    ),
                    _addDateBar(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state.students.isEmpty) {
                    if (state.status == HomeStatus.loading) {
                      return CupertinoActivityIndicator();
                    } else if (state.status == HomeStatus.loaded) {
                      return SizedBox();
                    }
                  }

                  final students = state.students;

                  List<DataRow> myList = [];
                  late DataRow row;
                  for (var element in students) {
                    final attendenceList = element.attendance ?? [];
                    String? isPresent = attendenceList.firstWhere(
                      (date) =>
                          DateFormat("yyyy-MM-dd hh:mm:ss").parse(date) ==
                          DateTime(_selectedDate.year, _selectedDate.month,
                              _selectedDate.day),
                      orElse: () => "A",
                    );

                    row = DataRow(
                      cells: [
                        DataCell(Text(element.name, style: rowHeaderStyle)),
                        DataCell(Text(isPresent == "A" ? "A" : "P",
                            style: cellStyle)),
                      ],
                    );

                    myList.add(row);
                  }
                  if (students.isEmpty) {
                    return SizedBox();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          // Add rounded container
                          Container(
                            width: MediaQuery.of(context).size.width,
                            // set height 40
                            height: 40,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                                columnSpacing: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      20), // this only make bottom rounded and not top
                                  color: const Color(0xE61B1D1C),
                                ),
                                // set heading row height 60
                                headingRowHeight: 60,
                                headingRowColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                // ignore: prefer_const_literals_to_create_immutables
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    "Students",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xF2979797)),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  )),
                                  DataColumn(
                                    label: Text(
                                  "Attendence",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color(0xF2979797)),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                )),
                                ],
                                rows: myList),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: DatePicker(
        DateTime(
          DateTime.now().year,
        ),
        height: 80,
        width: 60,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.teal,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
        controller: _controller,
      ),
    );
  }
}
