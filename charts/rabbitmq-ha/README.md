# RabbitMQ HA

Chart rasmiy RabbitMQ Cluster Operator’ning `RabbitmqCluster` resursidan foydalanadi. Har node uchun alohida PVC, quorum queue va node anti-affinity sozlanadi.

```bash
kubectl apply -f \
  https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml
kubectl rollout status deployment/rabbitmq-cluster-operator -n rabbitmq-system
helm upgrade --install rabbitmq charts/rabbitmq-ha \
  -n messaging-dev --create-namespace \
  -f charts/rabbitmq-ha/values.yaml \
  -f environments/dev/rabbitmq.yaml --wait
```

Production uchun:

```bash
helm upgrade --install rabbitmq charts/rabbitmq-ha -n messaging-prod --create-namespace \
  -f charts/rabbitmq-ha/values.yaml \
  -f environments/prod/rabbitmq.yaml --wait
```

Credential va tekshiruv:

```bash
kubectl get rabbitmqcluster,pod,pvc -n messaging-dev
kubectl get secret rabbitmq-default-user -n messaging-dev -o jsonpath='{.data.username}' | base64 -d; echo
kubectl get secret rabbitmq-default-user -n messaging-dev -o jsonpath='{.data.password}' | base64 -d; echo
kubectl port-forward -n messaging-dev service/rabbitmq 15672:15672
```

AMQP manzil: `rabbitmq.messaging-dev.svc.cluster.local:5672`. Management UI: `http://localhost:15672`.

Uch brokerning o‘zi xabarni saqlab qolishga kafolat emas: producer persistent message va publisher confirm ishlatishi, queue esa durable/quorum bo‘lishi kerak. StorageClass real replika va backup siyosatiga ega bo‘lishi kerak.
