import 'package:flutter/material.dart';
import 'timetable_data.dart';

class AttendanceScreen extends StatefulWidget {
  final String userType;
  final String username;

  const AttendanceScreen({
    super.key,
    this.userType = 'Student',
    this.username = '',
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String selectedMethod = 'Face';
  final TextEditingController facultyController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final DateTime _now = DateTime.now();
    final String _hh = _now.hour.toString().padLeft(2, '0');
    final String _mm = _now.minute.toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        backgroundColor: widget.userType == 'Student'
            ? const Color.fromARGB(255, 79, 243, 33)
            : const Color.fromARGB(255, 244, 54, 158),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student banner only (faculty selection removed as per requirement)
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 79, 243, 33),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade800),
                ),
                child: const Center(
                  child: Text(
                    'Student Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Today periods quick view
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today: ${TimetableData.todayName()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(7, (i) {
                        final p = i + 1;
                        final subj = TimetableData.periodsForDay(
                          TimetableData.todayName(),
                        )[i];
                        final time = TimetableData.periodTimes[p] ?? '';
                        final bool isCurrent = TimetableData.isNowWithinPeriod(
                          p,
                          TimeOfDay.now(),
                        );
                        return OutlinedButton(
                          onPressed: () {
                            subjectController.text = subj != '-'
                                ? subj
                                : subjectController.text;
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isCurrent
                                ? Colors.green.shade100
                                : null,
                            side: BorderSide(
                              color: isCurrent ? Colors.green : Colors.orange,
                            ),
                            minimumSize: const Size(100, 44),
                          ),
                          child: Text(
                            'P$p\n$time\n$subj',
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Date and Time Display
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Time: ${_hh}:${_mm}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Class Information
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Class Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Faculty field removed
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        prefixIcon: Icon(Icons.book),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Attendance Method Selection
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mark Attendance Method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => selectedMethod = 'Face'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: selectedMethod == 'Face'
                                    ? Colors.blue
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedMethod == 'Face'
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.face,
                                    size: 40,
                                    color: selectedMethod == 'Face'
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Face',
                                    style: TextStyle(
                                      color: selectedMethod == 'Face'
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => selectedMethod = 'Biometric'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: selectedMethod == 'Biometric'
                                    ? Colors.green
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedMethod == 'Biometric'
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.fingerprint,
                                    size: 40,
                                    color: selectedMethod == 'Biometric'
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Biometric',
                                    style: TextStyle(
                                      color: selectedMethod == 'Biometric'
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Mark Attendance Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final bool isValid =
                        subjectController.text.isNotEmpty &&
                        locationController.text.isNotEmpty;
                    if (isValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Attendance marked successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill all class information fields',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.userType == 'Student'
                        ? const Color.fromARGB(255, 79, 243, 33)
                        : const Color.fromARGB(255, 244, 54, 158),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Mark Attendance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
