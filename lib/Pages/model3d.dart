import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:smartrainbow/style.dart';  // Ensure this file defines the AppColors used below

class My3DModelPage extends StatefulWidget {
  final String rotationSpeed;
  final String tempDifference;

  const My3DModelPage({Key? key, required this.rotationSpeed, required this.tempDifference}) : super(key: key);

  @override
  My3DModelPageState createState() => My3DModelPageState();
}

class My3DModelPageState extends State<My3DModelPage> {
  List<String> modelPaths = [
    'assets/BeafSteak.glb',
    'assets/kohle_final.glb',
    'assets/fass_final.glb',
    'assets/spray_bottle3.glb',
    'assets/flug_final.glb',
    'assets/final_duck.glb',
    'assets/error.glb',
  ];

  List<String> buttonImages = [
    'assets/1-rot.png',
    'assets/2-orange.png',
    'assets/3-gelb.png',
    'assets/4-grun.png',
    'assets/5-helblau cyan.png',
    'assets/6-blau.png',
    'assets/7-violett.png'
  ];

  int _selectedIndex = -1;  // Start with no selection

  @override
  void initState() {
    super.initState();
  }

  void _updateModel(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getModelSrc() {
    if (_selectedIndex < 0 || _selectedIndex >= modelPaths.length) {
      return 'assets/select.glb';
    }
    return modelPaths[_selectedIndex];
  }

  Widget _buildModelViewer() {
    return Expanded(
      child: _selectedIndex == -1
        ? _buildDefaultView()
        : ModelViewer(
            key: ValueKey(getModelSrc()),
            backgroundColor: const Color.fromARGB(255, 200, 200, 200),
            src: getModelSrc(),
            alt: "3D Model Display",
            ar: true,
            arScale: ArScale.auto,
            autoRotate: true,
            autoPlay: true,
            cameraControls: true,
            rotationPerSecond: widget.rotationSpeed,
          ),
    );
  }

  Widget _buildDefaultView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            SizedBox( height:350,width:350, child: Image.asset('assets/last.png')),
            const SizedBox(height:10),
          const Center(
            child: Text(
              "errors are loading...",
              
              
              style: TextStyle(
                fontSize: 18,
              
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
             const Text(
            "(work in progress)",
            
            
            style: TextStyle(
              fontSize: 16,
            
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
         
        ],
      ),
    );
  }

  Widget _buildModelSelectionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: 15.0,
        runSpacing: 4.0,
        children: List.generate(modelPaths.length, (index) => InkWell(
          onTap: () => _updateModel(index),
          child: Container(
              padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: _selectedIndex == index ? const Color.fromARGB(255, 255, 255, 255) : Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset(buttonImages[index], width: 50, height: 50),
          ),
        )),
      ),
    );
  }

  Widget _buildFooterText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '${widget.tempDifference}, Rotation speed: ${widget.rotationSpeed}',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 215, 215, 215),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 120.0,
          backgroundColor: const Color.fromARGB(255, 215, 215, 215),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.red),
            onPressed: () => Navigator.pop(context),
          ),
          title: _buildAppBarTitle(),
        ),
        body: Column(
          children: [
            _buildModelViewer(),
            _buildModelSelectionButtons(),
            _buildFooterText(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() => SizedBox(
    height: 110.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRichTextTitle(),
        const Text(
          'M    O      N      I     T     O      R     I     N     G',
          style: TextStyle(fontSize: 30, color: AppColors.purple),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildRichTextTitle() => RichText(
    text: const TextSpan(
      children: [
        TextSpan(text: 'SMART  ', style: TextStyle(fontSize: 30, color: AppColors.red)),
        TextSpan(text: 'RAINBOW  ', style: TextStyle(fontSize: 30, color: AppColors.orange)),
        TextSpan(text: '7.  ', style: TextStyle(fontSize: 30, color: AppColors.yellow)),
        TextSpan(text: '0  ', style: TextStyle(fontSize: 30, color: AppColors.green)),
        TextSpan(text: 'CLIMATE  ', style: TextStyle(fontSize: 30, color: AppColors.cyan)),
        TextSpan(text: 'CHANGE ', style: TextStyle(fontSize: 30, color: AppColors.blue)),
      ],
    ),
  );
}
