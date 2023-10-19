import 'package:didyoucodetoday/controllers/auth_controller.dart';
import 'package:didyoucodetoday/controllers/user_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'locator.dart';

class BlocProviderGroup extends StatelessWidget {
  final Widget child;

  const BlocProviderGroup({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthController>(create: (_) => auth()),
        BlocProvider<UserDataController>(create: (_) => userData()),
      ],
      child: child,
    );
  }
}
