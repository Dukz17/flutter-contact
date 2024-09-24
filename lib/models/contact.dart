class Contact {
  late int? id;
  late String? name;
  late int? userId;
  late String? phone;
  late String? email;
  late String? address;
  late int? groupId;
  
  Contact
  (
    {
      required this.id,
      required this.name,
      required this.userId,
      required this.phone,
      required this.email,
      this.address,
      required this.groupId
    }
  );

  Contact.jsonData
  (
    {
      required this.userId,
      required this.groupId
    }
  );

  Map<String, dynamic> toJson2()
  {
    return
    {
      "id" : id,
      "name" : name,
      "phone" : phone,
      "email" : email,
      "address" : address,
      "groupId" : groupId,
    };
  }

  Map<String, dynamic> toJson()
  {
    return
    {
      "userId" : userId,
      "groupId" : groupId,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json)
  {
    return Contact
    (
      id: json['contact_id'],
      name: json['contact_name'],
      userId: json['contact_userId'],
      phone: json['contact_phone'],
      email: json['contact_email'],
      address: json['contact_address'],
      groupId: json['contact_group'],
    );
  }
}