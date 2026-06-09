library;

class UserModel {
  final int? id;
  final String name;
  final String email;
  final String passwordHash;
  final String? profilePicturePath;
  final DateTime createdAt;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.profilePicturePath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'email': email,
    'passwordHash': passwordHash,
    'profilePicturePath': profilePicturePath,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] as int?,
    name: map['name'] as String,
    email: map['email'] as String,
    passwordHash: map['passwordHash'] as String,
    profilePicturePath: map['profilePicturePath'] as String?,
    createdAt: DateTime.parse(map['createdAt'] as String),
  );

  UserModel copyWith({String? name, String? email, String? profilePicturePath}) => UserModel(
    id: id, name: name ?? this.name, email: email ?? this.email,
    passwordHash: passwordHash, profilePicturePath: profilePicturePath ?? this.profilePicturePath,
    createdAt: createdAt,
  );

  /// Guest user
  static UserModel guest() => UserModel(
    name: 'Guest', email: 'guest@local', passwordHash: '',
    createdAt: DateTime.now(),
  );
}
