class ProgressRequest {
  final String title;
  final String description;
  final String buttonTitle;
  final String cancelTitle;
  final void Function()? onpressed;

  ProgressRequest({
    this.title = '',
    this.description = '',
    this.buttonTitle = '',
    this.cancelTitle = '',
    this.onpressed,
  });
}

class ProgressResponse {
  final String fieldOne;
  final String fieldTwo;
  final bool confirmed;

  ProgressResponse({
    this.fieldOne = '',
    this.fieldTwo = '',
    this.confirmed = false,
  });
}
