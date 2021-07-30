provider "kubernetes-alpha" {
  config_path = "~/.kube/config"
}

resource "kubernetes_manifest" "daemonset_cert_manager_contour_envoy" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "DaemonSet"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "envoy"
      }
      "name" = "cert-manager-contour-envoy"
      "namespace" = "projectcontour"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app.kubernetes.io/component" = "envoy"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app.kubernetes.io/component" = "envoy"
          }
        }
        "spec" = {
          "containers" = [
            {
              "command" = [
                "contour",
              ]
              "image" = "docker.io/bitnami/contour:1.18.0-debian-10-r0"
              "livenessProbe" = {
                "failureThreshold" = 6
                "httpGet" = {
                  "path" = "/healthz"
                  "port" = 8090
                }
                "initialDelaySeconds" = 120
                "periodSeconds" = 20
                "successThreshold" = 1
                "timeoutSeconds" = 5
              }
              "name" = "shutdown-manager"
            },
            {
              "command" = [
                "envoy",
              ]
              "image" = "docker.io/bitnami/envoy:1.17.3-debian-10-r66"
              "lifecycle" = {
                "preStop" = {
                  "httpGet" = {
                    "path" = "/shutdown"
                    "port" = 8090
                    "scheme" = "HTTP"
                  }
                }
              }
              "livenessProbe" = {
                "failureThreshold" = 6
                "httpGet" = {
                  "path" = "/ready"
                  "port" = 8002
                }
                "initialDelaySeconds" = 120
                "periodSeconds" = 20
                "successThreshold" = 1
                "timeoutSeconds" = 5
              }
              "name" = "envoy"
            },
          ]
        }
      }
    }
  }
}
