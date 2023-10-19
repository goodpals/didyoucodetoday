import 'package:didyoucodetoday/app/locator.dart';
import 'package:didyoucodetoday/controllers/auth_controller.dart';
import 'package:didyoucodetoday/controllers/user_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Card(
          child: BlocBuilder<AuthController, AppAuthState>(
            builder: (context, authState) {
              return BlocBuilder<UserDataController, UserDataMap>(
                builder: (context, ud) {
                  final ourData = ud[authState.user?.id];
                  final bool codedToday =
                      authState.complete && (ourData?.codedToday ?? false);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Did You Code Today?',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        if (authState.complete) ...[
                          _TodayStatusText(codedToday),
                          Text(
                            'Streak: ${ourData?.streak ?? 0}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          if (!codedToday) const _LogTodayButton(),
                        ],
                        const SizedBox(height: 16),
                        if (authState.profile != null)
                          Text(
                            'Logged in as ${authState.profile!.username}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        if (!authState.loggedIn)
                          ElevatedButton.icon(
                            onPressed: auth().loginGithub,
                            icon: const ImageIcon(
                              AssetImage('assets/images/github_black.png'),
                            ),
                            label: const Text('Log in with Github'),
                          ),
                        if (authState.loggedIn)
                          ElevatedButton.icon(
                            onPressed: auth().logout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Log out'),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TodayStatusText extends StatelessWidget {
  final bool coded;
  const _TodayStatusText(this.coded);

  @override
  Widget build(BuildContext context) => Text(coded ? 'Yes!' : 'Not yet...',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: coded ? Colors.green : Colors.red,
          ));
}

class _LogTodayButton extends StatefulWidget {
  const _LogTodayButton({super.key});

  @override
  State<_LogTodayButton> createState() => __LogTodayButtonState();
}

class __LogTodayButtonState extends State<_LogTodayButton> {
  bool working = false;

  void _onTap() {
    setState(() => working = true);
    userData().logToday();
  }

  @override
  Widget build(BuildContext context) {
    return working
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: _onTap,
            child: const Text('I DID!'),
          );
  }
}
