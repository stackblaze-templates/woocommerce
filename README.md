# WooCommerce [![Version](https://img.shields.io/badge/version-9-96588a)](https://github.com/stackblaze-templates/woocommerce) [![Maintained by StackBlaze](https://img.shields.io/badge/maintained%20by-StackBlaze-blue)](https://stackblaze.com) [![Weekly Updates](https://img.shields.io/badge/updates-weekly-green)](https://github.com/stackblaze-templates/woocommerce/actions) [![Deploy on StackBlaze](https://img.shields.io/badge/Deploy%20on-StackBlaze-orange)](https://stackblaze.com)

<p align="center"><img src="logo.png" alt="WooCommerce" width="120"></p>

The most popular WordPress e-commerce plugin. WooCommerce powers over 25% of online stores with a massive extension ecosystem, payment gateways, and shipping integrations.

> **Credits**: Built on [WooCommerce](https://woocommerce.com) by [Automattic](https://github.com/woocommerce). All trademarks belong to their respective owners.

## Local Development

```bash
docker compose up
```

See the project files for configuration details.

## Deploy on StackBlaze

[![Deploy on StackBlaze](https://img.shields.io/badge/Deploy%20on-StackBlaze-orange)](https://stackblaze.com)

This template includes a `stackblaze.yaml` for one-click deployment on [StackBlaze](https://stackblaze.com). Both options run on **Kubernetes** for reliability and scalability.

<details>
<summary><strong>Standard Deployment</strong> — Single-instance Kubernetes setup for startups and moderate traffic</summary>

<br/>

```mermaid
flowchart LR
    U["Customers"] -->|HTTPS| LB["Edge Network\n+ SSL"]
    LB --> B["WooCommerce\nPHP 8.3"]
    B --> DB[("MySQL\nManaged DB")]
    B --> S3["Object Storage\nMedia + Assets"]

    style LB fill:#ff9800,stroke:#e65100,color:#fff
    style B fill:#0041ff,stroke:#002db3,color:#fff
    style DB fill:#4caf50,stroke:#2e7d32,color:#fff
    style S3 fill:#2196f3,stroke:#1565c0,color:#fff
```

**What you get:**
- Single WooCommerce instance on Kubernetes
- Managed MySQL database
- Automatic SSL/TLS via StackBlaze edge network
- Object storage for media and assets
- Automated daily backups
- Zero-downtime deploys

**Best for:** Development, staging, and moderate-traffic production environments.

</details>

<details>
<summary><strong>High Availability Deployment</strong> — Multi-instance Kubernetes setup for business-critical production</summary>

<br/>

```mermaid
flowchart LR
    U["Customers"] -->|HTTPS| CDN["CDN\nStatic Assets"]
    CDN --> LB["Load Balancer\nAuto-scaling"]
    LB --> B1["WooCommerce #1"]
    LB --> B2["WooCommerce #2"]
    LB --> B3["WooCommerce #N"]
    B1 --> R[("Redis\nSessions + Cache")]
    B2 --> R
    B3 --> R
    B1 --> DBP[("MySQL Primary\nRead + Write")]
    B2 --> DBP
    B3 --> DBR[("MySQL Replica\nRead-only")]
    DBP -.->|Replication| DBR
    B1 --> S3["Object Storage\nMedia + Assets"]
    B2 --> S3
    B3 --> S3
    B1 --> Q["Queue Worker\nBackground Jobs"]
    Q --> R
    Q --> DBP

    style CDN fill:#607d8b,stroke:#37474f,color:#fff
    style LB fill:#ff9800,stroke:#e65100,color:#fff
    style B1 fill:#0041ff,stroke:#002db3,color:#fff
    style B2 fill:#0041ff,stroke:#002db3,color:#fff
    style B3 fill:#0041ff,stroke:#002db3,color:#fff
    style R fill:#f44336,stroke:#c62828,color:#fff
    style DBP fill:#4caf50,stroke:#2e7d32,color:#fff
    style DBR fill:#66bb6a,stroke:#388e3c,color:#fff
    style S3 fill:#2196f3,stroke:#1565c0,color:#fff
    style Q fill:#9c27b0,stroke:#6a1b9a,color:#fff
```

**What you get:**
- Auto-scaling WooCommerce pods on Kubernetes behind a load balancer
- Redis for shared sessions, cache, and queue management
- MySQL primary + read replica for high throughput
- CDN for static assets (images, CSS, JS)
- Background queue workers for async processing
- Shared object storage across all instances
- Automated failover and self-healing
- Zero-downtime rolling deploys

**Best for:** Production workloads, high-traffic applications, business-critical deployments.

</details>

## Plugin Development

Custom WooCommerce plugins go in `wp-content/plugins/`. A starter plugin scaffold is included.

See [WooCommerce Plugin Development](https://developer.woocommerce.com/docs/category/extension-development/) docs.

---

## Security & Production Checklist

> ⚠️ **The default local-development configuration is NOT safe for production.** Review every item below before deploying publicly.

### Required environment variables

Copy `.env.example` to `.env` and set strong, unique values for each variable before running locally or deploying:

| Variable | Description |
|---|---|
| `WORDPRESS_DB_PASSWORD` | Password for the WordPress database user |
| `MYSQL_PASSWORD` | Must match `WORDPRESS_DB_PASSWORD` |
| `MYSQL_ROOT_PASSWORD` | MySQL root password (keep separate from the app user) |

On StackBlaze (and most managed platforms) these are injected automatically from the attached managed database — you do not need to set them manually.

### Production hardening notes

- **Database credentials** — never use the placeholder values (`change_me`) in a public environment. Generate long random passwords.
- **WordPress secret keys & salts** — WordPress requires eight secret keys/salts (`AUTH_KEY`, `SECURE_AUTH_KEY`, `LOGGED_IN_KEY`, etc.). Generate unique values at <https://api.wordpress.org/secret-key/1.1/salt/> and pass them as environment variables or write them to `wp-config.php` at container start-up.
- **WORDPRESS_TABLE_PREFIX** — consider changing from the default `wp_` to a custom prefix to reduce automated SQL-injection attack surface.
- **File permissions** — the official WordPress Docker image runs Apache as `www-data`. Do not run the container as `root` in production orchestrators (use `securityContext.runAsNonRoot: true` in Kubernetes).
- **Debug mode** — WordPress `WP_DEBUG` defaults to `false` in the official image. Never enable it in production.
- **HTTPS** — always serve WordPress behind TLS. StackBlaze handles this automatically via its edge network. For self-hosted deployments, configure an SSL-terminating reverse proxy (e.g. Nginx + Let's Encrypt).
- **Admin URL** — consider moving `wp-admin` behind a firewall or VPN for additional protection.

---

### Maintained by [StackBlaze](https://stackblaze.com)

This template is actively maintained by StackBlaze. We perform **weekly automated checks** to ensure:

- **Up-to-date dependencies** — frameworks, libraries, and base images are kept current
- **Security scanning** — continuous monitoring for known vulnerabilities and CVEs
- **Best practices** — configurations follow current recommendations from upstream projects

Found an issue? [Open a ticket](https://github.com/stackblaze-templates/woocommerce/issues).
