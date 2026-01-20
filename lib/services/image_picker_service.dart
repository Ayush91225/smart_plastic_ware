import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return null;

    final image = await _picker.pickImage(source: ImageSource.camera);
    return image?.path;
  }

  static Future<String?> pickFromGallery() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) return null;

    final image = await _picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  static Future<List<String>> pickMultiple() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) return [];

    final images = await _picker.pickMultiImage();
    return images.map((e) => e.path).toList();
  }
}
