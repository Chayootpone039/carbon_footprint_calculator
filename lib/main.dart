import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Footprint Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController electricityController = TextEditingController();
  final TextEditingController naturalGasController = TextEditingController();
  final TextEditingController fuelOilController = TextEditingController();
  final TextEditingController propaneController = TextEditingController();
  final TextEditingController milesDrivenController = TextEditingController();
  final TextEditingController mpgController = TextEditingController();
  bool recyclesAluminum = false;
  bool recyclesPaper = false;

  double calculateHomeEnergyEmissions(double electricity, double naturalGas, double fuelOil, double propane) {
    double electricityFactor = 1.459; // kg CO2 per kWh
    double naturalGasFactor = 5.3;   // kg CO2 per therm
    double fuelOilFactor = 10.2;      // kg CO2 per gallon
    double propaneFactor = 5.7;       // kg CO2 per gallon
    
    double electricityEmissions = electricity * electricityFactor * 12; // Annual emissions
    double naturalGasEmissions = naturalGas * naturalGasFactor * 12;
    double fuelOilEmissions = fuelOil * fuelOilFactor * 12;
    double propaneEmissions = propane * propaneFactor * 12;

    return electricityEmissions + naturalGasEmissions + fuelOilEmissions + propaneEmissions;
  }

  double calculateTransportationEmissions(double milesDriven, double mpg, double fuelFactor) {
    double fuelConsumed = milesDriven / mpg;
    return fuelConsumed * fuelFactor; // kg CO2 per gallon (specific for fuel type)
  }

  double calculateRecyclingEmissions(bool recyclesAluminum, bool recyclesPaper) {
    double aluminumFactor = 0.1; // CO2 savings per unit recycled
    double paperFactor = 0.05; // CO2 savings per unit recycled
    
    double totalSavings = 0;
    if (recyclesAluminum) {
      totalSavings += aluminumFactor;
    }
    if (recyclesPaper) {
      totalSavings += paperFactor;
    }

    return totalSavings;
  }

  void navigateToResultsPage(BuildContext context) {
    double electricity = double.parse(electricityController.text);
    double naturalGas = double.parse(naturalGasController.text);
    double fuelOil = double.parse(fuelOilController.text);
    double propane = double.parse(propaneController.text);
    double milesDriven = double.parse(milesDrivenController.text);
    double mpg = double.parse(mpgController.text);

    // Calculate Home Energy emissions
    double homeEnergyEmissions = calculateHomeEnergyEmissions(electricity, naturalGas, fuelOil, propane);

    // Calculate Transportation emissions (for gasoline, assuming a factor of 8.89 kg CO2 per gallon)
    double transportationEmissions = calculateTransportationEmissions(milesDriven, mpg, 8.89);

    // Calculate Recycling emissions savings
    double recyclingSavings = calculateRecyclingEmissions(recyclesAluminum, recyclesPaper);

    // Pass calculated values to the Results Page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(
          homeEnergyEmissions: homeEnergyEmissions,
          transportationEmissions: transportationEmissions,
          recyclingSavings: recyclingSavings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carbon Footprint Calculator'),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Home Energy Section
            Text(
              'Home Energy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            SizedBox(height: 8),
            _buildTextField(electricityController, 'Electricity Usage (kWh)', Icons.bolt),
            _buildTextField(naturalGasController, 'Natural Gas Usage (Therms)', Icons.local_fire_department),
            _buildTextField(fuelOilController, 'Fuel Oil Usage (Gallons)', Icons.local_gas_station),
            _buildTextField(propaneController, 'Propane Usage (Gallons)', Icons.fireplace),
            SizedBox(height: 20),
            
            // Transportation Section
            Text(
              'Transportation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            SizedBox(height: 8),
            _buildTextField(milesDrivenController, 'Miles Driven per Year', Icons.directions_car),
            _buildTextField(mpgController, 'Miles per Gallon (MPG)', Icons.speed),
            SizedBox(height: 20),
            
            // Recycling Habits Section
            Text(
              'Recycling Habits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: recyclesAluminum,
                  onChanged: (bool? value) {
                    setState(() {
                      recyclesAluminum = value!;
                    });
                  },
                ),
                Text('Recycles Aluminum', style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: recyclesPaper,
                  onChanged: (bool? value) {
                    setState(() {
                      recyclesPaper = value!;
                    });
                  },
                ),
                Text('Recycles Paper', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 20),

            // Calculate Button
            ElevatedButton.icon(
              onPressed: () {
                navigateToResultsPage(context);
              },
              icon: Icon(Icons.calculate),
              label: Text('Calculate', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16),
    );
  }
}

class ResultsPage extends StatelessWidget {
  final double homeEnergyEmissions;
  final double transportationEmissions;
  final double recyclingSavings;

  ResultsPage({required this.homeEnergyEmissions, required this.transportationEmissions, required this.recyclingSavings});

  @override
  Widget build(BuildContext context) {
    double totalEmissions = homeEnergyEmissions + transportationEmissions - recyclingSavings;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carbon Footprint Results'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildResultText('Home Energy Emissions', homeEnergyEmissions),
            _buildResultText('Transportation Emissions', transportationEmissions),
            _buildResultText('Recycling Savings', -recyclingSavings),
            SizedBox(height: 16),
            Text(
              'Total Annual Emissions: ${totalEmissions.toStringAsFixed(2)} kg CO2',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.home),
              label: Text('Back to Home Page'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultText(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$label: ${value.toStringAsFixed(2)} kg CO2',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
