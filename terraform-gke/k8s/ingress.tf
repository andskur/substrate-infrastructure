resource "kubernetes_ingress" "main_ingress" {
  metadata {
    name = "main-ingress"
  }

  spec {
    backend {
      service_name = "telemetry-frontend"
      service_port = 80
    }

//    rule {
//      http {
//        path {
//          backend {
//            service_name = "MyApp1"
//            service_port = 8080
//          }
//
//          path = "/telemetry/frontend*"
//        }
//
//        path {
//          backend {
//            service_name = "MyApp2"
//            service_port = 8080
//          }
//
//          path = "/telemetry/*"
//        }
//      }
//    }

//    tls {
//      secret_name = "tls-secret"
//    }
  }
}