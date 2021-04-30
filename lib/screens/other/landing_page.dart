import 'package:flutter/material.dart';
import 'file:///C:/ornekler/flutter_biasansor/lib/screens/loading_page.dart';
import 'package:flutter_biasansor/screens/auth_pages/sign_in_page.dart';
import 'package:flutter_biasansor/screens/tab_page.dart';
import 'package:flutter_biasansor/viewmodel/viewmodel.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<ViewModel>(context, listen: true);
    if (_viewModel.state == ViewState.Idle) {
      if (_viewModel.user == null) {
        return SignInPage();
      } else {
        return TabPage();
      }
    } else {
      return LoadingPage();
    }
  }
}
