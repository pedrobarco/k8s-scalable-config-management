[package]
name = "dev"
edition = "v0.10.0"
version = "0.0.1"

[dependencies]
k8s-scalable-config-management = { path = "../../../../k8s-scalable-config-management" }

[profile]
entries = [
  "../base/base.k",
  "main.k",
  "${k8s_scalable_config_management:KCL_MOD}/models/nginx/render/render.k"
]
