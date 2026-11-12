import 'package:test/test.dart';

import 'package:scolarite/modeles.dart';
import 'package:scolarite/statistiques.dart';
import 'package:scolarite/resultats.dart';

void main() {
  test('moyenne pondérée', () {
    final ues = [
      const UE(
        'A',
        'Algo',
        2,
      ),
      const UE(
        'B',
        'BD',
        1,
      ),
    ];

    final etudiant = Etudiant(
      '21A0001',
      'Test',
      null,
      {
        'A': 12,
        'B': 15,
      },
    );

    expect(
      moyenne(etudiant, ues),
      closeTo(13.0, 0.001),
    );
  });

  test('UE manquante vaut 0', () {
    final ues = [
      const UE(
        'A',
        'Algo',
        2,
      ),
      const UE(
        'B',
        'BD',
        1,
      ),
    ];

    final etudiant = Etudiant(
      '21A0001',
      'Test',
      null,
      {
        'A': 12,
      },
    );

    expect(
      moyenne(etudiant, ues),
      closeTo(8.0, 0.001),
    );
  });

  test('classement', () {
    final ues = [
      const UE(
        'A',
        'Algo',
        1,
      ),
    ];

    final promo = [
      Etudiant(
        '1',
        'Koffi',
        null,
        {'A': 10},
      ),
      Etudiant(
        '2',
        'Awa',
        null,
        {'A': 15},
      ),
    ];

    final resultat = classement(
      promo,
      ues,
    );

    expect(
      resultat.first.nom,
      'Awa',
    );

    expect(
      resultat.last.nom,
      'Koffi',
    );
  });

  test('délibération admis', () {
    final ues = [
      const UE(
        'A',
        'Algo',
        1,
      ),
    ];

    final etudiant = Etudiant(
      '1',
      'Awa',
      null,
      {'A': 15},
    );

    final resultat = deliberer(
      etudiant,
      ues,
    );

    expect(
      resultat,
      isA<Admis>(),
    );
  });
}