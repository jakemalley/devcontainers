# devcontainers

Dev Container Images

## building

```bash
make build   # will build a commit sha tagged image
make release # will build images tagged 'latest'
```

## using

* e.g. to use for Go, create `.devcontainer/devcontainer.json` in the root
  of your project with the following:

  ```json
  {
    "image": "dev-go:latest",
    "customizations": {
        "vscode": {
        "extensions": [
            "golang.go"
        ]
      }
    }
  }
  ```