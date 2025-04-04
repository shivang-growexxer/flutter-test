import 'package:task_manager/models/user/user_model.dart';

abstract class LoginRepository {
  
  Future<UserModel> loginApi(dynamic data);
}
