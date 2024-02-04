import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

void main() {
  runApp(DCFCalculatorApp());
}

class DCFCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            buildTextField("Capital Expenditures (CapEx)", capExController),
            buildTextField("Working Capital Changes", workingCapitalController),
            buildTextField("Cost of Equity", costOfEquityController),
            buildTextField("Cost of Debt", costOfDebtController),
            buildTextField("Tax Rate", taxRateController),
            buildTextField(
                "Terminal Growth Rate", terminalGrowthRateController),
            buildTextField("Forecast Years", forecastYearsController),
            buildTextField("Exit Multiple", exitMultipleController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
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

class DCFResultScreen extends StatefulWidget {
  final double dcfValue;

  DCFResultScreen({required this.dcfValue});

  @override
  _DCFResultScreenState createState() => _DCFResultScreenState();
}

class _DCFResultScreenState extends State<DCFResultScreen> {
  TextEditingController numberOfSharesController = TextEditingController();
  TextEditingController currentMarketPriceController = TextEditingController();

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
              Text('${widget.dcfValue}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              buildTextField("Number of Shares", numberOfSharesController),
              buildTextField(
                  "Current Market Price", currentMarketPriceController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  double numberOfShares =
                      double.parse(numberOfSharesController.text);
                  double currentMarketPrice =
                      double.parse(currentMarketPriceController.text);

                  double sharePrice = widget.dcfValue / numberOfShares;
                  double percentageDifference =
                      ((currentMarketPrice - sharePrice) / sharePrice) * 100;

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Comparison Result'),
                        content: Column(
                          children: [
                            Text('Estimated Share Price: $sharePrice'),
                            Text('Current Market Price: $currentMarketPrice'),
                            SizedBox(height: 10),
                            Text(
                                'Percentage Difference: $percentageDifference%'),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 5,
                                  centerSpaceRadius: 40,
                                  sections: [
                                    PieChartSectionData(
                                      color: Colors.blue,
                                      value: sharePrice,
                                      title: 'Estimated',
                                      radius: 50,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.orange,
                                      value: currentMarketPrice,
                                      title: 'Current',
                                      radius: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Compare with Current Market Price'),
              ),
            ],
          ),
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
