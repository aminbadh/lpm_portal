class Student {
  String name, num, classN;

  Student(this.name, this.num, this.classN);

  Map<String, dynamic> toMap() => {
        'name': name,
        'num': num,
        'classN': classN,
      };
}
