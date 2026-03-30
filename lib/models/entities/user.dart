class User {
  const User({
    required this.id,
    this.email,
    this.isActive,
    this.isSuperuser,
    this.isVerified,
    this.firstName,
    this.lastName,
  });

  final int id;
  final String? email;
  final bool? isActive;
  final bool? isSuperuser;
  final bool? isVerified;
  final String? firstName;
  final String? lastName;

  factory User.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    if (idValue is! num) {
      throw FormatException('Invalid user JSON: $json');
    }

    final emailValue = json['email'];
    if (emailValue != null && emailValue is! String) {
      throw FormatException('Invalid user JSON: $json');
    }

    final isActiveValue = json['is_active'];
    if (isActiveValue != null && isActiveValue is! bool) {
      throw FormatException('Invalid user JSON: $json');
    }

    final isSuperuserValue = json['is_superuser'];
    if (isSuperuserValue != null && isSuperuserValue is! bool) {
      throw FormatException('Invalid user JSON: $json');
    }

    final isVerifiedValue = json['is_verified'];
    if (isVerifiedValue != null && isVerifiedValue is! bool) {
      throw FormatException('Invalid user JSON: $json');
    }

    final firstNameValue = json['first_name'];
    if (firstNameValue != null && firstNameValue is! String) {
      throw FormatException('Invalid user JSON: $json');
    }

    final lastNameValue = json['last_name'];
    if (lastNameValue != null && lastNameValue is! String) {
      throw FormatException('Invalid user JSON: $json');
    }

    return User(
      id: idValue.toInt(),
      email: emailValue as String?,
      isActive: isActiveValue as bool?,
      isSuperuser: isSuperuserValue as bool?,
      isVerified: isVerifiedValue as bool?,
      firstName: firstNameValue as String?,
      lastName: lastNameValue as String?,
    );
  }
}
