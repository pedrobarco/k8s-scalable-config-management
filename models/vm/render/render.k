import models.vm.backend
import models.vm.frontend

import manifests

frontToBack = lambda front: any, back: any, label: str -> [backend.Agent] {
    _frontInstances = [inst for inst in front.instances() if typeof(inst) == label]
    [back(inst) for inst in _frontInstances]
}

agentOutput = lambda agent: backend.Agent {
    [
        agent.deployment,
        agent.service,
    ]
}

_agents = [agentOutput(agent) for agent in frontToBack(frontend.Agent, backend.Agent, "Agent")]

_renderBackendInstances = [
    *_agents,
]

manifests.yaml_stream(_renderBackendInstances)
