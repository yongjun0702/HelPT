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
        self.down_threshold = 50  # 하강 시 어깨의 y축 절대 이동 기준 (픽셀 값)
        self.up_threshold = 20    # 상승 시 어깨의 y축 절대 이동 기준 (픽셀 값)
        self.prev_shoulder_y = None

    def count_pushups(self, frame):
        # 프레임 해상도
        frame_height, frame_width = frame.shape[:2]

        # 프레임을 RGB로 변환하여 Mediapipe로 처리
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = pose.process(image)

        if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark

            # 어깨의 y 좌표 절대 위치 계산
            shoulder_y = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y * frame_height

            # 초기 이전 어깨 위치 설정
            if self.prev_shoulder_y is None:
                self.prev_shoulder_y = shoulder_y

            # 어깨 y축 변화량 계산
            delta_y = shoulder_y - self.prev_shoulder_y

            # 푸시업 동작 감지
            if delta_y > self.down_threshold and self.direction == 1:
                self.direction = 0  # 내려감
                self.count += 1
            elif delta_y < -self.up_threshold and self.direction == 0:
                self.direction = 1  # 올라감

            # 현재 어깨 y 좌표를 이전 값으로 저장
            self.prev_shoulder_y = shoulder_y

        return self.count
