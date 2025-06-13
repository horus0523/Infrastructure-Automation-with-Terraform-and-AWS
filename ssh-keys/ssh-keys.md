# Create the necessary SSH keys to configure the nginx-server

**Create SSH key to nginx-server-dev**

```bash
ssh-keygen -t ed25519 -C "dev@nginx-server" -f ssh-keys/nginx-server-dev.key -N ""
```

**Create SSH key to nginx-server-qa**

```bash
ssh-keygen -t ed25519 -C "qa@nginx-server" -f ssh-keys/nginx-server-qa.key -N ""
```
