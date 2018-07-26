Configuration for deploying the OASP reference application "My Thai Star" on Istio service mesh running on Kubernetes.

# How to use

1. Install Istio on Kubernetes with automatic sidecar injection enabled.
2. OPTIONAL: Deploy Vistio on Kubernetes for service mesh visualization.
3. Deploy My Thai Star on Kubernetes.
4. Determine Istio ingress gateway `NODE_IP` and `NODE_PORT`. See [here](https://istio.io/docs/tasks/traffic-management/ingress/#determining-the-ingress-ip-and-ports) for further information.
5. Add Istio ingress gateway `NODE_IP` to hosts file with domains mts.local (and vistio.local).
6. Open up your browser at `http://mts.local:<NODE_PORT>`.

## 1. Install Istio on Kubernetes
I recommend using Helm for installing Istio on Kubernetes. Look up the [Istio Helm installation guide](https://istio.io/docs/setup/kubernetes/helm-install/) for detailed instructions.

## 2. OPTIONAL: Deploy Vistio on Kubernetes
```bash
# Deploy Vistio on Kubernetes cluster
kubectl apply -f vistio-with-ingress.yaml

# Configure default ingress gateway
kubectl apply -f ingress-gateway.yaml

# Setup virtual service routing vistio.local to Vistio services
kubectl apply -f vistio-virtualservice.yaml
```

## 3. Deploy My Thai Star on Kubernetes
```bash
# Deploy single page application frontend
kubectl apply -f mts-angular.yaml

# Deploy microservice for handling bookings and reservations
kubectl apply -f mts-java.yaml

# Deploy microservice for handling dishes
kubectl apply -f mts-dishes.yaml

# Configure default ingress gateway (if you skipped step 2)
kubectl apply -f ingress-gateway.yaml

# Setup virtual service routing mts.local to My Thai Star services
kubectl apply -f mts-virtualservice.yaml
```
