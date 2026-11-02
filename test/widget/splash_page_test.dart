import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mynote/logic/notes_cubit/notes_cubit.dart';
import 'package:mynote/logic/notes_cubit/notes_state.dart';
import 'package:mynote/logic/l10n/app_localizations.dart';
import 'package:mynote/presentation/pages/splash/splash_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockNotesCubit extends Mock implements NotesCubit {}

void main() {
  late MockNotesCubit mockNotesCubit;

  setUp(() {
    mockNotesCubit = MockNotesCubit();
    when(() => mockNotesCubit.state).thenReturn(const NotesLoaded([], categories: []));
    when(() => mockNotesCubit.stream).thenAnswer((_) => Stream.value(const NotesLoaded([], categories: [])));
    when(() => mockNotesCubit.loadNotes()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: BlocProvider<NotesCubit>.value(
        value: mockNotesCubit,
        child: const SplashPage(),
      ),
    );
  }

  testWidgets('SplashPage displays branding and title', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify title and icon are present
    expect(find.text('MyNote Pro'), findsOneWidget);
    expect(find.byIcon(Icons.note_alt_rounded), findsOneWidget);
  });
}
