import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;



class ImageEditorScreen extends StatefulWidget {
  @override
  _ImageEditorScreenState createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  File? _image;
  img.Image? _editedImage;
  TextEditingController _textController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _editedImage = img.decodeImage(_image!.readAsBytesSync())!;
      });
    }
  }

  void _applyBlackAndWhiteFilter() {
    if (_editedImage != null) {
      _editedImage = img.grayscale(_editedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسک سوم-ویرایشکر عکس'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus(); 
                      },
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (_editedImage != null)
                              Image.memory(Uint8List.fromList(img.encodeJpg(_editedImage!))),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                width: 200,
                                child: TextField(
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    hintText: 'نوشته را بنویسید...',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Text('عکسی برای ویرایش انتخاب نشده...'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('انتخاب عکس'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _applyBlackAndWhiteFilter();
                FocusScope.of(context).unfocus(); 
              },
              child: Text('اعمال فیلتر سیاه و سفید'),
            ),
          ],
        ),
      ),
    );
  }
}
