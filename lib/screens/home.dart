import 'package:atom_cto_task/models/task.dart';
import 'package:atom_cto_task/screens/edit_task.dart';
import 'package:atom_cto_task/services/database_helper.dart';
import 'package:atom_cto_task/utils/colors.dart';
import 'package:atom_cto_task/utils/my_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  final dbHelper = DateBaseHelper();
  List<Task> _taskList = [];
  int selectedFilter = -1;

  void _addNewTaskCallback() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTask(
          callback: (task) async {
            await dbHelper.insert(task.toJson());
            _getAllData();
          },
        ),
      ),
    );
  }

  void _editCallback(task) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTask(
          task: task,
          callback: (task) async {
            await dbHelper.update(task.toJson());
            _getAllData();
          },
        ),
      ),
    );
  }

  void _deleteCallback(task) {
    Navigator.pop(context);
    dbHelper.delete(task.id!);
    _getAllData();
  }

  var filterRow = [
    {
      'value': -1,
      'title': 'All',
    },
    {
      'value': 0,
      'title': 'Pending',
    },
    {
      'value': 1,
      'title': 'Completed',
    },
  ];

  void _getAllData() async {
    setState(() {
      loading = true;
    });

    final allRows = await dbHelper.queryAllRows(
        status: selectedFilter, filterStatus: selectedFilter != -1);
    _taskList = [];
    for (final row in allRows) {
      _taskList.add(Task.fromJson(row));
    }

    setState(() {
      loading = false;
    });
  }

  void setup() async {
    await dbHelper.init();
    _getAllData();
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTaskCallback(),
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: filterRow
                  .map((item) => _radioTile(
                      value: item['value'],
                      title: item['title'],
                      selectedValue: selectedFilter,
                      onSelect: (value) {
                        setState(() {
                          selectedFilter = value;
                          _getAllData();
                        });
                      }))
                  .toList(),
            ),
            const SizedBox(height: 20),
            loading
                ? MyWidgets.customCircularProgressBar
                : _taskList.isEmpty
                    ? Container(
                        child: MyWidgets.getTextView(
                            title: "No Task found at this moment."),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _taskList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return itemTile(_taskList[index]);
                          },
                        ),
                      )
          ],
        ),
      ),
    );
  }

  Widget itemTile(Task task) {
    return GestureDetector(
      onTap: () => _taskDescription(task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(MyColors.mainBlack),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            task.isCompleted = !task.isCompleted;
                            await dbHelper.update(task.toJson());
                            _getAllData();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              color: task.isCompleted
                                  ? const Color(MyColors.mainGolder)
                                  : Colors.transparent,
                              border: Border.all(
                                width: 1,
                                color: const Color(MyColors.mainGolder),
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: task.isCompleted
                                ? const Center(
                                    child: Icon(
                                      Icons.done_outlined,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                                color: Color(MyColors.mainWhite)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                      child: const Icon(
                        CupertinoIcons.ellipsis_vertical,
                        color: Color(MyColors.mainGolder),
                      ),
                      itemBuilder: (context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: GestureDetector(
                                  onTap: () => _editCallback(task),
                                  child: MyWidgets.getTextView(title: 'Edit')),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: GestureDetector(
                                  onTap: () => _deleteCallback(task),
                                  child:
                                      MyWidgets.getTextView(title: 'Delete')),
                            )
                          ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _radioTile({var value, var title, var selectedValue, var onSelect}) {
    return GestureDetector(
      onTap: () {
        onSelect(value);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 1,
                  color: const Color(MyColors.mainGolder),
                ),
              ),
              child: value == selectedValue
                  ? Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(MyColors.mainGolder),
                        borderRadius: BorderRadius.circular(8.7),
                      ),
                    )
                  : const SizedBox(),
            ),
            const Padding(padding: EdgeInsets.only(right: 9)),
            MyWidgets.getTextView(
                title: title, color: const Color(MyColors.mainBlack), size: 14),
          ],
        ),
      ),
    );
  }

  _taskDescription(Task task) {
    var due_date = DateFormat('dd-MM-yyy').format(task.dueDate);
    showModalBottomSheet(
        backgroundColor: const Color(MyColors.mainBlack),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) {
          return Container(
            // height: 300,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyWidgets.getTextView(
                        title: task.title,
                        color: const Color(MyColors.mainGolder),
                        size: 22,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 20),
                    MyWidgets.getTextView(
                        title: task.description,
                        color: const Color(MyColors.mainWhite),
                        size: 18,
                        fontWeight: FontWeight.w400),
                    const SizedBox(height: 10),
                    MyWidgets.getTextView(
                      title: due_date,
                      color: Colors.grey,
                      size: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              return Color(MyColors.bottomNavigationBarColor);
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.all(10.0),
                            ),
                          ),
                          onPressed: () => _editCallback(task),
                          child: MyWidgets.getTextView(
                            title: 'Edit',
                            color: Colors.greenAccent,
                          )),
                    ),
                    // const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              return Color(MyColors.bottomNavigationBarColor);
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.all(10.0),
                            ),
                          ),
                          onPressed: () => _deleteCallback(task),
                          child: MyWidgets.getTextView(
                            title: 'Delete',
                            color: Colors.redAccent,
                          )),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
