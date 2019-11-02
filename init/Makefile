boldGreen := $(shell tput bold)$(shell tput setaf 2)
normal := $(shell tput sgr0)

all: note-1 helm setup install

helm: helm-setup helm-tillerless 
setup: k8s-namespace github-token
install: argocd argocd-app

note-1:
	@clear
	@echo "$(boldGreen)Starting K8s Installation$(normal)"
	@echo
	@echo "You need the following tools installed on your machine:"
	@echo "	- kubectl (Homebrew: kubernetes-cli)"
	@echo "	- helm (Homebrew: kubernetes-helm)"
	@echo
	@echo "The following steps will be taken:"
	@echo "	1. Add ArgoCD repository, and update repository to latest"
	@echo "	2. Init Helm without Tiller"
	@echo "	3. Apply prerequisite namespace definition"
	@echo "	4. Install ArgoCD"
	@echo "	5. Set up ArgoCD with \`main\` folder"
	@echo
	@read -r -p "If you are ready to get started, press enter"
	@clear

helm-setup:
	@echo "$(boldGreen)1. Adding ArgoCD Helm repository to your local setup...$(normal)"
	@echo
	helm repo add argo https://argoproj.github.io/argo-helm
	@echo
	helm repo update
	@echo
	@read -r -p "completed."
	@clear

helm-tillerless:
	@echo "$(boldGreen)2. Setting up Helm without Tiller...$(normal)"
	@echo
	helm init --client-only
	@echo
	kubectl get all --all-namespaces
	@echo
	@read -r -p "completed."
	@clear

k8s-namespace:
	@echo "$(boldGreen)3. Applying K8s namespace for ArgoCD...$(normal)"
	@echo
	kubectl apply -f ../main/argocd/templates/namespace-argocd.yaml
	@echo
	@read -r -p "completed."
	@clear

github-token:
	@echo "$(boldGreen)4. Setting up access token for git repo...$(normal)"
	@echo
	@echo "Make sure you have updated the repository addresses before proceeding."
	@echo "If you need to make modifications to the files, exit this with Ctrl-C, and run"
	@echo "    make setup"
	@echo
	@echo "If you are ready to proceed, provide the following information:"
	@read -r -p "    Your username: " username;\
		read -s -p "    Your token: " userToken;\
		echo "";\
		kubectl -n argocd create secret generic access-secret \
			--from-literal=username=$$username \
			--from-literal=token=$$userToken
	@echo
	@read -r -p "completed."
	@clear

argocd:
	@echo "$(boldGreen)5. Installing ArgoCD...$(normal)"
	@echo
	helm template ../main/argocd -n argocd --namespace argocd | kubectl -n argocd apply -f -
	@echo
	@read -r -p "completed."
	@clear

argocd-app:
	@echo "$(boldGreen)5. Set up ArgoCD with \`main\` folder$(normal)"
	@echo
	kubectl apply -f ../main/argocd/templates/argocd-project.yaml
	kubectl apply -f ../main/argocd/templates/argocd-application.yaml
	@echo
	@read -r -p "completed."
