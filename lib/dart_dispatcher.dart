library dart_dispatcher;

class Signal {
  List _connectionsList;
  
  Signal() : _connectionsList = new List();
  
  bool get hasConnections => !_connectionsList.isEmpty;
  
  noSuchMethod(InvocationMirror inv) {
    if (inv.isMethod && inv.memberName == 'emit') {
       return _forEachConnection((connection) {
         connection._emitArguments(inv.positionalArguments, inv.namedArguments);
      });
    }
    
    super.noSuchMethod(inv);
  }
  
  connect(Function slot) {
    _ConnectionImpl c = _createConnection(slot);
    _addConnection(c);
    return c;
  }
  
  _ConnectionImpl _createConnection(Function slot) {
    return new _ConnectionImpl(this, slot);
  }
  
  void _addConnection(_ConnectionImpl c) {
    _connectionsList.add(c);
  }
  
  void _removeConnection(_ConnectionImpl c) {
    assert(identical(c._source, this));
    if (!_connectionsList.contains(c)) {
      return;
    }
    _connectionsList.remove(c);
    c._source = null;
  }
  
  void _forEachConnection(void action(_ConnectionImpl subscription)) {
    if (!hasConnections) {
      return;
    }
    _connectionsList.forEach((_ConnectionImpl current) {
      action(current);
    });
  }
}

abstract class Connection {
  disconnect();
}

class _ConnectionImpl implements Connection {
  Signal _source;
  var _slot;
  
  _ConnectionImpl(this._source, this._slot);
  
  void disconnect() {
    _source._removeConnection(this);
  }
  
  void _emitArguments(List<dynamic> args, Map<dynamic, dynamic> namedArgs) {
    Function.apply(_slot, args, namedArgs);
  }
}