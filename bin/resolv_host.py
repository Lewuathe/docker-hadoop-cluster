#!/usr/bin/env python

import sys
import subprocess
import json

def exec_process(cmd):
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout_data, stderr_data = p.communicate()
    return p.returncode, stdout_data, stderr_data

def get_ipaddress(host):
    (code, out, err) = exec_process('sudo docker inspect {}'.format(host))
    conf = json.loads(out)
    return conf[0]['NetworkSettings']['IPAddress'] 

if __name__ == "__main__":
    argvs = sys.argv
    for h in range(0, int(argvs[1])):
        print("{}\tdn{}".format(get_ipaddress('dn' + str(h + 1)), h + 1))
        print("{}\tdn{}.bridge".format(get_ipaddress('dn' + str(h + 1)), h + 1))
      
