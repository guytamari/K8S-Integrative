# WordPress with MySQL and Monitoring Helm Chart

This Helm chart deploys WordPress with MySQL (MariaDB) and includes Prometheus/Grafana monitoring stack.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- AWS EKS cluster
- AWS EBS CSI Driver installed
- Nginx Ingress Controller

## Installation

1. Add the Helm repository:

```bash
helm repo add my-repo https://guytamari.github.io/K8S-Integrative
helm repo update
```

2. Install the chart:

```bash
helm install my-release my-repo/wordpress-mysql-app \
  --namespace your-namespace \
  --create-namespace
  --set namespace=your-namespace
```

## Configuration

### Required Values

The following values must be configured in your `values.yaml`:

```yaml
namespace: your-namespace

storageClass:
  name: ebs-sc
  provisioner: ebs.csi.aws.com

wordpress:
  replicas: 2
  storage:
    size: 1Gi

database:
  storage:
    size: 1Gi
  credentials:
    rootPassword: your-root-password
    database: wordpress
    user: wordpress
    password: your-password
```

### Optional Values

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"

grafana:
  enabled: true
  adminPassword: your-admin-password
```

## Access Applications

After installation:

1. Get the Load Balancer URL:

```bash
kubectl get svc -n your-namespace ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

2. Access Applications:

- WordPress: `http://<load-balancer-url>/`
- Grafana: `http://<load-balancer-url>/grafana`

## Monitoring

This chart includes:

- Prometheus for metrics collection
- Grafana for visualization
- Pre-configured dashboards for:
  - WordPress metrics
  - MySQL metrics
  - Kubernetes cluster metrics

### Grafana Login

- Username: `admin`
- Password: Get with:
  ```bash
  kubectl get secret -n your-namespace prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
  ```

## Uninstallation

To remove the chart:

```bash
helm uninstall my-release -n your-namespace
```

## Storage

This chart uses AWS EBS for persistent storage. Make sure:

1. AWS EBS CSI Driver is installed
2. Proper IAM roles and permissions are configured
3. Storage class `ebs-sc` is available

## Security Notes

1. Change default passwords in values.yaml
2. Configure proper AWS IAM roles
3. Enable SSL/TLS for production use
4. Review and adjust RBAC permissions as needed

## Troubleshooting

Common issues:

1. PVCs in Pending state

   - Check EBS CSI Driver installation
   - Verify IAM roles
   - Check storage class exists

2. Ingress not working

   - Verify Nginx Ingress Controller installation
   - Check Load Balancer configuration
   - Verify DNS settings

3. Monitoring issues
   - Check Prometheus pods
   - Verify ServiceMonitor resources
   - Check Grafana configuration

## Examples

### Basic Installation

```bash
# Install with default values
helm install my-wordpress ./wordpress-mysql-app \
  --namespace wordpress \
  --create-namespace
```

### Custom Installation Examples

1. **Custom Database Configuration**:

```yaml
# custom-db-values.yaml
database:
  credentials:
    rootPassword: my-secure-root-pw
    password: my-secure-user-pw
    user: wp_user
    database: wp_database
  storage:
    size: 10Gi
```

```bash
helm install my-wordpress ./wordpress-mysql-app \
  -f custom-db-values.yaml \
  --namespace wordpress
```

## Support

For issues and feature requests, please create an issue in the repository.
