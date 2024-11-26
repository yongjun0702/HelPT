import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:helpt/config/color.dart';

class ExerciseResultWidget extends StatefulWidget {
  const ExerciseResultWidget({Key? key}) : super(key: key);

  @override
  _ExerciseResultWidgetState createState() => _ExerciseResultWidgetState();
}

class _ExerciseResultWidgetState extends State<ExerciseResultWidget> {
  String _sortOrder = '최신순'; // 초기 정렬 순서

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "내 운동 현황",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HelPT.subBlue,
                ),
              ),
              // 드롭다운 버튼은 운동 기록이 있는 경우에만 표시
              StreamBuilder<QuerySnapshot>(
                stream: _getExerciseRecordsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return SizedBox.shrink(); // 빈 공간으로 대체
                  }
                  return DropdownButton<String>(
                    value: _sortOrder,
                    items: ['최신순', '오래된순'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HelPT.mainBlue,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _sortOrder = newValue!;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
        // 운동 기록 리스트
        Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: _getExerciseRecordsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    '운동 기록이 없습니다.',
                    style: TextStyle(
                      color: HelPT.lightgrey3,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              // Firestore 데이터 정렬
              final records = snapshot.data!.docs;
              records.sort((a, b) {
                final dataA = a.data() as Map<String, dynamic>;
                final dataB = b.data() as Map<String, dynamic>;
                final dateA = _parseDate(dataA['start_time']);
                final dateB = _parseDate(dataB['start_time']);
                return _sortOrder == '최신순'
                    ? dateB.compareTo(dateA)
                    : dateA.compareTo(dateB);
              });

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index].data() as Map<String, dynamic>;
                  final recordId = records[index].id;

                  // 기록 정보
                  final startTime = record['start_time'] ?? '';
                  final endTime = record['end_time'] ?? '진행 중';
                  final pushupCount = record['pushup_count'] ?? 0;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: HelPT.tapBackgroud,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: HelPT.mainBlue,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "시작 시간: ${_formatDateTime(startTime)}",
                          style: TextStyle(
                            fontSize: 16,
                            color: HelPT.lightgrey3,
                          ),
                        ),
                        Text(
                          "종료 시간: ${endTime != '진행 중' ? _formatDateTime(endTime) : endTime}",
                          style: TextStyle(
                            fontSize: 16,
                            color: HelPT.lightgrey3,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "푸쉬업 횟수: $pushupCount 회",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: HelPT.mainBlue,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete_forever, color: HelPT.subBlue),
                              onPressed: () => _deleteRecord(recordId),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
  // Firestore에서 운동 기록을 가져오는 스트림
  Stream<QuerySnapshot> _getExerciseRecordsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('exercise_sessions')
          .snapshots();
    }
    return const Stream.empty();
  }

  // Firestore에서 기록 삭제
  Future<void> _deleteRecord(String recordId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('exercise_sessions')
            .doc(recordId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('기록이 삭제되었습니다.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('기록 삭제 실패: $e')),
        );
      }
    }
  }

  // 날짜 및 시간 포맷팅
  String _formatDateTime(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('yyyy년 M월 d일 H시 m분').format(dateTime);
    } catch (e) {
      return '잘못된 날짜';
    }
  }

  DateTime _parseDate(String? date) {
    if (date == null || date.isEmpty) return DateTime(0);
    try {
      return DateTime.parse(date);
    } catch (e) {
      return DateTime(0);
    }
  }
}