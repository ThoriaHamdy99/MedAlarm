class MedicineType{
  static String pill = 'assets/medicine_icons/pill.jpg';
  static String solution = 'assets/medicine_icons/solutions.jpg';
  static String injection = 'assets/medicine_icons/injections.png';
  static String powder = 'assets/medicine_icons/powder.png';
  static String drops = 'assets/medicine_icons/drops.png';
  static String other = 'assets/medicine_icons/other.jpg';

  String getMedIcon(String medType){
    if(medType == 'pill') return pill;
    else if(medType == 'solution') return solution;
    else if(medType == 'injection') return injection;
    else if(medType == 'powder') return powder;
    else if(medType == 'drops') return drops;
    else if(medType == 'other') return other;
  }
}