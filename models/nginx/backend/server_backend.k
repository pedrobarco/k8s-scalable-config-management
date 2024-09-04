import k8s.api.apps.v1 as apps
import k8s.api.core.v1 as core
import models.nginx.frontend
import file

schema Server[inputConfig: frontend.Server]:
    config: frontend.Server = inputConfig

    _index_html: str = file.read(file.abs(file.current() + "/../index.html"))

    configMap: core.ConfigMap = {
        metadata.name = "nginx"
        metadata.annotations = {
            "kapp.k14s.io/versioned": ""
        }
        data = {
            "index.html" = _index_html.format(config.welcomeMessage)
        }
    }

    deployment: apps.Deployment = {
        metadata.name = "nginx"
        metadata.labels = {
            app = metadata.name
        }
        spec: {
            replicas = 1
            selector.matchLabels = metadata.labels
            template: {
                metadata.labels = metadata.labels
                spec.containers = [{
                    name = metadata.labels.app
                    image = "nginx:1.14.2"
                    ports: [{
                        containerPort = 80
                    }]
                    volumeMounts = [{
                        name = "index-html"
                        mountPath = "/usr/share/nginx/html"
                    }]
                }]
                spec.volumes = [{
                    name = "index-html"
                    configMap = {
                        name = configMap.metadata.name
                    }
                }]
            }
        }
    }

    service: core.Service = {
        metadata.name = "nginx"
        metadata.labels = {
            app = metadata.name
        }
        spec: {
            selector = metadata.labels
            ports: [{
                port = 80
                targetPort = 80
            }]
            type = "ClusterIP"
        }
    }
