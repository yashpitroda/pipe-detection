from flask_cors import CORS #imp
from wsgiref.util import request_uri
from werkzeug.utils import secure_filename
from flask import Flask,request,jsonify
from flask_pymongo import PyMongo
from bson.json_util import dumps
from bson.objectid import ObjectId #_id value is genrate

from werkzeug.security import generate_password_hash, check_password_hash
import pymongo
import base64
from PIL import Image
from io import BytesIO
import uuid
import cv2
import numpy as np
import service

app=Flask(__name__)
CORS(app)
def generate_unique_filename():
    return str(uuid.uuid4())



# 5jNiTHJ1vDf9Ojd9
#------------------------
CONNECTION_STRING='mongodb+srv://yashpitroda06:5jNiTHJ1vDf9Ojd9@cluster0.w71rtgc.mongodb.net/?retryWrites=true&w=majority'
# Send a ping to confirm a successful connection
client =  pymongo.MongoClient(CONNECTION_STRING) 
database = client.get_database('pipe_detection') #create or inislize database


#------------------------

@app.route('/detectPipe',methods=['POST'])
def detectImage():
    
    value=request.get_json()
    base64_string = value["image"]
    requestImage=service.base64_to_image(base64_string)
    op,cnt=  service.pipe_detection_algo(requestImage)
    response_base64_string=service.image_to_base64(op)
    print(f'count is :${cnt}')
    res={'payload':{ "base64imageStirng":str(response_base64_string),"count":str(cnt),},}
    return jsonify(res),200

@app.route('/uploadImage',methods=['POST'])
def uploadImage():
    _value=request.get_json()
    _inputImageUrl = _value["inputImageUrl"]
    _outputImageUrl = _value["outputImageUrl"]
    _count = _value["count"]
    _date=_value["date"]
    id=database.prediction.insert_one({'inputImageUrl':_inputImageUrl,'outputImageUrl':_outputImageUrl,'count':_count,"date":_date})      
    resp=jsonify("sucess")
    print(id)
    return resp,200

@app.route('/fetchPrediction',methods=['POST'])
def fetchPrediction():
    c=database.prediction.find().sort("date",pymongo.DESCENDING)
    finalList=[]
    for data in c:
        temp={
            "id":str(ObjectId(data["_id"])),
            "inputImageUrl":data["inputImageUrl"],
            "outputImageUrl":data["outputImageUrl"],
            "count":data["count"],
            "date":data["date"],  
        }
        finalList.append(temp)
    # temp=dumps(c)
    
    
#   {
#     "_id": {
#       "$oid": "646f7b966eeccc2738251479"
#     },
#     "inputImageUrl": "https://firebasestorage.googleapis.com/v0/b/pipe-detection.appspot.com/o/images%2F4145b079-c709-4ae9-b725-fc9e179ab7cd.jpg?alt=media&token=2f44da1c-649f-40a8-a105-558d34d82c0a",
#     "outputImageUrl": "https://firebasestorage.googleapis.com/v0/b/pipe-detection.appspot.com/o/images%2F691e807b-ee1e-4942-b0b3-8ef8ba6056e2.jpg?alt=media&token=91f7bec4-a977-4f6c-9979-00e95220ed81",
#     "count": "287",
#     "date": "2023-05-25 20:45:22.825511"
#   }

   

    return {"payload": finalList},200

@app.route('/',methods=['GET'])
def index():
    return "hello"



# @app.errorhandler(404)
# def not_found(error=None):
#     massage={
#         'status':404,
#         'message':'not found'+request.uri
#     }
#     resp=jsonify(massage)
#     resp.status_code=404
#     return resp

if __name__ == "__main__":
   
    app.run(port=6000, debug=True,host='0.0.0.0')
    