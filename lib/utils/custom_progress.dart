import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CustomProgress {
  static ProgressDialog pr;
  static intializeProgressDialoug(BuildContext context) {
    //For normal dialog
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
  }

  showPr() {
    if (pr != null) {
      pr.show();
    }
  }

  hidePr() {
    if (pr != null) {
      pr.hide();
    }
  }
}
