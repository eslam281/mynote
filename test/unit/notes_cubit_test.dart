import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mynote/data/database/sqldb.dart';
import 'package:mynote/data/models/note_model.dart';
import 'package:mynote/logic/notes_cubit/notes_cubit.dart';
import 'package:mynote/logic/notes_cubit/notes_state.dart';

class MockSqlDb extends Mock implements SqlDb {}

void main() {
  late MockSqlDb mockSqlDb;
  late NotesCubit notesCubit;

  setUp(() {
    mockSqlDb = MockSqlDb();
    notesCubit = NotesCubit(mockSqlDb);
  });

  tearDown(() {
    notesCubit.close();
  });

  group('NotesCubit Unit Tests', () {
    final tNote = NoteModel(
      id: 1,
      title: 'Test Note',
      content: 'Content',
      createdAt: DateTime.now(),
      color: 0xFFFFFFFF,
    );

    test('Initial state should be NotesInitial', () {
      expect(notesCubit.state, isA<NotesInitial>());
    });

    blocTest<NotesCubit, NotesState>(
      'emits [NotesLoading, NotesLoaded] when loadNotes is successful',
      setUp: () {
        when(() => mockSqlDb.purgeDeletedNotes(any())).thenAnswer((_) async => 0);
        when(() => mockSqlDb.readAllCategories()).thenAnswer((_) async => []);
        when(() => mockSqlDb.readAllNotes()).thenAnswer((_) async => [tNote]);
      },
      build: () => notesCubit,
      act: (cubit) => cubit.loadNotes(),
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesLoaded>().having((s) => s.notes.length, 'notes length', 1),
      ],
    );

    blocTest<NotesCubit, NotesState>(
      'emits [NotesError] when loadNotes fails',
      setUp: () {
        when(() => mockSqlDb.purgeDeletedNotes(any())).thenThrow(Exception('DB Error'));
      },
      build: () => notesCubit,
      act: (cubit) => cubit.loadNotes(),
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesError>(),
      ],
    );
  });
}
