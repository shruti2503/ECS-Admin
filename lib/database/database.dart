import 'package:ecsadmin/models/student.dart';
import 'package:ecsadmin/utils/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:rxdart/subjects.dart';

class MongoDatabase {
  static var db, userCollection;
  final _studentStreamController =
      BehaviorSubject<List<Student>>.seeded(const []);

  MongoDatabase() {
    getStudentsRequest();
  }

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    userCollection = db.collection(USER_COLLECTION);
    print(userCollection);
  }

  getStudentsRequest() async {
    {
      final students = await userCollection.find().toList();
      final list = Student.parseStudentList(students);

      _studentStreamController.add(list);
    }
  }

  Stream<List<Student>> getAllStudentsResponse() =>
      _studentStreamController.asBroadcastStream();
}
