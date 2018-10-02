# My Thai Star Service Mesh
Configuration for deploying microservices of the OASP reference application "My Thai Star" on an Istio service mesh.

Microservices:
- [mts-booking-order](https://github.com/denniseffing/mts-booking-order)
- [mts-dishes](https://github.com/denniseffing/mts-dishes)
- [mts-frontend](https://github.com/denniseffing/mts-frontend)

The microservice implementation is **only for demonstrating the functionality of Istio** and is not under active development. It is based on [oasp/my-thai-star@9caedb](https://github.com/oasp/my-thai-star/commit/9caedb91eb3fe0d433f6d08e5cd72b7fbb8f25c3) and will not be updated in the future.

The configuration has been tested on the following environments:
- Minikube running Kubernetes 1.10.5 and Istio 1.0.2
- Google Kubernetes Engine with 4 nodes running Kubernetes 1.10.6-gke.4 and Istio 1.0.2

## How to use

1. Install Istio on Kubernetes and enable tracing, Kiali and Grafana.  
   Please disable Galley as it doesn't allow specifying a host:port combination for virtual services.  
   ```bash
   helm install ./install/kubernetes/helm/istio --name istio --namespace istio-system --set galley.enabled=false --set tracing.enabled=true --set=kiali.enabled=true --set=grafana.enabled=true
   ```  
   Check out the [Istio documentation](https://istio.io/docs/setup/kubernetes/quick-start/) for detailed installation instructions.

2. OPTIONAL: Apply service configuration for the Kiali dashboard.
   ```bash
   kubectl apply -f mts-app-deployment/kiali-services.yaml
   ```
   > NOTE: When deploying on minikube, you have to activate the ingress addon: `minikube addons enable ingress`  
   When deploying on GKE, you have to forward the port 20001 to the pod that runs Kiali. 

3. Deploy My Thai Star and apply the basic Istio routing configuration.  
   ```bash
   # Deploy My Thai Star
   kubectl apply -f mts-app-deployment/services/mts.yaml

   # Apply basic Istio routing configuration
   kubectl apply -f mts-app-deployment/routing-configuration/mts-ingress.yaml
   kubectl apply -f mts-app-deployment/routing-configuration/mts-virtualservice-ingress.yaml
   ```
4. Determine Istio ingress gateway `NODE_IP` and `NODE_PORT`. See [here](https://istio.io/docs/tasks/traffic-management/ingress/#determining-the-ingress-ip-and-ports) for further information.
5. Add Istio ingress gateway `NODE_IP` to hosts file using the domain mts.local.
6. Open up your browser at `http://mts.local:<NODE_PORT>` (Minikube) or http://mts.local (GKE).

> If you want to access the Kiali dashboard, you can reach it on http://mts.local when using Minikube or on http://localhost:20001 when using GKE.  

----
TODO: Documenation for advanced configurations.