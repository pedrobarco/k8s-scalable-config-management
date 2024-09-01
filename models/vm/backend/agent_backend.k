import k8s.api.apps.v1 as apps
import k8s.api.core.v1 as core
import models.vm.frontend

schema Agent[inputConfig: frontend.Agent]:
    config: frontend.Agent = inputConfig

    deployment: apps.Deployment = {
        metadata.name = "vmagent"
        metadata.labels = {
            app = metadata.name
        }
        spec: {
            replicas = config.spec.replicaCount
            selector.matchLabels = metadata.labels
            template: {
                metadata.labels = metadata.labels
                spec.containers = [{
                    name = metadata.labels.app
                    image = "nginx:1.14.2"
                    ports: [{
                        containerPort = 80
                    }]
                }]
            }
        }
    }

    service: core.Service = {
        metadata.name = "vmagent"
        metadata.labels = {
            app = metadata.name
        }
        spec: {
            selector = metadata.labels
            ports: [{
                port = 80
                targetPort = 80
            }]
            type = "LoadBalancer"
        }
    }
