import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Coming Soon'),
      content: const Text('This feature is coming soon! Stay tuned.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

void showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ComingSoon();
    },
  );
}

// Contoh penggunaan di dalam widget lain:
// ...
// ElevatedButton(
//   onPressed: () {
//     showComingSoonDialog(context);
//   },
//   child: Text('Show Coming Soon Dialog'),
// ),
// ...
