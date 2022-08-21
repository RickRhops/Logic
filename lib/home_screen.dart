import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' as prefix;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:logic/database/database.dart';
import 'package:logic/theme.dart';
import '../widgets/scroll_behavior.dart';
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
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(child: _buildNotesList(context)),
            _newNoteInputBar(),
          ],
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
            padding: const EdgeInsets.only(left: 16, right: 8),
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
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.secondaryText,
            label: 'Copy',
            onPressed: (BuildContext context) =>
                Clipboard.setData(ClipboardData(text: itemNote.content))
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.25,
        openThreshold: 0.35,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.red,
            label: 'Delete',
            onPressed: (BuildContext context) {
              final database = ref.read(AppDatabase.provider);
              database.deleteNote(itemNote);
            }
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1, color: AppColors.noteCardBorder))
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
    );
  }

  Container _newNoteInputBar() {
    return Container(
      constraints: const BoxConstraints(minHeight: 64, maxHeight: 180),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _newNoteInputField(),
          ),
          _newNoteInputButton(),
        ],
      ),
    );
  }

  TextButton _newNoteInputButton() {
    return TextButton(
      onPressed: () => _addNewNote(),
      child: const Text(
        'Save',
        style: TextStyle(color: AppColors.secondaryText),
      )
    );
  }

  TextField _newNoteInputField() {
    return TextField(
      controller: newNoteInputController,
      cursorColor: AppColors.cursorColor,
      cursorWidth: 7,
      maxLines: 6,
      minLines: 1,
      style: const TextStyle(
        color: AppColors.newNoteInputFieldText,
        fontSize: 18,
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(16),
        hintText: 'New Note...',
        hintStyle: TextStyle(
          color: AppColors.newNoteInputFieldHint,
          fontSize: 18,
        ),
        border: InputBorder.none,
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
