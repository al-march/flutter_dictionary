import 'package:flutter/material.dart';

class SearchWord extends StatefulWidget {
  const SearchWord({
    super.key,
    required this.onSubmit,
  });

  final void Function(String word) onSubmit;

  @override
  State<SearchWord> createState() => _SearchWordState();
}

class _SearchWordState extends State<SearchWord> {
  final form = GlobalKey<FormState>();
  final input = TextEditingController();

  void submit() {
    var isValid = form.currentState!.validate();
    if (isValid) {
      var value = input.value.text;
      widget.onSubmit(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 80,
              child: TextFormField(
                controller: input,
                onEditingComplete: submit,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Введите слово',
                  helperText: ' ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Слово должно иметь название';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
            height: 55,
            child: AspectRatio(
              aspectRatio: 1,
              child: ElevatedButton(
                onPressed: submit,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    );
  }
}
