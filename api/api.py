from flask import Flask
from flask_cors import CORS
import os

host = "192.168.114.165"
port = 5000
debug = False

app = Flask(__name__)
CORS(app)

##################################################
ip_mac = dict()
lines = os.popen("host -al csg486.tpia.in-addr.arpa 24.226.1.161| grep PTR | awk '{ print $1$5 }' | awk -F. '{ print $4\".\"$3\".\"$2\".\"$1\"-\"$9 }' | awk -F- '{ print $1\",\"$4$5$6$7$8$9}'").read().split('\n')
#Pour chaque ligne d'output en résultat de ma commande, je peuple mes dictionnaires avec les résultats mac/ip"
for line in lines:
    if(line != ''):
        ip_mac[line.split(',')[0]] = line.split(',')[1]
###################################################

@app.route('/', methods=["GET"])
def home():
    return True

@app.route('/<mac>', methods=["GET"])
##Fonction pour aller chercher les MAC et les IP associées. ##
def get_ip(mac):
    ip = ''
    if mac != '':
        for key in ip_mac.keys():
            value = ip_mac[key]
            if value == mac:
                ip = key
                return ip

app.run(host=host,port=port, debug=debug)
