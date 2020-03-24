boldGreen := $(shell tput bold)$(shell tput setaf 2)
normal := $(shell tput sgr0)

all: note-1 k8s-namespace github-token argocd argocd-app
resume: note-2 github-token argocd argocd-app

note-1:
	@clear
	@echo "$(boldGreen)Starting K8s Installation$(normal)"
	@echo
	@echo "You need the following tools installed on your machine:"
	@echo "	- kubectl (Homebrew: kubernetes-cli)"
	@echo
	@echo "The following steps will be taken:"
	@echo "	1. Apply prerequisite namespace definition"
	@echo "	2. Set up access token for git repo"
	@echo "	3. Install ArgoCD"
	@echo "	4. Set up ArgoCD with \`stack\` directory"
	@echo
	@echo "NOTE: If you used template to generate the repo, you need to run the following first:"
	@echo "      	tools/replace-repo-ref.sh"
	@echo "      This will replace all the repository references"
	@echo
	@echo "Current Kubernetes Setup"
	@kubectl cluster-info
	@echo

	@echo "Make sure you are working with the right Kubernetes cluster"
	@echo

	@read -r -p "If you are ready to proceed, press enter. Otherwise exit with Ctrl-C. "
	@clear

k8s-namespace:
	@echo "$(boldGreen)1. Applying K8s namespace for ArgoCD...$(normal)"
	@echo
	kubectl apply -f ./init/namespace-argocd.yaml
	@echo
	@read -r -p "completed."
	@clear

github-token:
	@echo "$(boldGreen)2. Setting up access token for git repo...$(normal)"
	@echo
	@echo "NOTE: For using a forked repository, you need to run \`tools/replace-repo-ref.sh\` script before this."
	@echo "      If you have not done this yet, exit with Ctrl-C now, and run the followings"
	@echo "    tools/replace-repo-ref.sh"
	@echo "    make resume"
	@echo
	@echo "If you are ready to proceed, provide the following information:"
# @read -r -p "    Your username: " username; # When user token is used, the username can be any non-empty string
	@read -s -p "    Your token: " userToken;\
		echo "";\
		kubectl -n argocd create secret generic access-secret \
			--from-literal=username=placeholder \
			--from-literal=token=$$userToken
	@echo
	@read -r -p "completed."
	@clear

argocd:
	@echo "$(boldGreen)3. Installing ArgoCD...$(normal)"
	@echo
	kubectl apply -f ./stack/argocd/argocd-install.yaml -n argocd
	@echo
	@read -r -p "completed."
	@clear

argocd-app:
	@echo "$(boldGreen)4. Set up ArgoCD with \`stack\` folder$(normal)"
	@echo
	kubectl apply -f ./init/argocd-project.yaml
	kubectl apply -f ./init/argocd-application.yaml
	@echo
	@read -r -p "completed."

note-2:
	@clear
	@echo "$(boldGreen)Resuming K8s Installation$(normal)"
	@echo
	@echo "You are about to resume the K8s installation"
	@echo
	@echo "The following steps will be taken:"
	@echo "	3. Set up access token for git repo"
	@echo "	4. Install ArgoCD"
	@echo "	5. Set up ArgoCD with \`stack\` directory"
	@echo
	@read -r -p "If you are ready to get started, press enter "
	@clear