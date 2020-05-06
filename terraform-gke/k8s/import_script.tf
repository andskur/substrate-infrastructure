resource "kubernetes_config_map" "import_script" {
  metadata { 
    name = "import-script"
  }

  data = {
    "import_keys.sh" = file("${path.module}/scripts/import_keys.sh")
  }
}
