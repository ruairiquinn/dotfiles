# If you come from bash you might have to change your $PATH.
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/aws/bin:$PATH"
export PATH=${PATH}:${HOME}/Library/Python/2.7/bin

# Path to your oh-my-zsh installation.
export ZSH="/Users/rquinn020/.oh-my-zsh"
ZSH_THEME="ys"

plugins=(zsh-nvm, docker, docker-compose, git, kubectl)

# Had to install NVM via Git as O-M-Z plugin didn't work (https://github.com/creationix/nvm#important-notes)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Autocomplete
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# FZF -  https://remysharp.com/2018/08/23/cli-improved
alias preview="fzf --preview 'bat --color \"always\" {}'"
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

eval "$(nodenv init -)"

source $ZSH/oh-my-zsh.sh

# Install Go (to install Jsonnet), the below will ensure Go packages are installed to ~/golang  
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOROOT/bin

# AWS
alias mfa-start-session='function(){eval $(~/code/aws_mfa_scripts/mfa-start-session $@);}'
alias assume-role='function(){eval $(command assume-role $@);}'
complete -C '/usr/local/bin/aws_completer' aws

function aws_ip_from_private_dns_name() {
     echo $(aws ec2 describe-instances --filters "{\"Name\":\"private-dns-name\", \"Values\":[\"$1*\"]}" --query='Reservations[0].Instances[0].PublicIpAddress' ) | tr -d '"'
}

function k_describe_node_for_pod() {
  kubectl describe node $(kubectl get pods $1 -owide --no-headers | awk '{ print $7 }')
}

# Docker
alias dc='docker-compose'
alias dc-up-api='docker-compose up api'
alias dc-up-api-dev='docker-compose up -d api-dev'
alias dc-down='docker-compose down'
alias dc-logs='docker-compose logs -f'
alias dc-ps='docker-compose ps'
alias dc-restart='docker-compose restart '
alias dc-exec='docker exec -it '
alias dc-at='docker-compose run acceptance-test'
alias dc-it='docker-compose -f docker-compose-integration.yml run integration-test'

#alias d='docker'
alias d-exec='docker exec -it '
alias d-logs='docker logs -f'
alias d-ps='docker ps'
alias d-psa='docker ps --all'
alias d-psa-short='docker ps --all --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}\t{{.CreatedAt}}\t{{.ID}}"'
alias di='docker images'
alias d-rm='docker rm $(docker ps -aq)'
alias d-ri='docker rmi $(docker images -q)'
alias d-stop='docker stop $(docker ps -aq)'
alias d-prune='docker system prune && docker volume prune'

# GRC - https://github.com/garabik/grc
[[ -s "/usr/local/etc/grc.zsh" ]] && source /usr/local/etc/grc.zsh

# Kubernetes
# Merge various K8s config files, excluding config-old-stuff
export KUBECONFIG=~/.kube/config:~/.kube/config-creds:~/.kube/config-hackathon
alias kubectl='/usr/local/bin/grc kubectl'
alias k='kubectl'
alias k-describe='kubectl describe'
alias k-describe-pod='kubectl describe pod'
alias k-describe='kubectl describe'
alias k-delete='kubectl delete pod '
alias k-logs='kubectl logs -f'

alias k-get-nodes='kubectl get nodes'
alias k-get-pods='kubectl get pods'
alias k-get-pods-monitoring='kubectl get pods -n monitoring'
alias k-get-pods-with-node-info='kubectl get pod -o=custom-columns=NODE:.spec.nodeName,NAME:.metadata.name --all-namespaces'
alias k-get-service='kubectl get service'
alias k-get-configmap='kubectl get cm'
alias k-get-secret='kubectl get secret'
alias k-get-ingress='kubectl get ingress'
alias k-get-deployment='kubectl get deployment'
alias k-get-crd='kubectl get crd'

alias k-port-forward='kubectl port-forward'
alias k-port-forward-kibana='kubectl port-forward $(kubectl get pods -lapp=aws-es-proxy -o jsonpath="{.items[0].metadata.name}") 9200'
alias k-kibana='kubectl port-forward -n default $(kubectl get pods -n default -lapp=aws-es-proxy -o jsonpath="{.items[0].metadata.name}") 9200'
alias k-grafana='kubectl port-forward -n monitoring $(kubectl get pods -n monitoring -lapp=kube-prometheus-grafana -o jsonpath="{.items[0].metadata.name}") 3000'
alias k-exec='kubectl exec -it '
alias k-ctx='kubectx'
alias k-ben='kubens'
alias k-switch-cluster='kubectl config use-context'
alias k-current-context='kubectl config current-context'
alias k-get-namespace='kubectl config view | grep namespace -B 1'

source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1

# Misc
alias at='yarn acceptance-test'
alias at-filtered='yarn acceptance-test -g '

# Standard Linux Commands
alias zv='vi ~/.zshrc'
alias zs='source ~/.zshrc'
alias zsub='sublime ~/.zshrc'
alias sub='sublime'
alias g='grep -i --color'
alias t='tail -f'
alias h='history'
alias hg='h | g'
alias l='ls -laht'
alias l10='l | head -10'
alias l20='l | head -20'
alias l50='l | head -50'
alias gco='git checkout'
alias gst='git status'
alias gb='git branch --list'

# Misc functions
alias urlencode='python -c "import urllib, sys; print urllib.quote(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()[0:-1], \"\")"'
yaml-validate () { ruby -e "require 'yaml';puts YAML.load_file('./$1')"; }
k-set-namespace () { kubectl config set-context $(kubectl config current-context) --namespace=$1; }
sed_x () { sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@" ;}
