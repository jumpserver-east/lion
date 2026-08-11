variable "TAG" {
  default = "dev"
}
target "ce" {
  context    = "./source"
  dockerfile = "Dockerfile"
  args = {
    VERSION = "${TAG}"
  }
  cache-from = ["type=gha,scope=lion-ce"]
  cache-to   = ["type=gha,mode=max,scope=lion-ce"]
}

target "ee" {
  context    = "./source"
  dockerfile = "Dockerfile-ee"
  args = {
    VERSION = "${TAG}"
  }
  contexts = {
    "jumpserver/lion:${TAG}-ce" = "target:ce"
  }
  tags = ["ghcr.io/jumpserver-east/lion:${TAG}"]
  labels = {
    "org.opencontainers.image.version" = "${TAG}"
    "org.jumpserver.edition"           = "ee"
  }
  cache-from = ["type=gha,scope=lion-ee"]
  cache-to   = ["type=gha,mode=max,scope=lion-ee"]
}
