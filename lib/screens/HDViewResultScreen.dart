import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/MIAColors.dart';

class HDViewResultScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  HDViewResultScreen({required this.data});

  @override
  State<HDViewResultScreen> createState() => _HDViewResultScreenState();
}

class _HDViewResultScreenState extends State<HDViewResultScreen> {
  late Map<String, dynamic> data;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: miaPrimaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ).paddingSymmetric(horizontal: 8),
          title: Center(
            child: Text(
              'Result',
              style: TextStyle(
                color: Colors.black, // Màu chữ
                fontWeight: FontWeight.bold,
                fontSize: 16.0, // Kích thước chữ
              ),
            ),
          )),
      body: Container(
        child: data['plant'] != null
            ? _buildPlantInfo(data['plant'])
            : _buildEstimates(data['estimate']),
      ),
    );
  }

  void _onSliderChanged(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  Widget _buildPlantInfo(Map<String, dynamic> plant) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            color: Colors.white,
            child: Image.network(
              data['plant']['images'][_currentImageIndex]['url'],
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: data['plant']['images'].map<Widget>((item) {
                return GestureDetector(
                  onTap: () {
                    _onSliderChanged(data['plant']['images'].indexOf(item));
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        // Màu viền cho hình ảnh xem trước được chọn
                        width: 2.0,
                      ),
                    ),
                    child: Image.network(
                      item['url'],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 10.0), // Chỉ định padding bên trái
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Căn lề bên trái
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${plant['name']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
                Text(
                  '${plant['plantCategories'][0]['category']['name'] ?? 'abc'}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Text(
                  '${plant['description'] ?? 'Description'}',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5), // Độ mờ màu chữ
                    fontSize: 16, // Kích thước chữ
                    fontWeight: FontWeight.normal, // Trọng lượng chữ
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimates(List<dynamic> estimates) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text(
              'Plant Undefine!',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Below are some similar results',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          for (var estimate in estimates)
            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Column(
                children: [
                  Text(
                    '${estimate['plant']['name']}: ${(estimate['confidence'] * 100).toStringAsFixed(2)}%',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  Image.network(estimate['plant']['images'][0]['url']),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
