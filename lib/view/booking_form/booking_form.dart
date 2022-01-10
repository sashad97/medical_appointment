import 'package:flutter/material.dart';
import 'package:health/utils/constants/colors.dart';
import 'package:health/utils/constants/helpers.dart';
import 'package:health/utils/constants/screensize.dart';
import 'package:health/utils/constants/textstyle.dart';
import 'package:health/view/widget/generalButton.dart';
import 'package:health/view/widget/text_form.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider_architecture/_viewmodel_provider.dart';
import '../widget/dropdown.dart';
import 'booking_form_vm.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String purpose;
  TextEditingController purposeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BookingFormVm>.withConsumer(
        viewModelBuilder: () => BookingFormVm(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
                  onPressed: () {
                    model.pop();
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
                      selectedItem: model.importance,
                      items: model.impt.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        model.importance = value;
                      }),
                ),
                customYMargin(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              if (_.isEmpty) {
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
                      if (formKey.currentState.validate()) {
                        if (model.importance != null && purpose != null) {
                          print(purpose);
                          model.submitform(purpose, context);
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
          );
        });
  }
}
