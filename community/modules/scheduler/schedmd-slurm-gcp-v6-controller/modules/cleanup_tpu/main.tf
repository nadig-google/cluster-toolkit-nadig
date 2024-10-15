# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "null_resource" "script" {
  count = var.enable_cleanup_compute ? 1 : 0

  triggers = {
    project_id               = var.project_id
    cluster_name             = var.slurm_cluster_name
    nodeset_name             = var.nodeset.nodeset_name
    zone                     = var.nodeset.zone
    universe_domain          = var.universe_domain
    compute_endpoint_version = var.endpoint_versions.compute
    gcloud_path_override     = var.gcloud_path_override
  }

  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/scripts/cleanup_tpu.sh ${self.triggers.project_id} ${self.triggers.cluster_name} ${self.triggers.nodeset_name} ${self.triggers.zone} ${self.triggers.universe_domain} ${self.triggers.compute_endpoint_version} ${self.triggers.gcloud_path_override}"
    when    = destroy
  }
}