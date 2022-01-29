#!/bin/sh

[ -z "$DATA_DIR"] && {
  export DATA_DIR="/etc/gitlab-runner"
}
[ -z "$CONFIG_FILE"] && {
  export CONFIG_FILE=${CONFIG_FILE:-$DATA_DIR/config.toml}
}
[ -z "$REGISTRATION_TOKEN" ] && [ -f "$REGISTRATION_TOKEN_FILE" ] && {
  export REGISTRATION_TOKEN=$(head -n 1 "$REGISTRATION_TOKEN_FILE")
}

exit_illegal_env_var() {
  local name=$1
  echo "Environment variable '$name' has not been set, exiting..."
  exit 1
}

print_env_var_value() {
  local name=$1
  echo $(eval echo "\${$name}")
}

check_env_var_is_not_empty() {
  local name=$1
  local value=$(print_env_var_value "$name")
  # echo $name=$value
  [ ! -z "$value" ]
}

for var in "RUNNER_NAME" "CI_SERVER_URL"
do
  check_env_var_is_not_empty "$var" || exit_illegal_env_var "$var"
done

verify() {
  # TODO
  # Probably when RUNNER_NAME changes this script will register new runner alongside with the old one.
  # RUNNER_NAME might be persisted inside a container (as config.toml)
  gitlab-runner verify \
    --name "$RUNNER_NAME" \
    --url "$CI_SERVER_URL" \
    --delete
}

register() {
  # '--description' flag is empty cause it overrides RUNNER_NAME env var
  gitlab-runner register \
    --description "" \
    --executor docker \
    --docker-image "docker:stable" \
    --docker-volumes "/var/run/docker.sock:/var/run/docker.sock"
}

# First verification may be successful when old runners has been deleted. 
# Second verification will fail if no active runners left so the new one will be registered.
verify && verify || register || exit 1
# DISABLE_ENTRYPOINT may be helpful to reinitialize container
[ "$DISABLE_ENTRYPOINT" = "1" ] || /entrypoint "$@"
