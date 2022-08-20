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
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 48,
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
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.noteCard,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 16),
              child: Text(
                itemNote.content,
                style: const TextStyle(
                  color: AppColors.noteCardText,
                  fontSize: 18,
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
      
      actionsAlignment: MainAxisAlignment.center,
      buttonPadding: const EdgeInsets.symmetric(horizontal: 2),
      insetPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.all(8),

      title: const Text('Delete Note?'),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
            primary: AppColors.gray90,
            backgroundColor: AppColors.gray30,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            textStyle: const TextStyle(
              fontFamily: 'BIZ UDMincho',
              fontSize: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context, 'CANCEL'),
          child: const Text('CANCEL'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
            primary: AppColors.gray90,
            backgroundColor: AppColors.red,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            textStyle: const TextStyle(
              fontFamily: 'BIZ UDMincho',
              fontSize: 18,
            ),
          ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero)),
      content: Text("Note deleted"),
      duration: Duration(milliseconds: 1000),
      margin: EdgeInsets.only(
        bottom: 64,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
    );
  }

  SnackBar _noteCopiedNotification() {
    return const SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero)),
      content: Text("Note copied"),
      duration: Duration(milliseconds: 1000),
      margin: EdgeInsets.only(
        bottom: 64,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
    );
  }

  Container _newNoteInputBar() {
    return Container(
      constraints: const BoxConstraints(minHeight: 64, maxHeight: 180),
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.newNoteInputBar,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
      cursorColor: AppColors.cursorColor,
      maxLines: 6,
      minLines: 1,
      style: const TextStyle(
        color: AppColors.newNoteInputFieldText,
        fontSize: 18,
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        hintText: 'New Note...',
        hintStyle: TextStyle(
          color: AppColors.newNoteInputFieldHint,
          fontSize: 18,
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
