
import base64
import cv2
import numpy as np

def base64_to_image(base64_string):
    image_bytes = base64.b64decode(base64_string)
    image_array = np.frombuffer(image_bytes, np.uint8)
    image = cv2.imdecode(image_array, cv2.IMREAD_COLOR)
    return image

def image_to_base64(image):
    image_array = cv2.imencode('.jpg', image)[1].tobytes()
    base64_string = base64.b64encode(image_array).decode('utf-8')
    return base64_string
    
 
def pipe_detection_algo(image):
    output=image
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    imgBlur = cv2.GaussianBlur(gray, (5, 5), 16) #16 or 1 // ADD GAUSSIAN BLUR
    count=0
    circles = cv2.HoughCircles(imgBlur,cv2.HOUGH_GRADIENT, 1, 15, param1 = 100,param2 = 20, minRadius = 0, maxRadius = 20)
    if circles is not None:
        circles = np.round(circles[0, :]).astype("int")
        for (x, y, r) in circles:
            count=count+1
            cv2.circle(output, (x, y), r, (0, 255, 0), 3)
            cv2.rectangle(output, (x - 3, y - 3), (x + 3, y + 3), (0, 128, 255), -1)
    return output,count


   



