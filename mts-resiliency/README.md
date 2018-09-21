## Resiliency config instructions

### Prerequisites
- Deploy base configuration of mts-app: `kubectl apply -f mts-app-deployment/services/mts.yaml`
- Apply mutual TLS to service mesh: `kubectl apply -f mts-app-deployment/mutual-tls.yaml`
- Delete destination rule mts-dishes-lb if it exists: `kubectl delete -f mts-load-balancing/mts-dishes-lb.yaml`

### Timeouts
- Apply timeout configuration: `kubectl apply -f mts-resiliency/mts-timeouts.yaml`

The booking order service will fail, if the request duration exceeds 3 seconds.
50% of the time, requests to the mts-dishes service are delayed by 200 milliseconds.  
The booking order timeout configuration and fault injection combined result in partial failure of the booking order service (roughly up to 10%). 

### Circuit Breaking
- Apply circuit breaker configuration: `kubectl apply -f mts-resiliency/mts-circuit-breaker.yaml`

The configuration applies a circuit breaker for the dishes service. The circuit breaker will trip, if:
- more than 100 HTTP requests are pending
- more than two concurrent requests are being made for a connection (HTTP 2)
- the service returns six consecutive errors in 30 seconds

The affected instance will be ejected for atleast 30 seconds. Only one instance will be ejected at the same time. 

The configuration also applies failures to v2 of the dishes service when accessed from the booking order service to test the circuit breaker configuration.  
After the circuit breaker has tripped, every request should start to work again, since the failure is not injected for v1.