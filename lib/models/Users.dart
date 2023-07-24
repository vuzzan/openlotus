import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  String? ownerId;
  String? shopId;
  String? userId;
  String? gId;
  String? userName;
  String? userPass;
  String? userFullname;
  String? address;
  String? phone;
  String? cusCk;
  String? createTime;
  String? createBy;
  String? updateTime;
  String? updateBy;
  String? sts;

  Users(
      {this.ownerId,
      this.shopId,
      this.userId,
      this.gId,
      this.userName,
      this.userPass,
      this.userFullname,
      this.address,
      this.phone,
      this.cusCk,
      this.createTime,
      this.createBy,
      this.updateTime,
      this.updateBy,
      this.sts});

  Users.fromJson(Map<String, dynamic> json) {
    ownerId = json['owner_id'];
    shopId = json['shop_id'];
    userId = json['user_id'];
    gId = json['g_id'];
    userName = json['user_name'];
    userPass = json['user_pass'];
    userFullname = json['user_fullname'];
    address = json['address'];
    phone = json['phone'];
    cusCk = json['cus_ck'];
    createTime = json['create_time'];
    createBy = json['create_by'];
    updateTime = json['update_time'];
    updateBy = json['update_by'];
    sts = json['sts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner_id'] = this.ownerId;
    data['shop_id'] = this.shopId;
    data['user_id'] = this.userId;
    data['g_id'] = this.gId;
    data['user_name'] = this.userName;
    data['user_pass'] = this.userPass;
    data['user_fullname'] = this.userFullname;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['cus_ck'] = this.cusCk;
    data['create_time'] = this.createTime;
    data['create_by'] = this.createBy;
    data['update_time'] = this.updateTime;
    data['update_by'] = this.updateBy;
    data['sts'] = this.sts;
    return data;
  }
}
