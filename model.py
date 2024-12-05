import cv2
import mediapipe as mp
import numpy as np

class PushUpCounter:
    def __init__(self):
        self.reset()  # 초기화 메서드 호출
        self.pose = None  # Pose 객체는 필요할 때 초기화

    def reset(self):
        """푸쉬업 카운터와 관련된 모든 상태 초기화"""
        self.count = 0
        self.direction = 0  # 0: 내려가기, 1: 올라가기
        self.down_threshold = 80  # 하강 기준 (각도)
        self.up_threshold = 160   # 상승 기준 (각도)

    def initialize_pose(self):
        """필요할 때 Pose 객체 초기화"""
        if self.pose is None:
            self.pose = mp.solutions.pose.Pose(
                static_image_mode=False,
                min_detection_confidence=0.5,
                min_tracking_confidence=0.5
            )

    def _calculate_angle(self, a, b, c):
        """어깨, 팔꿈치, 손목 좌표로 각도를 계산"""
        a, b, c = np.array(a), np.array(b), np.array(c)
        radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
        angle = np.abs(radians * 180.0 / np.pi)
        return 360 - angle if angle > 180.0 else angle

    def count_pushups(self, frame):
        """푸쉬업 카운트를 계산"""
        self.initialize_pose()  # 필요한 경우 Pose 초기화

        # 프레임을 RGB로 변환 및 Mediapipe 처리
        frame_height, frame_width = frame.shape[:2]
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = self.pose.process(image)

        if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark

            # 랜드마크 좌표 추출
            get_coords = lambda point: [
                landmarks[point.value].x * frame_width,
                landmarks[point.value].y * frame_height,
            ]
            shoulder = get_coords(mp.solutions.pose.PoseLandmark.LEFT_SHOULDER)
            elbow = get_coords(mp.solutions.pose.PoseLandmark.LEFT_ELBOW)
            wrist = get_coords(mp.solutions.pose.PoseLandmark.LEFT_WRIST)

            # 각도 계산
            angle = self._calculate_angle(shoulder, elbow, wrist)

            # 각도 변화에 따른 동작 감지
            if angle > self.up_threshold and self.direction == 1:
                self.direction = 0  # 내려감 상태로 전환
                self.count += 1     # 푸쉬업 성공 카운트
            elif angle < self.down_threshold and self.direction == 0:
                self.direction = 1  # 올라감 상태로 전환

        return self.count

    def release(self):
        """Mediapipe 리소스 해제"""
        if self.pose is not None:
            self.pose.close()
            self.pose = None  # 리소스 해제 후 None으로 설정
