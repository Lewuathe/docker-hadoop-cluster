#!/usr/bin/env python

import time
from optparse import OptionParser
import boto3
from fabric.api import local

def launch(key_name, security_group, subnet_id):
    client = boto3.client('ec2')
    response = client.run_instances(
        ImageId = 'ami-f5f41398',
        MinCount = 1,
        MaxCount = 1,
        KeyName = key_name,
        SecurityGroupIds = [security_group],
        InstanceType = 'm4.xlarge',
        SubnetId = subnet_id,
        BlockDeviceMappings = [
            {
                'DeviceName': '/dev/xvda',
                'Ebs': {
                    'VolumeSize': 80,
                    'DeleteOnTermination': True,
                    'VolumeType': 'gp2'
                }
            }
        ]
    )
    instance_id = response['Instances'][0]['InstanceId']
    waiter = client.get_waiter('instance_status_ok')
    waiter.wait(
        InstanceIds = [instance_id]
    )
    response = client.describe_instances(
        InstanceIds = [
            instance_id
        ]
    )
    public_ip = response['Reservations'][0]['Instances'][0]['PublicIpAddress']
    local("fab -f ./ec2/fabfile.py -i ~/.ssh/{}.pem -u ec2-user -H {} deploy".format(key_name, public_ip))
    print('Succeed to launch instance')
    print('    InstanceId: {}, PublicIp: {}'.format(instance_id, public_ip))
    print('Login')
    print('    ssh -i ~/.ssh/{}.pem ec2-user@{}'.format(key_name, public_ip))

def terminate(instance_id):
    client = boto3.client('ec2')
    client.terminate_instances(
        InstanceIds = [instance_id]
    )

if __name__ == "__main__":
    parser = OptionParser()
    parser.add_option('-k', '--key-name',
      dest='key_name', help='Specify key name to login the instance')
    parser.add_option('-s', '--security-group',
      dest='security_group', help='Specify security group to launch instance')
    parser.add_option('-n', '--subnet-id',
      dest='subnet_id', help='Specify subnet_id')
    parser.add_option('-i', '--instance',
      dest='instance_id', help='Specify instance id')

    (options, args) = parser.parse_args()

    if args[0] == 'launch':
        launch(key_name=options.key_name, security_group=options.security_group, subnet_id=options.subnet_id)
    elif args[0] == 'terminate':
        terminate(options.instance_id)
