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

resource "kubernetes_manifest" "customresourcedefinition_extensionservices_projectcontour_io" {
  provider = kubernetes-alpha

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
  provider = kubernetes-alpha

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
