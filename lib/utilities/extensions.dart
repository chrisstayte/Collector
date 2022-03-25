extension doubleExtensions on double {
  String cardinalDirection() {
    if (this > 337.5 || this <= 22.5) {
      return '${this.round()} N';
    } else if (this > 22.5 && this <= 67.5) {
      return '${this.round()} NE';
    } else if (this > 67.5 && this <= 112.5) {
      return '${this.round()} E';
    } else if (this > 112.5 && this <= 157.5) {
      return '${this.round()} SE';
    } else if (this > 157.5 && this <= 202.5) {
      return '${this.round()} S';
    } else if (this > 202.5 && this <= 247.5) {
      return '${this.round()} SW';
    } else if (this > 247.5 && this <= 292.5) {
      return '${this.round()} W';
    } else {
      return '${this.round()} NW';
    }
  }
}
