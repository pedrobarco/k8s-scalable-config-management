import models.nginx.backend
import models.nginx.frontend

import manifests

frontToBack = lambda front: any, back: any, label: str -> [any] {
    _frontInstances = [inst for inst in front.instances() if typeof(inst) == label]
    [back(inst) for inst in _frontInstances]
}

serverOutput = lambda server: backend.Server {
    [
        server.deployment,
        server.service,
        server.configMap,
    ]
}

_servers = [serverOutput(server) for server in frontToBack(frontend.Server, backend.Server, "Server")]

_renderBackendInstances = [
    *_servers,
]

manifests.yaml_stream(_renderBackendInstances)
