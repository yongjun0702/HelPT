import cv2
import mediapipe as mp
import numpy as np

mp_pose = mp.solutions.pose
pose = mp_pose.Pose()
mp_drawing = mp.solutions.drawing_utils

class PushUpCounter:
    def __init__(self):
        self.count = 0
        self.direction = 0  # 0: 내려가기, 1: 올라가기
        self.down_threshold = 80
        self.up_threshold = 160

    def calculate_angle(self, a, b, c):
        a = np.array(a)  # 어깨 좌표
        b = np.array(b)  # 팔꿈치 좌표
        c = np.array(c)  # 손목 좌표

        radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
        angle = np.abs(radians * 180.0 / np.pi)

        if angle > 180.0:
            angle = 360 - angle

        return angle

    def count_pushups(self, frame):
        # 프레임을 RGB로 변환하여 처리
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = pose.process(image)

        if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark

            # 어깨, 팔꿈치, 손목 좌표 추출
            shoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,
                        landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
            elbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,
                     landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
            wrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,
                     landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]

            # 팔의 각도 계산
            angle = self.calculate_angle(shoulder, elbow, wrist)

            # 푸시업 동작 감지
            if angle > self.up_threshold and self.direction == 1:
                self.direction = 0  # 내려감
                self.count += 1
            elif angle < self.down_threshold and self.direction == 0:
                self.direction = 1  # 올라감

        return self.count