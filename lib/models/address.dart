class Address {
  final String userId;
  final String houseNo;
  final String roadNo;
  final String colony;
  final String city;
  final String state;
  final String pincode;

  Address({required this.userId,
    required this.houseNo,
    required this.colony,
    required this.city,
    required this.roadNo,
    required this.state,
    required this.pincode});

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(userId: json['_id']['\$oid'],
        houseNo: json['House_no'],
        roadNo:json['road_no'],
        colony: json['colony'],
        city: json['city'],
        state: json['state'],
        pincode: json['pincode']);
  }
}
