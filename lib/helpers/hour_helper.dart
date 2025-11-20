class HourHelper {
    static int hourToMinute(String hour) {
        List<String> splitHour = hour.split(':');
        int h = int.parse(splitHour[0]);
        int m = int.parse(splitHour[1]);

        return (h * 60) + m ?? 0;
    }

    static String minutesToHour(int minutes) {
        int h = minutes ~/ 60;
        int m = minutes % 60;

        return "${h.toString().padLeft(2, '0')}:{$m.toString().padLeft(2, '0'),}";
    }
} 