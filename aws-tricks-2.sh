#!/bin/bash
##############################################################
#
# M0sC0 tricks
#
##############################################################
# Variables
ARG1=$1
ARG2=$2
ARGC=$#
USER="mosco"
PASS="r3dh4tO1"
# Functions
get_help() {
    echo "---------------------------------------------------------------------------------------"
    echo "Recuperando las credenciales de consola web de opentlc y otras yerbas"
    echo "---------------------------------------------------------------------------------------"
    echo "Params:"
    echo "        aws-mosco.sh "
    echo ""
    echo "Sub Commands:"
    echo ""
    echo "         help"
    echo "         mosco-efs"
    echo "---------------------------------------------------------------------------------------"
}
# Main
if [[ $ARGC -eq 0 ]] ; then
    mkdir -p .aws
    AWS_KEY=$(oc get secret aws-creds  -n kube-system -o yaml | grep aws_access_key_id |awk -F ': ' '{print $2}'| base64 -d)
    AWS_SECRET=$(oc get secret aws-creds  -n kube-system -o yaml | grep aws_secret_access_key |awk -F ': ' '{print $2}' | base64 -d)
    (echo "[default]"; echo "aws_access_key_id = ${AWS_KEY}"; echo "aws_secret_access_key = ${AWS_SECRET}") > .aws/credentials
    (echo "[default]"; echo "aws_access_key_id = ${AWS_KEY}"; echo "aws_secret_access_key = ${AWS_SECRET}") > .aws/credentials
    (echo "[default]"; echo "region = us-east-2";) > .aws/config
    (echo "Creo iam role";    aws iam create-user --user-name ${USER};)
    (echo "Creo iam role";    aws iam create-login-profile --user-name ${USER} --password ${PASS};)
    (echo "Creo iam group";   aws iam create-group --group-name admin;)
    (echo "Add role to user";  aws iam add-user-to-group --user-name ${USER} --group admin;)
    (echo "Add admin policy to group";  aws iam attach-group-policy --group-name admin --policy-arn arn:aws:iam::aws:policy/AdministratorAccess;)
    (echo "Show Account ID:";  aws sts get-caller-identity --query "Account" --output text;)
    (echo "https://console.aws.amazon.com/console/home?nc2=h_ct&src=header-signin"; echo "User: ${USER} Password: ${PASS}";)
elif [[ $ARG1 == "mosco-efs" ]] ; then
    fsid=$(aws efs create-file-system | grep -i filesystemid  | awk '{print $2}' | sed s/\",/\"/g)
    echo $fsid
    (echo "kind: StorageClass";echo "apiVersion: storage.k8s.io/v1";echo "metadata:";echo "  name: efs-sc";echo "provisioner: efs.csi.aws.com";echo "parameters:";echo "  provisioningMode: efs-ap ";echo "  fileSystemId: ${fsid}";echo "  directoryPerms: \"700\" ";echo "  gidRangeStart: \"1000\"" ;echo "  gidRangeEnd: \"2000\" ";echo "  basePath: \"/dynamic_provisioning\" ";) > efs-sc.yml
    salida=$(oc create -f efs-sc.yml)
    echo $salida
    echo "Instalar el operador de EFS en OCP usando este link https://docs.openshift.com/container-platform/4.9/storage/container_storage_interface/persistent-storage-csi-aws-efs.html";
else
    get_help
fi

echo ${AWS_KEY}
echo ${AWS_SECRET}
