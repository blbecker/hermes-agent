# Re-add the PVC-backed CLI directories to PATH.
#
# Why this is needed: /etc/profile unconditionally *assigns* PATH (dropping the image's
# ENV PATH, which is where /usr/local/cargo/bin comes from), and Hermes captures the
# login-shell environment once per session and replays it for every command. Anything
# installed at runtime on the volume -- `spec.hermes.packages.npm` / `.pip` from the
# HermesAgent CR, `uv tool install` (openviking, vikingbot, ...) and the ~/.local/bin
# wrappers -- is invisible to agent-run shells unless it is restored here.
#
# The list is walked in order, so the first entry ends up leftmost in PATH: PVC-backed
# and user-installed dirs win over same-named binaries baked into the image.
_hermes_prefix=""
for _hermes_bin in \
    "$HOME/.local/bin" \
    "${HERMES_HOME:-/opt/data}/.npm-packages/bin" \
    "${HERMES_HOME:-/opt/data}/.python-packages/bin" \
    "${HERMES_HOME:-/opt/data}/bin" \
    "${HERMES_HOME:-/opt/data}/.local/bin" \
    /opt/hermes/bin \
    /usr/local/cargo/bin; do
    [ -d "$_hermes_bin" ] || continue
    case ":$PATH:" in
        *":$_hermes_bin:"*) continue ;;
    esac
    _hermes_prefix="$_hermes_prefix:$_hermes_bin"
done
if [ -n "$_hermes_prefix" ]; then
    PATH="${_hermes_prefix#:}:$PATH"
fi
unset _hermes_prefix _hermes_bin
export PATH
