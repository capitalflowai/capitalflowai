import json
import os
pwd = os.getcwd()
f = open(pwd+"/others/dataFetch.json",'r')
data = json.load(f)
print(len(data['Payload'][0]['data'][0]['decryptedFI']['account']['transactions']['transaction']))