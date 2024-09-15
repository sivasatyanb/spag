import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final String hint;
  final List<String> options;
  final Function(String) onSelected;
  const Dropdown({
    super.key,
    required this.hint,
    required this.options,
    required this.onSelected,
  });
  @override
  State<Dropdown> createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  String _selectedOption = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffCF4520),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: const Color(0xffCF4520),
          value: _selectedOption.isEmpty ? null : _selectedOption,
          hint: Text(
            widget.hint,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(
              () {
                _selectedOption = newValue ?? '';
                widget.onSelected(_selectedOption);
              },
            );
          },
          items: widget.options.map<DropdownMenuItem<String>>(
            (String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
