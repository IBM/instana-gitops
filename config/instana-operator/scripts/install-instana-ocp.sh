#! /bin/sh


if [ "$INSTANA_DOWNLOAD_KEY" = "" -o "$INSTANA_SALES_KEY" = ""  ] ; then
  echo "var INSTANA_DOWNLOAD_KEY, INSTANA_SALES_KEY not set yet and  exit."
  exit 1
fi
if [ "$INSTANA_LICENSE" = "" ] ; then
  echo "var INSTANA_LICENSE not set yet and  exit."
  exit 1
fi
if [ "$dbhost" = "" ] ; then
  echo "var dbhost not set yet and  exit."
  exit 1
fi
if [ "$storageClassName" = "" ] ; then
  echo "var storageClassName not set yet and  exit."
  exit 1
fi
if [ "$portalPassword" = "" ] ; then
  echo "var portalPassword not set and will use 'passw0rd' as default instana portal password ."
  portalPassword=passw0rd
fi

echo "prepare for installing ... "
./prepare.sh
sleep 3

helm install instana-operator --namespace=instana-operator \
    --set INSTANA_DOWNLOAD_KEY=$INSTANA_DOWNLOAD_KEY \
    --set INSTANA_SALES_KEY=$INSTANA_SALES_KEY   \
    --set INSTANA_LICENSE=$INSTANA_LICENSE \
    --set storageClassName=$storageClassName \
    --set dbhost=$dbhost \
    --set portalPassword=$portalPassword ../ 

# wait all pods running and goto ocp route to navigate to instana portal
echo "Now instana helm chart is installed, and you need to wait for all instana resources are created and ready, and this will take about 1 hour.

You can check progress of instana by running:
	oc get event -n instana-core
	oc get event -n instana-units
	iopod=$(oc get pod -n instana-operator | grep -e "^instana-operator-" | awk '{print $1}' )
	oc logs $ioppod -n instana-operator

After instana is deployed and all pods are running, you can run the command as follows to check:
	kubectl get core -A
	kubectl get unit -A
	kubectl get po -n instana-operator
	kubectl get po -n instana-core
	kubectl get po -n instana-units
"

echo 
echo "---------------------------------------------------------------------------------------------------------------------------------------------"
echo "
To login instana portal, in OCP portal, go to 'Routes', and Project select 'instana-core', then click 'gateway-unit' to navigate to instana.
In login UI,
    User name is 'admin@instana.local'
    Passowrd is set in env varable portalPassword, and if not set, then default is 'passw0rd'.
"

