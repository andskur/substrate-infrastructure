resource "kubernetes_config_map" "chainspec" {
  metadata { 
    name = "chainspec"
  }

  data = {
    "chainSpecRaw.json" = file("${path.module}/chainSpec/chainSpecRaw.json")
  }
}
