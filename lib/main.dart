import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(DCFCalculatorApp());
}

class DCFCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DCF Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DCFInputScreen(),
    );
  }
}

class DCFInputScreen extends StatefulWidget {
  @override
  _DCFInputScreenState createState() => _DCFInputScreenState();
}

class _DCFInputScreenState extends State<DCFInputScreen> {
  TextEditingController netIncomeController = TextEditingController();
  TextEditingController depreciationController = TextEditingController();
  TextEditingController amortizationController = TextEditingController();
  TextEditingController capExController = TextEditingController();
  TextEditingController workingCapitalController = TextEditingController();
  TextEditingController costOfEquityController = TextEditingController();
  TextEditingController costOfDebtController = TextEditingController();
  TextEditingController taxRateController = TextEditingController();
  TextEditingController terminalGrowthRateController = TextEditingController();
  TextEditingController forecastYearsController = TextEditingController();
  TextEditingController exitMultipleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DCF Input Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTextField("Net Income", netIncomeController),
            buildTextField("Depreciation", depreciationController),
            buildTextField("Amortization", amortizationController),
            buildTextField("Capital Expenditures", capExController),
            buildTextField(
                "Changes in Working Capital", workingCapitalController),
            buildTextField("Cost of Equity", costOfEquityController),
            buildTextField("Cost of Debt", costOfDebtController),
            buildTextField("Tax Rate", taxRateController),
            buildTextField(
                "Terminal Growth Rate", terminalGrowthRateController),
            buildTextField(
                "Number of Years in Forecast", forecastYearsController),
            buildTextField("Exit Multiple", exitMultipleController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Retrieve values from controllers and use them for DCF calculation
                double netIncome = double.parse(netIncomeController.text);
                double depreciation = double.parse(depreciationController.text);
                double amortization = double.parse(amortizationController.text);
                double capEx = double.parse(capExController.text);
                double workingCapital =
                    double.parse(workingCapitalController.text);
                double costOfEquity = double.parse(costOfEquityController.text);
                double costOfDebt = double.parse(costOfDebtController.text);
                double taxRate = double.parse(taxRateController.text);
                double terminalGrowthRate =
                    double.parse(terminalGrowthRateController.text);
                int forecastYears = int.parse(forecastYearsController.text);
                double exitMultiple = double.parse(exitMultipleController.text);

                // Perform DCF calculation
                double dcfValue = calculateDCF(
                  netIncome,
                  depreciation,
                  amortization,
                  capEx,
                  workingCapital,
                  costOfEquity,
                  costOfDebt,
                  taxRate,
                  terminalGrowthRate,
                  forecastYears,
                  exitMultiple,
                );

                // Navigate to the result screen and pass the calculated DCF value
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DCFResultScreen(dcfValue: dcfValue),
                  ),
                );
              },
              child: Text('Calculate DCF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: labelText),
    );
  }
}

class DCFResultScreen extends StatelessWidget {
  final double dcfValue;

  DCFResultScreen({required this.dcfValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DCF Result Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('DCF Value:', style: TextStyle(fontSize: 20)),
              Text('$dcfValue',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

double calculateDCF(
  double netIncome,
  double depreciation,
  double amortization,
  double capEx,
  double workingCapital,
  double costOfEquity,
  double costOfDebt,
  double taxRate,
  double terminalGrowthRate,
  int forecastYears,
  double exitMultiple,
) {
  List<double> freeCashFlows = [];
  for (int year = 1; year <= forecastYears; year++) {
    double fcf =
        (netIncome + depreciation + amortization - capEx - workingCapital) *
            (1 - taxRate);
    freeCashFlows.add(fcf);
  }

  double terminalYearFCF = freeCashFlows.last * (1 + terminalGrowthRate);
  double terminalValue = terminalYearFCF / (costOfEquity - terminalGrowthRate);

  double dcfValue = 0.0;
  for (int year = 1; year <= forecastYears; year++) {
    double discountFactor = 1 / pow(1 + costOfEquity, year);
    dcfValue += freeCashFlows[year - 1] * discountFactor;
  }

  if (forecastYears > 0) {
    dcfValue += terminalValue / pow(1 + costOfEquity, forecastYears);
  }

  dcfValue *= exitMultiple;

  return dcfValue;
}
