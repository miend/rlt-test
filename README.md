# RLT Test Repo

The following functions have been accomplished with the Terraform configurations in this repo:

1. Deploy a Kubernetes cluster to GKE
2. Deploy an application image (stored on GCR) via local Helm chart
3. Expose that application to the internet, accepting dns requests by ingress. No DNS records pointing to it, but by getting the loadbalancer IP you can verify the application properly responds from both namespaces, allowing (200) or denying (403) the request as it's configured to do for the source IP, but not delivering an error. Check this with (for example):
   - `curl -v -H "Host:rlt-demo.exitprompt.com" http://[loadbalancer-ip]/test.php` and
   - `curl -v -H "Host:staging.rlt-demo.exitprompt.com" http://[loadbalancer-ip]/test.php`
4. Make the cluster private (albeit with some open, but controllable, settings for ease of testing)
5. Allow for, and establish by default, multiple environments (namespaces) our Helm chart will deploy to, and ingress configuration to go with them

The following tasks were not accomplished in time, but with each follows a brief explanation of how I would intend to accomplish them:

* Monitoring and alerting on the cluster:
  * Stackdriver monitoring and logging are enabled with this deployment, however I haven't had time to evaluate it in enough detail, or figure out how I would establish alert policies yet (via Terraform).
* Use Istio:
  * Since gruntwork modules were used instead of the google_container_cluster resource to ease the deployment of a more production-friendly kubernetes cluster, and they don't yet have support for Istio installs, the best approach may be to install the components by first configuring installation of the Istio [standalone operator](https://istio.io/latest/docs/setup/install/standalone-operator/),  which itself may be deployed by Helm. Once installed, I would immediately make use of Istio for mTLS communication between services in the cluster, then evaluate its other features, potentially getting rid of nginx ingress.
* Automatically configure DNS records to serve traffic when an ingress is configured:
  * There is some non-functional code in helm.tf approaching this, but the gist is that since in my current design the default host is defined in one variable and changes with subdomain prefixes based on namespace, I would only need a block that checks existing namespaces and their provided subdomain prefixes, and create wildcard DNS records targeting the relevant load balancer IP. Any individual service in that namespace could be served with a fairly arbitrary host -- as long as the FQDN matches the wildcard DNS record (e.g. "my.custom.staging.domain.com" matches "*.staging.domain.com"), it will get sent to the load balancer and be handled by the ingress controller.
* Stand up terraform infrastructure in a second env:
  * I haven't had a lot of time to evaluate this one, but I imagine it could be accomplished largely (or entirely?) by use of an environment-specific .tfvars file overriding the default values for many of the existing defaults in variables.tf.

