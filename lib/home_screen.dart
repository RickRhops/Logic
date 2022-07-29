import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' as prefix;
import 'package:logic/database/database.dart';
import 'package:logic/theme.dart';
import '../widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController notesListController = ScrollController();
  final TextEditingController newNoteInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {FocusScope.of(context).unfocus();},
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 52,
            flexibleSpace: const TopBar(),
          ),
          body: Column(
            children: <Widget>[
              Expanded(child: _buildNotesList(context)),
              _newNoteInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notesListController.hasClients) {
        notesListController.jumpTo(
          notesListController.position.maxScrollExtent,
        );
      }
    });
  }

  StreamBuilder<List<Note>> _buildNotesList(BuildContext context) {
    final database = ref.read(AppDatabase.provider);
    return StreamBuilder(
      stream: database.watchNotesInDatabase(),
      builder: (context, AsyncSnapshot<List<Note>> snapshot) {
        final notes = snapshot.data ?? [];

        return ScrollConfiguration(
          behavior: ScrollEffect(),
          child: ListView.builder(
            reverse: true,
            controller: notesListController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 24, right: 8),
            itemCount: notes.length,
            itemBuilder: (_, index) {
              final itemCount = notes.length;
              final itemNote = notes[itemCount - 1 - index];
              return _buildNoteCard(itemNote, database);
            },
          ),
        );
      },
    );
  }

  Widget _buildNoteCard(Note itemNote, AppDatabase database) {
    const cardRadius = 4.0;

    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: itemNote.content)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(_noteCopiedNotification());
        });
      },
      onLongPress: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            _deleteNoteAlertDialog(context, itemNote),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.noteCard,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(cardRadius),
                bottomLeft: Radius.circular(cardRadius),
                bottomRight: Radius.circular(cardRadius),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 16),
              child: Text(
                itemNote.content,
                style: const TextStyle(
                  color: AppColors.noteCardText,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog _deleteNoteAlertDialog(BuildContext context, Note itemNote) {
    return AlertDialog(
      backgroundColor: AppColors.gray2,
      shape: null,
      elevation: 0,
      content: const Text('Delete Note?'),
      contentTextStyle: const TextStyle(color: AppColors.gray5),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(primary: AppColors.gray7),
          onPressed: () => Navigator.pop(context, 'CANCEL'),
          child: const Text('CANCEL'),
        ),
        TextButton(
          style: TextButton.styleFrom(primary: AppColors.gray7),
          onPressed: () {
            Navigator.pop(context, 'DELETE');
            final database = ref.read(AppDatabase.provider);
            database.deleteNote(itemNote);
            ScaffoldMessenger.of(context)
                .showSnackBar(_noteDeletedNotification());
          },
          child: const Text('DELETE'),
        ),
      ],
    );
  }

  SnackBar _noteDeletedNotification() {
    return const SnackBar(
      content: Text("Note deleted"),
      width: null,
      duration: Duration(milliseconds: 1200),
      margin: EdgeInsets.only(
        bottom: 72,
        left: 48,
        right: 48,
      ),
      dismissDirection: DismissDirection.endToStart,
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
    );
  }

  SnackBar _noteCopiedNotification() {
    return const SnackBar(
      content: Text("Note copied"),
      width: null,
      duration: Duration(milliseconds: 1200),
      margin: EdgeInsets.only(
        bottom: 72,
        left: 48,
        right: 48,
      ),
      dismissDirection: DismissDirection.endToStart,
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
    );
  }

  Container _newNoteInputBar() {
    return Container(
      constraints: const BoxConstraints(minHeight: 64, maxHeight: 140),
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.newNoteInputBar,
            border: Border(
              bottom: BorderSide(
                color: AppColors.newNoteInputBorder,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _newNoteInputField(),
                ),
                _newNoteInputButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _newNoteInputField() {
    return TextField(
      controller: newNoteInputController,
      cursorColor: AppColors.newNoteInputIcon,
      maxLines: 6,
      minLines: 1,
      style: const TextStyle(
        color: AppColors.newNoteInputFieldText,
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        hintText: 'New Note...',
        hintStyle: TextStyle(
          color: AppColors.newNoteInputFieldHint,
          fontSize: 16,
        ),
        border: InputBorder.none,
      ),
    );
  }

  Padding _newNoteInputButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => _addNewNote(),
        child: SizedBox(
          height: 32,
          child: Image.asset('assets/save_note_icon.png'),
        ),
      ),
    );
  }

  _addNewNote() {
    if (newNoteInputController.text.isNotEmpty) {
      final database = ref.read(AppDatabase.provider);
      database.notes.insertOne(NotesCompanion.insert(
        content: newNoteInputController.text,
      ));
      newNoteInputController.clear();
      notesListController.jumpTo(notesListController.position.minScrollExtent);
    }
  }
}