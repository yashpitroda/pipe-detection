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
async def detectImage():
    
    value=request.get_json()
    base64_string = value["image"]
    requestImage=service.base64_to_image(base64_string)
    op,cnt= await service.pipe_detection_algo(requestImage)
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
    id=database.userm.insert_one({'inputImageUrl':_inputImageUrl,'outputImageUrl':_outputImageUrl,'count':_count})      
    resp=jsonify("sucess")
    print(id)
    return resp,200

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
    