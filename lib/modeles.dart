class UE {
  final String code;
  final String intitule;
  final int coefficient;

  const UE(
    this.code,
    this.intitule,
    this.coefficient,
  );

  factory UE.fromJson(Map<String, dynamic> j) {
    return UE(
      j['code'] as String,
      j['intitule'] as String,
      j['coefficient'] as int,
    );
  }

  @override
  String toString() {
    return '$code - $intitule (coefficient : $coefficient)';
  }
}

class Etudiant {
  final String matricule;
  final String nom;
  final String? email;
  final Map<String, double> notes;

  const Etudiant(
    this.matricule,
    this.nom,
    this.email,
    this.notes,
  );

  factory Etudiant.fromJson(Map<String, dynamic> j) {
    final notesJson = j['notes'] as Map<String, dynamic>;

    final notes = notesJson.map(
      (code, note) {
        return MapEntry(
          code,
          (note as num).toDouble(),
        );
      },
    );

    return Etudiant(
      j['matricule'] as String,
      j['nom'] as String,
      j['email'] as String?,
      notes,
    );
  }

  String get contact {
    return email ?? 'non renseigné';
  }

  double? note(String codeUE) {
    return notes[codeUE];
  }

  @override
  String toString() {
    return '''
Matricule : $matricule
Nom       : $nom
Email     : $contact
Notes     : $notes
''';
  }
}