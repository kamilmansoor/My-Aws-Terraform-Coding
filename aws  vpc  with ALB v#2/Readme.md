#Instructions to Remember while execution of aws vpc with ALB v#2


POINT#1:
#the port for the ALB-SG ingress needs to be same as of ALB-LISTNER, like here we used port "50" for both ALB-SG ingress and ALB-LISTNER


POINT#2:
##The port for ALB-target-group needs to be same as for ALB-target-group-attachment as well as for the ingress port of the instance(private_ec2) that is attach to ALB-target_group-attachment, like here we have used port "8081" for these three


#POINT#3:
We run a jenkins container inside our private Ec2 machine on host port 8081
docker run -d -p 8081:8080 --name container_name jenkins_image

######################################################################################3

On browser when we write ALB_DNS:50
http://my-application-lb-1682971174.us-east-1.elb.amazonaws.com:50
It will take you to the jenkins service service runing on port 8081 in private EC2 machine
