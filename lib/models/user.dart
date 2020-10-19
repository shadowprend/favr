class FavrUser {
  final String name;
  final String lastname;

  FavrUser(this.name, this.lastname);

  FavrUser.fromJson(Map<String, dynamic> json)
      : name = json['first_name'],
        lastname = json['last_name'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'lastname': lastname,
      };
}
