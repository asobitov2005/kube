SHELL := /bin/bash
SERVICES := dotnet-api python-api node-api go-api java-api php-api ruby-api rust-api nginx-web caddy-web busybox-web
REGISTRY ?= ghcr.io/asobitov2005
TAG ?= local
ENV ?= dev
NAMESPACE ?= demo-$(ENV)
KIND_CLUSTER ?= kube-lab

.PHONY: help cluster build-all load-kind deploy-all remove-all render lint status

help:
	@echo "make cluster      - 3 node kind cluster yaratish"
	@echo "make build-all    - barcha image'larni build qilish"
	@echo "make load-kind    - image'larni kind clusterga yuklash"
	@echo "make deploy-all   - barcha servisni Helm bilan o'rnatish"
	@echo "                     ENV=dev|stage|prod bilan muhit tanlanadi"
	@echo "make status       - Pod va Service holatini ko'rish"
	@echo "make remove-all   - stateless servislarni o'chirish"
	@echo "make lint         - Helm chartlarni tekshirish"

cluster:
	kind create cluster --name $(KIND_CLUSTER) --config platform/kind-config.yaml

build-all:
	@set -e; for service in $(SERVICES); do \
		docker build -t $(REGISTRY)/kube-$$service:$(TAG) apps/$$service; \
	done

load-kind:
	@set -e; for service in $(SERVICES); do \
		kind load docker-image --name $(KIND_CLUSTER) $(REGISTRY)/kube-$$service:$(TAG); \
	done

deploy-all:
	@set -e; for service in $(SERVICES); do \
		helm upgrade --install $$service charts/web-service \
			-n $(NAMESPACE) --create-namespace \
			-f apps/$$service/values.yaml \
			-f environments/$(ENV)/common.yaml \
			--set image.repository=$(REGISTRY)/kube-$$service \
			--set-string image.tag=$(TAG) --wait --timeout 5m; \
	done

remove-all:
	@for service in $(SERVICES); do helm uninstall $$service -n $(NAMESPACE) 2>/dev/null || true; done

render:
	@set -e; for service in $(SERVICES); do \
		helm template $$service charts/web-service \
			-f apps/$$service/values.yaml \
			-f environments/$(ENV)/common.yaml >/dev/null; \
	done

lint:
	helm lint charts/web-service
	helm lint charts/postgresql-ha
	helm lint charts/rabbitmq-ha
	$(MAKE) render

status:
	kubectl get pods,services -n $(NAMESPACE) -o wide
