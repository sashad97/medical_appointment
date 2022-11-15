import 'package:equatable/equatable.dart';

abstract class ViewMoreInfoEvent extends Equatable {
  const ViewMoreInfoEvent();
  @override
  List<Object?> get props => [];
}

class GetWaitingTimeEvent extends ViewMoreInfoEvent {
  final bool isCritical;
  final String purpose;
  final String importance;
  final String documentId;

  const GetWaitingTimeEvent(
      {required this.isCritical,
      required this.purpose,
      required this.importance,
      required this.documentId});
}

class ConfirmArrivalEvent extends ViewMoreInfoEvent {
  final bool isCritical;
  final String documentId;
  final String date;
  final String arrivalStatus;

  const ConfirmArrivalEvent(
      {required this.isCritical,
      required this.documentId,
      required this.arrivalStatus,
      required this.date});
}
