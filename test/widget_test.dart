import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trauma/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Construir nuestra app y disparar un frame.
    await tester.pumpWidget(TraumaApp());  // Eliminar 'const'

    // Verificar que el contador comienza en 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tocar el ícono '+' y disparar un frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verificar que el contador ha incrementado.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
