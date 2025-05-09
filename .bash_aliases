# ========================
# Core Shell Configuration
# ========================
# src: https://github.com/dvorka/hstr/blob/master/CONFIGURATION.md#bash-history-settings
HISTFILESIZE=10000
HISTSIZE=${HISTFILESIZE}
PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
HISTCONTROL=ignoredups
shopt -s histappend

HSTR_CONFIG=hicolor
HSTR_CONFIG=raw-history-view


# ========================
# Navigation & Utilities
# ========================
alias c="clear"
alias xx="exit"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ========================
# Terraform/Terragrunt Operations
# ========================
_set_terragrunt_env() {
    export _DEPLOYMENT_CONFIG_NAME="cus"
    export TERRAGRUNT_USE_PARTIAL_PARSE_CONFIG_CACHE="true"
    export TERRAGRUNT_FETCH_DEPENDENCY_OUTPUT_FROM_STATE="true"
    export TERRAGRUNT_NON_INTERACTIVE="true"
    export TERRAGRUNT_STRICT_CONTROL="skip-dependencies-inputs"
    export TERRAGRUNT_DEBUG="true"
    export TERRAGRUNT_PROVIDER_CACHE="1"
    export TERRAGRUNT_PROVIDER_CACHE_DIR="${HOME}/.terraform.d/plugin-cache"
    export TERRAGRUNT_PARALLELISM="4"
    export TG_NO_DESTROY_DEPENDENCIES_CHECK="true"
}

alias tgp="_set_terragrunt_env && terragrunt plan"
alias tfa="terraform apply"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfsp="tfp -out tf.plan && terraform show -no-color tf.plan > tfplan.txt"
alias tfd="terraform destroy"

# Generate base aliases with pattern preservation
for count in {2..15}; do
    # TF apply --auto-approve (tfaa-tfaaaaaa...)
    alias tfa$(printf '%0.sa' $(seq 1 $count))="terraform apply --auto-approve"
    
    # TF destroy --auto-approve (tfda-tfdaaaaa...)
    alias tfd$(printf '%0.sa' $(seq 1 $count))="terraform destroy --auto-approve"
    
    # Standard apply aliases (tgaa-tgaaaaaa...)
    alias tga$(printf '%0.sa' $(seq 1 $count))="_set_terragrunt_env && terragrunt apply --auto-approve"
    
    # Destroy aliases (tgda-tgdaaaaaa...)
    alias tgda$(printf '%0.sa' $(seq 1 $count))="_set_terragrunt_env && terragrunt destroy --auto-approve"
    
    # Run-all apply aliases (tgraa-tgraaaaaa...)
    alias tgra$(printf '%0.sa' $(seq 1 $count))="_set_terragrunt_env && terragrunt run-all apply \
        --terragrunt-include-external-dependencies \
        --auto-approve \
        --terragrunt-non-interactive \
        --terragrunt-log-show-abs-paths \
        --terragrunt-parallelism=1"

    alias ltga$(printf '%0.sa' $(seq 1 $count))="_log_tg_operation apply --auto-approve"
    alias ltgda$(printf '%0.sa' $(seq 1 $count))="_log_tg_operation destroy --auto-approve"
done

TG_LZ_LOGS_PATH="/home/pw/repos/landing_zone_gc/_lz/logs"
STRIP_ANSI_COLOR_CODES='s/\x1B\[[0-9;]*[0-9][mK]|\[[0-9;]*[0-9][mK]//g'

_log_tg_operation() {
    local operation=$1
    local log_file="${TG_LZ_LOGS_PATH}/$(date -Is).logs.tmp"
    
    _set_terragrunt_env && terragrunt "$@" 2>&1 | tee >(
        sed -r "${STRIP_ANSI_COLOR_CODES}" > "${log_file}"
    )
}

alias tgrm='find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \; && \
            find . -type f -name "tjson.tmp.json" -delete && \
            echo "Removed terragrunt cache files"'

# ========================
# Other
# ========================
alias _va='. .venv/bin/activate'
alias _vd='deactivate'
alias _vc='python3 -m venv .venv'
alias d='docker'
alias dc='docker compose'
alias k='kubectl'

_cp_to_windows() {
    local _file_path; _file_path=$1; readonly _file_path
    local _windows_desktop_path; _windows_desktop_path="/mnt/c/Users/e-prwk/OneDrive - GFT Technologies SE/Desktop"; readonly _windows_desktop_path
    
    cp "${_file_path}" "${_windows_desktop_path}"
}

alias cpwin="_cp_to_windows"
alias env_dbt='source /home/pw/repos/landing_zone_gc/_org/_030-dev/folder-env/folder__data-platform/project__dbt/.venv/bin/activate'
