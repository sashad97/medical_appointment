import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/app/booking_form/cubit/booking_form_cubit.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/enum.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/app/widget/generalButton.dart';
import 'package:health/app/widget/text_form.dart';
import 'package:health/utils/general_state/general_state.dart';
import 'package:health/utils/locator.dart';
import 'package:health/utils/mixins/ui_tool_mixin.dart';
import '../../widget/dropdown.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> with UIToolMixin {
  final formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String? purpose;
  TextEditingController purposeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingFormCubit, AppState>(
      bloc: locator<BookingFormCubit>(),
      listener: (context, state) {
        if (state.viewState.isLoading) {
          appPrint('loading');
          progressService.loadingDialog();
        } else if (state.viewState.isIdle) {
          appPrint('not loading');
          progressService.dialogComplete(response);
          navigationService.pop();
          showFlushBar(
              title: state.response!.title ?? "",
              message: state.response!.message ?? "",
              context: context);
        } else {
          appPrint('not loading');
          appPrint(state.response!.title!);
          appPrint(state.response!.message!);
          progressService.dialogComplete(response);
          progressService.showDialog(
              title: state.response!.title ?? "",
              description: state.response!.message ?? "");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
              onPressed: () {
                navigationService.pop();
              }),
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Book Appointment',
            textAlign: TextAlign.center,
            style: newTitletextStyle,
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20),
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownWidget(
                  hint: 'select priority',
                  selectedItem: context.read<BookingFormCubit>().importance,
                  items:
                      context.read<BookingFormCubit>().impt.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      context.read<BookingFormCubit>().importance = value;
                    });
                  }),
            ),
            customYMargin(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: Responsive.sizeboxheight(context)),
                      CustomTextFormField(
                        label: 'Purpose',
                        borderStyle: BorderStyle.solid,
                        textInputType: TextInputType.text,
                        controller: purposeController,
                        onChanged: (value) {
                          purpose = value;
                        },
                        validator: (_) {
                          if (_!.isEmpty) {
                            return 'fill purpose of visit';
                          } else {
                            return null;
                          }
                        },
                      )
                    ]),
              ),
            ),
            SizedBox(height: Responsive.sizeboxheight(context) * 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                child: Text('Submit',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (formKey.currentState!.validate()) {
                    if (context.read<BookingFormCubit>().importance != null &&
                        purpose != null) {
                      print(purpose);
                      context
                          .read<BookingFormCubit>()
                          .submitform(purpose: purpose!);
                    } else {
                      showFlushBar(
                          title: "error",
                          message: 'fill empty fields',
                          context: context);
                    }
                  }
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
