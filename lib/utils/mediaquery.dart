import 'package:flutter/material.dart';

class MyMediaQuery {
  final BuildContext context;

  MyMediaQuery(this.context);

  bool get isMobileScreen => MediaQuery.of(context).size.width < 612;
  bool get isMediumScreen => MediaQuery.of(context).size.width < 1366;
  bool get isUltrawideScreen => MediaQuery.of(context).size.width < 2560;

  double get widthMaximized {
    if (isMobileScreen) {
      return 0.4;
    } else if (isMediumScreen) {
      return 0.2;
    } else if (isUltrawideScreen) {
      return 0.1;
    } else {
      return 0.1;
    }
  }

  double get width {
    return MediaQuery.of(context).size.width;
  }

  double get height {
    return MediaQuery.of(context).size.height;
  }
}
