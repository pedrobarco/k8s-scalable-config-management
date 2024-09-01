import k8s_scalable_config_management.models.vm.frontend

agent: frontend.Agent {
    spec: {
        replicaCount = 5
        scrapeInterval = "2m"
    }
}
