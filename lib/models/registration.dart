class Registration {
  String professorName, professorId, subject, fromTime, toTime, group, className, docRef;
  List<dynamic> absences;
  int submitTime;

  Registration(
      {this.professorName,
      this.professorId,
      this.subject,
      this.fromTime,
      this.toTime,
      this.group,
      this.className,
      this.docRef,
      this.absences,
      this.submitTime});
}
