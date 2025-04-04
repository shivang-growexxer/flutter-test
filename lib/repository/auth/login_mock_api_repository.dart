import 'package:task_manager/models/user/user_model.dart';
import 'package:task_manager/repository/auth/login_repository.dart';

class LoginMockApiRepository implements LoginRepository {
  @override
  Future<UserModel> loginApi(dynamic data) async {
    await Future.delayed(const Duration(seconds: 2));
    final response = {'token': 'rgml5542r4grd'};
    return UserModel.fromJson(response);
  }
}
