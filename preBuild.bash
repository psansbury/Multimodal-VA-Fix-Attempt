
#!/usr/bin/env bash
set -euo pipefail

# Optional: print versions for debugging
pythonpython --version || true
pip --version || true

# Upgrade build tooling to avoid pip/PEP517 metadata issues
