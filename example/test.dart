import 'dart:async';
import '../lib/dart_dispatcher.dart';

class Option {
  String _text;
  String _description;
  dynamic _value;
  
  Option();
  
  Signal textChanged = new Signal();
  
  Signal descriptionChanged = new Signal();
  
  Signal valueChanged = new Signal();
  
  String get text => _text;
  
  set text(String text) {
    if (identical(text, _text))
      return;
    
    _text = text;
    textChanged.emit(_text, sender: this);
  }
  
  String get description => _description;
  
  set description(String description) {
    if (identical(description, _description))
      return;
    
    _description = description;
    descriptionChanged.emit(_description, sender: this);
  }
  
  String get value => _value;
  
  set value(dynamic value) {
    if (identical(value, _value))
      return;
    
    _value = value;
    valueChanged.emit(_value, sender: this);
  }
}


main() {
  Option o1 = new Option();
  Option o2 = new Option();
  

  slotTextChanged(String text, {Object sender}) {
    Option o = sender as Option;
    String name = o == o1 ? "Option 1" : "Option 2";
    print("${name} text changed to \"${text}\"");
  }

  o1.textChanged.connect(slotTextChanged);
  o2.textChanged.connect(slotTextChanged);

  o2.text = "New Text";
  o1.text = "New Text";
}


