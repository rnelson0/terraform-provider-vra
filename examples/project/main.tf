provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure      = var.insecure
}

data "vra_zone" "this" {
  name = var.zone_name
}

resource "vra_project" "this" {
  name        = var.project_name
  description = "terraform test project"

  zone_assignments {
    zone_id          = data.vra_zone.this.id
    priority         = 1
    max_instances    = 2
    cpu_limit        = 1024
    memory_limit_mb  = 8192
    storage_limit_gb = 65536
  }

  shared_resources = false

  # Deprecated, please use administrator_roles instead.
  administrators = ["jason@vra.local"]

  administrator_roles {
    email = "jason@vra.local"
    type = "user"
  }

  administrator_roles {
    email = "jason-group@vra.local"
    type = "group"
  }

  # Deprecated, please use member_roles instead.
  members = ["tony@vra.local"]

  member_roles {
    email = "tony@vra.local"
    type = "user"
  }

  member_roles {
    email = "tony-group@vra.local"
    type = "group"
  }

  # Deprecated, please use viewer_roles instead
  viewers = ["shauna@vra.local"]

  viewer_roles {
    email = "shauna@vra.local"
    type = "user"
  }

  viewer_roles {
    email = "shauna-group@vra.local"
    type = "group"
  }

  operation_timeout = 6000

  machine_naming_template = "$${resource.name}-$${####}"

  constraints {
    extensibility {
      expression = "foo:bar"
      mandatory  = false
    }
    extensibility {
      expression = "environment:Test"
      mandatory  = true
    }

    network {
      expression = "foo:bar"
      mandatory  = false
    }
    network {
      expression = "environment:Test"
      mandatory  = true
    }

    storage {
      expression = "foo:bar"
      mandatory  = false
    }
    storage {
      expression = "environment:Test"
      mandatory  = true
    }
  }
}

data "vra_project" "this" {
  name = vra_project.this.name

  depends_on = [vra_project.this]
}
