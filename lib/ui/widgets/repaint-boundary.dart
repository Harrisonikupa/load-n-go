import 'package:flutter/cupertino.dart';

class RepaintBoundaryW extends StatelessWidget {
  final Widget? customMarkerWidget;
  final markerKey = GlobalKey();
  RepaintBoundaryW({Key? key, this.customMarkerWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    markerKey.currentContext!.findRenderObject();
    return RepaintBoundary(child: customMarkerWidget);
  }
}
