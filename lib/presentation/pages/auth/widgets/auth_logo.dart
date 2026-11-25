import 'package:ecommerce_app/core/constants/app_assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.width = 64});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AppAssets.logo, width: width, height: width * 1.05);
  }
}
