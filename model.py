import cv2
import mediapipe as mp
import numpy as np
import time

class PushUpCounter:
    def __init__(self):
        self.count = 0
        self.direction = 0  # 0: 내려가기, 1: 올라가기
        self.down_threshold = 50  # 하강 기준 (픽셀 값)
        self.up_threshold = 20    # 상승 기준 (픽셀 값)
        self.prev_shoulder_y = None  # 이전 어깨 위치 (초기화)
        self.pose = mp.solutions.pose.Pose(static_image_mode=False, min_detection_confidence=0.5, min_tracking_confidence=0.5)
        self.last_timestamp = time.time()  # 마지막 타임스탬프

    def count_pushups(self, frame):
        # 프레임 해상도
        frame_height, frame_width = frame.shape[:2]

        # 프레임을 RGB로 변환
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = self.pose.process(image)

        if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark

            # 왼쪽, 오른쪽 어깨의 y 좌표 계산
            left_shoulder_y = landmarks[mp.solutions.pose.PoseLandmark.LEFT_SHOULDER.value].y * frame_height
            right_shoulder_y = landmarks[mp.solutions.pose.PoseLandmark.RIGHT_SHOULDER.value].y * frame_height

            # 평균 어깨 y 좌표 계산
            shoulder_y = (left_shoulder_y + right_shoulder_y) / 2

            # 초기 이전 어깨 위치 설정
            if self.prev_shoulder_y is None:
                self.prev_shoulder_y = shoulder_y
                return self.count  # 초기화 상태에서 카운트는 변경하지 않음

            # 어깨 y축 변화량 계산
            delta_y = shoulder_y - self.prev_shoulder_y

            # 노이즈 필터링 (변화량이 일정 기준 이상일 때만 동작 감지)
            if abs(delta_y) > 5:
                if delta_y > self.down_threshold and self.direction == 1:
                    self.direction = 0  # 내려감
                    self.count += 1
                elif delta_y < -self.up_threshold and self.direction == 0:
                    self.direction = 1  # 올라감

                # 이전 어깨 위치 업데이트
                self.prev_shoulder_y = shoulder_y

        return self.count

    def release(self):
        """Mediapipe 리소스 해제"""
        self.pose.close()
