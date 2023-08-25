import 'package:intl/intl.dart';

class CFServer {
  static double monthlyBudgetSlider(Map<String, dynamic> requestData) {
    double budget = requestData['budget'];

    DateTime now = DateTime.now();
    int currentMonth = now.month;

    List<dynamic> transactions = requestData['Payload'][0]['data'][0]
        ['decryptedFI']['account']['transactions']['transaction'];

    List<dynamic> currentMonthTransactions = transactions.where((transaction) {
      int transactionMonth = int.parse(
          transaction['transactionTimestamp'].substring(0, 10).split('-')[1]);
      return transactionMonth == currentMonth;
    }).toList();

    double percentageSpent =
        calculatePercentageSpent(currentMonthTransactions, budget);
    return percentageSpent;
  }

  static double calculatePercentageSpent(
      List<dynamic> transactions, double budget) {
    double totalSpent = transactions
        .where((transaction) => transaction['type'] == 'DEBIT')
        .map((transaction) => double.parse(transaction['amount']))
        .fold(0, (sum, amount) => sum + amount);

    double percentageSpent = (totalSpent / budget) * 100;
    return percentageSpent;
  }

  static Map<String, dynamic> modePieChart(Map<String, dynamic> requestData) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;

    List<dynamic> transactions = requestData['Payload'][0]['data'][0]
        ['decryptedFI']['account']['transactions']['transaction'];

    List<dynamic> currentMonthTransactions = transactions.where((transaction) {
      int transactionMonth = int.parse(
          transaction['transactionTimestamp'].substring(0, 10).split('-')[1]);
      return transactionMonth == currentMonth;
    }).toList();

    double totalMoneySpent = currentMonthTransactions
        .where((transaction) => transaction['type'] == 'DEBIT')
        .map((transaction) => double.parse(transaction['amount']))
        .fold(0, (sum, amount) => sum + amount);

    Map<String, double> modePercentages = {};
    List<String> modes = ["ATM", "FT", "CASH", "OTHER"];

    for (var mode in modes) {
      double modeMoneySpent =
          calculatePercentageByMode(currentMonthTransactions, mode);
      double modePercentage =
          ((modeMoneySpent / totalMoneySpent) * 100).roundToDouble();
      modePercentages[mode] = modePercentage;
    }

    return modePercentages;
  }

  static double calculatePercentageByMode(
      List<dynamic> transactions, String mode) {
    double modeMoneySpent = transactions
        .where((transaction) =>
            transaction['mode'] == mode && transaction['type'] == 'DEBIT')
        .map((transaction) => double.parse(transaction['amount']))
        .fold(0, (sum, amount) => sum + amount);

    return modeMoneySpent;
  }

  static Map<String, dynamic> lineGraph(Map<String, dynamic> requestData) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;

    List<dynamic> transactions = requestData['Payload'][0]['data'][0]
        ['decryptedFI']['account']['transactions']['transaction'];

    List<dynamic> currentMonthTransactions = transactions.where((transaction) {
      int transactionMonth = int.parse(
          transaction['transactionTimestamp'].substring(0, 10).split('-')[1]);
      return transactionMonth == currentMonth;
    }).toList();

    Map<String, double> expensesPerDay = {
      for (var day = 1; day <= 31; day++) day.toString().padLeft(2, '0'): 0.0
    };

    for (var transaction in currentMonthTransactions) {
      String transactionDate =
          transaction['transactionTimestamp'].substring(0, 10);
      if (transaction['type'] == 'DEBIT') {
        String dayStr = transactionDate.split('-')[2];
        expensesPerDay[dayStr] =
            expensesPerDay[dayStr]! + double.parse(transaction['amount']);
      }
    }

    return expensesPerDay;
  }

  static List<Map<String, dynamic>> findTop3Debits(Map<String, dynamic> data) {
    List<dynamic> transactions = data["Payload"][0]["data"][0]["decryptedFI"]
        ["account"]["transactions"]["transaction"];
    List<Map<String, dynamic>> debits = [];

    for (var transaction in transactions) {
      if (transaction["type"] == "DEBIT") {
        debits.add({
          "date": transaction["transactionTimestamp"],
          "amount": double.parse(transaction["amount"]),
          "mode": transaction["mode"],
          "narration": transaction["narration"].split("/")[3],
        });
      }
    }

    debits.sort((a, b) => b["amount"].compareTo(a["amount"]));
    return debits.sublist(0, 3);
  }

  static List<Map<String, dynamic>> findTop3Credits(Map<String, dynamic> data) {
    List<dynamic> transactions = data["Payload"][0]["data"][0]["decryptedFI"]
        ["account"]["transactions"]["transaction"];
    List<Map<String, dynamic>> credits = [];

    for (var transaction in transactions) {
      if (transaction["type"] == "CREDIT") {
        credits.add({
          "date": transaction["transactionTimestamp"],
          "amount": double.parse(transaction["amount"]),
          "mode": transaction["mode"],
        });
      }
    }

    credits.sort((a, b) => b["amount"].compareTo(a["amount"]));
    return credits.sublist(0, 3);
  }

  static Map<String, Map<String, double>> inflowOutflowMonths(
      Map<String, dynamic> data) {
    Map<String, double> inflow = {};
    Map<String, double> outflow = {};

    List<dynamic> transactions = data['Payload'][0]['data'][0]['decryptedFI']
        ['account']['transactions']['transaction'];

    for (var transaction in transactions) {
      String transaction_month = transaction['transactionTimestamp'];
      transaction_month =
          DateFormat('MMMM yyyy').format(DateTime.parse(transaction_month));

      double amount = double.parse(transaction['amount']);

      if (transaction['type'] == 'CREDIT') {
        inflow.update(transaction_month, (value) => value + amount,
            ifAbsent: () => 0);
      } else {
        outflow.update(transaction_month, (value) => value + amount,
            ifAbsent: () => 0);
      }
    }

    return {'inflow': inflow, 'outflow': outflow};
  }
}
