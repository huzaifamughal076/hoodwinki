class ChatModel {
  var id, image, name,
      email, dob, house,
      street, town, province,
      zip, country,about,
      businessDetails,type,createdAt,
      rating,idVerification,CountryCode,
      ChatId,message,messageDeliverTime,
      read;

  ChatModel(
      {this.id,
        this.image,
        this.name,
        this.email,
        this.dob,
        this.house,
        this.street,
        this.town,
        this.province,
        this.zip,
        this.country,
        this.about,
        this.businessDetails,
        this.type,
        this.createdAt,
        this.rating,
        this.idVerification,
        this.CountryCode,
        this.ChatId,
        this.message,
        this.messageDeliverTime,
        this.read
      });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['image']=image;
    map['Name'] = name;
    map['Email'] = email;
    map['DOB'] = dob;
    map['House_name_number'] = house;
    map['Street'] = street;
    map['Town'] = town;
    map['Province'] = province;
    map['Zip'] = zip;
    map['Country'] = country;
    map['About'] = about;
    map['Business details'] = businessDetails;
    map['Type'] = type;
    map['Created at']=createdAt;
    map['Rating']=rating;
    map['Verified']=idVerification;
    map['CountryCode']=CountryCode;
    map['ChatId']=ChatId;
    map['read']=read;
    return map;
  }

  Map<String,dynamic> ChatMap(){
    Map<String,dynamic>map = <String,dynamic>{};
    map['id'] = id;
    map['ChatId']=ChatId;
    return map;
  }
  factory ChatModel.fromChatMap(var map){
    return ChatModel(
      id: map['id'],
      ChatId: map['ChatId'],
    );
  }

  factory ChatModel.fromMap(var map) {
    return ChatModel(
        id: map['id'],
        image: map['image'],
        name: map['Name'],
        email: map['Email'],
        dob: map['DOB'],
        house: map['House_name_number'],
        street: map['Street'],
        town: map['Town'],
        province: map['Province'],
        type: map['Type'],
        zip: map['Zip'],
        country: map['Country'],
        about: map['About'],
        businessDetails: map['Business details'],
        createdAt: map['Created at'],
        rating: map['Rating'],
        idVerification: map['Verified'],
        CountryCode: map['CountryCode'],
        ChatId: map['ChatId'],
        read: map['read'],
    );
  }
}



// SenderChatSide.name = ReceiverModel.name;
// SenderChatSide.CountryCode = ReceiverModel.CountryCode;
// SenderChatSide.email = ReceiverModel.email;
// SenderChatSide.country = ReceiverModel.country;
// SenderChatSide.zip = ReceiverModel.zip;
// SenderChatSide.province = ReceiverModel.province;
// SenderChatSide.town = ReceiverModel.town;
// SenderChatSide.street = ReceiverModel.street;
// SenderChatSide.house = ReceiverModel.house;
// SenderChatSide.id = ReceiverModel.id;
// SenderChatSide.about = ReceiverModel.about;
// SenderChatSide.createdAt = ReceiverModel.createdAt;
// SenderChatSide.image = ReceiverModel.image;
// SenderChatSide.businessDetails = ReceiverModel.businessDetails;
// SenderChatSide.dob = ReceiverModel.dob;
// SenderChatSide.type = ReceiverModel.type;
// SenderChatSide.idVerification = ReceiverModel.idVerification;


// double sum=0.0;
// var rating;
// await usersRef.doc(ReceiverChatSide.id).get().then((val) async {
// List pointlist = List.from(val.data()!['Rating']);
// if(pointlist.isNotEmpty || pointlist.length!=0){
// for(var i in pointlist){
// print(i);
// sum += i;
// }
// print("SUM: "+sum.toString());
// rating = sum/pointlist.length;
// print("Rating is: "+rating.toString());
// }
// else{
// rating = 0.0;
// }
// SenderChatSide.rating = rating;
// });