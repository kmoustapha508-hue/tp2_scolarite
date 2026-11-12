import 'modeles.dart';

double moyenne(Etudiant e, List<UE> ues) {
  final somme = ues.fold<double>(
    0,
    (acc, ue) {
      final note = e.note(ue.code) ?? 0;

      return acc + note * ue.coefficient;
    },
  );

  final totalCoefficients = ues.fold<int>(
    0,
    (acc, ue) {
      return acc + ue.coefficient;
    },
  );

  return somme / totalCoefficients;
}

List<Etudiant> classement(
  List<Etudiant> promo,
  List<UE> ues,
) {
  final resultat = [...promo];

  resultat.sort(
    (a, b) {
      return moyenne(b, ues).compareTo(
        moyenne(a, ues),
      );
    },
  );

  return resultat;
}

Map<String, double> moyenneParUE(
  List<Etudiant> promo,
) {
  final codes = promo
      .expand((e) => e.notes.keys)
      .toSet();

  return codes.fold<Map<String, double>>(
    {},
    (resultat, code) {
      final notes = promo.map(
        (e) => e.note(code) ?? 0,
      );

      resultat[code] =
          notes.reduce((a, b) => a + b) / promo.length;

      return resultat;
    },
  );
}

(double, double) extremes(
  List<double> valeurs,
) {
  final min = valeurs.reduce(
    (a, b) => a < b ? a : b,
  );

  final max = valeurs.reduce(
    (a, b) => a > b ? a : b,
  );

  return (min, max);
}