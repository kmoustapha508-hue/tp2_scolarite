import 'modeles.dart';
import 'statistiques.dart';

sealed class Resultat {}

class Admis extends Resultat {
  final String mention;

  Admis(this.mention);
}

class Rattrapage extends Resultat {
  final List<String> ues;

  Rattrapage(this.ues);
}

class Ajourne extends Resultat {}

Resultat deliberer(
  Etudiant e,
  List<UE> ues,
) {
  final moyenneEtudiant = moyenne(e, ues);

  if (moyenneEtudiant >= 10) {
    String mention;

    if (moyenneEtudiant >= 16) {
      mention = 'Très bien';
    } else if (moyenneEtudiant >= 14) {
      mention = 'Bien';
    } else if (moyenneEtudiant >= 12) {
      mention = 'Assez bien';
    } else {
      mention = 'Passable';
    }

    return Admis(mention);
  }

  if (moyenneEtudiant >= 8) {
    final uesSous10 = ues
        .where(
          (ue) => (e.note(ue.code) ?? 0) < 10,
        )
        .map((ue) => ue.code)
        .toList();

    return Rattrapage(uesSous10);
  }

  return Ajourne();
}

String message(Resultat r) {
  return switch (r) {
    Admis(mention: final mention) =>
      'Admis - Mention $mention',

    Rattrapage(ues: final ues) =>
      'Rattrapage - UE à repasser : ${ues.join(', ')}',

    Ajourne() =>
      'Ajourné',
  };
}