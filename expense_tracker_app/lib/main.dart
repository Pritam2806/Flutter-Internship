import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => ExpenseProvider(),  // The only provider of our app
    // Any widget inside the expense Tracker App can access the Expense data
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black),
            bodySmall: TextStyle(color: Colors.black87),
          ),
          segmentedButtonTheme: SegmentedButtonThemeData(
            style: ButtonStyle(
              side: WidgetStateProperty.all(
                const BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

