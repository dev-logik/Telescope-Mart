abstract final class TelescopeUtils {
  static const String _equitorial = 'Equitorial';
  static const String _altazimuth = 'Altazimuth';
  static const String _refractor = 'Refractor';
  static const String _reflector = 'Reflector';
  static const String _catadioptric = 'Catadioptric';
  static const String _autoFOcus = 'Auto Focus';
  static const String _manualFocus = 'Manual Focus';
  static const String _autoAndManualFocus = 'Auto & Manual Focus';
  static const mountList = [_equitorial, _altazimuth];
  static const typeList = [_reflector, _refractor, _catadioptric];
  static const focusList = [_autoAndManualFocus, _autoFOcus, _manualFocus];
}

const String telescopeImageDirectory = "telescopes";
const String currencySymbol = '\$';
