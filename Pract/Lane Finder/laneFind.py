import cv2
import numpy as np

def readInput(fileHandle):
    video = cv2.VideoCapture(fileHandle)
    print (video)
    return video
    
fileHandle = "input.mp4"
video = readInput(fileHandle)
cv2.imshow('Raw', video.grab())

