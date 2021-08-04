provider "kubernetes-alpha" {
  config_path = "~/.kube/config"
}

resource "kubernetes_manifest" "customresourcedefinition_certificaterequests_cert_manager_io" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "cert-manager.io/inject-ca-from-secret" = "cert-manager/cert-manager-webhook-ca"
      }
      "labels" = {
        "app" = "cert-manager"
        "app.kubernetes.io/instance" = "cert-manager"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name" = "cert-manager"
        "helm.sh/chart" = "cert-manager-v1.4.1"
      }
      "name" = "certificaterequests.cert-manager.io"
    }
    "spec" = {
      "conversion" = {
        "strategy" = "Webhook"
        "webhook" = {
          "clientConfig" = {
            "service" = {
              "name" = "cert-manager-webhook"
              "namespace" = "cert-manager"
              "path" = "/convert"
            }
          }
          "conversionReviewVersions" = [
            "v1",
            "v1beta1",
          ]
        }
      }
      "group" = "cert-manager.io"
      "names" = {
        "categories" = [
          "cert-manager",
        ]
        "kind" = "CertificateRequest"
        "listKind" = "CertificateRequestList"
        "plural" = "certificaterequests"
        "shortNames" = [
          "cr",
          "crs",
        ]
        "singular" = "certificaterequest"
      }
      "scope" = "Namespaced"
      "versions" = [
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Approved\")].status"
              "name" = "Approved"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Denied\")].status"
              "name" = "Denied"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Ready\")].status"
              "name" = "Ready"
              "type" = "string"
            },
            {
              "jsonPath" = ".spec.issuerRef.name"
              "name" = "Issuer"
              "type" = "string"
            },
            {
              "jsonPath" = ".spec.username"
              "name" = "Requestor"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Ready\")].message"
              "name" = "Status"
              "priority" = 1
              "type" = "string"
            },
            {
              "description" = "CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC."
              "jsonPath" = ".metadata.creationTimestamp"
              "name" = "Age"
              "type" = "date"
            },
          ]
          "name" = "v1alpha2"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = <<-EOT
              A CertificateRequest is used to request a signed certificate from one of the configured issuers.
               All fields within the CertificateRequest's `spec` are immutable after creation. A CertificateRequest will either succeed or fail, as denoted by its `status.state` field.
               A CertificateRequest is a one-shot resource, meaning it represents a single point in time request for a certificate and cannot be re-used.
              EOT
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Desired state of the CertificateRequest resource."
                  "properties" = {
                    "csr" = {
                      "description" = "The PEM-encoded x509 certificate signing request to be submitted to the CA for signing."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "duration" = {
                      "description" = "The requested 'duration' (i.e. lifetime) of the Certificate. This option may be ignored/overridden by some issuer types."
                      "type" = "string"
                    }
                    "extra" = {
                      "additionalProperties" = {
                        "items" = {
                          "type" = "string"
                        }
                        "type" = "array"
                      }
                      "description" = "Extra contains extra attributes of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "object"
                    }
                    "groups" = {
                      "description" = "Groups contains group membership of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "items" = {
                        "type" = "string"
                      }
                      "type" = "array"
                      "x-kubernetes-list-type" = "atomic"
                    }
                    "isCA" = {
                      "description" = "IsCA will request to mark the certificate as valid for certificate signing when submitting to the issuer. This will automatically add the `cert sign` usage to the list of `usages`."
                      "type" = "boolean"
                    }
                    "issuerRef" = {
                      "description" = "IssuerRef is a reference to the issuer for this CertificateRequest.  If the `kind` field is not set, or set to `Issuer`, an Issuer resource with the given name in the same namespace as the CertificateRequest will be used.  If the `kind` field is set to `ClusterIssuer`, a ClusterIssuer with the provided name will be used. The `name` field in this stanza is required at all times. The group field refers to the API group of the issuer which defaults to `cert-manager.io` if empty."
                      "properties" = {
                        "group" = {
                          "description" = "Group of the resource being referred to."
                          "type" = "string"
                        }
                        "kind" = {
                          "description" = "Kind of the resource being referred to."
                          "type" = "string"
                        }
                        "name" = {
                          "description" = "Name of the resource being referred to."
                          "type" = "string"
                        }
                      }
                      "required" = [
                        "name",
                      ]
                      "type" = "object"
                    }
                    "uid" = {
                      "description" = "UID contains the uid of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "string"
                    }
                    "usages" = {
                      "description" = "Usages is the set of x509 usages that are requested for the certificate. Defaults to `digital signature` and `key encipherment` if not specified."
                      "items" = {
                        "description" = "KeyUsage specifies valid usage contexts for keys. See: https://tools.ietf.org/html/rfc5280#section-4.2.1.3      https://tools.ietf.org/html/rfc5280#section-4.2.1.12 Valid KeyUsage values are as follows: \"signing\", \"digital signature\", \"content commitment\", \"key encipherment\", \"key agreement\", \"data encipherment\", \"cert sign\", \"crl sign\", \"encipher only\", \"decipher only\", \"any\", \"server auth\", \"client auth\", \"code signing\", \"email protection\", \"s/mime\", \"ipsec end system\", \"ipsec tunnel\", \"ipsec user\", \"timestamping\", \"ocsp signing\", \"microsoft sgc\", \"netscape sgc\""
                        "enum" = [
                          "signing",
                          "digital signature",
                          "content commitment",
                          "key encipherment",
                          "key agreement",
                          "data encipherment",
                          "cert sign",
                          "crl sign",
                          "encipher only",
                          "decipher only",
                          "any",
                          "server auth",
                          "client auth",
                          "code signing",
                          "email protection",
                          "s/mime",
                          "ipsec end system",
                          "ipsec tunnel",
                          "ipsec user",
                          "timestamping",
                          "ocsp signing",
                          "microsoft sgc",
                          "netscape sgc",
                        ]
                        "type" = "string"
                      }
                      "type" = "array"
                    }
                    "username" = {
                      "description" = "Username contains the name of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "string"
                    }
                  }
                  "required" = [
                    "csr",
                    "issuerRef",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "description" = "Status of the CertificateRequest. This is set and managed automatically."
                  "properties" = {
                    "ca" = {
                      "description" = "The PEM encoded x509 certificate of the signer, also known as the CA (Certificate Authority). This is set on a best-effort basis by different issuers. If not set, the CA is assumed to be unknown/not available."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "certificate" = {
                      "description" = "The PEM encoded x509 certificate resulting from the certificate signing request. If not set, the CertificateRequest has either not been completed or has failed. More information on failure can be found by checking the `conditions` field."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "conditions" = {
                      "description" = "List of status conditions to indicate the status of a CertificateRequest. Known condition types are `Ready` and `InvalidRequest`."
                      "items" = {
                        "description" = "CertificateRequestCondition contains condition information for a CertificateRequest."
                        "properties" = {
                          "lastTransitionTime" = {
                            "description" = "LastTransitionTime is the timestamp corresponding to the last status change of this condition."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "Message is a human readable description of the details of the last transition, complementing reason."
                            "type" = "string"
                          }
                          "reason" = {
                            "description" = "Reason is a brief machine readable explanation for the condition's last transition."
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "Status of the condition, one of (`True`, `False`, `Unknown`)."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "Type of the condition, known values are (`Ready`, `InvalidRequest`, `Approved`, `Denied`)."
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "failureTime" = {
                      "description" = "FailureTime stores the time that this CertificateRequest failed. This is used to influence garbage collection and back-off."
                      "format" = "date-time"
                      "type" = "string"
                    }
                  }
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = false
          "subresources" = {
            "status" = {}
          }
        },
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Approved\")].status"
              "name" = "Approved"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Denied\")].status"
              "name" = "Denied"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Ready\")].status"
              "name" = "Ready"
              "type" = "string"
            },
            {
              "jsonPath" = ".spec.issuerRef.name"
              "name" = "Issuer"
              "type" = "string"
            },
            {
              "jsonPath" = ".spec.username"
              "name" = "Requestor"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Ready\")].message"
              "name" = "Status"
              "priority" = 1
              "type" = "string"
            },
            {
              "description" = "CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC."
              "jsonPath" = ".metadata.creationTimestamp"
              "name" = "Age"
              "type" = "date"
            },
          ]
          "name" = "v1alpha3"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = <<-EOT
              A CertificateRequest is used to request a signed certificate from one of the configured issuers.
               All fields within the CertificateRequest's `spec` are immutable after creation. A CertificateRequest will either succeed or fail, as denoted by its `status.state` field.
               A CertificateRequest is a one-shot resource, meaning it represents a single point in time request for a certificate and cannot be re-used.
              EOT
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Desired state of the CertificateRequest resource."
                  "properties" = {
                    "csr" = {
                      "description" = "The PEM-encoded x509 certificate signing request to be submitted to the CA for signing."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "duration" = {
                      "description" = "The requested 'duration' (i.e. lifetime) of the Certificate. This option may be ignored/overridden by some issuer types."
                      "type" = "string"
                    }
                    "extra" = {
                      "additionalProperties" = {
                        "items" = {
                          "type" = "string"
                        }
                        "type" = "array"
                      }
                      "description" = "Extra contains extra attributes of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "object"
                    }
                    "groups" = {
                      "description" = "Groups contains group membership of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "items" = {
                        "type" = "string"
                      }
                      "type" = "array"
                      "x-kubernetes-list-type" = "atomic"
                    }
                    "isCA" = {
                      "description" = "IsCA will request to mark the certificate as valid for certificate signing when submitting to the issuer. This will automatically add the `cert sign` usage to the list of `usages`."
                      "type" = "boolean"
                    }
                    "issuerRef" = {
                      "description" = "IssuerRef is a reference to the issuer for this CertificateRequest.  If the `kind` field is not set, or set to `Issuer`, an Issuer resource with the given name in the same namespace as the CertificateRequest will be used.  If the `kind` field is set to `ClusterIssuer`, a ClusterIssuer with the provided name will be used. The `name` field in this stanza is required at all times. The group field refers to the API group of the issuer which defaults to `cert-manager.io` if empty."
                      "properties" = {
                        "group" = {
                          "description" = "Group of the resource being referred to."
                          "type" = "string"
                        }
                        "kind" = {
                          "description" = "Kind of the resource being referred to."
                          "type" = "string"
                        }
                        "name" = {
                          "description" = "Name of the resource being referred to."
                          "type" = "string"
                        }
                      }
                      "required" = [
                        "name",
                      ]
                      "type" = "object"
                    }
                    "uid" = {
                      "description" = "UID contains the uid of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "string"
                    }
                    "usages" = {
                      "description" = "Usages is the set of x509 usages that are requested for the certificate. Defaults to `digital signature` and `key encipherment` if not specified."
                      "items" = {
                        "description" = "KeyUsage specifies valid usage contexts for keys. See: https://tools.ietf.org/html/rfc5280#section-4.2.1.3      https://tools.ietf.org/html/rfc5280#section-4.2.1.12 Valid KeyUsage values are as follows: \"signing\", \"digital signature\", \"content commitment\", \"key encipherment\", \"key agreement\", \"data encipherment\", \"cert sign\", \"crl sign\", \"encipher only\", \"decipher only\", \"any\", \"server auth\", \"client auth\", \"code signing\", \"email protection\", \"s/mime\", \"ipsec end system\", \"ipsec tunnel\", \"ipsec user\", \"timestamping\", \"ocsp signing\", \"microsoft sgc\", \"netscape sgc\""
                        "enum" = [
                          "signing",
                          "digital signature",
                          "content commitment",
                          "key encipherment",
                          "key agreement",
                          "data encipherment",
                          "cert sign",
                          "crl sign",
                          "encipher only",
                          "decipher only",
                          "any",
                          "server auth",
                          "client auth",
                          "code signing",
                          "email protection",
                          "s/mime",
                          "ipsec end system",
                          "ipsec tunnel",
                          "ipsec user",
                          "timestamping",
                          "ocsp signing",
                          "microsoft sgc",
                          "netscape sgc",
                        ]
                        "type" = "string"
                      }
                      "type" = "array"
                    }
                    "username" = {
                      "description" = "Username contains the name of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "string"
                    }
                  }
                  "required" = [
                    "csr",
                    "issuerRef",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "description" = "Status of the CertificateRequest. This is set and managed automatically."
                  "properties" = {
                    "ca" = {
                      "description" = "The PEM encoded x509 certificate of the signer, also known as the CA (Certificate Authority). This is set on a best-effort basis by different issuers. If not set, the CA is assumed to be unknown/not available."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "certificate" = {
                      "description" = "The PEM encoded x509 certificate resulting from the certificate signing request. If not set, the CertificateRequest has either not been completed or has failed. More information on failure can be found by checking the `conditions` field."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "conditions" = {
                      "description" = "List of status conditions to indicate the status of a CertificateRequest. Known condition types are `Ready` and `InvalidRequest`."
                      "items" = {
                        "description" = "CertificateRequestCondition contains condition information for a CertificateRequest."
                        "properties" = {
                          "lastTransitionTime" = {
                            "description" = "LastTransitionTime is the timestamp corresponding to the last status change of this condition."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "Message is a human readable description of the details of the last transition, complementing reason."
                            "type" = "string"
                          }
                          "reason" = {
                            "description" = "Reason is a brief machine readable explanation for the condition's last transition."
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "Status of the condition, one of (`True`, `False`, `Unknown`)."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "Type of the condition, known values are (`Ready`, `InvalidRequest`, `Approved`, `Denied`)."
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "failureTime" = {
                      "description" = "FailureTime stores the time that this CertificateRequest failed. This is used to influence garbage collection and back-off."
                      "format" = "date-time"
                      "type" = "string"
                    }
                  }
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = false
          "subresources" = {
            "status" = {}
          }
        },
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Approved\")].status"
              "name" = "Approved"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Denied\")].status"
              "name" = "Denied"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Ready\")].status"
              "name" = "Ready"
              "type" = "string"
            },
            {
              "jsonPath" = ".spec.issuerRef.name"
              "name" = "Issuer"
              "type" = "string"
            },
            {
              "jsonPath" = ".spec.username"
              "name" = "Requestor"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Ready\")].message"
              "name" = "Status"
              "priority" = 1
              "type" = "string"
            },
            {
              "description" = "CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC."
              "jsonPath" = ".metadata.creationTimestamp"
              "name" = "Age"
              "type" = "date"
            },
          ]
          "name" = "v1beta1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = <<-EOT
              A CertificateRequest is used to request a signed certificate from one of the configured issuers.
               All fields within the CertificateRequest's `spec` are immutable after creation. A CertificateRequest will either succeed or fail, as denoted by its `status.state` field.
               A CertificateRequest is a one-shot resource, meaning it represents a single point in time request for a certificate and cannot be re-used.
              EOT
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Desired state of the CertificateRequest resource."
                  "properties" = {
                    "duration" = {
                      "description" = "The requested 'duration' (i.e. lifetime) of the Certificate. This option may be ignored/overridden by some issuer types."
                      "type" = "string"
                    }
                    "extra" = {
                      "additionalProperties" = {
                        "items" = {
                          "type" = "string"
                        }
                        "type" = "array"
                      }
                      "description" = "Extra contains extra attributes of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "object"
                    }
                    "groups" = {
                      "description" = "Groups contains group membership of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "items" = {
                        "type" = "string"
                      }
                      "type" = "array"
                      "x-kubernetes-list-type" = "atomic"
                    }
                    "isCA" = {
                      "description" = "IsCA will request to mark the certificate as valid for certificate signing when submitting to the issuer. This will automatically add the `cert sign` usage to the list of `usages`."
                      "type" = "boolean"
                    }
                    "issuerRef" = {
                      "description" = "IssuerRef is a reference to the issuer for this CertificateRequest.  If the `kind` field is not set, or set to `Issuer`, an Issuer resource with the given name in the same namespace as the CertificateRequest will be used.  If the `kind` field is set to `ClusterIssuer`, a ClusterIssuer with the provided name will be used. The `name` field in this stanza is required at all times. The group field refers to the API group of the issuer which defaults to `cert-manager.io` if empty."
                      "properties" = {
                        "group" = {
                          "description" = "Group of the resource being referred to."
                          "type" = "string"
                        }
                        "kind" = {
                          "description" = "Kind of the resource being referred to."
                          "type" = "string"
                        }
                        "name" = {
                          "description" = "Name of the resource being referred to."
                          "type" = "string"
                        }
                      }
                      "required" = [
                        "name",
                      ]
                      "type" = "object"
                    }
                    "request" = {
                      "description" = "The PEM-encoded x509 certificate signing request to be submitted to the CA for signing."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "uid" = {
                      "description" = "UID contains the uid of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "string"
                    }
                    "usages" = {
                      "description" = "Usages is the set of x509 usages that are requested for the certificate. Defaults to `digital signature` and `key encipherment` if not specified."
                      "items" = {
                        "description" = "KeyUsage specifies valid usage contexts for keys. See: https://tools.ietf.org/html/rfc5280#section-4.2.1.3      https://tools.ietf.org/html/rfc5280#section-4.2.1.12 Valid KeyUsage values are as follows: \"signing\", \"digital signature\", \"content commitment\", \"key encipherment\", \"key agreement\", \"data encipherment\", \"cert sign\", \"crl sign\", \"encipher only\", \"decipher only\", \"any\", \"server auth\", \"client auth\", \"code signing\", \"email protection\", \"s/mime\", \"ipsec end system\", \"ipsec tunnel\", \"ipsec user\", \"timestamping\", \"ocsp signing\", \"microsoft sgc\", \"netscape sgc\""
                        "enum" = [
                          "signing",
                          "digital signature",
                          "content commitment",
                          "key encipherment",
                          "key agreement",
                          "data encipherment",
                          "cert sign",
                          "crl sign",
                          "encipher only",
                          "decipher only",
                          "any",
                          "server auth",
                          "client auth",
                          "code signing",
                          "email protection",
                          "s/mime",
                          "ipsec end system",
                          "ipsec tunnel",
                          "ipsec user",
                          "timestamping",
                          "ocsp signing",
                          "microsoft sgc",
                          "netscape sgc",
                        ]
                        "type" = "string"
                      }
                      "type" = "array"
                    }
                    "username" = {
                      "description" = "Username contains the name of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "string"
                    }
                  }
                  "required" = [
                    "issuerRef",
                    "request",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "description" = "Status of the CertificateRequest. This is set and managed automatically."
                  "properties" = {
                    "ca" = {
                      "description" = "The PEM encoded x509 certificate of the signer, also known as the CA (Certificate Authority). This is set on a best-effort basis by different issuers. If not set, the CA is assumed to be unknown/not available."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "certificate" = {
                      "description" = "The PEM encoded x509 certificate resulting from the certificate signing request. If not set, the CertificateRequest has either not been completed or has failed. More information on failure can be found by checking the `conditions` field."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "conditions" = {
                      "description" = "List of status conditions to indicate the status of a CertificateRequest. Known condition types are `Ready` and `InvalidRequest`."
                      "items" = {
                        "description" = "CertificateRequestCondition contains condition information for a CertificateRequest."
                        "properties" = {
                          "lastTransitionTime" = {
                            "description" = "LastTransitionTime is the timestamp corresponding to the last status change of this condition."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "Message is a human readable description of the details of the last transition, complementing reason."
                            "type" = "string"
                          }
                          "reason" = {
                            "description" = "Reason is a brief machine readable explanation for the condition's last transition."
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "Status of the condition, one of (`True`, `False`, `Unknown`)."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "Type of the condition, known values are (`Ready`, `InvalidRequest`, `Approved`, `Denied`)."
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "failureTime" = {
                      "description" = "FailureTime stores the time that this CertificateRequest failed. This is used to influence garbage collection and back-off."
                      "format" = "date-time"
                      "type" = "string"
                    }
                  }
                  "type" = "object"
                }
              }
              "required" = [
                "spec",
              ]
              "type" = "object"
            }
          }
          "served" = true
          "storage" = false
          "subresources" = {
            "status" = {}
          }
        },
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Approved\")].status"
              "name" = "Approved"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Denied\")].status"
              "name" = "Denied"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Ready\")].status"
              "name" = "Ready"
              "type" = "string"
            },
            {
              "jsonPath" = ".spec.issuerRef.name"
              "name" = "Issuer"
              "type" = "string"
            },
            {
              "jsonPath" = ".spec.username"
              "name" = "Requestor"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Ready\")].message"
              "name" = "Status"
              "priority" = 1
              "type" = "string"
            },
            {
              "description" = "CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC."
              "jsonPath" = ".metadata.creationTimestamp"
              "name" = "Age"
              "type" = "date"
            },
          ]
          "name" = "v1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = <<-EOT
              A CertificateRequest is used to request a signed certificate from one of the configured issuers.
               All fields within the CertificateRequest's `spec` are immutable after creation. A CertificateRequest will either succeed or fail, as denoted by its `status.state` field.
               A CertificateRequest is a one-shot resource, meaning it represents a single point in time request for a certificate and cannot be re-used.
              EOT
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Desired state of the CertificateRequest resource."
                  "properties" = {
                    "duration" = {
                      "description" = "The requested 'duration' (i.e. lifetime) of the Certificate. This option may be ignored/overridden by some issuer types."
                      "type" = "string"
                    }
                    "extra" = {
                      "additionalProperties" = {
                        "items" = {
                          "type" = "string"
                        }
                        "type" = "array"
                      }
                      "description" = "Extra contains extra attributes of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "object"
                    }
                    "groups" = {
                      "description" = "Groups contains group membership of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "items" = {
                        "type" = "string"
                      }
                      "type" = "array"
                      "x-kubernetes-list-type" = "atomic"
                    }
                    "isCA" = {
                      "description" = "IsCA will request to mark the certificate as valid for certificate signing when submitting to the issuer. This will automatically add the `cert sign` usage to the list of `usages`."
                      "type" = "boolean"
                    }
                    "issuerRef" = {
                      "description" = "IssuerRef is a reference to the issuer for this CertificateRequest.  If the `kind` field is not set, or set to `Issuer`, an Issuer resource with the given name in the same namespace as the CertificateRequest will be used.  If the `kind` field is set to `ClusterIssuer`, a ClusterIssuer with the provided name will be used. The `name` field in this stanza is required at all times. The group field refers to the API group of the issuer which defaults to `cert-manager.io` if empty."
                      "properties" = {
                        "group" = {
                          "description" = "Group of the resource being referred to."
                          "type" = "string"
                        }
                        "kind" = {
                          "description" = "Kind of the resource being referred to."
                          "type" = "string"
                        }
                        "name" = {
                          "description" = "Name of the resource being referred to."
                          "type" = "string"
                        }
                      }
                      "required" = [
                        "name",
                      ]
                      "type" = "object"
                    }
                    "request" = {
                      "description" = "The PEM-encoded x509 certificate signing request to be submitted to the CA for signing."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "uid" = {
                      "description" = "UID contains the uid of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "string"
                    }
                    "usages" = {
                      "description" = "Usages is the set of x509 usages that are requested for the certificate. If usages are set they SHOULD be encoded inside the CSR spec Defaults to `digital signature` and `key encipherment` if not specified."
                      "items" = {
                        "description" = "KeyUsage specifies valid usage contexts for keys. See: https://tools.ietf.org/html/rfc5280#section-4.2.1.3      https://tools.ietf.org/html/rfc5280#section-4.2.1.12 Valid KeyUsage values are as follows: \"signing\", \"digital signature\", \"content commitment\", \"key encipherment\", \"key agreement\", \"data encipherment\", \"cert sign\", \"crl sign\", \"encipher only\", \"decipher only\", \"any\", \"server auth\", \"client auth\", \"code signing\", \"email protection\", \"s/mime\", \"ipsec end system\", \"ipsec tunnel\", \"ipsec user\", \"timestamping\", \"ocsp signing\", \"microsoft sgc\", \"netscape sgc\""
                        "enum" = [
                          "signing",
                          "digital signature",
                          "content commitment",
                          "key encipherment",
                          "key agreement",
                          "data encipherment",
                          "cert sign",
                          "crl sign",
                          "encipher only",
                          "decipher only",
                          "any",
                          "server auth",
                          "client auth",
                          "code signing",
                          "email protection",
                          "s/mime",
                          "ipsec end system",
                          "ipsec tunnel",
                          "ipsec user",
                          "timestamping",
                          "ocsp signing",
                          "microsoft sgc",
                          "netscape sgc",
                        ]
                        "type" = "string"
                      }
                      "type" = "array"
                    }
                    "username" = {
                      "description" = "Username contains the name of the user that created the CertificateRequest. Populated by the cert-manager webhook on creation and immutable."
                      "type" = "string"
                    }
                  }
                  "required" = [
                    "issuerRef",
                    "request",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "description" = "Status of the CertificateRequest. This is set and managed automatically."
                  "properties" = {
                    "ca" = {
                      "description" = "The PEM encoded x509 certificate of the signer, also known as the CA (Certificate Authority). This is set on a best-effort basis by different issuers. If not set, the CA is assumed to be unknown/not available."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "certificate" = {
                      "description" = "The PEM encoded x509 certificate resulting from the certificate signing request. If not set, the CertificateRequest has either not been completed or has failed. More information on failure can be found by checking the `conditions` field."
                      "format" = "byte"
                      "type" = "string"
                    }
                    "conditions" = {
                      "description" = "List of status conditions to indicate the status of a CertificateRequest. Known condition types are `Ready` and `InvalidRequest`."
                      "items" = {
                        "description" = "CertificateRequestCondition contains condition information for a CertificateRequest."
                        "properties" = {
                          "lastTransitionTime" = {
                            "description" = "LastTransitionTime is the timestamp corresponding to the last status change of this condition."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "Message is a human readable description of the details of the last transition, complementing reason."
                            "type" = "string"
                          }
                          "reason" = {
                            "description" = "Reason is a brief machine readable explanation for the condition's last transition."
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "Status of the condition, one of (`True`, `False`, `Unknown`)."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "Type of the condition, known values are (`Ready`, `InvalidRequest`, `Approved`, `Denied`)."
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "failureTime" = {
                      "description" = "FailureTime stores the time that this CertificateRequest failed. This is used to influence garbage collection and back-off."
                      "format" = "date-time"
                      "type" = "string"
                    }
                  }
                  "type" = "object"
                }
              }
              "required" = [
                "spec",
              ]
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_backendpolicies_networking_x_k8s_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.5.0"
      }
      "name" = "backendpolicies.networking.x-k8s.io"
    }
    "spec" = {
      "group" = "networking.x-k8s.io"
      "names" = {
        "categories" = [
          "gateway-api",
        ]
        "kind" = "BackendPolicy"
        "listKind" = "BackendPolicyList"
        "plural" = "backendpolicies"
        "shortNames" = [
          "bp",
        ]
        "singular" = "backendpolicy"
      }
      "scope" = "Namespaced"
      "versions" = [
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".metadata.creationTimestamp"
              "name" = "Age"
              "type" = "date"
            },
          ]
          "name" = "v1alpha1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = "BackendPolicy defines policies associated with backends. For the purpose of this API, a backend is defined as any resource that a route can forward traffic to. A common example of a backend is a Service. Configuration that is implementation specific may be represented with similar implementation specific custom resources."
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Spec defines the desired state of BackendPolicy."
                  "properties" = {
                    "backendRefs" = {
                      "description" = <<-EOT
                      BackendRefs define which backends this policy should be applied to. This policy can only apply to backends within the same namespace. If more than one BackendPolicy targets the same backend, precedence must be given to the oldest BackendPolicy.
                       Support: Core
                      EOT
                      "items" = {
                        "description" = "BackendRef identifies an API object within the same namespace as the BackendPolicy."
                        "properties" = {
                          "group" = {
                            "description" = "Group is the group of the referent."
                            "maxLength" = 253
                            "type" = "string"
                          }
                          "kind" = {
                            "description" = "Kind is the kind of the referent."
                            "maxLength" = 253
                            "type" = "string"
                          }
                          "name" = {
                            "description" = "Name is the name of the referent."
                            "maxLength" = 253
                            "type" = "string"
                          }
                          "port" = {
                            "description" = "Port is the port of the referent. If unspecified, this policy applies to all ports on the backend."
                            "format" = "int32"
                            "maximum" = 65535
                            "minimum" = 1
                            "type" = "integer"
                          }
                        }
                        "required" = [
                          "group",
                          "kind",
                          "name",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 16
                      "type" = "array"
                    }
                    "tls" = {
                      "description" = <<-EOT
                      TLS is the TLS configuration for these backends.
                       Support: Extended
                      EOT
                      "properties" = {
                        "certificateAuthorityRef" = {
                          "description" = <<-EOT
                          CertificateAuthorityRef is a reference to a Kubernetes object that contains one or more trusted CA certificates. The CA certificates are used to establish a TLS handshake to backends listed in BackendRefs. The referenced object MUST reside in the same namespace as BackendPolicy.
                           CertificateAuthorityRef can reference a standard Kubernetes resource, i.e. ConfigMap, or an implementation-specific custom resource.
                           When stored in a Secret, certificates must be PEM encoded and specified within the "ca.crt" data field of the Secret. When multiple certificates are specified, the certificates MUST be concatenated by new lines.
                           CertificateAuthorityRef can also reference a standard Kubernetes resource, i.e. ConfigMap, or an implementation-specific custom resource.
                           Support: Extended
                          EOT
                          "properties" = {
                            "group" = {
                              "description" = "Group is the group of the referent."
                              "maxLength" = 253
                              "minLength" = 1
                              "type" = "string"
                            }
                            "kind" = {
                              "description" = "Kind is kind of the referent."
                              "maxLength" = 253
                              "minLength" = 1
                              "type" = "string"
                            }
                            "name" = {
                              "description" = "Name is the name of the referent."
                              "maxLength" = 253
                              "minLength" = 1
                              "type" = "string"
                            }
                          }
                          "required" = [
                            "group",
                            "kind",
                            "name",
                          ]
                          "type" = "object"
                        }
                        "options" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "description" = <<-EOT
                          Options are a list of key/value pairs to give extended options to the provider.
                           Support: Implementation-specific
                          EOT
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                  }
                  "required" = [
                    "backendRefs",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "description" = "Status defines the current state of BackendPolicy."
                  "properties" = {
                    "conditions" = {
                      "description" = "Conditions describe the current conditions of the BackendPolicy."
                      "items" = {
                        "description" = <<-EOT
                        Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: "Available", "Progressing", and "Degraded"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:"conditions,omitempty" patchStrategy:"merge" patchMergeKey:"type" protobuf:"bytes,1,rep,name=conditions"`
                             // other fields }
                        EOT
                        "properties" = {
                          "lastTransitionTime" = {
                            "description" = "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "message is a human readable message indicating details about the transition. This may be an empty string."
                            "maxLength" = 32768
                            "type" = "string"
                          }
                          "observedGeneration" = {
                            "description" = "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."
                            "format" = "int64"
                            "minimum" = 0
                            "type" = "integer"
                          }
                          "reason" = {
                            "description" = "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."
                            "maxLength" = 1024
                            "minLength" = 1
                            "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "status of the condition, one of True, False, Unknown."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                            "maxLength" = 316
                            "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "lastTransitionTime",
                          "message",
                          "reason",
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 8
                      "type" = "array"
                      "x-kubernetes-list-map-keys" = [
                        "type",
                      ]
                      "x-kubernetes-list-type" = "map"
                    }
                  }
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_contours_operator_projectcontour_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.5.0"
      }
      "name" = "contours.operator.projectcontour.io"
    }
    "spec" = {
      "group" = "operator.projectcontour.io"
      "names" = {
        "kind" = "Contour"
        "listKind" = "ContourList"
        "plural" = "contours"
        "singular" = "contour"
      }
      "scope" = "Namespaced"
      "versions" = [
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Available\")].status"
              "name" = "Ready"
              "type" = "string"
            },
            {
              "jsonPath" = ".status.conditions[?(@.type==\"Available\")].reason"
              "name" = "Reason"
              "type" = "string"
            },
          ]
          "name" = "v1alpha1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = "Contour is the Schema for the contours API."
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Spec defines the desired state of Contour."
                  "properties" = {
                    "gatewayClassRef" = {
                      "description" = "GatewayClassRef is a reference to a GatewayClass name used for managing a Contour."
                      "maxLength" = 253
                      "type" = "string"
                    }
                    "ingressClassName" = {
                      "description" = <<-EOT
                      IngressClassName is the name of the IngressClass used by Contour. If unset, Contour will process all ingress objects without an ingress class annotation or ingress objects with an annotation matching ingress-class=contour. When specified, Contour will only process ingress objects that match the provided class.
                       For additional IngressClass details, refer to:   https://projectcontour.io/docs/main/config/annotations/#ingress-class
                      EOT
                      "maxLength" = 253
                      "minLength" = 1
                      "type" = "string"
                    }
                    "namespace" = {
                      "default" = {
                        "name" = "projectcontour"
                        "removeOnDeletion" = false
                      }
                      "description" = <<-EOT
                      Namespace defines the schema of a Contour namespace. See each field for additional details. Namespace name should be the same namespace as the Gateway when GatewayClassRef is set.
                       TODO [danehans]: Ignore Namespace when GatewayClassRef is set. xref: https://github.com/projectcontour/contour-operator/issues/212
                      EOT
                      "properties" = {
                        "name" = {
                          "default" = "projectcontour"
                          "description" = "Name is the name of the namespace to run Contour and dependent resources. If unset, defaults to \"projectcontour\"."
                          "type" = "string"
                        }
                        "removeOnDeletion" = {
                          "default" = false
                          "description" = <<-EOT
                          RemoveOnDeletion will remove the namespace when the Contour is deleted. If set to True, deletion will not occur if any of the following conditions exist:
                           1. The Contour namespace is "default", "kube-system" or the    contour-operator's namespace.
                           2. Another Contour exists in the namespace.
                           3. The namespace does not contain the Contour owning label.
                          EOT
                          "type" = "boolean"
                        }
                      }
                      "type" = "object"
                    }
                    "networkPublishing" = {
                      "default" = {
                        "envoy" = {
                          "containerPorts" = [
                            {
                              "name" = "http"
                              "portNumber" = 8080
                            },
                            {
                              "name" = "https"
                              "portNumber" = 8443
                            },
                          ]
                          "type" = "LoadBalancerService"
                        }
                      }
                      "description" = <<-EOT
                      NetworkPublishing defines the schema for publishing Contour to a network.
                       See each field for additional details.
                      EOT
                      "properties" = {
                        "envoy" = {
                          "default" = {
                            "containerPorts" = [
                              {
                                "name" = "http"
                                "portNumber" = 8080
                              },
                              {
                                "name" = "https"
                                "portNumber" = 8443
                              },
                            ]
                            "loadBalancer" = {
                              "providerParameters" = {
                                "type" = "AWS"
                              }
                              "scope" = "External"
                            }
                            "type" = "LoadBalancerService"
                          }
                          "description" = <<-EOT
                          Envoy provides the schema for publishing the network endpoints of Envoy.
                           If unset, defaults to:   type: LoadBalancerService   containerPorts:   - name: http     portNumber: 8080   - name: https     portNumber: 8443
                          EOT
                          "properties" = {
                            "containerPorts" = {
                              "default" = [
                                {
                                  "name" = "http"
                                  "portNumber" = 8080
                                },
                                {
                                  "name" = "https"
                                  "portNumber" = 8443
                                },
                              ]
                              "description" = <<-EOT
                              ContainerPorts is a list of container ports to expose from the Envoy container(s). Exposing a port here gives the system additional information about the network connections the Envoy container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed by Envoy. Any port which is listening on the default "0.0.0.0" address inside the Envoy container will be accessible from the network. Names and port numbers must be unique in the list container ports. Two ports must be specified, one named "http" for Envoy's insecure service and one named "https" for Envoy's secure service.
                               TODO [danehans]: Update minItems to 1, requiring only https when the following issue is fixed: https://github.com/projectcontour/contour/issues/2577.
                               TODO [danehans]: Increase maxItems when https://github.com/projectcontour/contour/pull/3263 is implemented.
                              EOT
                              "items" = {
                                "description" = "ContainerPort is the schema to specify a network port for a container. A container port gives the system additional information about network connections a container uses, but is primarily informational."
                                "properties" = {
                                  "name" = {
                                    "description" = "Name is an IANA_SVC_NAME within the pod."
                                    "maxLength" = 253
                                    "minLength" = 1
                                    "type" = "string"
                                  }
                                  "portNumber" = {
                                    "description" = "PortNumber is the network port number to expose on the envoy pod. The number must be greater than 0 and less than 65536."
                                    "format" = "int32"
                                    "maximum" = 65535
                                    "minimum" = 1
                                    "type" = "integer"
                                  }
                                }
                                "required" = [
                                  "name",
                                  "portNumber",
                                ]
                                "type" = "object"
                              }
                              "maxItems" = 2
                              "minItems" = 2
                              "type" = "array"
                            }
                            "loadBalancer" = {
                              "default" = {
                                "providerParameters" = {
                                  "type" = "AWS"
                                }
                                "scope" = "External"
                              }
                              "description" = <<-EOT
                              LoadBalancer holds parameters for the load balancer. Present only if type is LoadBalancerService.
                               If unspecified, defaults to an external Classic AWS ELB.
                              EOT
                              "properties" = {
                                "providerParameters" = {
                                  "default" = {
                                    "type" = "AWS"
                                  }
                                  "description" = "ProviderParameters contains load balancer information specific to the underlying infrastructure provider."
                                  "properties" = {
                                    "aws" = {
                                      "description" = <<-EOT
                                      AWS provides configuration settings that are specific to AWS load balancers.
                                       If empty, defaults will be applied. See specific aws fields for details about their defaults.
                                      EOT
                                      "properties" = {
                                        "allocationIds" = {
                                          "description" = <<-EOT
                                          AllocationIDs is a list of Allocation IDs of Elastic IP addresses that are to be assigned to the Network Load Balancer. Works only with type NLB. If you are using Amazon EKS 1.16 or later, you can assign Elastic IP addresses to Network Load Balancer with AllocationIDs. The number of Allocation IDs must match the number of subnets used for the load balancer.
                                           Example: "eipalloc-<xxxxxxxxxxxxxxxxx>"
                                           See: https://docs.aws.amazon.com/eks/latest/userguide/load-balancing.html
                                          EOT
                                          "items" = {
                                            "type" = "string"
                                          }
                                          "type" = "array"
                                        }
                                        "type" = {
                                          "default" = "Classic"
                                          "description" = <<-EOT
                                          Type is the type of AWS load balancer to manage.
                                           Valid values are:
                                           * "Classic": A Classic load balancer makes routing decisions at either the   transport layer (TCP/SSL) or the application layer (HTTP/HTTPS). See   the following for additional details:
                                               https://docs.aws.amazon.com/AmazonECS/latest/developerguide/load-balancer-types.html#clb
                                           * "NLB": A Network load balancer makes routing decisions at the transport   layer (TCP/SSL). See the following for additional details:
                                               https://docs.aws.amazon.com/AmazonECS/latest/developerguide/load-balancer-types.html#nlb
                                           If unset, defaults to "Classic".
                                          EOT
                                          "enum" = [
                                            "Classic",
                                            "NLB",
                                          ]
                                          "type" = "string"
                                        }
                                      }
                                      "type" = "object"
                                    }
                                    "azure" = {
                                      "description" = <<-EOT
                                      Azure provides configuration settings that are specific to Azure load balancers.
                                       If empty, defaults will be applied. See specific azure fields for details about their defaults.
                                      EOT
                                      "properties" = {
                                        "address" = {
                                          "description" = <<-EOT
                                          Address is the desired load balancer IP address. If scope is "Internal", address must reside in same virtual network as AKS and must not already be assigned to a resource. If address does not reside in same subnet as AKS, the subnet parameter is also required.
                                           Address must already exist (e.g. `az network public-ip create`).
                                           See: 	 https://docs.microsoft.com/en-us/azure/aks/static-ip#create-a-service-using-the-static-ip-address 	 https://docs.microsoft.com/en-us/azure/aks/internal-lb#specify-an-ip-address
                                          EOT
                                          "maxLength" = 253
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                        "resourceGroup" = {
                                          "description" = <<-EOT
                                          ResourceGroup is the resource group name where the "address" resides. Relevant only if scope is "External".
                                           Omit if desired IP is created in same resource group as AKS cluster.
                                          EOT
                                          "maxLength" = 90
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                        "subnet" = {
                                          "description" = <<-EOT
                                          Subnet is the subnet name where the "address" resides. Relevant only if scope is "Internal" and desired IP does not reside in same subnet as AKS.
                                           Omit if desired IP is in same subnet as AKS cluster.
                                           See: https://docs.microsoft.com/en-us/azure/aks/internal-lb#specify-an-ip-address
                                          EOT
                                          "maxLength" = 80
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                      }
                                      "type" = "object"
                                    }
                                    "gcp" = {
                                      "description" = <<-EOT
                                      GCP provides configuration settings that are specific to GCP load balancers.
                                       If empty, defaults will be applied. See specific gcp fields for details about their defaults.
                                      EOT
                                      "properties" = {
                                        "address" = {
                                          "description" = <<-EOT
                                          Address is the desired load balancer IP address. If scope is "Internal", the address must reside in same subnet as the GKE cluster or "subnet" has to be provided.
                                           See: 	 https://cloud.google.com/kubernetes-engine/docs/tutorials/configuring-domain-name-static-ip#use_a_service 	 https://cloud.google.com/kubernetes-engine/docs/how-to/internal-load-balancing#lb_subnet
                                          EOT
                                          "maxLength" = 253
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                        "subnet" = {
                                          "description" = <<-EOT
                                          Subnet is the subnet name where the "address" resides. Relevant only if scope is "Internal" and desired IP does not reside in same subnet as GKE cluster.
                                           Omit if desired IP is in same subnet as GKE cluster.
                                           See: https://cloud.google.com/kubernetes-engine/docs/how-to/internal-load-balancing#lb_subnet
                                          EOT
                                          "maxLength" = 63
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                      }
                                      "type" = "object"
                                    }
                                    "type" = {
                                      "default" = "AWS"
                                      "description" = "Type is the underlying infrastructure provider for the load balancer. Allowed values are \"AWS\", \"Azure\", and \"GCP\"."
                                      "enum" = [
                                        "AWS",
                                        "Azure",
                                        "GCP",
                                      ]
                                      "type" = "string"
                                    }
                                  }
                                  "type" = "object"
                                }
                                "scope" = {
                                  "default" = "External"
                                  "description" = "Scope indicates the scope at which the load balancer is exposed. Possible values are \"External\" and \"Internal\"."
                                  "enum" = [
                                    "Internal",
                                    "External",
                                  ]
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "nodePorts" = {
                              "description" = <<-EOT
                              NodePorts is a list of network ports to expose on each node's IP at a static port number using a NodePort Service. Present only if type is NodePortService. A ClusterIP Service, which the NodePort Service routes to, is automatically created. You'll be able to contact the NodePort Service, from outside the cluster, by requesting <NodeIP>:<NodePort>.
                               If type is NodePortService and nodePorts is unspecified, two nodeports will be created, one named "http" and the other named "https", with port numbers auto assigned by Kubernetes API server. For additional information on the NodePort Service, see:
                                https://kubernetes.io/docs/concepts/services-networking/service/#nodeport
                               Names and port numbers must be unique in the list. Two ports must be specified, one named "http" for Envoy's insecure service and one named "https" for Envoy's secure service.
                              EOT
                              "items" = {
                                "description" = "NodePort is the schema to specify a network port for a NodePort Service."
                                "properties" = {
                                  "name" = {
                                    "description" = "Name is an IANA_SVC_NAME within the NodePort Service."
                                    "maxLength" = 253
                                    "minLength" = 1
                                    "type" = "string"
                                  }
                                  "portNumber" = {
                                    "description" = <<-EOT
                                    PortNumber is the network port number to expose for the NodePort Service. If unspecified, a port number will be assigned from the the cluster's nodeport service range, i.e. --service-node-port-range flag (default: 30000-32767).
                                     If specified, the number must:
                                     1. Not be used by another NodePort Service. 2. Be within the cluster's nodeport service range, i.e. --service-node-port-range    flag (default: 30000-32767). 3. Be a valid network port number, i.e. greater than 0 and less than 65536.
                                    EOT
                                    "format" = "int32"
                                    "maximum" = 65535
                                    "minimum" = 1
                                    "type" = "integer"
                                  }
                                }
                                "required" = [
                                  "name",
                                ]
                                "type" = "object"
                              }
                              "maxItems" = 2
                              "minItems" = 2
                              "type" = "array"
                            }
                            "type" = {
                              "default" = "LoadBalancerService"
                              "description" = <<-EOT
                              Type is the type of publishing strategy to use. Valid values are:
                               * LoadBalancerService
                               In this configuration, network endpoints for Envoy use container networking. A Kubernetes LoadBalancer Service is created to publish Envoy network endpoints. The Service uses port 80 to publish Envoy's HTTP network endpoint and port 443 to publish Envoy's HTTPS network endpoint.
                               See: https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer
                               * NodePortService
                               Publishes Envoy network endpoints using a Kubernetes NodePort Service.
                               In this configuration, Envoy network endpoints use container networking. A Kubernetes NodePort Service is created to publish the network endpoints.
                               See: https://kubernetes.io/docs/concepts/services-networking/service/#nodeport
                               * ClusterIPService
                               Publishes Envoy network endpoints using a Kubernetes ClusterIP Service.
                               In this configuration, Envoy network endpoints use container networking. A Kubernetes ClusterIP Service is created to publish the network endpoints.
                               See: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types
                              EOT
                              "enum" = [
                                "LoadBalancerService",
                                "NodePortService",
                                "ClusterIPService",
                              ]
                              "type" = "string"
                            }
                          }
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                    "nodePlacement" = {
                      "description" = <<-EOT
                      NodePlacement enables scheduling of Contour and Envoy pods onto specific nodes.
                       See each field for additional details.
                      EOT
                      "properties" = {
                        "contour" = {
                          "description" = "Contour describes node scheduling configuration of Contour pods."
                          "properties" = {
                            "nodeSelector" = {
                              "additionalProperties" = {
                                "type" = "string"
                              }
                              "description" = <<-EOT
                              NodeSelector is the simplest recommended form of node selection constraint and specifies a map of key-value pairs. For the Contour pod to be eligible to run on a node, the node must have each of the indicated key-value pairs as labels (it can have additional labels as well).
                               If unset, the Contour pod(s) will be scheduled to any available node.
                              EOT
                              "type" = "object"
                            }
                            "tolerations" = {
                              "description" = <<-EOT
                              Tolerations work with taints to ensure that Envoy pods are not scheduled onto inappropriate nodes. One or more taints are applied to a node; this marks that the node should not accept any pods that do not tolerate the taints.
                               The default is an empty list.
                               See https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ for additional details.
                              EOT
                              "items" = {
                                "description" = "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
                                "properties" = {
                                  "effect" = {
                                    "description" = "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                                    "type" = "string"
                                  }
                                  "key" = {
                                    "description" = "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                                    "type" = "string"
                                  }
                                  "operator" = {
                                    "description" = "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                                    "type" = "string"
                                  }
                                  "tolerationSeconds" = {
                                    "description" = "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system."
                                    "format" = "int64"
                                    "type" = "integer"
                                  }
                                  "value" = {
                                    "description" = "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                                    "type" = "string"
                                  }
                                }
                                "type" = "object"
                              }
                              "type" = "array"
                            }
                          }
                          "type" = "object"
                        }
                        "envoy" = {
                          "description" = "Envoy describes node scheduling configuration of Envoy pods."
                          "properties" = {
                            "nodeSelector" = {
                              "additionalProperties" = {
                                "type" = "string"
                              }
                              "description" = <<-EOT
                              NodeSelector is the simplest recommended form of node selection constraint and specifies a map of key-value pairs. For the Envoy pod to be eligible to run on a node, the node must have each of the indicated key-value pairs as labels (it can have additional labels as well).
                               If unset, the Envoy pod(s) will be scheduled to any available node.
                              EOT
                              "type" = "object"
                            }
                            "tolerations" = {
                              "description" = <<-EOT
                              Tolerations work with taints to ensure that Envoy pods are not scheduled onto inappropriate nodes. One or more taints are applied to a node; this marks that the node should not accept any pods that do not tolerate the taints.
                               The default is an empty list.
                               See https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ for additional details.
                              EOT
                              "items" = {
                                "description" = "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
                                "properties" = {
                                  "effect" = {
                                    "description" = "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                                    "type" = "string"
                                  }
                                  "key" = {
                                    "description" = "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                                    "type" = "string"
                                  }
                                  "operator" = {
                                    "description" = "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                                    "type" = "string"
                                  }
                                  "tolerationSeconds" = {
                                    "description" = "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system."
                                    "format" = "int64"
                                    "type" = "integer"
                                  }
                                  "value" = {
                                    "description" = "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                                    "type" = "string"
                                  }
                                }
                                "type" = "object"
                              }
                              "type" = "array"
                            }
                          }
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                    "replicas" = {
                      "default" = 2
                      "description" = "Replicas is the desired number of Contour replicas. If unset, defaults to 2."
                      "format" = "int32"
                      "minimum" = 0
                      "type" = "integer"
                    }
                  }
                  "type" = "object"
                }
                "status" = {
                  "description" = "Status defines the observed state of Contour."
                  "properties" = {
                    "availableContours" = {
                      "description" = "AvailableContours is the number of observed available replicas according to the Contour deployment. The deployment and its pods will reside in the namespace specified by spec.namespace.name of the contour."
                      "format" = "int32"
                      "type" = "integer"
                    }
                    "availableEnvoys" = {
                      "description" = "AvailableEnvoys is the number of observed available pods from the Envoy daemonset. The daemonset and its pods will reside in the namespace specified by spec.namespace.name of the contour."
                      "format" = "int32"
                      "type" = "integer"
                    }
                    "conditions" = {
                      "description" = "Conditions represent the observations of a contour's current state. Known condition types are \"Available\". Reference the condition type for additional details."
                      "items" = {
                        "description" = <<-EOT
                        Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: "Available", "Progressing", and "Degraded"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:"conditions,omitempty" patchStrategy:"merge" patchMergeKey:"type" protobuf:"bytes,1,rep,name=conditions"`
                             // other fields }
                        EOT
                        "properties" = {
                          "lastTransitionTime" = {
                            "description" = "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "message is a human readable message indicating details about the transition. This may be an empty string."
                            "maxLength" = 32768
                            "type" = "string"
                          }
                          "observedGeneration" = {
                            "description" = "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."
                            "format" = "int64"
                            "minimum" = 0
                            "type" = "integer"
                          }
                          "reason" = {
                            "description" = "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."
                            "maxLength" = 1024
                            "minLength" = 1
                            "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "status of the condition, one of True, False, Unknown."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                            "maxLength" = 316
                            "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "lastTransitionTime",
                          "message",
                          "reason",
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                      "x-kubernetes-list-map-keys" = [
                        "type",
                      ]
                      "x-kubernetes-list-type" = "map"
                    }
                  }
                  "required" = [
                    "availableContours",
                    "availableEnvoys",
                  ]
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_extensionservices_projectcontour_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.5.0"
      }
      "name" = "extensionservices.projectcontour.io"
    }
    "spec" = {
      "group" = "projectcontour.io"
      "names" = {
        "kind" = "ExtensionService"
        "listKind" = "ExtensionServiceList"
        "plural" = "extensionservices"
        "shortNames" = [
          "extensionservice",
          "extensionservices",
        ]
        "singular" = "extensionservice"
      }
      "preserveUnknownFields" = false
      "scope" = "Namespaced"
      "versions" = [
        {
          "name" = "v1alpha1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = "ExtensionService is the schema for the Contour extension services API. An ExtensionService resource binds a network service to the Contour API so that Contour API features can be implemented by collaborating components."
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "ExtensionServiceSpec defines the desired state of an ExtensionService resource."
                  "properties" = {
                    "loadBalancerPolicy" = {
                      "description" = "The policy for load balancing GRPC service requests. Note that the `Cookie` and `RequestHash` load balancing strategies cannot be used here."
                      "properties" = {
                        "requestHashPolicies" = {
                          "description" = "RequestHashPolicies contains a list of hash policies to apply when the `RequestHash` load balancing strategy is chosen. If an element of the supplied list of hash policies is invalid, it will be ignored. If the list of hash policies is empty after validation, the load balancing strategy will fall back the the default `RoundRobin`."
                          "items" = {
                            "description" = "RequestHashPolicy contains configuration for an individual hash policy on a request attribute."
                            "properties" = {
                              "headerHashOptions" = {
                                "description" = "HeaderHashOptions should be set when request header hash based load balancing is desired. It must be the only hash option field set, otherwise this request hash policy object will be ignored."
                                "properties" = {
                                  "headerName" = {
                                    "description" = "HeaderName is the name of the HTTP request header that will be used to calculate the hash key. If the header specified is not present on a request, no hash will be produced."
                                    "minLength" = 1
                                    "type" = "string"
                                  }
                                }
                                "type" = "object"
                              }
                              "terminal" = {
                                "description" = "Terminal is a flag that allows for short-circuiting computing of a hash for a given request. If set to true, and the request attribute specified in the attribute hash options is present, no further hash policies will be used to calculate a hash for the request."
                                "type" = "boolean"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                        "strategy" = {
                          "description" = "Strategy specifies the policy used to balance requests across the pool of backend pods. Valid policy names are `Random`, `RoundRobin`, `WeightedLeastRequest`, `Cookie`, and `RequestHash`. If an unknown strategy name is specified or no policy is supplied, the default `RoundRobin` policy is used."
                          "type" = "string"
                        }
                      }
                      "type" = "object"
                    }
                    "protocol" = {
                      "description" = "Protocol may be used to specify (or override) the protocol used to reach this Service. Values may be h2 or h2c. If omitted, protocol-selection falls back on Service annotations."
                      "enum" = [
                        "h2",
                        "h2c",
                      ]
                      "type" = "string"
                    }
                    "protocolVersion" = {
                      "description" = "This field sets the version of the GRPC protocol that Envoy uses to send requests to the extension service. Since Contour always uses the v3 Envoy API, this is currently fixed at \"v3\". However, other protocol options will be available in future."
                      "enum" = [
                        "v3",
                      ]
                      "type" = "string"
                    }
                    "services" = {
                      "description" = "Services specifies the set of Kubernetes Service resources that receive GRPC extension API requests. If no weights are specified for any of the entries in this array, traffic will be spread evenly across all the services. Otherwise, traffic is balanced proportionally to the Weight field in each entry."
                      "items" = {
                        "description" = "ExtensionServiceTarget defines an Kubernetes Service to target with extension service traffic."
                        "properties" = {
                          "name" = {
                            "description" = "Name is the name of Kubernetes service that will accept service traffic."
                            "type" = "string"
                          }
                          "port" = {
                            "description" = "Port (defined as Integer) to proxy traffic to since a service can have multiple defined."
                            "exclusiveMaximum" = true
                            "maximum" = 65536
                            "minimum" = 1
                            "type" = "integer"
                          }
                          "weight" = {
                            "description" = "Weight defines proportion of traffic to balance to the Kubernetes Service."
                            "format" = "int32"
                            "type" = "integer"
                          }
                        }
                        "required" = [
                          "name",
                          "port",
                        ]
                        "type" = "object"
                      }
                      "minItems" = 1
                      "type" = "array"
                    }
                    "timeoutPolicy" = {
                      "description" = "The timeout policy for requests to the services."
                      "properties" = {
                        "idle" = {
                          "description" = "Timeout after which, if there are no active requests for this route, the connection between Envoy and the backend or Envoy and the external client will be closed. If not specified, there is no per-route idle timeout, though a connection manager-wide stream_idle_timeout default of 5m still applies."
                          "pattern" = "^(((\\d*(\\.\\d*)?h)|(\\d*(\\.\\d*)?m)|(\\d*(\\.\\d*)?s)|(\\d*(\\.\\d*)?ms)|(\\d*(\\.\\d*)?us)|(\\d*(\\.\\d*)?µs)|(\\d*(\\.\\d*)?ns))+|infinity|infinite)$"
                          "type" = "string"
                        }
                        "response" = {
                          "description" = "Timeout for receiving a response from the server after processing a request from client. If not supplied, Envoy's default value of 15s applies."
                          "pattern" = "^(((\\d*(\\.\\d*)?h)|(\\d*(\\.\\d*)?m)|(\\d*(\\.\\d*)?s)|(\\d*(\\.\\d*)?ms)|(\\d*(\\.\\d*)?us)|(\\d*(\\.\\d*)?µs)|(\\d*(\\.\\d*)?ns))+|infinity|infinite)$"
                          "type" = "string"
                        }
                      }
                      "type" = "object"
                    }
                    "validation" = {
                      "description" = "UpstreamValidation defines how to verify the backend service's certificate"
                      "properties" = {
                        "caSecret" = {
                          "description" = "Name or namespaced name of the Kubernetes secret used to validate the certificate presented by the backend"
                          "type" = "string"
                        }
                        "subjectName" = {
                          "description" = "Key which is expected to be present in the 'subjectAltName' of the presented certificate"
                          "type" = "string"
                        }
                      }
                      "required" = [
                        "caSecret",
                        "subjectName",
                      ]
                      "type" = "object"
                    }
                  }
                  "required" = [
                    "services",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "description" = "ExtensionServiceStatus defines the observed state of an ExtensionService resource."
                  "properties" = {
                    "conditions" = {
                      "description" = <<-EOT
                      Conditions contains the current status of the ExtensionService resource.
                       Contour will update a single condition, `Valid`, that is in normal-true polarity.
                       Contour will not modify any other Conditions set in this block, in case some other controller wants to add a Condition.
                      EOT
                      "items" = {
                        "description" = <<-EOT
                        DetailedCondition is an extension of the normal Kubernetes conditions, with two extra fields to hold sub-conditions, which provide more detailed reasons for the state (True or False) of the condition.
                         `errors` holds information about sub-conditions which are fatal to that condition and render its state False.
                         `warnings` holds information about sub-conditions which are not fatal to that condition and do not force the state to be False.
                         Remember that Conditions have a type, a status, and a reason.
                         The type is the type of the condition, the most important one in this CRD set is `Valid`. `Valid` is a positive-polarity condition: when it is `status: true` there are no problems.
                         In more detail, `status: true` means that the object is has been ingested into Contour with no errors. `warnings` may still be present, and will be indicated in the Reason field. There must be zero entries in the `errors` slice in this case.
                         `Valid`, `status: false` means that the object has had one or more fatal errors during processing into Contour.  The details of the errors will be present under the `errors` field. There must be at least one error in the `errors` slice if `status` is `false`.
                         For DetailedConditions of types other than `Valid`, the Condition must be in the negative polarity. When they have `status` `true`, there is an error. There must be at least one entry in the `errors` Subcondition slice. When they have `status` `false`, there are no serious errors, and there must be zero entries in the `errors` slice. In either case, there may be entries in the `warnings` slice.
                         Regardless of the polarity, the `reason` and `message` fields must be updated with either the detail of the reason (if there is one and only one entry in total across both the `errors` and `warnings` slices), or `MultipleReasons` if there is more than one entry.
                        EOT
                        "properties" = {
                          "errors" = {
                            "description" = <<-EOT
                            Errors contains a slice of relevant error subconditions for this object.
                             Subconditions are expected to appear when relevant (when there is a error), and disappear when not relevant. An empty slice here indicates no errors.
                            EOT
                            "items" = {
                              "description" = <<-EOT
                              SubCondition is a Condition-like type intended for use as a subcondition inside a DetailedCondition.
                               It contains a subset of the Condition fields.
                               It is intended for warnings and errors, so `type` names should use abnormal-true polarity, that is, they should be of the form "ErrorPresent: true".
                               The expected lifecycle for these errors is that they should only be present when the error or warning is, and should be removed when they are not relevant.
                              EOT
                              "properties" = {
                                "message" = {
                                  "description" = <<-EOT
                                  Message is a human readable message indicating details about the transition.
                                   This may be an empty string.
                                  EOT
                                  "maxLength" = 32768
                                  "type" = "string"
                                }
                                "reason" = {
                                  "description" = <<-EOT
                                  Reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API.
                                   The value should be a CamelCase string.
                                   This field may not be empty.
                                  EOT
                                  "maxLength" = 1024
                                  "minLength" = 1
                                  "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                                  "type" = "string"
                                }
                                "status" = {
                                  "description" = "Status of the condition, one of True, False, Unknown."
                                  "enum" = [
                                    "True",
                                    "False",
                                    "Unknown",
                                  ]
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = <<-EOT
                                  Type of condition in `CamelCase` or in `foo.example.com/CamelCase`.
                                   This must be in abnormal-true polarity, that is, `ErrorFound` or `controller.io/ErrorFound`.
                                   The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                                  EOT
                                  "maxLength" = 316
                                  "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "message",
                                "reason",
                                "status",
                                "type",
                              ]
                              "type" = "object"
                            }
                            "type" = "array"
                          }
                          "lastTransitionTime" = {
                            "description" = "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "message is a human readable message indicating details about the transition. This may be an empty string."
                            "maxLength" = 32768
                            "type" = "string"
                          }
                          "observedGeneration" = {
                            "description" = "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."
                            "format" = "int64"
                            "minimum" = 0
                            "type" = "integer"
                          }
                          "reason" = {
                            "description" = "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."
                            "maxLength" = 1024
                            "minLength" = 1
                            "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "status of the condition, one of True, False, Unknown."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                            "maxLength" = 316
                            "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                            "type" = "string"
                          }
                          "warnings" = {
                            "description" = <<-EOT
                            Warnings contains a slice of relevant warning subconditions for this object.
                             Subconditions are expected to appear when relevant (when there is a warning), and disappear when not relevant. An empty slice here indicates no warnings.
                            EOT
                            "items" = {
                              "description" = <<-EOT
                              SubCondition is a Condition-like type intended for use as a subcondition inside a DetailedCondition.
                               It contains a subset of the Condition fields.
                               It is intended for warnings and errors, so `type` names should use abnormal-true polarity, that is, they should be of the form "ErrorPresent: true".
                               The expected lifecycle for these errors is that they should only be present when the error or warning is, and should be removed when they are not relevant.
                              EOT
                              "properties" = {
                                "message" = {
                                  "description" = <<-EOT
                                  Message is a human readable message indicating details about the transition.
                                   This may be an empty string.
                                  EOT
                                  "maxLength" = 32768
                                  "type" = "string"
                                }
                                "reason" = {
                                  "description" = <<-EOT
                                  Reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API.
                                   The value should be a CamelCase string.
                                   This field may not be empty.
                                  EOT
                                  "maxLength" = 1024
                                  "minLength" = 1
                                  "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                                  "type" = "string"
                                }
                                "status" = {
                                  "description" = "Status of the condition, one of True, False, Unknown."
                                  "enum" = [
                                    "True",
                                    "False",
                                    "Unknown",
                                  ]
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = <<-EOT
                                  Type of condition in `CamelCase` or in `foo.example.com/CamelCase`.
                                   This must be in abnormal-true polarity, that is, `ErrorFound` or `controller.io/ErrorFound`.
                                   The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                                  EOT
                                  "maxLength" = 316
                                  "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "message",
                                "reason",
                                "status",
                                "type",
                              ]
                              "type" = "object"
                            }
                            "type" = "array"
                          }
                        }
                        "required" = [
                          "lastTransitionTime",
                          "message",
                          "reason",
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                      "x-kubernetes-list-map-keys" = [
                        "type",
                      ]
                      "x-kubernetes-list-type" = "map"
                    }
                  }
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_gatewayclasses_networking_x_k8s_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.5.0"
      }
      "name" = "gatewayclasses.networking.x-k8s.io"
    }
    "spec" = {
      "group" = "networking.x-k8s.io"
      "names" = {
        "categories" = [
          "gateway-api",
        ]
        "kind" = "GatewayClass"
        "listKind" = "GatewayClassList"
        "plural" = "gatewayclasses"
        "shortNames" = [
          "gc",
        ]
        "singular" = "gatewayclass"
      }
      "scope" = "Cluster"
      "versions" = [
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".spec.controller"
              "name" = "Controller"
              "type" = "string"
            },
            {
              "jsonPath" = ".metadata.creationTimestamp"
              "name" = "Age"
              "type" = "date"
            },
          ]
          "name" = "v1alpha1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = <<-EOT
              GatewayClass describes a class of Gateways available to the user for creating Gateway resources.
               GatewayClass is a Cluster level resource.
              EOT
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Spec defines the desired state of GatewayClass."
                  "properties" = {
                    "controller" = {
                      "description" = <<-EOT
                      Controller is a domain/path string that indicates the controller that is managing Gateways of this class.
                       Example: "acme.io/gateway-controller".
                       This field is not mutable and cannot be empty.
                       The format of this field is DOMAIN "/" PATH, where DOMAIN and PATH are valid Kubernetes names (https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names).
                       Support: Core
                      EOT
                      "maxLength" = 253
                      "type" = "string"
                    }
                    "parametersRef" = {
                      "description" = <<-EOT
                      ParametersRef is a reference to a resource that contains the configuration parameters corresponding to the GatewayClass. This is optional if the controller does not require any additional configuration.
                       ParametersRef can reference a standard Kubernetes resource, i.e. ConfigMap, or an implementation-specific custom resource. The resource can be cluster-scoped or namespace-scoped.
                       If the referent cannot be found, the GatewayClass's "InvalidParameters" status condition will be true.
                       Support: Custom
                      EOT
                      "properties" = {
                        "group" = {
                          "description" = "Group is the group of the referent."
                          "maxLength" = 253
                          "minLength" = 1
                          "type" = "string"
                        }
                        "kind" = {
                          "description" = "Kind is kind of the referent."
                          "maxLength" = 253
                          "minLength" = 1
                          "type" = "string"
                        }
                        "name" = {
                          "description" = "Name is the name of the referent."
                          "maxLength" = 253
                          "minLength" = 1
                          "type" = "string"
                        }
                        "namespace" = {
                          "description" = "Namespace is the namespace of the referent. This field is required when scope is set to \"Namespace\" and ignored when scope is set to \"Cluster\"."
                          "maxLength" = 253
                          "minLength" = 1
                          "type" = "string"
                        }
                        "scope" = {
                          "default" = "Cluster"
                          "description" = "Scope represents if the referent is a Cluster or Namespace scoped resource. This may be set to \"Cluster\" or \"Namespace\"."
                          "enum" = [
                            "Cluster",
                            "Namespace",
                          ]
                          "type" = "string"
                        }
                      }
                      "required" = [
                        "group",
                        "kind",
                        "name",
                      ]
                      "type" = "object"
                    }
                  }
                  "required" = [
                    "controller",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "default" = {
                    "conditions" = [
                      {
                        "lastTransitionTime" = "1970-01-01T00:00:00Z"
                        "message" = "Waiting for controller"
                        "reason" = "Waiting"
                        "status" = "False"
                        "type" = "Admitted"
                      },
                    ]
                  }
                  "description" = "Status defines the current state of GatewayClass."
                  "properties" = {
                    "conditions" = {
                      "default" = [
                        {
                          "lastTransitionTime" = "1970-01-01T00:00:00Z"
                          "message" = "Waiting for controller"
                          "reason" = "Waiting"
                          "status" = "False"
                          "type" = "Admitted"
                        },
                      ]
                      "description" = <<-EOT
                      Conditions is the current status from the controller for this GatewayClass.
                       Controllers should prefer to publish conditions using values of GatewayClassConditionType for the type of each Condition.
                      EOT
                      "items" = {
                        "description" = <<-EOT
                        Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: "Available", "Progressing", and "Degraded"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:"conditions,omitempty" patchStrategy:"merge" patchMergeKey:"type" protobuf:"bytes,1,rep,name=conditions"`
                             // other fields }
                        EOT
                        "properties" = {
                          "lastTransitionTime" = {
                            "description" = "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "message is a human readable message indicating details about the transition. This may be an empty string."
                            "maxLength" = 32768
                            "type" = "string"
                          }
                          "observedGeneration" = {
                            "description" = "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."
                            "format" = "int64"
                            "minimum" = 0
                            "type" = "integer"
                          }
                          "reason" = {
                            "description" = "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."
                            "maxLength" = 1024
                            "minLength" = 1
                            "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "status of the condition, one of True, False, Unknown."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                            "maxLength" = 316
                            "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "lastTransitionTime",
                          "message",
                          "reason",
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 8
                      "type" = "array"
                      "x-kubernetes-list-map-keys" = [
                        "type",
                      ]
                      "x-kubernetes-list-type" = "map"
                    }
                  }
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_gateways_networking_x_k8s_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.5.0"
      }
      "name" = "gateways.networking.x-k8s.io"
    }
    "spec" = {
      "group" = "networking.x-k8s.io"
      "names" = {
        "categories" = [
          "gateway-api",
        ]
        "kind" = "Gateway"
        "listKind" = "GatewayList"
        "plural" = "gateways"
        "shortNames" = [
          "gtw",
        ]
        "singular" = "gateway"
      }
      "scope" = "Namespaced"
      "versions" = [
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".spec.gatewayClassName"
              "name" = "Class"
              "type" = "string"
            },
            {
              "jsonPath" = ".metadata.creationTimestamp"
              "name" = "Age"
              "type" = "date"
            },
          ]
          "name" = "v1alpha1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = <<-EOT
              Gateway represents an instantiation of a service-traffic handling infrastructure by binding Listeners to a set of IP addresses.
               Implementations should add the `gateway-exists-finalizer.networking.x-k8s.io` finalizer on the associated GatewayClass whenever Gateway(s) is running. This ensures that a GatewayClass associated with a Gateway(s) is not deleted while in use.
              EOT
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Spec defines the desired state of Gateway."
                  "properties" = {
                    "addresses" = {
                      "description" = <<-EOT
                      Addresses requested for this gateway. This is optional and behavior can depend on the GatewayClass. If a value is set in the spec and the requested address is invalid, the GatewayClass MUST indicate this in the associated entry in GatewayStatus.Addresses.
                       If no Addresses are specified, the GatewayClass may schedule the Gateway in an implementation-defined manner, assigning an appropriate set of Addresses.
                       The GatewayClass MUST bind all Listeners to every GatewayAddress that it assigns to the Gateway.
                       Support: Core
                      EOT
                      "items" = {
                        "description" = "GatewayAddress describes an address that can be bound to a Gateway."
                        "properties" = {
                          "type" = {
                            "default" = "IPAddress"
                            "description" = <<-EOT
                            Type of the address.
                             Support: Extended
                            EOT
                            "enum" = [
                              "IPAddress",
                              "NamedAddress",
                            ]
                            "type" = "string"
                          }
                          "value" = {
                            "description" = <<-EOT
                            Value of the address. The validity of the values will depend on the type and support by the controller.
                             Examples: `1.2.3.4`, `128::1`, `my-ip-address`.
                            EOT
                            "maxLength" = 253
                            "minLength" = 1
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "value",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 16
                      "type" = "array"
                    }
                    "gatewayClassName" = {
                      "description" = "GatewayClassName used for this Gateway. This is the name of a GatewayClass resource."
                      "maxLength" = 253
                      "minLength" = 1
                      "type" = "string"
                    }
                    "listeners" = {
                      "description" = <<-EOT
                      Listeners associated with this Gateway. Listeners define logical endpoints that are bound on this Gateway's addresses. At least one Listener MUST be specified.
                       An implementation MAY group Listeners by Port and then collapse each group of Listeners into a single Listener if the implementation determines that the Listeners in the group are "compatible". An implementation MAY also group together and collapse compatible Listeners belonging to different Gateways.
                       For example, an implementation might consider Listeners to be compatible with each other if all of the following conditions are met:
                       1. Either each Listener within the group specifies the "HTTP"    Protocol or each Listener within the group specifies either    the "HTTPS" or "TLS" Protocol.
                       2. Each Listener within the group specifies a Hostname that is unique    within the group.
                       3. As a special case, one Listener within a group may omit Hostname,    in which case this Listener matches when no other Listener    matches.
                       If the implementation does collapse compatible Listeners, the hostname provided in the incoming client request MUST be matched to a Listener to find the correct set of Routes. The incoming hostname MUST be matched using the Hostname field for each Listener in order of most to least specific. That is, exact matches must be processed before wildcard matches.
                       If this field specifies multiple Listeners that have the same Port value but are not compatible, the implementation must raise a "Conflicted" condition in the Listener status.
                       Support: Core
                      EOT
                      "items" = {
                        "description" = "Listener embodies the concept of a logical endpoint where a Gateway can accept network connections. Each listener in a Gateway must have a unique combination of Hostname, Port, and Protocol. This will be enforced by a validating webhook."
                        "properties" = {
                          "hostname" = {
                            "description" = <<-EOT
                            Hostname specifies the virtual hostname to match for protocol types that define this concept. When unspecified, "", or `*`, all hostnames are matched. This field can be omitted for protocols that don't require hostname based matching.
                             Hostname is the fully qualified domain name of a network host, as defined by RFC 3986. Note the following deviations from the "host" part of the URI as defined in the RFC:
                             1. IP literals are not allowed. 2. The `:` delimiter is not respected because ports are not allowed.
                             Hostname can be "precise" which is a domain name without the terminating dot of a network host (e.g. "foo.example.com") or "wildcard", which is a domain name prefixed with a single wildcard label (e.g. `*.example.com`). The wildcard character `*` must appear by itself as the first DNS label and matches only a single label.
                             Support: Core
                            EOT
                            "maxLength" = 253
                            "minLength" = 1
                            "type" = "string"
                          }
                          "port" = {
                            "description" = <<-EOT
                            Port is the network port. Multiple listeners may use the same port, subject to the Listener compatibility rules.
                             Support: Core
                            EOT
                            "format" = "int32"
                            "maximum" = 65535
                            "minimum" = 1
                            "type" = "integer"
                          }
                          "protocol" = {
                            "description" = <<-EOT
                            Protocol specifies the network protocol this listener expects to receive. The GatewayClass MUST apply the Hostname match appropriately for each protocol:
                             * For the "TLS" protocol, the Hostname match MUST be   applied to the [SNI](https://tools.ietf.org/html/rfc6066#section-3)   server name offered by the client. * For the "HTTP" protocol, the Hostname match MUST be   applied to the host portion of the   [effective request URI](https://tools.ietf.org/html/rfc7230#section-5.5)   or the [:authority pseudo-header](https://tools.ietf.org/html/rfc7540#section-8.1.2.3) * For the "HTTPS" protocol, the Hostname match MUST be   applied at both the TLS and HTTP protocol layers.
                             Support: Core
                            EOT
                            "type" = "string"
                          }
                          "routes" = {
                            "description" = <<-EOT
                            Routes specifies a schema for associating routes with the Listener using selectors. A Route is a resource capable of servicing a request and allows a cluster operator to expose a cluster resource (i.e. Service) by externally-reachable URL, load-balance traffic and terminate SSL/TLS.  Typically, a route is a "HTTPRoute" or "TCPRoute" in group "networking.x-k8s.io", however, an implementation may support other types of resources.
                             The Routes selector MUST select a set of objects that are compatible with the application protocol specified in the Protocol field.
                             Although a client request may technically match multiple route rules, only one rule may ultimately receive the request. Matching precedence MUST be determined in order of the following criteria:
                             * The most specific match. For example, the most specific HTTPRoute match   is determined by the longest matching combination of hostname and path. * The oldest Route based on creation timestamp. For example, a Route with   a creation timestamp of "2020-09-08 01:02:03" is given precedence over   a Route with a creation timestamp of "2020-09-08 01:02:04". * If everything else is equivalent, the Route appearing first in   alphabetical order (namespace/name) should be given precedence. For   example, foo/bar is given precedence over foo/baz.
                             All valid portions of a Route selected by this field should be supported. Invalid portions of a Route can be ignored (sometimes that will mean the full Route). If a portion of a Route transitions from valid to invalid, support for that portion of the Route should be dropped to ensure consistency. For example, even if a filter specified by a Route is invalid, the rest of the Route should still be supported.
                             Support: Core
                            EOT
                            "properties" = {
                              "group" = {
                                "default" = "networking.x-k8s.io"
                                "description" = <<-EOT
                                Group is the group of the route resource to select. Omitting the value or specifying the empty string indicates the networking.x-k8s.io API group. For example, use the following to select an HTTPRoute:
                                 routes:   kind: HTTPRoute
                                 Otherwise, if an alternative API group is desired, specify the desired group:
                                 routes:   group: acme.io   kind: FooRoute
                                 Support: Core
                                EOT
                                "maxLength" = 253
                                "minLength" = 1
                                "type" = "string"
                              }
                              "kind" = {
                                "description" = <<-EOT
                                Kind is the kind of the route resource to select.
                                 Kind MUST correspond to kinds of routes that are compatible with the application protocol specified in the Listener's Protocol field.
                                 If an implementation does not support or recognize this resource type, it SHOULD set the "ResolvedRefs" condition to false for this listener with the "InvalidRoutesRef" reason.
                                 Support: Core
                                EOT
                                "type" = "string"
                              }
                              "namespaces" = {
                                "default" = {
                                  "from" = "Same"
                                }
                                "description" = <<-EOT
                                Namespaces indicates in which namespaces Routes should be selected for this Gateway. This is restricted to the namespace of this Gateway by default.
                                 Support: Core
                                EOT
                                "properties" = {
                                  "from" = {
                                    "default" = "Same"
                                    "description" = <<-EOT
                                    From indicates where Routes will be selected for this Gateway. Possible values are: * All: Routes in all namespaces may be used by this Gateway. * Selector: Routes in namespaces selected by the selector may be used by   this Gateway. * Same: Only Routes in the same namespace may be used by this Gateway.
                                     Support: Core
                                    EOT
                                    "enum" = [
                                      "All",
                                      "Selector",
                                      "Same",
                                    ]
                                    "type" = "string"
                                  }
                                  "selector" = {
                                    "description" = <<-EOT
                                    Selector must be specified when From is set to "Selector". In that case, only Routes in Namespaces matching this Selector will be selected by this Gateway. This field is ignored for other values of "From".
                                     Support: Core
                                    EOT
                                    "properties" = {
                                      "matchExpressions" = {
                                        "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                        "items" = {
                                          "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                          "properties" = {
                                            "key" = {
                                              "description" = "key is the label key that the selector applies to."
                                              "type" = "string"
                                            }
                                            "operator" = {
                                              "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                              "type" = "string"
                                            }
                                            "values" = {
                                              "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                              "items" = {
                                                "type" = "string"
                                              }
                                              "type" = "array"
                                            }
                                          }
                                          "required" = [
                                            "key",
                                            "operator",
                                          ]
                                          "type" = "object"
                                        }
                                        "type" = "array"
                                      }
                                      "matchLabels" = {
                                        "additionalProperties" = {
                                          "type" = "string"
                                        }
                                        "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                        "type" = "object"
                                      }
                                    }
                                    "type" = "object"
                                  }
                                }
                                "type" = "object"
                              }
                              "selector" = {
                                "description" = <<-EOT
                                Selector specifies a set of route labels used for selecting routes to associate with the Gateway. If this Selector is defined, only routes matching the Selector are associated with the Gateway. An empty Selector matches all routes.
                                 Support: Core
                                EOT
                                "properties" = {
                                  "matchExpressions" = {
                                    "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                    "items" = {
                                      "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                      "properties" = {
                                        "key" = {
                                          "description" = "key is the label key that the selector applies to."
                                          "type" = "string"
                                        }
                                        "operator" = {
                                          "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                          "type" = "string"
                                        }
                                        "values" = {
                                          "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                          "items" = {
                                            "type" = "string"
                                          }
                                          "type" = "array"
                                        }
                                      }
                                      "required" = [
                                        "key",
                                        "operator",
                                      ]
                                      "type" = "object"
                                    }
                                    "type" = "array"
                                  }
                                  "matchLabels" = {
                                    "additionalProperties" = {
                                      "type" = "string"
                                    }
                                    "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                    "type" = "object"
                                  }
                                }
                                "type" = "object"
                              }
                            }
                            "required" = [
                              "kind",
                            ]
                            "type" = "object"
                          }
                          "tls" = {
                            "description" = <<-EOT
                            TLS is the TLS configuration for the Listener. This field is required if the Protocol field is "HTTPS" or "TLS" and ignored otherwise.
                             The association of SNIs to Certificate defined in GatewayTLSConfig is defined based on the Hostname field for this listener.
                             The GatewayClass MUST use the longest matching SNI out of all available certificates for any TLS handshake.
                             Support: Core
                            EOT
                            "properties" = {
                              "certificateRef" = {
                                "description" = <<-EOT
                                CertificateRef is a reference to a Kubernetes object that contains a TLS certificate and private key. This certificate is used to establish a TLS handshake for requests that match the hostname of the associated listener. The referenced object MUST reside in the same namespace as Gateway.
                                 This field is required when mode is set to "Terminate" (default) and optional otherwise.
                                 CertificateRef can reference a standard Kubernetes resource, i.e. Secret, or an implementation-specific custom resource.
                                 Support: Core (Kubernetes Secrets)
                                 Support: Implementation-specific (Other resource types)
                                EOT
                                "properties" = {
                                  "group" = {
                                    "description" = "Group is the group of the referent."
                                    "maxLength" = 253
                                    "minLength" = 1
                                    "type" = "string"
                                  }
                                  "kind" = {
                                    "description" = "Kind is kind of the referent."
                                    "maxLength" = 253
                                    "minLength" = 1
                                    "type" = "string"
                                  }
                                  "name" = {
                                    "description" = "Name is the name of the referent."
                                    "maxLength" = 253
                                    "minLength" = 1
                                    "type" = "string"
                                  }
                                }
                                "required" = [
                                  "group",
                                  "kind",
                                  "name",
                                ]
                                "type" = "object"
                              }
                              "mode" = {
                                "default" = "Terminate"
                                "description" = <<-EOT
                                Mode defines the TLS behavior for the TLS session initiated by the client. There are two possible modes: - Terminate: The TLS session between the downstream client   and the Gateway is terminated at the Gateway. This mode requires   certificateRef to be set. - Passthrough: The TLS session is NOT terminated by the Gateway. This   implies that the Gateway can't decipher the TLS stream except for   the ClientHello message of the TLS protocol.   CertificateRef field is ignored in this mode.
                                 Support: Core
                                EOT
                                "enum" = [
                                  "Terminate",
                                  "Passthrough",
                                ]
                                "type" = "string"
                              }
                              "options" = {
                                "additionalProperties" = {
                                  "type" = "string"
                                }
                                "description" = <<-EOT
                                Options are a list of key/value pairs to give extended options to the provider.
                                 There variation among providers as to how ciphersuites are expressed. If there is a common subset for expressing ciphers then it will make sense to loft that as a core API construct.
                                 Support: Implementation-specific
                                EOT
                                "type" = "object"
                              }
                              "routeOverride" = {
                                "default" = {
                                  "certificate" = "Deny"
                                }
                                "description" = <<-EOT
                                RouteOverride dictates if TLS settings can be configured via Routes or not.
                                 CertificateRef must be defined even if `routeOverride.certificate` is set to 'Allow' as it will be used as the default certificate for the listener.
                                 Support: Core
                                EOT
                                "properties" = {
                                  "certificate" = {
                                    "default" = "Deny"
                                    "description" = <<-EOT
                                    Certificate dictates if TLS certificates can be configured via Routes. If set to 'Allow', a TLS certificate for a hostname defined in a Route takes precedence over the certificate defined in Gateway.
                                     Support: Core
                                    EOT
                                    "enum" = [
                                      "Allow",
                                      "Deny",
                                    ]
                                    "type" = "string"
                                  }
                                }
                                "type" = "object"
                              }
                            }
                            "type" = "object"
                          }
                        }
                        "required" = [
                          "port",
                          "protocol",
                          "routes",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 64
                      "minItems" = 1
                      "type" = "array"
                    }
                  }
                  "required" = [
                    "gatewayClassName",
                    "listeners",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "default" = {
                    "conditions" = [
                      {
                        "lastTransitionTime" = "1970-01-01T00:00:00Z"
                        "message" = "Waiting for controller"
                        "reason" = "NotReconciled"
                        "status" = "False"
                        "type" = "Scheduled"
                      },
                    ]
                  }
                  "description" = "Status defines the current state of Gateway."
                  "properties" = {
                    "addresses" = {
                      "description" = <<-EOT
                      Addresses lists the IP addresses that have actually been bound to the Gateway. These addresses may differ from the addresses in the Spec, e.g. if the Gateway automatically assigns an address from a reserved pool.
                       These addresses should all be of type "IPAddress".
                      EOT
                      "items" = {
                        "description" = "GatewayAddress describes an address that can be bound to a Gateway."
                        "properties" = {
                          "type" = {
                            "default" = "IPAddress"
                            "description" = <<-EOT
                            Type of the address.
                             Support: Extended
                            EOT
                            "enum" = [
                              "IPAddress",
                              "NamedAddress",
                            ]
                            "type" = "string"
                          }
                          "value" = {
                            "description" = <<-EOT
                            Value of the address. The validity of the values will depend on the type and support by the controller.
                             Examples: `1.2.3.4`, `128::1`, `my-ip-address`.
                            EOT
                            "maxLength" = 253
                            "minLength" = 1
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "value",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 16
                      "type" = "array"
                    }
                    "conditions" = {
                      "default" = [
                        {
                          "lastTransitionTime" = "1970-01-01T00:00:00Z"
                          "message" = "Waiting for controller"
                          "reason" = "NotReconciled"
                          "status" = "False"
                          "type" = "Scheduled"
                        },
                      ]
                      "description" = <<-EOT
                      Conditions describe the current conditions of the Gateway.
                       Implementations should prefer to express Gateway conditions using the `GatewayConditionType` and `GatewayConditionReason` constants so that operators and tools can converge on a common vocabulary to describe Gateway state.
                       Known condition types are:
                       * "Scheduled" * "Ready"
                      EOT
                      "items" = {
                        "description" = <<-EOT
                        Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: "Available", "Progressing", and "Degraded"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:"conditions,omitempty" patchStrategy:"merge" patchMergeKey:"type" protobuf:"bytes,1,rep,name=conditions"`
                             // other fields }
                        EOT
                        "properties" = {
                          "lastTransitionTime" = {
                            "description" = "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "message is a human readable message indicating details about the transition. This may be an empty string."
                            "maxLength" = 32768
                            "type" = "string"
                          }
                          "observedGeneration" = {
                            "description" = "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."
                            "format" = "int64"
                            "minimum" = 0
                            "type" = "integer"
                          }
                          "reason" = {
                            "description" = "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."
                            "maxLength" = 1024
                            "minLength" = 1
                            "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "status of the condition, one of True, False, Unknown."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                            "maxLength" = 316
                            "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "lastTransitionTime",
                          "message",
                          "reason",
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 8
                      "type" = "array"
                      "x-kubernetes-list-map-keys" = [
                        "type",
                      ]
                      "x-kubernetes-list-type" = "map"
                    }
                    "listeners" = {
                      "description" = "Listeners provide status for each unique listener port defined in the Spec."
                      "items" = {
                        "description" = "ListenerStatus is the status associated with a Listener."
                        "properties" = {
                          "conditions" = {
                            "description" = "Conditions describe the current condition of this listener."
                            "items" = {
                              "description" = <<-EOT
                              Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: "Available", "Progressing", and "Degraded"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:"conditions,omitempty" patchStrategy:"merge" patchMergeKey:"type" protobuf:"bytes,1,rep,name=conditions"`
                                   // other fields }
                              EOT
                              "properties" = {
                                "lastTransitionTime" = {
                                  "description" = "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."
                                  "format" = "date-time"
                                  "type" = "string"
                                }
                                "message" = {
                                  "description" = "message is a human readable message indicating details about the transition. This may be an empty string."
                                  "maxLength" = 32768
                                  "type" = "string"
                                }
                                "observedGeneration" = {
                                  "description" = "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."
                                  "format" = "int64"
                                  "minimum" = 0
                                  "type" = "integer"
                                }
                                "reason" = {
                                  "description" = "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."
                                  "maxLength" = 1024
                                  "minLength" = 1
                                  "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                                  "type" = "string"
                                }
                                "status" = {
                                  "description" = "status of the condition, one of True, False, Unknown."
                                  "enum" = [
                                    "True",
                                    "False",
                                    "Unknown",
                                  ]
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                                  "maxLength" = 316
                                  "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "lastTransitionTime",
                                "message",
                                "reason",
                                "status",
                                "type",
                              ]
                              "type" = "object"
                            }
                            "maxItems" = 8
                            "type" = "array"
                            "x-kubernetes-list-map-keys" = [
                              "type",
                            ]
                            "x-kubernetes-list-type" = "map"
                          }
                          "hostname" = {
                            "description" = "Hostname is the Listener hostname value for which this message is reporting the status."
                            "maxLength" = 253
                            "minLength" = 1
                            "type" = "string"
                          }
                          "port" = {
                            "description" = "Port is the unique Listener port value for which this message is reporting the status."
                            "format" = "int32"
                            "maximum" = 65535
                            "minimum" = 1
                            "type" = "integer"
                          }
                          "protocol" = {
                            "description" = "Protocol is the Listener protocol value for which this message is reporting the status."
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "conditions",
                          "port",
                          "protocol",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 64
                      "type" = "array"
                      "x-kubernetes-list-map-keys" = [
                        "port",
                      ]
                      "x-kubernetes-list-type" = "map"
                    }
                  }
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_httpproxies_projectcontour_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.5.0"
      }
      "name" = "httpproxies.projectcontour.io"
    }
    "spec" = {
      "group" = "projectcontour.io"
      "names" = {
        "kind" = "HTTPProxy"
        "listKind" = "HTTPProxyList"
        "plural" = "httpproxies"
        "shortNames" = [
          "proxy",
          "proxies",
        ]
        "singular" = "httpproxy"
      }
      "preserveUnknownFields" = false
      "scope" = "Namespaced"
      "versions" = [
        {
          "additionalPrinterColumns" = [
            {
              "description" = "Fully qualified domain name"
              "jsonPath" = ".spec.virtualhost.fqdn"
              "name" = "FQDN"
              "type" = "string"
            },
            {
              "description" = "Secret with TLS credentials"
              "jsonPath" = ".spec.virtualhost.tls.secretName"
              "name" = "TLS Secret"
              "type" = "string"
            },
            {
              "description" = "The current status of the HTTPProxy"
              "jsonPath" = ".status.currentStatus"
              "name" = "Status"
              "type" = "string"
            },
            {
              "description" = "Description of the current status"
              "jsonPath" = ".status.description"
              "name" = "Status Description"
              "type" = "string"
            },
          ]
          "name" = "v1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = "HTTPProxy is an Ingress CRD specification."
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "HTTPProxySpec defines the spec of the CRD."
                  "properties" = {
                    "includes" = {
                      "description" = "Includes allow for specific routing configuration to be included from another HTTPProxy, possibly in another namespace."
                      "items" = {
                        "description" = "Include describes a set of policies that can be applied to an HTTPProxy in a namespace."
                        "properties" = {
                          "conditions" = {
                            "description" = "Conditions are a set of rules that are applied to included HTTPProxies. In effect, they are added onto the Conditions of included HTTPProxy Route structs. When applied, they are merged using AND, with one exception: There can be only one Prefix MatchCondition per Conditions slice. More than one Prefix, or contradictory Conditions, will make the include invalid."
                            "items" = {
                              "description" = "MatchCondition are a general holder for matching rules for HTTPProxies. One of Prefix or Header must be provided."
                              "properties" = {
                                "header" = {
                                  "description" = "Header specifies the header condition to match."
                                  "properties" = {
                                    "contains" = {
                                      "description" = "Contains specifies a substring that must be present in the header value."
                                      "type" = "string"
                                    }
                                    "exact" = {
                                      "description" = "Exact specifies a string that the header value must be equal to."
                                      "type" = "string"
                                    }
                                    "name" = {
                                      "description" = "Name is the name of the header to match against. Name is required. Header names are case insensitive."
                                      "type" = "string"
                                    }
                                    "notcontains" = {
                                      "description" = "NotContains specifies a substring that must not be present in the header value."
                                      "type" = "string"
                                    }
                                    "notexact" = {
                                      "description" = "NoExact specifies a string that the header value must not be equal to. The condition is true if the header has any other value."
                                      "type" = "string"
                                    }
                                    "notpresent" = {
                                      "description" = "NotPresent specifies that condition is true when the named header is not present. Note that setting NotPresent to false does not make the condition true if the named header is present."
                                      "type" = "boolean"
                                    }
                                    "present" = {
                                      "description" = "Present specifies that condition is true when the named header is present, regardless of its value. Note that setting Present to false does not make the condition true if the named header is absent."
                                      "type" = "boolean"
                                    }
                                  }
                                  "required" = [
                                    "name",
                                  ]
                                  "type" = "object"
                                }
                                "prefix" = {
                                  "description" = "Prefix defines a prefix match for a request."
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "type" = "array"
                          }
                          "name" = {
                            "description" = "Name of the HTTPProxy"
                            "type" = "string"
                          }
                          "namespace" = {
                            "description" = "Namespace of the HTTPProxy to include. Defaults to the current namespace if not supplied."
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "name",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "ingressClassName" = {
                      "description" = "IngressClassName optionally specifies the ingress class to use for this HTTPProxy. This replaces the deprecated `kubernetes.io/ingress.class` annotation. For backwards compatibility, when that annotation is set, it is given precedence over this field."
                      "type" = "string"
                    }
                    "routes" = {
                      "description" = "Routes are the ingress routes. If TCPProxy is present, Routes is ignored."
                      "items" = {
                        "description" = "Route contains the set of routes for a virtual host."
                        "properties" = {
                          "authPolicy" = {
                            "description" = "AuthPolicy updates the authorization policy that was set on the root HTTPProxy object for client requests that match this route."
                            "properties" = {
                              "context" = {
                                "additionalProperties" = {
                                  "type" = "string"
                                }
                                "description" = "Context is a set of key/value pairs that are sent to the authentication server in the check request. If a context is provided at an enclosing scope, the entries are merged such that the inner scope overrides matching keys from the outer scope."
                                "type" = "object"
                              }
                              "disabled" = {
                                "description" = "When true, this field disables client request authentication for the scope of the policy."
                                "type" = "boolean"
                              }
                            }
                            "type" = "object"
                          }
                          "conditions" = {
                            "description" = "Conditions are a set of rules that are applied to a Route. When applied, they are merged using AND, with one exception: There can be only one Prefix MatchCondition per Conditions slice. More than one Prefix, or contradictory Conditions, will make the route invalid."
                            "items" = {
                              "description" = "MatchCondition are a general holder for matching rules for HTTPProxies. One of Prefix or Header must be provided."
                              "properties" = {
                                "header" = {
                                  "description" = "Header specifies the header condition to match."
                                  "properties" = {
                                    "contains" = {
                                      "description" = "Contains specifies a substring that must be present in the header value."
                                      "type" = "string"
                                    }
                                    "exact" = {
                                      "description" = "Exact specifies a string that the header value must be equal to."
                                      "type" = "string"
                                    }
                                    "name" = {
                                      "description" = "Name is the name of the header to match against. Name is required. Header names are case insensitive."
                                      "type" = "string"
                                    }
                                    "notcontains" = {
                                      "description" = "NotContains specifies a substring that must not be present in the header value."
                                      "type" = "string"
                                    }
                                    "notexact" = {
                                      "description" = "NoExact specifies a string that the header value must not be equal to. The condition is true if the header has any other value."
                                      "type" = "string"
                                    }
                                    "notpresent" = {
                                      "description" = "NotPresent specifies that condition is true when the named header is not present. Note that setting NotPresent to false does not make the condition true if the named header is present."
                                      "type" = "boolean"
                                    }
                                    "present" = {
                                      "description" = "Present specifies that condition is true when the named header is present, regardless of its value. Note that setting Present to false does not make the condition true if the named header is absent."
                                      "type" = "boolean"
                                    }
                                  }
                                  "required" = [
                                    "name",
                                  ]
                                  "type" = "object"
                                }
                                "prefix" = {
                                  "description" = "Prefix defines a prefix match for a request."
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "type" = "array"
                          }
                          "enableWebsockets" = {
                            "description" = "Enables websocket support for the route."
                            "type" = "boolean"
                          }
                          "healthCheckPolicy" = {
                            "description" = "The health check policy for this route."
                            "properties" = {
                              "healthyThresholdCount" = {
                                "description" = "The number of healthy health checks required before a host is marked healthy"
                                "format" = "int64"
                                "minimum" = 0
                                "type" = "integer"
                              }
                              "host" = {
                                "description" = "The value of the host header in the HTTP health check request. If left empty (default value), the name \"contour-envoy-healthcheck\" will be used."
                                "type" = "string"
                              }
                              "intervalSeconds" = {
                                "description" = "The interval (seconds) between health checks"
                                "format" = "int64"
                                "type" = "integer"
                              }
                              "path" = {
                                "description" = "HTTP endpoint used to perform health checks on upstream service"
                                "type" = "string"
                              }
                              "timeoutSeconds" = {
                                "description" = "The time to wait (seconds) for a health check response"
                                "format" = "int64"
                                "type" = "integer"
                              }
                              "unhealthyThresholdCount" = {
                                "description" = "The number of unhealthy health checks required before a host is marked unhealthy"
                                "format" = "int64"
                                "minimum" = 0
                                "type" = "integer"
                              }
                            }
                            "required" = [
                              "path",
                            ]
                            "type" = "object"
                          }
                          "loadBalancerPolicy" = {
                            "description" = "The load balancing policy for this route."
                            "properties" = {
                              "requestHashPolicies" = {
                                "description" = "RequestHashPolicies contains a list of hash policies to apply when the `RequestHash` load balancing strategy is chosen. If an element of the supplied list of hash policies is invalid, it will be ignored. If the list of hash policies is empty after validation, the load balancing strategy will fall back the the default `RoundRobin`."
                                "items" = {
                                  "description" = "RequestHashPolicy contains configuration for an individual hash policy on a request attribute."
                                  "properties" = {
                                    "headerHashOptions" = {
                                      "description" = "HeaderHashOptions should be set when request header hash based load balancing is desired. It must be the only hash option field set, otherwise this request hash policy object will be ignored."
                                      "properties" = {
                                        "headerName" = {
                                          "description" = "HeaderName is the name of the HTTP request header that will be used to calculate the hash key. If the header specified is not present on a request, no hash will be produced."
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                      }
                                      "type" = "object"
                                    }
                                    "terminal" = {
                                      "description" = "Terminal is a flag that allows for short-circuiting computing of a hash for a given request. If set to true, and the request attribute specified in the attribute hash options is present, no further hash policies will be used to calculate a hash for the request."
                                      "type" = "boolean"
                                    }
                                  }
                                  "type" = "object"
                                }
                                "type" = "array"
                              }
                              "strategy" = {
                                "description" = "Strategy specifies the policy used to balance requests across the pool of backend pods. Valid policy names are `Random`, `RoundRobin`, `WeightedLeastRequest`, `Cookie`, and `RequestHash`. If an unknown strategy name is specified or no policy is supplied, the default `RoundRobin` policy is used."
                                "type" = "string"
                              }
                            }
                            "type" = "object"
                          }
                          "pathRewritePolicy" = {
                            "description" = "The policy for rewriting the path of the request URL after the request has been routed to a Service."
                            "properties" = {
                              "replacePrefix" = {
                                "description" = "ReplacePrefix describes how the path prefix should be replaced."
                                "items" = {
                                  "description" = "ReplacePrefix describes a path prefix replacement."
                                  "properties" = {
                                    "prefix" = {
                                      "description" = <<-EOT
                                      Prefix specifies the URL path prefix to be replaced.
                                       If Prefix is specified, it must exactly match the MatchCondition prefix that is rendered by the chain of including HTTPProxies and only that path prefix will be replaced by Replacement. This allows HTTPProxies that are included through multiple roots to only replace specific path prefixes, leaving others unmodified.
                                       If Prefix is not specified, all routing prefixes rendered by the include chain will be replaced.
                                      EOT
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "replacement" = {
                                      "description" = "Replacement is the string that the routing path prefix will be replaced with. This must not be empty."
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "replacement",
                                  ]
                                  "type" = "object"
                                }
                                "type" = "array"
                              }
                            }
                            "type" = "object"
                          }
                          "permitInsecure" = {
                            "description" = "Allow this path to respond to insecure requests over HTTP which are normally not permitted when a `virtualhost.tls` block is present."
                            "type" = "boolean"
                          }
                          "rateLimitPolicy" = {
                            "description" = "The policy for rate limiting on the route."
                            "properties" = {
                              "global" = {
                                "description" = "Global defines global rate limiting parameters, i.e. parameters defining descriptors that are sent to an external rate limit service (RLS) for a rate limit decision on each request."
                                "properties" = {
                                  "descriptors" = {
                                    "description" = "Descriptors defines the list of descriptors that will be generated and sent to the rate limit service. Each descriptor contains 1+ key-value pair entries."
                                    "items" = {
                                      "description" = "RateLimitDescriptor defines a list of key-value pair generators."
                                      "properties" = {
                                        "entries" = {
                                          "description" = "Entries is the list of key-value pair generators."
                                          "items" = {
                                            "description" = "RateLimitDescriptorEntry is a key-value pair generator. Exactly one field on this struct must be non-nil."
                                            "properties" = {
                                              "genericKey" = {
                                                "description" = "GenericKey defines a descriptor entry with a static key and value."
                                                "properties" = {
                                                  "key" = {
                                                    "description" = "Key defines the key of the descriptor entry. If not set, the key is set to \"generic_key\"."
                                                    "type" = "string"
                                                  }
                                                  "value" = {
                                                    "description" = "Value defines the value of the descriptor entry."
                                                    "minLength" = 1
                                                    "type" = "string"
                                                  }
                                                }
                                                "type" = "object"
                                              }
                                              "remoteAddress" = {
                                                "description" = "RemoteAddress defines a descriptor entry with a key of \"remote_address\" and a value equal to the client's IP address (from x-forwarded-for)."
                                                "type" = "object"
                                              }
                                              "requestHeader" = {
                                                "description" = "RequestHeader defines a descriptor entry that's populated only if a given header is present on the request. The descriptor key is static, and the descriptor value is equal to the value of the header."
                                                "properties" = {
                                                  "descriptorKey" = {
                                                    "description" = "DescriptorKey defines the key to use on the descriptor entry."
                                                    "minLength" = 1
                                                    "type" = "string"
                                                  }
                                                  "headerName" = {
                                                    "description" = "HeaderName defines the name of the header to look for on the request."
                                                    "minLength" = 1
                                                    "type" = "string"
                                                  }
                                                }
                                                "type" = "object"
                                              }
                                              "requestHeaderValueMatch" = {
                                                "description" = "RequestHeaderValueMatch defines a descriptor entry that's populated if the request's headers match a set of 1+ match criteria. The descriptor key is \"header_match\", and the descriptor value is static."
                                                "properties" = {
                                                  "expectMatch" = {
                                                    "default" = true
                                                    "description" = "ExpectMatch defines whether the request must positively match the match criteria in order to generate a descriptor entry (i.e. true), or not match the match criteria in order to generate a descriptor entry (i.e. false). The default is true."
                                                    "type" = "boolean"
                                                  }
                                                  "headers" = {
                                                    "description" = "Headers is a list of 1+ match criteria to apply against the request to determine whether to populate the descriptor entry or not."
                                                    "items" = {
                                                      "description" = "HeaderMatchCondition specifies how to conditionally match against HTTP headers. The Name field is required, but only one of the remaining fields should be be provided."
                                                      "properties" = {
                                                        "contains" = {
                                                          "description" = "Contains specifies a substring that must be present in the header value."
                                                          "type" = "string"
                                                        }
                                                        "exact" = {
                                                          "description" = "Exact specifies a string that the header value must be equal to."
                                                          "type" = "string"
                                                        }
                                                        "name" = {
                                                          "description" = "Name is the name of the header to match against. Name is required. Header names are case insensitive."
                                                          "type" = "string"
                                                        }
                                                        "notcontains" = {
                                                          "description" = "NotContains specifies a substring that must not be present in the header value."
                                                          "type" = "string"
                                                        }
                                                        "notexact" = {
                                                          "description" = "NoExact specifies a string that the header value must not be equal to. The condition is true if the header has any other value."
                                                          "type" = "string"
                                                        }
                                                        "notpresent" = {
                                                          "description" = "NotPresent specifies that condition is true when the named header is not present. Note that setting NotPresent to false does not make the condition true if the named header is present."
                                                          "type" = "boolean"
                                                        }
                                                        "present" = {
                                                          "description" = "Present specifies that condition is true when the named header is present, regardless of its value. Note that setting Present to false does not make the condition true if the named header is absent."
                                                          "type" = "boolean"
                                                        }
                                                      }
                                                      "required" = [
                                                        "name",
                                                      ]
                                                      "type" = "object"
                                                    }
                                                    "minItems" = 1
                                                    "type" = "array"
                                                  }
                                                  "value" = {
                                                    "description" = "Value defines the value of the descriptor entry."
                                                    "minLength" = 1
                                                    "type" = "string"
                                                  }
                                                }
                                                "type" = "object"
                                              }
                                            }
                                            "type" = "object"
                                          }
                                          "minItems" = 1
                                          "type" = "array"
                                        }
                                      }
                                      "type" = "object"
                                    }
                                    "minItems" = 1
                                    "type" = "array"
                                  }
                                }
                                "type" = "object"
                              }
                              "local" = {
                                "description" = "Local defines local rate limiting parameters, i.e. parameters for rate limiting that occurs within each Envoy pod as requests are handled."
                                "properties" = {
                                  "burst" = {
                                    "description" = "Burst defines the number of requests above the requests per unit that should be allowed within a short period of time."
                                    "format" = "int32"
                                    "type" = "integer"
                                  }
                                  "requests" = {
                                    "description" = "Requests defines how many requests per unit of time should be allowed before rate limiting occurs."
                                    "format" = "int32"
                                    "minimum" = 1
                                    "type" = "integer"
                                  }
                                  "responseHeadersToAdd" = {
                                    "description" = "ResponseHeadersToAdd is an optional list of response headers to set when a request is rate-limited."
                                    "items" = {
                                      "description" = "HeaderValue represents a header name/value pair"
                                      "properties" = {
                                        "name" = {
                                          "description" = "Name represents a key of a header"
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                        "value" = {
                                          "description" = "Value represents the value of a header specified by a key"
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                      }
                                      "required" = [
                                        "name",
                                        "value",
                                      ]
                                      "type" = "object"
                                    }
                                    "type" = "array"
                                  }
                                  "responseStatusCode" = {
                                    "description" = "ResponseStatusCode is the HTTP status code to use for responses to rate-limited requests. Codes must be in the 400-599 range (inclusive). If not specified, the Envoy default of 429 (Too Many Requests) is used."
                                    "format" = "int32"
                                    "maximum" = 599
                                    "minimum" = 400
                                    "type" = "integer"
                                  }
                                  "unit" = {
                                    "description" = "Unit defines the period of time within which requests over the limit will be rate limited. Valid values are \"second\", \"minute\" and \"hour\"."
                                    "enum" = [
                                      "second",
                                      "minute",
                                      "hour",
                                    ]
                                    "type" = "string"
                                  }
                                }
                                "required" = [
                                  "requests",
                                  "unit",
                                ]
                                "type" = "object"
                              }
                            }
                            "type" = "object"
                          }
                          "requestHeadersPolicy" = {
                            "description" = "The policy for managing request headers during proxying."
                            "properties" = {
                              "remove" = {
                                "description" = "Remove specifies a list of HTTP header names to remove."
                                "items" = {
                                  "type" = "string"
                                }
                                "type" = "array"
                              }
                              "set" = {
                                "description" = "Set specifies a list of HTTP header values that will be set in the HTTP header. If the header does not exist it will be added, otherwise it will be overwritten with the new value."
                                "items" = {
                                  "description" = "HeaderValue represents a header name/value pair"
                                  "properties" = {
                                    "name" = {
                                      "description" = "Name represents a key of a header"
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "value" = {
                                      "description" = "Value represents the value of a header specified by a key"
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "name",
                                    "value",
                                  ]
                                  "type" = "object"
                                }
                                "type" = "array"
                              }
                            }
                            "type" = "object"
                          }
                          "responseHeadersPolicy" = {
                            "description" = "The policy for managing response headers during proxying. Rewriting the 'Host' header is not supported."
                            "properties" = {
                              "remove" = {
                                "description" = "Remove specifies a list of HTTP header names to remove."
                                "items" = {
                                  "type" = "string"
                                }
                                "type" = "array"
                              }
                              "set" = {
                                "description" = "Set specifies a list of HTTP header values that will be set in the HTTP header. If the header does not exist it will be added, otherwise it will be overwritten with the new value."
                                "items" = {
                                  "description" = "HeaderValue represents a header name/value pair"
                                  "properties" = {
                                    "name" = {
                                      "description" = "Name represents a key of a header"
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "value" = {
                                      "description" = "Value represents the value of a header specified by a key"
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "name",
                                    "value",
                                  ]
                                  "type" = "object"
                                }
                                "type" = "array"
                              }
                            }
                            "type" = "object"
                          }
                          "retryPolicy" = {
                            "description" = "The retry policy for this route."
                            "properties" = {
                              "count" = {
                                "description" = "NumRetries is maximum allowed number of retries. If not supplied, the number of retries is one."
                                "format" = "int64"
                                "minimum" = 0
                                "type" = "integer"
                              }
                              "perTryTimeout" = {
                                "description" = "PerTryTimeout specifies the timeout per retry attempt. Ignored if NumRetries is not supplied."
                                "pattern" = "^(((\\d*(\\.\\d*)?h)|(\\d*(\\.\\d*)?m)|(\\d*(\\.\\d*)?s)|(\\d*(\\.\\d*)?ms)|(\\d*(\\.\\d*)?us)|(\\d*(\\.\\d*)?µs)|(\\d*(\\.\\d*)?ns))+|infinity|infinite)$"
                                "type" = "string"
                              }
                              "retriableStatusCodes" = {
                                "description" = <<-EOT
                                RetriableStatusCodes specifies the HTTP status codes that should be retried.
                                 This field is only respected when you include `retriable-status-codes` in the `RetryOn` field.
                                EOT
                                "items" = {
                                  "format" = "int32"
                                  "type" = "integer"
                                }
                                "type" = "array"
                              }
                              "retryOn" = {
                                "description" = <<-EOT
                                RetryOn specifies the conditions on which to retry a request.
                                 Supported [HTTP conditions](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/router_filter#x-envoy-retry-on):
                                 - `5xx` - `gateway-error` - `reset` - `connect-failure` - `retriable-4xx` - `refused-stream` - `retriable-status-codes` - `retriable-headers`
                                 Supported [gRPC conditions](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/router_filter#x-envoy-retry-grpc-on):
                                 - `cancelled` - `deadline-exceeded` - `internal` - `resource-exhausted` - `unavailable`
                                EOT
                                "items" = {
                                  "description" = "RetryOn is a string type alias with validation to ensure that the value is valid."
                                  "enum" = [
                                    "5xx",
                                    "gateway-error",
                                    "reset",
                                    "connect-failure",
                                    "retriable-4xx",
                                    "refused-stream",
                                    "retriable-status-codes",
                                    "retriable-headers",
                                    "cancelled",
                                    "deadline-exceeded",
                                    "internal",
                                    "resource-exhausted",
                                    "unavailable",
                                  ]
                                  "type" = "string"
                                }
                                "type" = "array"
                              }
                            }
                            "type" = "object"
                          }
                          "services" = {
                            "description" = "Services are the services to proxy traffic."
                            "items" = {
                              "description" = "Service defines an Kubernetes Service to proxy traffic."
                              "properties" = {
                                "mirror" = {
                                  "description" = "If Mirror is true the Service will receive a read only mirror of the traffic for this route."
                                  "type" = "boolean"
                                }
                                "name" = {
                                  "description" = "Name is the name of Kubernetes service to proxy traffic. Names defined here will be used to look up corresponding endpoints which contain the ips to route."
                                  "type" = "string"
                                }
                                "port" = {
                                  "description" = "Port (defined as Integer) to proxy traffic to since a service can have multiple defined."
                                  "exclusiveMaximum" = true
                                  "maximum" = 65536
                                  "minimum" = 1
                                  "type" = "integer"
                                }
                                "protocol" = {
                                  "description" = "Protocol may be used to specify (or override) the protocol used to reach this Service. Values may be tls, h2, h2c. If omitted, protocol-selection falls back on Service annotations."
                                  "enum" = [
                                    "h2",
                                    "h2c",
                                    "tls",
                                  ]
                                  "type" = "string"
                                }
                                "requestHeadersPolicy" = {
                                  "description" = "The policy for managing request headers during proxying. Rewriting the 'Host' header is not supported."
                                  "properties" = {
                                    "remove" = {
                                      "description" = "Remove specifies a list of HTTP header names to remove."
                                      "items" = {
                                        "type" = "string"
                                      }
                                      "type" = "array"
                                    }
                                    "set" = {
                                      "description" = "Set specifies a list of HTTP header values that will be set in the HTTP header. If the header does not exist it will be added, otherwise it will be overwritten with the new value."
                                      "items" = {
                                        "description" = "HeaderValue represents a header name/value pair"
                                        "properties" = {
                                          "name" = {
                                            "description" = "Name represents a key of a header"
                                            "minLength" = 1
                                            "type" = "string"
                                          }
                                          "value" = {
                                            "description" = "Value represents the value of a header specified by a key"
                                            "minLength" = 1
                                            "type" = "string"
                                          }
                                        }
                                        "required" = [
                                          "name",
                                          "value",
                                        ]
                                        "type" = "object"
                                      }
                                      "type" = "array"
                                    }
                                  }
                                  "type" = "object"
                                }
                                "responseHeadersPolicy" = {
                                  "description" = "The policy for managing response headers during proxying. Rewriting the 'Host' header is not supported."
                                  "properties" = {
                                    "remove" = {
                                      "description" = "Remove specifies a list of HTTP header names to remove."
                                      "items" = {
                                        "type" = "string"
                                      }
                                      "type" = "array"
                                    }
                                    "set" = {
                                      "description" = "Set specifies a list of HTTP header values that will be set in the HTTP header. If the header does not exist it will be added, otherwise it will be overwritten with the new value."
                                      "items" = {
                                        "description" = "HeaderValue represents a header name/value pair"
                                        "properties" = {
                                          "name" = {
                                            "description" = "Name represents a key of a header"
                                            "minLength" = 1
                                            "type" = "string"
                                          }
                                          "value" = {
                                            "description" = "Value represents the value of a header specified by a key"
                                            "minLength" = 1
                                            "type" = "string"
                                          }
                                        }
                                        "required" = [
                                          "name",
                                          "value",
                                        ]
                                        "type" = "object"
                                      }
                                      "type" = "array"
                                    }
                                  }
                                  "type" = "object"
                                }
                                "validation" = {
                                  "description" = "UpstreamValidation defines how to verify the backend service's certificate"
                                  "properties" = {
                                    "caSecret" = {
                                      "description" = "Name or namespaced name of the Kubernetes secret used to validate the certificate presented by the backend"
                                      "type" = "string"
                                    }
                                    "subjectName" = {
                                      "description" = "Key which is expected to be present in the 'subjectAltName' of the presented certificate"
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "caSecret",
                                    "subjectName",
                                  ]
                                  "type" = "object"
                                }
                                "weight" = {
                                  "description" = "Weight defines percentage of traffic to balance traffic"
                                  "format" = "int64"
                                  "minimum" = 0
                                  "type" = "integer"
                                }
                              }
                              "required" = [
                                "name",
                                "port",
                              ]
                              "type" = "object"
                            }
                            "minItems" = 1
                            "type" = "array"
                          }
                          "timeoutPolicy" = {
                            "description" = "The timeout policy for this route."
                            "properties" = {
                              "idle" = {
                                "description" = "Timeout after which, if there are no active requests for this route, the connection between Envoy and the backend or Envoy and the external client will be closed. If not specified, there is no per-route idle timeout, though a connection manager-wide stream_idle_timeout default of 5m still applies."
                                "pattern" = "^(((\\d*(\\.\\d*)?h)|(\\d*(\\.\\d*)?m)|(\\d*(\\.\\d*)?s)|(\\d*(\\.\\d*)?ms)|(\\d*(\\.\\d*)?us)|(\\d*(\\.\\d*)?µs)|(\\d*(\\.\\d*)?ns))+|infinity|infinite)$"
                                "type" = "string"
                              }
                              "response" = {
                                "description" = "Timeout for receiving a response from the server after processing a request from client. If not supplied, Envoy's default value of 15s applies."
                                "pattern" = "^(((\\d*(\\.\\d*)?h)|(\\d*(\\.\\d*)?m)|(\\d*(\\.\\d*)?s)|(\\d*(\\.\\d*)?ms)|(\\d*(\\.\\d*)?us)|(\\d*(\\.\\d*)?µs)|(\\d*(\\.\\d*)?ns))+|infinity|infinite)$"
                                "type" = "string"
                              }
                            }
                            "type" = "object"
                          }
                        }
                        "required" = [
                          "services",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "tcpproxy" = {
                      "description" = "TCPProxy holds TCP proxy information."
                      "properties" = {
                        "healthCheckPolicy" = {
                          "description" = "The health check policy for this tcp proxy"
                          "properties" = {
                            "healthyThresholdCount" = {
                              "description" = "The number of healthy health checks required before a host is marked healthy"
                              "format" = "int32"
                              "type" = "integer"
                            }
                            "intervalSeconds" = {
                              "description" = "The interval (seconds) between health checks"
                              "format" = "int64"
                              "type" = "integer"
                            }
                            "timeoutSeconds" = {
                              "description" = "The time to wait (seconds) for a health check response"
                              "format" = "int64"
                              "type" = "integer"
                            }
                            "unhealthyThresholdCount" = {
                              "description" = "The number of unhealthy health checks required before a host is marked unhealthy"
                              "format" = "int32"
                              "type" = "integer"
                            }
                          }
                          "type" = "object"
                        }
                        "include" = {
                          "description" = "Include specifies that this tcpproxy should be delegated to another HTTPProxy."
                          "properties" = {
                            "name" = {
                              "description" = "Name of the child HTTPProxy"
                              "type" = "string"
                            }
                            "namespace" = {
                              "description" = "Namespace of the HTTPProxy to include. Defaults to the current namespace if not supplied."
                              "type" = "string"
                            }
                          }
                          "required" = [
                            "name",
                          ]
                          "type" = "object"
                        }
                        "includes" = {
                          "description" = <<-EOT
                          IncludesDeprecated allow for specific routing configuration to be appended to another HTTPProxy in another namespace.
                           Exists due to a mistake when developing HTTPProxy and the field was marked plural when it should have been singular. This field should stay to not break backwards compatibility to v1 users.
                          EOT
                          "properties" = {
                            "name" = {
                              "description" = "Name of the child HTTPProxy"
                              "type" = "string"
                            }
                            "namespace" = {
                              "description" = "Namespace of the HTTPProxy to include. Defaults to the current namespace if not supplied."
                              "type" = "string"
                            }
                          }
                          "required" = [
                            "name",
                          ]
                          "type" = "object"
                        }
                        "loadBalancerPolicy" = {
                          "description" = "The load balancing policy for the backend services. Note that the `Cookie` and `RequestHash` load balancing strategies cannot be used here."
                          "properties" = {
                            "requestHashPolicies" = {
                              "description" = "RequestHashPolicies contains a list of hash policies to apply when the `RequestHash` load balancing strategy is chosen. If an element of the supplied list of hash policies is invalid, it will be ignored. If the list of hash policies is empty after validation, the load balancing strategy will fall back the the default `RoundRobin`."
                              "items" = {
                                "description" = "RequestHashPolicy contains configuration for an individual hash policy on a request attribute."
                                "properties" = {
                                  "headerHashOptions" = {
                                    "description" = "HeaderHashOptions should be set when request header hash based load balancing is desired. It must be the only hash option field set, otherwise this request hash policy object will be ignored."
                                    "properties" = {
                                      "headerName" = {
                                        "description" = "HeaderName is the name of the HTTP request header that will be used to calculate the hash key. If the header specified is not present on a request, no hash will be produced."
                                        "minLength" = 1
                                        "type" = "string"
                                      }
                                    }
                                    "type" = "object"
                                  }
                                  "terminal" = {
                                    "description" = "Terminal is a flag that allows for short-circuiting computing of a hash for a given request. If set to true, and the request attribute specified in the attribute hash options is present, no further hash policies will be used to calculate a hash for the request."
                                    "type" = "boolean"
                                  }
                                }
                                "type" = "object"
                              }
                              "type" = "array"
                            }
                            "strategy" = {
                              "description" = "Strategy specifies the policy used to balance requests across the pool of backend pods. Valid policy names are `Random`, `RoundRobin`, `WeightedLeastRequest`, `Cookie`, and `RequestHash`. If an unknown strategy name is specified or no policy is supplied, the default `RoundRobin` policy is used."
                              "type" = "string"
                            }
                          }
                          "type" = "object"
                        }
                        "services" = {
                          "description" = "Services are the services to proxy traffic"
                          "items" = {
                            "description" = "Service defines an Kubernetes Service to proxy traffic."
                            "properties" = {
                              "mirror" = {
                                "description" = "If Mirror is true the Service will receive a read only mirror of the traffic for this route."
                                "type" = "boolean"
                              }
                              "name" = {
                                "description" = "Name is the name of Kubernetes service to proxy traffic. Names defined here will be used to look up corresponding endpoints which contain the ips to route."
                                "type" = "string"
                              }
                              "port" = {
                                "description" = "Port (defined as Integer) to proxy traffic to since a service can have multiple defined."
                                "exclusiveMaximum" = true
                                "maximum" = 65536
                                "minimum" = 1
                                "type" = "integer"
                              }
                              "protocol" = {
                                "description" = "Protocol may be used to specify (or override) the protocol used to reach this Service. Values may be tls, h2, h2c. If omitted, protocol-selection falls back on Service annotations."
                                "enum" = [
                                  "h2",
                                  "h2c",
                                  "tls",
                                ]
                                "type" = "string"
                              }
                              "requestHeadersPolicy" = {
                                "description" = "The policy for managing request headers during proxying. Rewriting the 'Host' header is not supported."
                                "properties" = {
                                  "remove" = {
                                    "description" = "Remove specifies a list of HTTP header names to remove."
                                    "items" = {
                                      "type" = "string"
                                    }
                                    "type" = "array"
                                  }
                                  "set" = {
                                    "description" = "Set specifies a list of HTTP header values that will be set in the HTTP header. If the header does not exist it will be added, otherwise it will be overwritten with the new value."
                                    "items" = {
                                      "description" = "HeaderValue represents a header name/value pair"
                                      "properties" = {
                                        "name" = {
                                          "description" = "Name represents a key of a header"
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                        "value" = {
                                          "description" = "Value represents the value of a header specified by a key"
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                      }
                                      "required" = [
                                        "name",
                                        "value",
                                      ]
                                      "type" = "object"
                                    }
                                    "type" = "array"
                                  }
                                }
                                "type" = "object"
                              }
                              "responseHeadersPolicy" = {
                                "description" = "The policy for managing response headers during proxying. Rewriting the 'Host' header is not supported."
                                "properties" = {
                                  "remove" = {
                                    "description" = "Remove specifies a list of HTTP header names to remove."
                                    "items" = {
                                      "type" = "string"
                                    }
                                    "type" = "array"
                                  }
                                  "set" = {
                                    "description" = "Set specifies a list of HTTP header values that will be set in the HTTP header. If the header does not exist it will be added, otherwise it will be overwritten with the new value."
                                    "items" = {
                                      "description" = "HeaderValue represents a header name/value pair"
                                      "properties" = {
                                        "name" = {
                                          "description" = "Name represents a key of a header"
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                        "value" = {
                                          "description" = "Value represents the value of a header specified by a key"
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                      }
                                      "required" = [
                                        "name",
                                        "value",
                                      ]
                                      "type" = "object"
                                    }
                                    "type" = "array"
                                  }
                                }
                                "type" = "object"
                              }
                              "validation" = {
                                "description" = "UpstreamValidation defines how to verify the backend service's certificate"
                                "properties" = {
                                  "caSecret" = {
                                    "description" = "Name or namespaced name of the Kubernetes secret used to validate the certificate presented by the backend"
                                    "type" = "string"
                                  }
                                  "subjectName" = {
                                    "description" = "Key which is expected to be present in the 'subjectAltName' of the presented certificate"
                                    "type" = "string"
                                  }
                                }
                                "required" = [
                                  "caSecret",
                                  "subjectName",
                                ]
                                "type" = "object"
                              }
                              "weight" = {
                                "description" = "Weight defines percentage of traffic to balance traffic"
                                "format" = "int64"
                                "minimum" = 0
                                "type" = "integer"
                              }
                            }
                            "required" = [
                              "name",
                              "port",
                            ]
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                      }
                      "type" = "object"
                    }
                    "virtualhost" = {
                      "description" = "Virtualhost appears at most once. If it is present, the object is considered to be a \"root\" HTTPProxy."
                      "properties" = {
                        "authorization" = {
                          "description" = "This field configures an extension service to perform authorization for this virtual host. Authorization can only be configured on virtual hosts that have TLS enabled. If the TLS configuration requires client certificate validation, the client certificate is always included in the authentication check request."
                          "properties" = {
                            "authPolicy" = {
                              "description" = "AuthPolicy sets a default authorization policy for client requests. This policy will be used unless overridden by individual routes."
                              "properties" = {
                                "context" = {
                                  "additionalProperties" = {
                                    "type" = "string"
                                  }
                                  "description" = "Context is a set of key/value pairs that are sent to the authentication server in the check request. If a context is provided at an enclosing scope, the entries are merged such that the inner scope overrides matching keys from the outer scope."
                                  "type" = "object"
                                }
                                "disabled" = {
                                  "description" = "When true, this field disables client request authentication for the scope of the policy."
                                  "type" = "boolean"
                                }
                              }
                              "type" = "object"
                            }
                            "extensionRef" = {
                              "description" = "ExtensionServiceRef specifies the extension resource that will authorize client requests."
                              "properties" = {
                                "apiVersion" = {
                                  "description" = "API version of the referent. If this field is not specified, the default \"projectcontour.io/v1alpha1\" will be used"
                                  "minLength" = 1
                                  "type" = "string"
                                }
                                "name" = {
                                  "description" = <<-EOT
                                  Name of the referent.
                                   More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                                  EOT
                                  "minLength" = 1
                                  "type" = "string"
                                }
                                "namespace" = {
                                  "description" = <<-EOT
                                  Namespace of the referent. If this field is not specifies, the namespace of the resource that targets the referent will be used.
                                   More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
                                  EOT
                                  "minLength" = 1
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "failOpen" = {
                              "description" = "If FailOpen is true, the client request is forwarded to the upstream service even if the authorization server fails to respond. This field should not be set in most cases. It is intended for use only while migrating applications from internal authorization to Contour external authorization."
                              "type" = "boolean"
                            }
                            "responseTimeout" = {
                              "description" = "ResponseTimeout configures maximum time to wait for a check response from the authorization server. Timeout durations are expressed in the Go [Duration format](https://godoc.org/time#ParseDuration). Valid time units are \"ns\", \"us\" (or \"µs\"), \"ms\", \"s\", \"m\", \"h\". The string \"infinity\" is also a valid input and specifies no timeout."
                              "pattern" = "^(((\\d*(\\.\\d*)?h)|(\\d*(\\.\\d*)?m)|(\\d*(\\.\\d*)?s)|(\\d*(\\.\\d*)?ms)|(\\d*(\\.\\d*)?us)|(\\d*(\\.\\d*)?µs)|(\\d*(\\.\\d*)?ns))+|infinity|infinite)$"
                              "type" = "string"
                            }
                          }
                          "required" = [
                            "extensionRef",
                          ]
                          "type" = "object"
                        }
                        "corsPolicy" = {
                          "description" = "Specifies the cross-origin policy to apply to the VirtualHost."
                          "properties" = {
                            "allowCredentials" = {
                              "description" = "Specifies whether the resource allows credentials."
                              "type" = "boolean"
                            }
                            "allowHeaders" = {
                              "description" = "AllowHeaders specifies the content for the *access-control-allow-headers* header."
                              "items" = {
                                "description" = "CORSHeaderValue specifies the value of the string headers returned by a cross-domain request."
                                "pattern" = "^[a-zA-Z0-9!#$%&'*+.^_`|~-]+$"
                                "type" = "string"
                              }
                              "type" = "array"
                            }
                            "allowMethods" = {
                              "description" = "AllowMethods specifies the content for the *access-control-allow-methods* header."
                              "items" = {
                                "description" = "CORSHeaderValue specifies the value of the string headers returned by a cross-domain request."
                                "pattern" = "^[a-zA-Z0-9!#$%&'*+.^_`|~-]+$"
                                "type" = "string"
                              }
                              "type" = "array"
                            }
                            "allowOrigin" = {
                              "description" = "AllowOrigin specifies the origins that will be allowed to do CORS requests. \"*\" means allow any origin."
                              "items" = {
                                "type" = "string"
                              }
                              "type" = "array"
                            }
                            "exposeHeaders" = {
                              "description" = "ExposeHeaders Specifies the content for the *access-control-expose-headers* header."
                              "items" = {
                                "description" = "CORSHeaderValue specifies the value of the string headers returned by a cross-domain request."
                                "pattern" = "^[a-zA-Z0-9!#$%&'*+.^_`|~-]+$"
                                "type" = "string"
                              }
                              "type" = "array"
                            }
                            "maxAge" = {
                              "description" = "MaxAge indicates for how long the results of a preflight request can be cached. MaxAge durations are expressed in the Go [Duration format](https://godoc.org/time#ParseDuration). Valid time units are \"ns\", \"us\" (or \"µs\"), \"ms\", \"s\", \"m\", \"h\". Only positive values are allowed while 0 disables the cache requiring a preflight OPTIONS check for all cross-origin requests."
                              "type" = "string"
                            }
                          }
                          "required" = [
                            "allowMethods",
                            "allowOrigin",
                          ]
                          "type" = "object"
                        }
                        "fqdn" = {
                          "description" = "The fully qualified domain name of the root of the ingress tree all leaves of the DAG rooted at this object relate to the fqdn."
                          "type" = "string"
                        }
                        "rateLimitPolicy" = {
                          "description" = "The policy for rate limiting on the virtual host."
                          "properties" = {
                            "global" = {
                              "description" = "Global defines global rate limiting parameters, i.e. parameters defining descriptors that are sent to an external rate limit service (RLS) for a rate limit decision on each request."
                              "properties" = {
                                "descriptors" = {
                                  "description" = "Descriptors defines the list of descriptors that will be generated and sent to the rate limit service. Each descriptor contains 1+ key-value pair entries."
                                  "items" = {
                                    "description" = "RateLimitDescriptor defines a list of key-value pair generators."
                                    "properties" = {
                                      "entries" = {
                                        "description" = "Entries is the list of key-value pair generators."
                                        "items" = {
                                          "description" = "RateLimitDescriptorEntry is a key-value pair generator. Exactly one field on this struct must be non-nil."
                                          "properties" = {
                                            "genericKey" = {
                                              "description" = "GenericKey defines a descriptor entry with a static key and value."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "Key defines the key of the descriptor entry. If not set, the key is set to \"generic_key\"."
                                                  "type" = "string"
                                                }
                                                "value" = {
                                                  "description" = "Value defines the value of the descriptor entry."
                                                  "minLength" = 1
                                                  "type" = "string"
                                                }
                                              }
                                              "type" = "object"
                                            }
                                            "remoteAddress" = {
                                              "description" = "RemoteAddress defines a descriptor entry with a key of \"remote_address\" and a value equal to the client's IP address (from x-forwarded-for)."
                                              "type" = "object"
                                            }
                                            "requestHeader" = {
                                              "description" = "RequestHeader defines a descriptor entry that's populated only if a given header is present on the request. The descriptor key is static, and the descriptor value is equal to the value of the header."
                                              "properties" = {
                                                "descriptorKey" = {
                                                  "description" = "DescriptorKey defines the key to use on the descriptor entry."
                                                  "minLength" = 1
                                                  "type" = "string"
                                                }
                                                "headerName" = {
                                                  "description" = "HeaderName defines the name of the header to look for on the request."
                                                  "minLength" = 1
                                                  "type" = "string"
                                                }
                                              }
                                              "type" = "object"
                                            }
                                            "requestHeaderValueMatch" = {
                                              "description" = "RequestHeaderValueMatch defines a descriptor entry that's populated if the request's headers match a set of 1+ match criteria. The descriptor key is \"header_match\", and the descriptor value is static."
                                              "properties" = {
                                                "expectMatch" = {
                                                  "default" = true
                                                  "description" = "ExpectMatch defines whether the request must positively match the match criteria in order to generate a descriptor entry (i.e. true), or not match the match criteria in order to generate a descriptor entry (i.e. false). The default is true."
                                                  "type" = "boolean"
                                                }
                                                "headers" = {
                                                  "description" = "Headers is a list of 1+ match criteria to apply against the request to determine whether to populate the descriptor entry or not."
                                                  "items" = {
                                                    "description" = "HeaderMatchCondition specifies how to conditionally match against HTTP headers. The Name field is required, but only one of the remaining fields should be be provided."
                                                    "properties" = {
                                                      "contains" = {
                                                        "description" = "Contains specifies a substring that must be present in the header value."
                                                        "type" = "string"
                                                      }
                                                      "exact" = {
                                                        "description" = "Exact specifies a string that the header value must be equal to."
                                                        "type" = "string"
                                                      }
                                                      "name" = {
                                                        "description" = "Name is the name of the header to match against. Name is required. Header names are case insensitive."
                                                        "type" = "string"
                                                      }
                                                      "notcontains" = {
                                                        "description" = "NotContains specifies a substring that must not be present in the header value."
                                                        "type" = "string"
                                                      }
                                                      "notexact" = {
                                                        "description" = "NoExact specifies a string that the header value must not be equal to. The condition is true if the header has any other value."
                                                        "type" = "string"
                                                      }
                                                      "notpresent" = {
                                                        "description" = "NotPresent specifies that condition is true when the named header is not present. Note that setting NotPresent to false does not make the condition true if the named header is present."
                                                        "type" = "boolean"
                                                      }
                                                      "present" = {
                                                        "description" = "Present specifies that condition is true when the named header is present, regardless of its value. Note that setting Present to false does not make the condition true if the named header is absent."
                                                        "type" = "boolean"
                                                      }
                                                    }
                                                    "required" = [
                                                      "name",
                                                    ]
                                                    "type" = "object"
                                                  }
                                                  "minItems" = 1
                                                  "type" = "array"
                                                }
                                                "value" = {
                                                  "description" = "Value defines the value of the descriptor entry."
                                                  "minLength" = 1
                                                  "type" = "string"
                                                }
                                              }
                                              "type" = "object"
                                            }
                                          }
                                          "type" = "object"
                                        }
                                        "minItems" = 1
                                        "type" = "array"
                                      }
                                    }
                                    "type" = "object"
                                  }
                                  "minItems" = 1
                                  "type" = "array"
                                }
                              }
                              "type" = "object"
                            }
                            "local" = {
                              "description" = "Local defines local rate limiting parameters, i.e. parameters for rate limiting that occurs within each Envoy pod as requests are handled."
                              "properties" = {
                                "burst" = {
                                  "description" = "Burst defines the number of requests above the requests per unit that should be allowed within a short period of time."
                                  "format" = "int32"
                                  "type" = "integer"
                                }
                                "requests" = {
                                  "description" = "Requests defines how many requests per unit of time should be allowed before rate limiting occurs."
                                  "format" = "int32"
                                  "minimum" = 1
                                  "type" = "integer"
                                }
                                "responseHeadersToAdd" = {
                                  "description" = "ResponseHeadersToAdd is an optional list of response headers to set when a request is rate-limited."
                                  "items" = {
                                    "description" = "HeaderValue represents a header name/value pair"
                                    "properties" = {
                                      "name" = {
                                        "description" = "Name represents a key of a header"
                                        "minLength" = 1
                                        "type" = "string"
                                      }
                                      "value" = {
                                        "description" = "Value represents the value of a header specified by a key"
                                        "minLength" = 1
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "name",
                                      "value",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "responseStatusCode" = {
                                  "description" = "ResponseStatusCode is the HTTP status code to use for responses to rate-limited requests. Codes must be in the 400-599 range (inclusive). If not specified, the Envoy default of 429 (Too Many Requests) is used."
                                  "format" = "int32"
                                  "maximum" = 599
                                  "minimum" = 400
                                  "type" = "integer"
                                }
                                "unit" = {
                                  "description" = "Unit defines the period of time within which requests over the limit will be rate limited. Valid values are \"second\", \"minute\" and \"hour\"."
                                  "enum" = [
                                    "second",
                                    "minute",
                                    "hour",
                                  ]
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "requests",
                                "unit",
                              ]
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "tls" = {
                          "description" = "If present the fields describes TLS properties of the virtual host. The SNI names that will be matched on are described in fqdn, the tls.secretName secret must contain a certificate that itself contains a name that matches the FQDN."
                          "properties" = {
                            "clientValidation" = {
                              "description" = <<-EOT
                              ClientValidation defines how to verify the client certificate when an external client establishes a TLS connection to Envoy.
                               This setting:
                               1. Enables TLS client certificate validation. 2. Specifies how the client certificate will be validated (i.e.    validation required or skipped).
                               Note: Setting client certificate validation to be skipped should be only used in conjunction with an external authorization server that performs client validation as Contour will ensure client certificates are passed along.
                              EOT
                              "properties" = {
                                "caSecret" = {
                                  "description" = "Name of a Kubernetes secret that contains a CA certificate bundle. The client certificate must validate against the certificates in the bundle. If specified and SkipClientCertValidation is true, client certificates will be required on requests."
                                  "minLength" = 1
                                  "type" = "string"
                                }
                                "skipClientCertValidation" = {
                                  "description" = "SkipClientCertValidation disables downstream client certificate validation. Defaults to false. This field is intended to be used in conjunction with external authorization in order to enable the external authorization server to validate client certificates. When this field is set to true, client certificates are requested but not verified by Envoy. If CACertificate is specified, client certificates are required on requests, but not verified. If external authorization is in use, they are presented to the external authorization server."
                                  "type" = "boolean"
                                }
                              }
                              "type" = "object"
                            }
                            "enableFallbackCertificate" = {
                              "description" = "EnableFallbackCertificate defines if the vhost should allow a default certificate to be applied which handles all requests which don't match the SNI defined in this vhost."
                              "type" = "boolean"
                            }
                            "minimumProtocolVersion" = {
                              "description" = "MinimumProtocolVersion is the minimum TLS version this vhost should negotiate. Valid options are `1.2` (default) and `1.3`. Any other value defaults to TLS 1.2."
                              "type" = "string"
                            }
                            "passthrough" = {
                              "description" = "Passthrough defines whether the encrypted TLS handshake will be passed through to the backing cluster. Either Passthrough or SecretName must be specified, but not both."
                              "type" = "boolean"
                            }
                            "secretName" = {
                              "description" = "SecretName is the name of a TLS secret in the current namespace. Either SecretName or Passthrough must be specified, but not both. If specified, the named secret must contain a matching certificate for the virtual host's FQDN."
                              "type" = "string"
                            }
                          }
                          "type" = "object"
                        }
                      }
                      "required" = [
                        "fqdn",
                      ]
                      "type" = "object"
                    }
                  }
                  "type" = "object"
                }
                "status" = {
                  "description" = "Status is a container for computed information about the HTTPProxy."
                  "properties" = {
                    "conditions" = {
                      "description" = <<-EOT
                      Conditions contains information about the current status of the HTTPProxy, in an upstream-friendly container.
                       Contour will update a single condition, `Valid`, that is in normal-true polarity. That is, when `currentStatus` is `valid`, the `Valid` condition will be `status: true`, and vice versa.
                       Contour will leave untouched any other Conditions set in this block, in case some other controller wants to add a Condition.
                       If you are another controller owner and wish to add a condition, you *should* namespace your condition with a label, like `controller.domain.com/ConditionName`.
                      EOT
                      "items" = {
                        "description" = <<-EOT
                        DetailedCondition is an extension of the normal Kubernetes conditions, with two extra fields to hold sub-conditions, which provide more detailed reasons for the state (True or False) of the condition.
                         `errors` holds information about sub-conditions which are fatal to that condition and render its state False.
                         `warnings` holds information about sub-conditions which are not fatal to that condition and do not force the state to be False.
                         Remember that Conditions have a type, a status, and a reason.
                         The type is the type of the condition, the most important one in this CRD set is `Valid`. `Valid` is a positive-polarity condition: when it is `status: true` there are no problems.
                         In more detail, `status: true` means that the object is has been ingested into Contour with no errors. `warnings` may still be present, and will be indicated in the Reason field. There must be zero entries in the `errors` slice in this case.
                         `Valid`, `status: false` means that the object has had one or more fatal errors during processing into Contour.  The details of the errors will be present under the `errors` field. There must be at least one error in the `errors` slice if `status` is `false`.
                         For DetailedConditions of types other than `Valid`, the Condition must be in the negative polarity. When they have `status` `true`, there is an error. There must be at least one entry in the `errors` Subcondition slice. When they have `status` `false`, there are no serious errors, and there must be zero entries in the `errors` slice. In either case, there may be entries in the `warnings` slice.
                         Regardless of the polarity, the `reason` and `message` fields must be updated with either the detail of the reason (if there is one and only one entry in total across both the `errors` and `warnings` slices), or `MultipleReasons` if there is more than one entry.
                        EOT
                        "properties" = {
                          "errors" = {
                            "description" = <<-EOT
                            Errors contains a slice of relevant error subconditions for this object.
                             Subconditions are expected to appear when relevant (when there is a error), and disappear when not relevant. An empty slice here indicates no errors.
                            EOT
                            "items" = {
                              "description" = <<-EOT
                              SubCondition is a Condition-like type intended for use as a subcondition inside a DetailedCondition.
                               It contains a subset of the Condition fields.
                               It is intended for warnings and errors, so `type` names should use abnormal-true polarity, that is, they should be of the form "ErrorPresent: true".
                               The expected lifecycle for these errors is that they should only be present when the error or warning is, and should be removed when they are not relevant.
                              EOT
                              "properties" = {
                                "message" = {
                                  "description" = <<-EOT
                                  Message is a human readable message indicating details about the transition.
                                   This may be an empty string.
                                  EOT
                                  "maxLength" = 32768
                                  "type" = "string"
                                }
                                "reason" = {
                                  "description" = <<-EOT
                                  Reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API.
                                   The value should be a CamelCase string.
                                   This field may not be empty.
                                  EOT
                                  "maxLength" = 1024
                                  "minLength" = 1
                                  "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                                  "type" = "string"
                                }
                                "status" = {
                                  "description" = "Status of the condition, one of True, False, Unknown."
                                  "enum" = [
                                    "True",
                                    "False",
                                    "Unknown",
                                  ]
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = <<-EOT
                                  Type of condition in `CamelCase` or in `foo.example.com/CamelCase`.
                                   This must be in abnormal-true polarity, that is, `ErrorFound` or `controller.io/ErrorFound`.
                                   The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                                  EOT
                                  "maxLength" = 316
                                  "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "message",
                                "reason",
                                "status",
                                "type",
                              ]
                              "type" = "object"
                            }
                            "type" = "array"
                          }
                          "lastTransitionTime" = {
                            "description" = "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "message is a human readable message indicating details about the transition. This may be an empty string."
                            "maxLength" = 32768
                            "type" = "string"
                          }
                          "observedGeneration" = {
                            "description" = "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."
                            "format" = "int64"
                            "minimum" = 0
                            "type" = "integer"
                          }
                          "reason" = {
                            "description" = "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."
                            "maxLength" = 1024
                            "minLength" = 1
                            "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "status of the condition, one of True, False, Unknown."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                            "maxLength" = 316
                            "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                            "type" = "string"
                          }
                          "warnings" = {
                            "description" = <<-EOT
                            Warnings contains a slice of relevant warning subconditions for this object.
                             Subconditions are expected to appear when relevant (when there is a warning), and disappear when not relevant. An empty slice here indicates no warnings.
                            EOT
                            "items" = {
                              "description" = <<-EOT
                              SubCondition is a Condition-like type intended for use as a subcondition inside a DetailedCondition.
                               It contains a subset of the Condition fields.
                               It is intended for warnings and errors, so `type` names should use abnormal-true polarity, that is, they should be of the form "ErrorPresent: true".
                               The expected lifecycle for these errors is that they should only be present when the error or warning is, and should be removed when they are not relevant.
                              EOT
                              "properties" = {
                                "message" = {
                                  "description" = <<-EOT
                                  Message is a human readable message indicating details about the transition.
                                   This may be an empty string.
                                  EOT
                                  "maxLength" = 32768
                                  "type" = "string"
                                }
                                "reason" = {
                                  "description" = <<-EOT
                                  Reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API.
                                   The value should be a CamelCase string.
                                   This field may not be empty.
                                  EOT
                                  "maxLength" = 1024
                                  "minLength" = 1
                                  "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                                  "type" = "string"
                                }
                                "status" = {
                                  "description" = "Status of the condition, one of True, False, Unknown."
                                  "enum" = [
                                    "True",
                                    "False",
                                    "Unknown",
                                  ]
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = <<-EOT
                                  Type of condition in `CamelCase` or in `foo.example.com/CamelCase`.
                                   This must be in abnormal-true polarity, that is, `ErrorFound` or `controller.io/ErrorFound`.
                                   The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                                  EOT
                                  "maxLength" = 316
                                  "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "message",
                                "reason",
                                "status",
                                "type",
                              ]
                              "type" = "object"
                            }
                            "type" = "array"
                          }
                        }
                        "required" = [
                          "lastTransitionTime",
                          "message",
                          "reason",
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                      "x-kubernetes-list-map-keys" = [
                        "type",
                      ]
                      "x-kubernetes-list-type" = "map"
                    }
                    "currentStatus" = {
                      "type" = "string"
                    }
                    "description" = {
                      "type" = "string"
                    }
                    "loadBalancer" = {
                      "description" = "LoadBalancer contains the current status of the load balancer."
                      "properties" = {
                        "ingress" = {
                          "description" = "Ingress is a list containing ingress points for the load-balancer. Traffic intended for the service should be sent to these ingress points."
                          "items" = {
                            "description" = "LoadBalancerIngress represents the status of a load-balancer ingress point: traffic intended for the service should be sent to an ingress point."
                            "properties" = {
                              "hostname" = {
                                "description" = "Hostname is set for load-balancer ingress points that are DNS based (typically AWS load-balancers)"
                                "type" = "string"
                              }
                              "ip" = {
                                "description" = "IP is set for load-balancer ingress points that are IP based (typically GCE or OpenStack load-balancers)"
                                "type" = "string"
                              }
                              "ports" = {
                                "description" = "Ports is a list of records of service ports If used, every port defined in the service should have an entry in it"
                                "items" = {
                                  "properties" = {
                                    "error" = {
                                      "description" = "Error is to record the problem with the service port The format of the error shall comply with the following rules: - built-in error values shall be specified in this file and those shall use   CamelCase names - cloud provider specific error values must have names that comply with the   format foo.example.com/CamelCase. --- The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                                      "maxLength" = 316
                                      "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                                      "type" = "string"
                                    }
                                    "port" = {
                                      "description" = "Port is the port number of the service port of which status is recorded here"
                                      "format" = "int32"
                                      "type" = "integer"
                                    }
                                    "protocol" = {
                                      "default" = "TCP"
                                      "description" = "Protocol is the protocol of the service port of which status is recorded here The supported values are: \"TCP\", \"UDP\", \"SCTP\""
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "port",
                                    "protocol",
                                  ]
                                  "type" = "object"
                                }
                                "type" = "array"
                                "x-kubernetes-list-type" = "atomic"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                      }
                      "type" = "object"
                    }
                  }
                  "type" = "object"
                }
              }
              "required" = [
                "metadata",
                "spec",
              ]
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_httproutes_networking_x_k8s_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.5.0"
      }
      "name" = "httproutes.networking.x-k8s.io"
    }
    "spec" = {
      "group" = "networking.x-k8s.io"
      "names" = {
        "categories" = [
          "gateway-api",
        ]
        "kind" = "HTTPRoute"
        "listKind" = "HTTPRouteList"
        "plural" = "httproutes"
        "singular" = "httproute"
      }
      "scope" = "Namespaced"
      "versions" = [
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".spec.hostnames"
              "name" = "Hostnames"
              "type" = "string"
            },
            {
              "jsonPath" = ".metadata.creationTimestamp"
              "name" = "Age"
              "type" = "date"
            },
          ]
          "name" = "v1alpha1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = "HTTPRoute is the Schema for the HTTPRoute resource."
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Spec defines the desired state of HTTPRoute."
                  "properties" = {
                    "gateways" = {
                      "default" = {
                        "allow" = "SameNamespace"
                      }
                      "description" = "Gateways defines which Gateways can use this Route."
                      "properties" = {
                        "allow" = {
                          "default" = "SameNamespace"
                          "description" = "Allow indicates which Gateways will be allowed to use this route. Possible values are: * All: Gateways in any namespace can use this route. * FromList: Only Gateways specified in GatewayRefs may use this route. * SameNamespace: Only Gateways in the same namespace may use this route."
                          "enum" = [
                            "All",
                            "FromList",
                            "SameNamespace",
                          ]
                          "type" = "string"
                        }
                        "gatewayRefs" = {
                          "description" = "GatewayRefs must be specified when Allow is set to \"FromList\". In that case, only Gateways referenced in this list will be allowed to use this route. This field is ignored for other values of \"Allow\"."
                          "items" = {
                            "description" = "GatewayReference identifies a Gateway in a specified namespace."
                            "properties" = {
                              "name" = {
                                "description" = "Name is the name of the referent."
                                "maxLength" = 253
                                "minLength" = 1
                                "type" = "string"
                              }
                              "namespace" = {
                                "description" = "Namespace is the namespace of the referent."
                                "maxLength" = 253
                                "minLength" = 1
                                "type" = "string"
                              }
                            }
                            "required" = [
                              "name",
                              "namespace",
                            ]
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                      }
                      "type" = "object"
                    }
                    "hostnames" = {
                      "description" = <<-EOT
                      Hostnames defines a set of hostname that should match against the HTTP Host header to select a HTTPRoute to process the request. Hostname is the fully qualified domain name of a network host, as defined by RFC 3986. Note the following deviations from the "host" part of the URI as defined in the RFC:
                       1. IPs are not allowed. 2. The `:` delimiter is not respected because ports are not allowed.
                       Incoming requests are matched against the hostnames before the HTTPRoute rules. If no hostname is specified, traffic is routed based on the HTTPRouteRules.
                       Hostname can be "precise" which is a domain name without the terminating dot of a network host (e.g. "foo.example.com") or "wildcard", which is a domain name prefixed with a single wildcard label (e.g. `*.example.com`). The wildcard character `*` must appear by itself as the first DNS label and matches only a single label. You cannot have a wildcard label by itself (e.g. Host == `*`). Requests will be matched against the Host field in the following order:
                       1. If Host is precise, the request matches this rule if    the HTTP Host header is equal to Host. 2. If Host is a wildcard, then the request matches this rule if    the HTTP Host header is to equal to the suffix    (removing the first label) of the wildcard rule.
                       Support: Core
                      EOT
                      "items" = {
                        "description" = "Hostname is used to specify a hostname that should be matched."
                        "maxLength" = 253
                        "minLength" = 1
                        "type" = "string"
                      }
                      "maxItems" = 16
                      "type" = "array"
                    }
                    "rules" = {
                      "default" = [
                        {
                          "matches" = [
                            {
                              "path" = {
                                "type" = "Prefix"
                                "value" = "/"
                              }
                            },
                          ]
                        },
                      ]
                      "description" = "Rules are a list of HTTP matchers, filters and actions."
                      "items" = {
                        "description" = "HTTPRouteRule defines semantics for matching an HTTP request based on conditions, optionally executing additional processing steps, and forwarding the request to an API object."
                        "properties" = {
                          "filters" = {
                            "description" = <<-EOT
                            Filters define the filters that are applied to requests that match this rule.
                             The effects of ordering of multiple behaviors are currently unspecified. This can change in the future based on feedback during the alpha stage.
                             Conformance-levels at this level are defined based on the type of filter:
                             - ALL core filters MUST be supported by all implementations. - Implementers are encouraged to support extended filters. - Implementation-specific custom filters have no API guarantees across   implementations.
                             Specifying a core filter multiple times has unspecified or custom conformance.
                             Support: Core
                            EOT
                            "items" = {
                              "description" = "HTTPRouteFilter defines additional processing steps that must be completed during the request or response lifecycle. HTTPRouteFilters are meant as an extension point to express additional processing that may be done in Gateway implementations. Some examples include request or response modification, implementing authentication strategies, rate-limiting, and traffic shaping. API guarantee/conformance is defined based on the type of the filter. TODO(hbagdi): re-render CRDs once controller-tools supports union tags: - https://github.com/kubernetes-sigs/controller-tools/pull/298 - https://github.com/kubernetes-sigs/controller-tools/issues/461"
                              "properties" = {
                                "extensionRef" = {
                                  "description" = <<-EOT
                                  ExtensionRef is an optional, implementation-specific extension to the "filter" behavior.  For example, resource "myroutefilter" in group "networking.acme.io"). ExtensionRef MUST NOT be used for core and extended filters.
                                   Support: Implementation-specific
                                  EOT
                                  "properties" = {
                                    "group" = {
                                      "description" = "Group is the group of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "kind" = {
                                      "description" = "Kind is kind of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "name" = {
                                      "description" = "Name is the name of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "group",
                                    "kind",
                                    "name",
                                  ]
                                  "type" = "object"
                                }
                                "requestHeaderModifier" = {
                                  "description" = <<-EOT
                                  RequestHeaderModifier defines a schema for a filter that modifies request headers.
                                   Support: Core
                                  EOT
                                  "properties" = {
                                    "add" = {
                                      "additionalProperties" = {
                                        "type" = "string"
                                      }
                                      "description" = <<-EOT
                                      Add adds the given header (name, value) to the request before the action. It appends to any existing values associated with the header name.
                                       Input:   GET /foo HTTP/1.1   my-header: foo
                                       Config:   add: {"my-header": "bar"}
                                       Output:   GET /foo HTTP/1.1   my-header: foo   my-header: bar
                                       Support: Extended
                                      EOT
                                      "type" = "object"
                                    }
                                    "remove" = {
                                      "description" = <<-EOT
                                      Remove the given header(s) from the HTTP request before the action. The value of RemoveHeader is a list of HTTP header names. Note that the header names are case-insensitive [RFC-2616 4.2].
                                       Input:   GET /foo HTTP/1.1   my-header1: foo   my-header2: bar   my-header3: baz
                                       Config:   remove: ["my-header1", "my-header3"]
                                       Output:   GET /foo HTTP/1.1   my-header2: bar
                                       Support: Extended
                                      EOT
                                      "items" = {
                                        "type" = "string"
                                      }
                                      "maxItems" = 16
                                      "type" = "array"
                                    }
                                    "set" = {
                                      "additionalProperties" = {
                                        "type" = "string"
                                      }
                                      "description" = <<-EOT
                                      Set overwrites the request with the given header (name, value) before the action.
                                       Input:   GET /foo HTTP/1.1   my-header: foo
                                       Config:   set: {"my-header": "bar"}
                                       Output:   GET /foo HTTP/1.1   my-header: bar
                                       Support: Extended
                                      EOT
                                      "type" = "object"
                                    }
                                  }
                                  "type" = "object"
                                }
                                "requestMirror" = {
                                  "description" = <<-EOT
                                  RequestMirror defines a schema for a filter that mirrors requests.
                                   Support: Extended
                                  EOT
                                  "properties" = {
                                    "backendRef" = {
                                      "description" = <<-EOT
                                      BackendRef is a local object reference to mirror matched requests to. If both BackendRef and ServiceName are specified, ServiceName will be given precedence.
                                       If the referent cannot be found, the rule is not included in the route. The controller should raise the "ResolvedRefs" condition on the Gateway with the "DegradedRoutes" reason. The gateway status for this route should be updated with a condition that describes the error more specifically.
                                       Support: Custom
                                      EOT
                                      "properties" = {
                                        "group" = {
                                          "description" = "Group is the group of the referent."
                                          "maxLength" = 253
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                        "kind" = {
                                          "description" = "Kind is kind of the referent."
                                          "maxLength" = 253
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                        "name" = {
                                          "description" = "Name is the name of the referent."
                                          "maxLength" = 253
                                          "minLength" = 1
                                          "type" = "string"
                                        }
                                      }
                                      "required" = [
                                        "group",
                                        "kind",
                                        "name",
                                      ]
                                      "type" = "object"
                                    }
                                    "port" = {
                                      "description" = <<-EOT
                                      Port specifies the destination port number to use for the backend referenced by the ServiceName or BackendRef field.
                                       If unspecified, the destination port in the request is used when forwarding to a backendRef or serviceName.
                                      EOT
                                      "format" = "int32"
                                      "maximum" = 65535
                                      "minimum" = 1
                                      "type" = "integer"
                                    }
                                    "serviceName" = {
                                      "description" = <<-EOT
                                      ServiceName refers to the name of the Service to mirror matched requests to. When specified, this takes the place of BackendRef. If both BackendRef and ServiceName are specified, ServiceName will be given precedence.
                                       If the referent cannot be found, the rule is not included in the route. The controller should raise the "ResolvedRefs" condition on the Gateway with the "DegradedRoutes" reason. The gateway status for this route should be updated with a condition that describes the error more specifically.
                                       Support: Core
                                      EOT
                                      "maxLength" = 253
                                      "type" = "string"
                                    }
                                  }
                                  "type" = "object"
                                }
                                "type" = {
                                  "description" = <<-EOT
                                  Type identifies the type of filter to apply. As with other API fields, types are classified into three conformance levels:
                                   - Core: Filter types and their corresponding configuration defined by   "Support: Core" in this package, e.g. "RequestHeaderModifier". All   implementations must support core filters.
                                   - Extended: Filter types and their corresponding configuration defined by   "Support: Extended" in this package, e.g. "RequestMirror". Implementers   are encouraged to support extended filters.
                                   - Custom: Filters that are defined and supported by specific vendors.   In the future, filters showing convergence in behavior across multiple   implementations will be considered for inclusion in extended or core   conformance levels. Filter-specific configuration for such filters   is specified using the ExtensionRef field. `Type` should be set to   "ExtensionRef" for custom filters.
                                   Implementers are encouraged to define custom implementation types to extend the core API with implementation-specific behavior.
                                  EOT
                                  "enum" = [
                                    "RequestHeaderModifier",
                                    "RequestMirror",
                                    "ExtensionRef",
                                  ]
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "type",
                              ]
                              "type" = "object"
                            }
                            "maxItems" = 16
                            "type" = "array"
                          }
                          "forwardTo" = {
                            "description" = "ForwardTo defines the backend(s) where matching requests should be sent. If unspecified, the rule performs no forwarding. If unspecified and no filters are specified that would result in a response being sent, a 503 error code is returned."
                            "items" = {
                              "description" = "HTTPRouteForwardTo defines how a HTTPRoute should forward a request."
                              "properties" = {
                                "backendRef" = {
                                  "description" = <<-EOT
                                  BackendRef is a reference to a backend to forward matched requests to. If both BackendRef and ServiceName are specified, ServiceName will be given precedence.
                                   If the referent cannot be found, the route must be dropped from the Gateway. The controller should raise the "ResolvedRefs" condition on the Gateway with the "DegradedRoutes" reason. The gateway status for this route should be updated with a condition that describes the error more specifically.
                                   Support: Custom
                                  EOT
                                  "properties" = {
                                    "group" = {
                                      "description" = "Group is the group of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "kind" = {
                                      "description" = "Kind is kind of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "name" = {
                                      "description" = "Name is the name of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "group",
                                    "kind",
                                    "name",
                                  ]
                                  "type" = "object"
                                }
                                "filters" = {
                                  "description" = <<-EOT
                                  Filters defined at this-level should be executed if and only if the request is being forwarded to the backend defined here.
                                   Support: Custom (For broader support of filters, use the Filters field in HTTPRouteRule.)
                                  EOT
                                  "items" = {
                                    "description" = "HTTPRouteFilter defines additional processing steps that must be completed during the request or response lifecycle. HTTPRouteFilters are meant as an extension point to express additional processing that may be done in Gateway implementations. Some examples include request or response modification, implementing authentication strategies, rate-limiting, and traffic shaping. API guarantee/conformance is defined based on the type of the filter. TODO(hbagdi): re-render CRDs once controller-tools supports union tags: - https://github.com/kubernetes-sigs/controller-tools/pull/298 - https://github.com/kubernetes-sigs/controller-tools/issues/461"
                                    "properties" = {
                                      "extensionRef" = {
                                        "description" = <<-EOT
                                        ExtensionRef is an optional, implementation-specific extension to the "filter" behavior.  For example, resource "myroutefilter" in group "networking.acme.io"). ExtensionRef MUST NOT be used for core and extended filters.
                                         Support: Implementation-specific
                                        EOT
                                        "properties" = {
                                          "group" = {
                                            "description" = "Group is the group of the referent."
                                            "maxLength" = 253
                                            "minLength" = 1
                                            "type" = "string"
                                          }
                                          "kind" = {
                                            "description" = "Kind is kind of the referent."
                                            "maxLength" = 253
                                            "minLength" = 1
                                            "type" = "string"
                                          }
                                          "name" = {
                                            "description" = "Name is the name of the referent."
                                            "maxLength" = 253
                                            "minLength" = 1
                                            "type" = "string"
                                          }
                                        }
                                        "required" = [
                                          "group",
                                          "kind",
                                          "name",
                                        ]
                                        "type" = "object"
                                      }
                                      "requestHeaderModifier" = {
                                        "description" = <<-EOT
                                        RequestHeaderModifier defines a schema for a filter that modifies request headers.
                                         Support: Core
                                        EOT
                                        "properties" = {
                                          "add" = {
                                            "additionalProperties" = {
                                              "type" = "string"
                                            }
                                            "description" = <<-EOT
                                            Add adds the given header (name, value) to the request before the action. It appends to any existing values associated with the header name.
                                             Input:   GET /foo HTTP/1.1   my-header: foo
                                             Config:   add: {"my-header": "bar"}
                                             Output:   GET /foo HTTP/1.1   my-header: foo   my-header: bar
                                             Support: Extended
                                            EOT
                                            "type" = "object"
                                          }
                                          "remove" = {
                                            "description" = <<-EOT
                                            Remove the given header(s) from the HTTP request before the action. The value of RemoveHeader is a list of HTTP header names. Note that the header names are case-insensitive [RFC-2616 4.2].
                                             Input:   GET /foo HTTP/1.1   my-header1: foo   my-header2: bar   my-header3: baz
                                             Config:   remove: ["my-header1", "my-header3"]
                                             Output:   GET /foo HTTP/1.1   my-header2: bar
                                             Support: Extended
                                            EOT
                                            "items" = {
                                              "type" = "string"
                                            }
                                            "maxItems" = 16
                                            "type" = "array"
                                          }
                                          "set" = {
                                            "additionalProperties" = {
                                              "type" = "string"
                                            }
                                            "description" = <<-EOT
                                            Set overwrites the request with the given header (name, value) before the action.
                                             Input:   GET /foo HTTP/1.1   my-header: foo
                                             Config:   set: {"my-header": "bar"}
                                             Output:   GET /foo HTTP/1.1   my-header: bar
                                             Support: Extended
                                            EOT
                                            "type" = "object"
                                          }
                                        }
                                        "type" = "object"
                                      }
                                      "requestMirror" = {
                                        "description" = <<-EOT
                                        RequestMirror defines a schema for a filter that mirrors requests.
                                         Support: Extended
                                        EOT
                                        "properties" = {
                                          "backendRef" = {
                                            "description" = <<-EOT
                                            BackendRef is a local object reference to mirror matched requests to. If both BackendRef and ServiceName are specified, ServiceName will be given precedence.
                                             If the referent cannot be found, the rule is not included in the route. The controller should raise the "ResolvedRefs" condition on the Gateway with the "DegradedRoutes" reason. The gateway status for this route should be updated with a condition that describes the error more specifically.
                                             Support: Custom
                                            EOT
                                            "properties" = {
                                              "group" = {
                                                "description" = "Group is the group of the referent."
                                                "maxLength" = 253
                                                "minLength" = 1
                                                "type" = "string"
                                              }
                                              "kind" = {
                                                "description" = "Kind is kind of the referent."
                                                "maxLength" = 253
                                                "minLength" = 1
                                                "type" = "string"
                                              }
                                              "name" = {
                                                "description" = "Name is the name of the referent."
                                                "maxLength" = 253
                                                "minLength" = 1
                                                "type" = "string"
                                              }
                                            }
                                            "required" = [
                                              "group",
                                              "kind",
                                              "name",
                                            ]
                                            "type" = "object"
                                          }
                                          "port" = {
                                            "description" = <<-EOT
                                            Port specifies the destination port number to use for the backend referenced by the ServiceName or BackendRef field.
                                             If unspecified, the destination port in the request is used when forwarding to a backendRef or serviceName.
                                            EOT
                                            "format" = "int32"
                                            "maximum" = 65535
                                            "minimum" = 1
                                            "type" = "integer"
                                          }
                                          "serviceName" = {
                                            "description" = <<-EOT
                                            ServiceName refers to the name of the Service to mirror matched requests to. When specified, this takes the place of BackendRef. If both BackendRef and ServiceName are specified, ServiceName will be given precedence.
                                             If the referent cannot be found, the rule is not included in the route. The controller should raise the "ResolvedRefs" condition on the Gateway with the "DegradedRoutes" reason. The gateway status for this route should be updated with a condition that describes the error more specifically.
                                             Support: Core
                                            EOT
                                            "maxLength" = 253
                                            "type" = "string"
                                          }
                                        }
                                        "type" = "object"
                                      }
                                      "type" = {
                                        "description" = <<-EOT
                                        Type identifies the type of filter to apply. As with other API fields, types are classified into three conformance levels:
                                         - Core: Filter types and their corresponding configuration defined by   "Support: Core" in this package, e.g. "RequestHeaderModifier". All   implementations must support core filters.
                                         - Extended: Filter types and their corresponding configuration defined by   "Support: Extended" in this package, e.g. "RequestMirror". Implementers   are encouraged to support extended filters.
                                         - Custom: Filters that are defined and supported by specific vendors.   In the future, filters showing convergence in behavior across multiple   implementations will be considered for inclusion in extended or core   conformance levels. Filter-specific configuration for such filters   is specified using the ExtensionRef field. `Type` should be set to   "ExtensionRef" for custom filters.
                                         Implementers are encouraged to define custom implementation types to extend the core API with implementation-specific behavior.
                                        EOT
                                        "enum" = [
                                          "RequestHeaderModifier",
                                          "RequestMirror",
                                          "ExtensionRef",
                                        ]
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "type",
                                    ]
                                    "type" = "object"
                                  }
                                  "maxItems" = 16
                                  "type" = "array"
                                }
                                "port" = {
                                  "description" = <<-EOT
                                  Port specifies the destination port number to use for the backend referenced by the ServiceName or BackendRef field. If unspecified, the destination port in the request is used when forwarding to a backendRef or serviceName.
                                   Support: Core
                                  EOT
                                  "format" = "int32"
                                  "maximum" = 65535
                                  "minimum" = 1
                                  "type" = "integer"
                                }
                                "serviceName" = {
                                  "description" = <<-EOT
                                  ServiceName refers to the name of the Service to forward matched requests to. When specified, this takes the place of BackendRef. If both BackendRef and ServiceName are specified, ServiceName will be given precedence.
                                   If the referent cannot be found, the route must be dropped from the Gateway. The controller should raise the "ResolvedRefs" condition on the Gateway with the "DegradedRoutes" reason. The gateway status for this route should be updated with a condition that describes the error more specifically.
                                   The protocol to use should be specified with the AppProtocol field on Service resources. This field was introduced in Kubernetes 1.18. If using an earlier version of Kubernetes, a `networking.x-k8s.io/app-protocol` annotation on the BackendPolicy resource may be used to define the protocol. If the AppProtocol field is available, this annotation should not be used. The AppProtocol field, when populated, takes precedence over the annotation in the BackendPolicy resource. For custom backends, it is encouraged to add a semantically-equivalent field in the Custom Resource Definition.
                                   Support: Core
                                  EOT
                                  "maxLength" = 253
                                  "type" = "string"
                                }
                                "weight" = {
                                  "default" = 1
                                  "description" = <<-EOT
                                  Weight specifies the proportion of HTTP requests forwarded to the backend referenced by the ServiceName or BackendRef field. This is computed as weight/(sum of all weights in this ForwardTo list). For non-zero values, there may be some epsilon from the exact proportion defined here depending on the precision an implementation supports. Weight is not a percentage and the sum of weights does not need to equal 100.
                                   If only one backend is specified and it has a weight greater than 0, 100% of the traffic is forwarded to that backend. If weight is set to 0, no traffic should be forwarded for this entry. If unspecified, weight defaults to 1.
                                   Support: Core
                                  EOT
                                  "format" = "int32"
                                  "maximum" = 1000000
                                  "minimum" = 0
                                  "type" = "integer"
                                }
                              }
                              "type" = "object"
                            }
                            "maxItems" = 16
                            "type" = "array"
                          }
                          "matches" = {
                            "default" = [
                              {
                                "path" = {
                                  "type" = "Prefix"
                                  "value" = "/"
                                }
                              },
                            ]
                            "description" = <<-EOT
                            Matches define conditions used for matching the rule against incoming HTTP requests. Each match is independent, i.e. this rule will be matched if **any** one of the matches is satisfied.
                             For example, take the following matches configuration:
                             ``` matches: - path:     value: "/foo"   headers:     values:       version: "2" - path:     value: "/v2/foo" ```
                             For a request to match against this rule, a request should satisfy EITHER of the two conditions:
                             - path prefixed with `/foo` AND contains the header `version: "2"` - path prefix of `/v2/foo`
                             See the documentation for HTTPRouteMatch on how to specify multiple match conditions that should be ANDed together.
                             If no matches are specified, the default is a prefix path match on "/", which has the effect of matching every HTTP request.
                             Each client request MUST map to a maximum of one route rule. If a request matches multiple rules, matching precedence MUST be determined in order of the following criteria, continuing on ties:
                             * The longest matching hostname. * The longest matching path. * The largest number of header matches.
                             If ties still exist across multiple Routes, matching precedence MUST be determined in order of the following criteria, continuing on ties:
                             * The oldest Route based on creation timestamp. For example, a Route with   a creation timestamp of "2020-09-08 01:02:03" is given precedence over   a Route with a creation timestamp of "2020-09-08 01:02:04". * The Route appearing first in alphabetical order by   "<namespace>/<name>". For example, foo/bar is given precedence over   foo/baz.
                             If ties still exist within the Route that has been given precedence, matching precedence MUST be granted to the first matching rule meeting the above criteria.
                            EOT
                            "items" = {
                              "description" = <<-EOT
                              HTTPRouteMatch defines the predicate used to match requests to a given action. Multiple match types are ANDed together, i.e. the match will evaluate to true only if all conditions are satisfied.
                               For example, the match below will match a HTTP request only if its path starts with `/foo` AND it contains the `version: "1"` header:
                               ``` match:   path:     value: "/foo"   headers:     values:       version: "1" ```
                              EOT
                              "properties" = {
                                "extensionRef" = {
                                  "description" = <<-EOT
                                  ExtensionRef is an optional, implementation-specific extension to the "match" behavior. For example, resource "myroutematcher" in group "networking.acme.io". If the referent cannot be found, the rule is not included in the route. The controller should raise the "ResolvedRefs" condition on the Gateway with the "DegradedRoutes" reason. The gateway status for this route should be updated with a condition that describes the error more specifically.
                                   Support: Custom
                                  EOT
                                  "properties" = {
                                    "group" = {
                                      "description" = "Group is the group of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "kind" = {
                                      "description" = "Kind is kind of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "name" = {
                                      "description" = "Name is the name of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "group",
                                    "kind",
                                    "name",
                                  ]
                                  "type" = "object"
                                }
                                "headers" = {
                                  "description" = "Headers specifies a HTTP request header matcher."
                                  "properties" = {
                                    "type" = {
                                      "default" = "Exact"
                                      "description" = <<-EOT
                                      Type specifies how to match against the value of the header.
                                       Support: Core (Exact)
                                       Support: Custom (RegularExpression, ImplementationSpecific)
                                       Since RegularExpression PathType has custom conformance, implementations can support POSIX, PCRE or any other dialects of regular expressions. Please read the implementation's documentation to determine the supported dialect.
                                       HTTP Header name matching MUST be case-insensitive (RFC 2616 - section 4.2).
                                      EOT
                                      "enum" = [
                                        "Exact",
                                        "RegularExpression",
                                        "ImplementationSpecific",
                                      ]
                                      "type" = "string"
                                    }
                                    "values" = {
                                      "additionalProperties" = {
                                        "type" = "string"
                                      }
                                      "description" = <<-EOT
                                      Values is a map of HTTP Headers to be matched. It MUST contain at least one entry.
                                       The HTTP header field name to match is the map key, and the value of the HTTP header is the map value. HTTP header field name matching MUST be case-insensitive.
                                       Multiple match values are ANDed together, meaning, a request must match all the specified headers to select the route.
                                      EOT
                                      "type" = "object"
                                    }
                                  }
                                  "required" = [
                                    "values",
                                  ]
                                  "type" = "object"
                                }
                                "path" = {
                                  "default" = {
                                    "type" = "Prefix"
                                    "value" = "/"
                                  }
                                  "description" = "Path specifies a HTTP request path matcher. If this field is not specified, a default prefix match on the \"/\" path is provided."
                                  "properties" = {
                                    "type" = {
                                      "default" = "Prefix"
                                      "description" = <<-EOT
                                      Type specifies how to match against the path Value.
                                       Support: Core (Exact, Prefix)
                                       Support: Custom (RegularExpression, ImplementationSpecific)
                                       Since RegularExpression PathType has custom conformance, implementations can support POSIX, PCRE or any other dialects of regular expressions. Please read the implementation's documentation to determine the supported dialect.
                                      EOT
                                      "enum" = [
                                        "Exact",
                                        "Prefix",
                                        "RegularExpression",
                                        "ImplementationSpecific",
                                      ]
                                      "type" = "string"
                                    }
                                    "value" = {
                                      "default" = "/"
                                      "description" = "Value of the HTTP path to match against."
                                      "type" = "string"
                                    }
                                  }
                                  "type" = "object"
                                }
                                "queryParams" = {
                                  "description" = "QueryParams specifies a HTTP query parameter matcher."
                                  "properties" = {
                                    "type" = {
                                      "default" = "Exact"
                                      "description" = <<-EOT
                                      Type specifies how to match against the value of the query parameter.
                                       Support: Extended (Exact)
                                       Support: Custom (RegularExpression, ImplementationSpecific)
                                       Since RegularExpression QueryParamMatchType has custom conformance, implementations can support POSIX, PCRE or any other dialects of regular expressions. Please read the implementation's documentation to determine the supported dialect.
                                      EOT
                                      "enum" = [
                                        "Exact",
                                        "RegularExpression",
                                        "ImplementationSpecific",
                                      ]
                                      "type" = "string"
                                    }
                                    "values" = {
                                      "additionalProperties" = {
                                        "type" = "string"
                                      }
                                      "description" = <<-EOT
                                      Values is a map of HTTP query parameters to be matched. It MUST contain at least one entry.
                                       The query parameter name to match is the map key, and the value of the query parameter is the map value.
                                       Multiple match values are ANDed together, meaning, a request must match all the specified query parameters to select the route.
                                       HTTP query parameter matching MUST be case-sensitive for both keys and values. (See https://tools.ietf.org/html/rfc7230#section-2.7.3).
                                       Note that the query parameter key MUST always be an exact match by string comparison.
                                      EOT
                                      "type" = "object"
                                    }
                                  }
                                  "required" = [
                                    "values",
                                  ]
                                  "type" = "object"
                                }
                              }
                              "type" = "object"
                            }
                            "maxItems" = 8
                            "type" = "array"
                          }
                        }
                        "type" = "object"
                      }
                      "maxItems" = 16
                      "type" = "array"
                    }
                    "tls" = {
                      "description" = <<-EOT
                      TLS defines the TLS certificate to use for Hostnames defined in this Route. This configuration only takes effect if the AllowRouteOverride field is set to true in the associated Gateway resource.
                       Collisions can happen if multiple HTTPRoutes define a TLS certificate for the same hostname. In such a case, conflict resolution guiding principles apply, specifically, if hostnames are same and two different certificates are specified then the certificate in the oldest resource wins.
                       Please note that HTTP Route-selection takes place after the TLS Handshake (ClientHello). Due to this, TLS certificate defined here will take precedence even if the request has the potential to match multiple routes (in case multiple HTTPRoutes share the same hostname).
                       Support: Core
                      EOT
                      "properties" = {
                        "certificateRef" = {
                          "description" = <<-EOT
                          CertificateRef is a reference to a Kubernetes object that contains a TLS certificate and private key. This certificate is used to establish a TLS handshake for requests that match the hostname of the associated HTTPRoute. The referenced object MUST reside in the same namespace as HTTPRoute.
                           This field is required when the TLS configuration mode of the associated Gateway listener is set to "Passthrough".
                           CertificateRef can reference a standard Kubernetes resource, i.e. Secret, or an implementation-specific custom resource.
                           Support: Core (Kubernetes Secrets)
                           Support: Implementation-specific (Other resource types)
                          EOT
                          "properties" = {
                            "group" = {
                              "description" = "Group is the group of the referent."
                              "maxLength" = 253
                              "minLength" = 1
                              "type" = "string"
                            }
                            "kind" = {
                              "description" = "Kind is kind of the referent."
                              "maxLength" = 253
                              "minLength" = 1
                              "type" = "string"
                            }
                            "name" = {
                              "description" = "Name is the name of the referent."
                              "maxLength" = 253
                              "minLength" = 1
                              "type" = "string"
                            }
                          }
                          "required" = [
                            "group",
                            "kind",
                            "name",
                          ]
                          "type" = "object"
                        }
                      }
                      "required" = [
                        "certificateRef",
                      ]
                      "type" = "object"
                    }
                  }
                  "type" = "object"
                }
                "status" = {
                  "description" = "Status defines the current state of HTTPRoute."
                  "properties" = {
                    "gateways" = {
                      "description" = <<-EOT
                      Gateways is a list of Gateways that are associated with the route, and the status of the route with respect to each Gateway. When a Gateway selects this route, the controller that manages the Gateway must add an entry to this list when the controller first sees the route and should update the entry as appropriate when the route is modified.
                       A maximum of 100 Gateways will be represented in this list. If this list is full, there may be additional Gateways using this Route that are not included in the list. An empty list means the route has not been admitted by any Gateway.
                      EOT
                      "items" = {
                        "description" = "RouteGatewayStatus describes the status of a route with respect to an associated Gateway."
                        "properties" = {
                          "conditions" = {
                            "description" = "Conditions describes the status of the route with respect to the Gateway. The \"Admitted\" condition must always be specified by controllers to indicate whether the route has been admitted or rejected by the Gateway, and why. Note that the route's availability is also subject to the Gateway's own status conditions and listener status."
                            "items" = {
                              "description" = <<-EOT
                              Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: "Available", "Progressing", and "Degraded"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:"conditions,omitempty" patchStrategy:"merge" patchMergeKey:"type" protobuf:"bytes,1,rep,name=conditions"`
                                   // other fields }
                              EOT
                              "properties" = {
                                "lastTransitionTime" = {
                                  "description" = "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."
                                  "format" = "date-time"
                                  "type" = "string"
                                }
                                "message" = {
                                  "description" = "message is a human readable message indicating details about the transition. This may be an empty string."
                                  "maxLength" = 32768
                                  "type" = "string"
                                }
                                "observedGeneration" = {
                                  "description" = "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."
                                  "format" = "int64"
                                  "minimum" = 0
                                  "type" = "integer"
                                }
                                "reason" = {
                                  "description" = "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."
                                  "maxLength" = 1024
                                  "minLength" = 1
                                  "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                                  "type" = "string"
                                }
                                "status" = {
                                  "description" = "status of the condition, one of True, False, Unknown."
                                  "enum" = [
                                    "True",
                                    "False",
                                    "Unknown",
                                  ]
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                                  "maxLength" = 316
                                  "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "lastTransitionTime",
                                "message",
                                "reason",
                                "status",
                                "type",
                              ]
                              "type" = "object"
                            }
                            "maxItems" = 8
                            "type" = "array"
                            "x-kubernetes-list-map-keys" = [
                              "type",
                            ]
                            "x-kubernetes-list-type" = "map"
                          }
                          "gatewayRef" = {
                            "description" = "GatewayRef is a reference to a Gateway object that is associated with the route."
                            "properties" = {
                              "controller" = {
                                "description" = <<-EOT
                                Controller is a domain/path string that indicates the controller implementing the Gateway. This corresponds with the controller field on GatewayClass.
                                 Example: "acme.io/gateway-controller".
                                 The format of this field is DOMAIN "/" PATH, where DOMAIN and PATH are valid Kubernetes names (https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names).
                                EOT
                                "maxLength" = 253
                                "type" = "string"
                              }
                              "name" = {
                                "description" = "Name is the name of the referent."
                                "maxLength" = 253
                                "minLength" = 1
                                "type" = "string"
                              }
                              "namespace" = {
                                "description" = "Namespace is the namespace of the referent."
                                "maxLength" = 253
                                "minLength" = 1
                                "type" = "string"
                              }
                            }
                            "required" = [
                              "name",
                              "namespace",
                            ]
                            "type" = "object"
                          }
                        }
                        "required" = [
                          "gatewayRef",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 100
                      "type" = "array"
                    }
                  }
                  "required" = [
                    "gateways",
                  ]
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_tcproutes_networking_x_k8s_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.5.0"
      }
      "name" = "tcproutes.networking.x-k8s.io"
    }
    "spec" = {
      "group" = "networking.x-k8s.io"
      "names" = {
        "categories" = [
          "gateway-api",
        ]
        "kind" = "TCPRoute"
        "listKind" = "TCPRouteList"
        "plural" = "tcproutes"
        "singular" = "tcproute"
      }
      "scope" = "Namespaced"
      "versions" = [
        {
          "additionalPrinterColumns" = [
            {
              "jsonPath" = ".metadata.creationTimestamp"
              "name" = "Age"
              "type" = "date"
            },
          ]
          "name" = "v1alpha1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = "TCPRoute is the Schema for the TCPRoute resource."
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "Spec defines the desired state of TCPRoute."
                  "properties" = {
                    "gateways" = {
                      "default" = {
                        "allow" = "SameNamespace"
                      }
                      "description" = "Gateways defines which Gateways can use this Route."
                      "properties" = {
                        "allow" = {
                          "default" = "SameNamespace"
                          "description" = "Allow indicates which Gateways will be allowed to use this route. Possible values are: * All: Gateways in any namespace can use this route. * FromList: Only Gateways specified in GatewayRefs may use this route. * SameNamespace: Only Gateways in the same namespace may use this route."
                          "enum" = [
                            "All",
                            "FromList",
                            "SameNamespace",
                          ]
                          "type" = "string"
                        }
                        "gatewayRefs" = {
                          "description" = "GatewayRefs must be specified when Allow is set to \"FromList\". In that case, only Gateways referenced in this list will be allowed to use this route. This field is ignored for other values of \"Allow\"."
                          "items" = {
                            "description" = "GatewayReference identifies a Gateway in a specified namespace."
                            "properties" = {
                              "name" = {
                                "description" = "Name is the name of the referent."
                                "maxLength" = 253
                                "minLength" = 1
                                "type" = "string"
                              }
                              "namespace" = {
                                "description" = "Namespace is the namespace of the referent."
                                "maxLength" = 253
                                "minLength" = 1
                                "type" = "string"
                              }
                            }
                            "required" = [
                              "name",
                              "namespace",
                            ]
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                      }
                      "type" = "object"
                    }
                    "rules" = {
                      "description" = "Rules are a list of TCP matchers and actions."
                      "items" = {
                        "description" = "TCPRouteRule is the configuration for a given rule."
                        "properties" = {
                          "forwardTo" = {
                            "description" = "ForwardTo defines the backend(s) where matching requests should be sent."
                            "items" = {
                              "description" = "RouteForwardTo defines how a Route should forward a request."
                              "properties" = {
                                "backendRef" = {
                                  "description" = <<-EOT
                                  BackendRef is a reference to a backend to forward matched requests to. If both BackendRef and ServiceName are specified, ServiceName will be given precedence.
                                   If the referent cannot be found, the rule is not included in the route. The controller should raise the "ResolvedRefs" condition on the Gateway with the "DegradedRoutes" reason. The gateway status for this route should be updated with a condition that describes the error more specifically.
                                   Support: Custom
                                  EOT
                                  "properties" = {
                                    "group" = {
                                      "description" = "Group is the group of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "kind" = {
                                      "description" = "Kind is kind of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "name" = {
                                      "description" = "Name is the name of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "group",
                                    "kind",
                                    "name",
                                  ]
                                  "type" = "object"
                                }
                                "port" = {
                                  "description" = <<-EOT
                                  Port specifies the destination port number to use for the backend referenced by the ServiceName or BackendRef field. If unspecified, the destination port in the request is used when forwarding to a backendRef or serviceName.
                                   Support: Core
                                  EOT
                                  "format" = "int32"
                                  "maximum" = 65535
                                  "minimum" = 1
                                  "type" = "integer"
                                }
                                "serviceName" = {
                                  "description" = <<-EOT
                                  ServiceName refers to the name of the Service to forward matched requests to. When specified, this takes the place of BackendRef. If both BackendRef and ServiceName are specified, ServiceName will be given precedence.
                                   If the referent cannot be found, the rule is not included in the route. The controller should raise the "ResolvedRefs" condition on the Gateway with the "DegradedRoutes" reason. The gateway status for this route should be updated with a condition that describes the error more specifically.
                                   The protocol to use is defined using AppProtocol field (introduced in Kubernetes 1.18) in the Service resource. In the absence of the AppProtocol field a `networking.x-k8s.io/app-protocol` annotation on the BackendPolicy resource may be used to define the protocol. If the AppProtocol field is available, this annotation should not be used. The AppProtocol field, when populated, takes precedence over the annotation in the BackendPolicy resource. For custom backends, it is encouraged to add a semantically-equivalent field in the Custom Resource Definition.
                                   Support: Core
                                  EOT
                                  "maxLength" = 253
                                  "type" = "string"
                                }
                                "weight" = {
                                  "default" = 1
                                  "description" = <<-EOT
                                  Weight specifies the proportion of HTTP requests forwarded to the backend referenced by the ServiceName or BackendRef field. This is computed as weight/(sum of all weights in this ForwardTo list). For non-zero values, there may be some epsilon from the exact proportion defined here depending on the precision an implementation supports. Weight is not a percentage and the sum of weights does not need to equal 100.
                                   If only one backend is specified and it has a weight greater than 0, 100% of the traffic is forwarded to that backend. If weight is set to 0, no traffic should be forwarded for this entry. If unspecified, weight defaults to 1.
                                   Support: Extended
                                  EOT
                                  "format" = "int32"
                                  "maximum" = 1000000
                                  "minimum" = 0
                                  "type" = "integer"
                                }
                              }
                              "type" = "object"
                            }
                            "maxItems" = 16
                            "minItems" = 1
                            "type" = "array"
                          }
                          "matches" = {
                            "description" = <<-EOT
                            Matches define conditions used for matching the rule against incoming TCP connections. Each match is independent, i.e. this rule will be matched if **any** one of the matches is satisfied. If unspecified (i.e. empty), this Rule will match all requests for the associated Listener.
                             Each client request MUST map to a maximum of one route rule. If a request matches multiple rules, matching precedence MUST be determined in order of the following criteria, continuing on ties:
                             * The most specific match specified by ExtensionRef. Each implementation   that supports ExtensionRef may have different ways of determining the   specificity of the referenced extension.
                             If ties still exist across multiple Routes, matching precedence MUST be determined in order of the following criteria, continuing on ties:
                             * The oldest Route based on creation timestamp. For example, a Route with   a creation timestamp of "2020-09-08 01:02:03" is given precedence over   a Route with a creation timestamp of "2020-09-08 01:02:04". * The Route appearing first in alphabetical order by   "<namespace>/<name>". For example, foo/bar is given precedence over   foo/baz.
                             If ties still exist within the Route that has been given precedence, matching precedence MUST be granted to the first matching rule meeting the above criteria.
                            EOT
                            "items" = {
                              "description" = "TCPRouteMatch defines the predicate used to match connections to a given action."
                              "properties" = {
                                "extensionRef" = {
                                  "description" = <<-EOT
                                  ExtensionRef is an optional, implementation-specific extension to the "match" behavior.  For example, resource "mytcproutematcher" in group "networking.acme.io". If the referent cannot be found, the rule is not included in the route. The controller should raise the "ResolvedRefs" condition on the Gateway with the "DegradedRoutes" reason. The gateway status for this route should be updated with a condition that describes the error more specifically.
                                   Support: Custom
                                  EOT
                                  "properties" = {
                                    "group" = {
                                      "description" = "Group is the group of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "kind" = {
                                      "description" = "Kind is kind of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                    "name" = {
                                      "description" = "Name is the name of the referent."
                                      "maxLength" = 253
                                      "minLength" = 1
                                      "type" = "string"
                                    }
                                  }
                                  "required" = [
                                    "group",
                                    "kind",
                                    "name",
                                  ]
                                  "type" = "object"
                                }
                              }
                              "type" = "object"
                            }
                            "maxItems" = 8
                            "type" = "array"
                          }
                        }
                        "required" = [
                          "forwardTo",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 16
                      "minItems" = 1
                      "type" = "array"
                    }
                  }
                  "required" = [
                    "rules",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "description" = "Status defines the current state of TCPRoute."
                  "properties" = {
                    "gateways" = {
                      "description" = <<-EOT
                      Gateways is a list of Gateways that are associated with the route, and the status of the route with respect to each Gateway. When a Gateway selects this route, the controller that manages the Gateway must add an entry to this list when the controller first sees the route and should update the entry as appropriate when the route is modified.
                       A maximum of 100 Gateways will be represented in this list. If this list is full, there may be additional Gateways using this Route that are not included in the list. An empty list means the route has not been admitted by any Gateway.
                      EOT
                      "items" = {
                        "description" = "RouteGatewayStatus describes the status of a route with respect to an associated Gateway."
                        "properties" = {
                          "conditions" = {
                            "description" = "Conditions describes the status of the route with respect to the Gateway. The \"Admitted\" condition must always be specified by controllers to indicate whether the route has been admitted or rejected by the Gateway, and why. Note that the route's availability is also subject to the Gateway's own status conditions and listener status."
                            "items" = {
                              "description" = <<-EOT
                              Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, type FooStatus struct{     // Represents the observations of a foo's current state.     // Known .status.conditions.type are: "Available", "Progressing", and "Degraded"     // +patchMergeKey=type     // +patchStrategy=merge     // +listType=map     // +listMapKey=type     Conditions []metav1.Condition `json:"conditions,omitempty" patchStrategy:"merge" patchMergeKey:"type" protobuf:"bytes,1,rep,name=conditions"`
                                   // other fields }
                              EOT
                              "properties" = {
                                "lastTransitionTime" = {
                                  "description" = "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."
                                  "format" = "date-time"
                                  "type" = "string"
                                }
                                "message" = {
                                  "description" = "message is a human readable message indicating details about the transition. This may be an empty string."
                                  "maxLength" = 32768
                                  "type" = "string"
                                }
                                "observedGeneration" = {
                                  "description" = "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."
                                  "format" = "int64"
                                  "minimum" = 0
                                  "type" = "integer"
                                }
                                "reason" = {
                                  "description" = "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."
                                  "maxLength" = 1024
                                  "minLength" = 1
                                  "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                                  "type" = "string"
                                }
                                "status" = {
                                  "description" = "status of the condition, one of True, False, Unknown."
                                  "enum" = [
                                    "True",
                                    "False",
                                    "Unknown",
                                  ]
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                                  "maxLength" = 316
                                  "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "lastTransitionTime",
                                "message",
                                "reason",
                                "status",
                                "type",
                              ]
                              "type" = "object"
                            }
                            "maxItems" = 8
                            "type" = "array"
                            "x-kubernetes-list-map-keys" = [
                              "type",
                            ]
                            "x-kubernetes-list-type" = "map"
                          }
                          "gatewayRef" = {
                            "description" = "GatewayRef is a reference to a Gateway object that is associated with the route."
                            "properties" = {
                              "controller" = {
                                "description" = <<-EOT
                                Controller is a domain/path string that indicates the controller implementing the Gateway. This corresponds with the controller field on GatewayClass.
                                 Example: "acme.io/gateway-controller".
                                 The format of this field is DOMAIN "/" PATH, where DOMAIN and PATH are valid Kubernetes names (https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names).
                                EOT
                                "maxLength" = 253
                                "type" = "string"
                              }
                              "name" = {
                                "description" = "Name is the name of the referent."
                                "maxLength" = 253
                                "minLength" = 1
                                "type" = "string"
                              }
                              "namespace" = {
                                "description" = "Namespace is the namespace of the referent."
                                "maxLength" = 253
                                "minLength" = 1
                                "type" = "string"
                              }
                            }
                            "required" = [
                              "name",
                              "namespace",
                            ]
                            "type" = "object"
                          }
                        }
                        "required" = [
                          "gatewayRef",
                        ]
                        "type" = "object"
                      }
                      "maxItems" = 100
                      "type" = "array"
                    }
                  }
                  "required" = [
                    "gateways",
                  ]
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_tlscertificatedelegations_projectcontour_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.5.0"
      }
      "name" = "tlscertificatedelegations.projectcontour.io"
    }
    "spec" = {
      "group" = "projectcontour.io"
      "names" = {
        "kind" = "TLSCertificateDelegation"
        "listKind" = "TLSCertificateDelegationList"
        "plural" = "tlscertificatedelegations"
        "shortNames" = [
          "tlscerts",
        ]
        "singular" = "tlscertificatedelegation"
      }
      "preserveUnknownFields" = false
      "scope" = "Namespaced"
      "versions" = [
        {
          "name" = "v1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = "TLSCertificateDelegation is an TLS Certificate Delegation CRD specification. See design/tls-certificate-delegation.md for details."
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "TLSCertificateDelegationSpec defines the spec of the CRD"
                  "properties" = {
                    "delegations" = {
                      "items" = {
                        "description" = "CertificateDelegation maps the authority to reference a secret in the current namespace to a set of namespaces."
                        "properties" = {
                          "secretName" = {
                            "description" = "required, the name of a secret in the current namespace."
                            "type" = "string"
                          }
                          "targetNamespaces" = {
                            "description" = "required, the namespaces the authority to reference the the secret will be delegated to. If TargetNamespaces is nil or empty, the CertificateDelegation' is ignored. If the TargetNamespace list contains the character, \"*\" the secret will be delegated to all namespaces."
                            "items" = {
                              "type" = "string"
                            }
                            "type" = "array"
                          }
                        }
                        "required" = [
                          "secretName",
                          "targetNamespaces",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                  }
                  "required" = [
                    "delegations",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "description" = "TLSCertificateDelegationStatus allows for the status of the delegation to be presented to the user."
                  "properties" = {
                    "conditions" = {
                      "description" = <<-EOT
                      Conditions contains information about the current status of the HTTPProxy, in an upstream-friendly container.
                       Contour will update a single condition, `Valid`, that is in normal-true polarity. That is, when `currentStatus` is `valid`, the `Valid` condition will be `status: true`, and vice versa.
                       Contour will leave untouched any other Conditions set in this block, in case some other controller wants to add a Condition.
                       If you are another controller owner and wish to add a condition, you *should* namespace your condition with a label, like `controller.domain.com\ConditionName`.
                      EOT
                      "items" = {
                        "description" = <<-EOT
                        DetailedCondition is an extension of the normal Kubernetes conditions, with two extra fields to hold sub-conditions, which provide more detailed reasons for the state (True or False) of the condition.
                         `errors` holds information about sub-conditions which are fatal to that condition and render its state False.
                         `warnings` holds information about sub-conditions which are not fatal to that condition and do not force the state to be False.
                         Remember that Conditions have a type, a status, and a reason.
                         The type is the type of the condition, the most important one in this CRD set is `Valid`. `Valid` is a positive-polarity condition: when it is `status: true` there are no problems.
                         In more detail, `status: true` means that the object is has been ingested into Contour with no errors. `warnings` may still be present, and will be indicated in the Reason field. There must be zero entries in the `errors` slice in this case.
                         `Valid`, `status: false` means that the object has had one or more fatal errors during processing into Contour.  The details of the errors will be present under the `errors` field. There must be at least one error in the `errors` slice if `status` is `false`.
                         For DetailedConditions of types other than `Valid`, the Condition must be in the negative polarity. When they have `status` `true`, there is an error. There must be at least one entry in the `errors` Subcondition slice. When they have `status` `false`, there are no serious errors, and there must be zero entries in the `errors` slice. In either case, there may be entries in the `warnings` slice.
                         Regardless of the polarity, the `reason` and `message` fields must be updated with either the detail of the reason (if there is one and only one entry in total across both the `errors` and `warnings` slices), or `MultipleReasons` if there is more than one entry.
                        EOT
                        "properties" = {
                          "errors" = {
                            "description" = <<-EOT
                            Errors contains a slice of relevant error subconditions for this object.
                             Subconditions are expected to appear when relevant (when there is a error), and disappear when not relevant. An empty slice here indicates no errors.
                            EOT
                            "items" = {
                              "description" = <<-EOT
                              SubCondition is a Condition-like type intended for use as a subcondition inside a DetailedCondition.
                               It contains a subset of the Condition fields.
                               It is intended for warnings and errors, so `type` names should use abnormal-true polarity, that is, they should be of the form "ErrorPresent: true".
                               The expected lifecycle for these errors is that they should only be present when the error or warning is, and should be removed when they are not relevant.
                              EOT
                              "properties" = {
                                "message" = {
                                  "description" = <<-EOT
                                  Message is a human readable message indicating details about the transition.
                                   This may be an empty string.
                                  EOT
                                  "maxLength" = 32768
                                  "type" = "string"
                                }
                                "reason" = {
                                  "description" = <<-EOT
                                  Reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API.
                                   The value should be a CamelCase string.
                                   This field may not be empty.
                                  EOT
                                  "maxLength" = 1024
                                  "minLength" = 1
                                  "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                                  "type" = "string"
                                }
                                "status" = {
                                  "description" = "Status of the condition, one of True, False, Unknown."
                                  "enum" = [
                                    "True",
                                    "False",
                                    "Unknown",
                                  ]
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = <<-EOT
                                  Type of condition in `CamelCase` or in `foo.example.com/CamelCase`.
                                   This must be in abnormal-true polarity, that is, `ErrorFound` or `controller.io/ErrorFound`.
                                   The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                                  EOT
                                  "maxLength" = 316
                                  "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "message",
                                "reason",
                                "status",
                                "type",
                              ]
                              "type" = "object"
                            }
                            "type" = "array"
                          }
                          "lastTransitionTime" = {
                            "description" = "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."
                            "format" = "date-time"
                            "type" = "string"
                          }
                          "message" = {
                            "description" = "message is a human readable message indicating details about the transition. This may be an empty string."
                            "maxLength" = 32768
                            "type" = "string"
                          }
                          "observedGeneration" = {
                            "description" = "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."
                            "format" = "int64"
                            "minimum" = 0
                            "type" = "integer"
                          }
                          "reason" = {
                            "description" = "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."
                            "maxLength" = 1024
                            "minLength" = 1
                            "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                            "type" = "string"
                          }
                          "status" = {
                            "description" = "status of the condition, one of True, False, Unknown."
                            "enum" = [
                              "True",
                              "False",
                              "Unknown",
                            ]
                            "type" = "string"
                          }
                          "type" = {
                            "description" = "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"
                            "maxLength" = 316
                            "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                            "type" = "string"
                          }
                          "warnings" = {
                            "description" = <<-EOT
                            Warnings contains a slice of relevant warning subconditions for this object.
                             Subconditions are expected to appear when relevant (when there is a warning), and disappear when not relevant. An empty slice here indicates no warnings.
                            EOT
                            "items" = {
                              "description" = <<-EOT
                              SubCondition is a Condition-like type intended for use as a subcondition inside a DetailedCondition.
                               It contains a subset of the Condition fields.
                               It is intended for warnings and errors, so `type` names should use abnormal-true polarity, that is, they should be of the form "ErrorPresent: true".
                               The expected lifecycle for these errors is that they should only be present when the error or warning is, and should be removed when they are not relevant.
                              EOT
                              "properties" = {
                                "message" = {
                                  "description" = <<-EOT
                                  Message is a human readable message indicating details about the transition.
                                   This may be an empty string.
                                  EOT
                                  "maxLength" = 32768
                                  "type" = "string"
                                }
                                "reason" = {
                                  "description" = <<-EOT
                                  Reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API.
                                   The value should be a CamelCase string.
                                   This field may not be empty.
                                  EOT
                                  "maxLength" = 1024
                                  "minLength" = 1
                                  "pattern" = "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
                                  "type" = "string"
                                }
                                "status" = {
                                  "description" = "Status of the condition, one of True, False, Unknown."
                                  "enum" = [
                                    "True",
                                    "False",
                                    "Unknown",
                                  ]
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = <<-EOT
                                  Type of condition in `CamelCase` or in `foo.example.com/CamelCase`.
                                   This must be in abnormal-true polarity, that is, `ErrorFound` or `controller.io/ErrorFound`.
                                   The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
                                  EOT
                                  "maxLength" = 316
                                  "pattern" = "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
                                  "type" = "string"
                                }
                              }
                              "required" = [
                                "message",
                                "reason",
                                "status",
                                "type",
                              ]
                              "type" = "object"
                            }
                            "type" = "array"
                          }
                        }
                        "required" = [
                          "lastTransitionTime",
                          "message",
                          "reason",
                          "status",
                          "type",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                      "x-kubernetes-list-map-keys" = [
                        "type",
                      ]
                      "x-kubernetes-list-type" = "map"
                    }
                  }
                  "type" = "object"
                }
              }
              "required" = [
                "metadata",
                "spec",
              ]
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}
