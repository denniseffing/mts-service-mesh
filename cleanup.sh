SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# only ask if in interactive mode
if [[ -t 0 ]];then
  echo -n "namespace ? [default] "
  read NAMESPACE
fi

if [[ -z ${NAMESPACE} ]];then
  NAMESPACE=default
fi

echo "using NAMESPACE=${NAMESPACE}"

# Delete services
export OUTPUT=$(mktemp)
echo "Application cleanup may take up to one minute"
kubectl delete -n ${NAMESPACE} -f $SCRIPTDIR/mts-angular.yaml
kubectl delete -n ${NAMESPACE} -f $SCRIPTDIR/mts-java.yaml
ret=$?
function cleanup() {
  rm -f ${OUTPUT}
}

trap cleanup EXIT

echo "Application cleanup successful"