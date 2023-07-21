import 'package:atom_cto_task/models/task.dart';
import 'package:atom_cto_task/utils/colors.dart';
import 'package:atom_cto_task/utils/my_widgets.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTask extends StatefulWidget {
  final Task? task;
  final Function callback;
  EditTask({this.task, required this.callback});
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime dueDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.task != null) {
      titleController.value = TextEditingValue(text: widget.task!.title);
      descriptionController.value =
          TextEditingValue(text: widget.task!.description);
      dueDate = widget.task!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(
            children: [
              CommonTextInputField(
                hint: 'Enter Title',
                controller: titleController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Title';
                  }
                },
              ),
              CommonTextInputField(
                hint: 'Enter Description',
                controller: descriptionController,
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Description';
                  }
                },
              ),
              _dueDate(),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(15.0),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('title: ${titleController.text}');
                    print('description: ${descriptionController.text}');
                    print('dueDate: ${dueDate}');
                    if (widget.task == null) {
                      Task task = Task(
                          title: titleController.text,
                          description: descriptionController.text,
                          dueDate: dueDate,
                          isCompleted: false);
                      widget.callback(task);
                    } else {
                      widget.task!.title = titleController.text;
                      widget.task!.description = descriptionController.text;
                      widget.task!.dueDate = dueDate;
                      widget.callback(widget.task);
                    }
                    Navigator.pop(context);
                  }
                },
                child: MyWidgets.getTextView(
                    title: 'Submit', color: const Color(MyColors.mainWhite)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CommonTextInputField({
    required String hint,
    required controller,
    required var validator,
    TextInputType textInputType = TextInputType.name,
    int maxLines = 1,
  }) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            keyboardType: textInputType,
            textInputAction: TextInputAction.next,
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(
                color: Color(0xff1D2545),
                fontSize: 14,
                fontWeight: FontWeight.w400),
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide:
                      const BorderSide(color: Color(MyColors.mainGolder))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide:
                      const BorderSide(color: Color(MyColors.mainGolder))),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide:
                      const BorderSide(color: Color(MyColors.mainGolder))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dueDate() {
    return DateTimeField(
      initialValue: widget.task == null ? DateTime.now() : widget.task!.dueDate,
      format: DateFormat('dd/MM/yyyy'),
      style: const TextStyle(
          color: Color(0xff1D2545), fontSize: 14, fontWeight: FontWeight.w400),
      onShowPicker: (context, currentValue) {
        final initialDate = widget.task != null
            ? widget.task!.dueDate.isAfter(DateTime.now())
                ? DateTime.now()
                : widget.task!.dueDate
            : DateTime.now();
        return showDatePicker(
          context: context,
          firstDate: initialDate,
          initialDate: currentValue ?? initialDate,
          lastDate: DateTime(DateTime.now().year + 13),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData(
                primarySwatch: MyColors.primaryBlack,
              ),
              child: child!,
            );
          },
        );
      },
      validator: (value) {
        if (value == null) {
          return 'Select due date';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Due Date',
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: Color(MyColors.mainGolder)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            color: Color(MyColors.mainGolder),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            color: Color(MyColors.mainGolder),
          ),
        ),
        suffixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      onChanged: (value) {
        if (value != null) {
          dueDate = value;
        }
      },
    );
  }
}
