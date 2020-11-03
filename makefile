.PHONEY: deploy
deploy: deploy.sh
	bash deploy.sh || git bash deploy.sh 

.PHONEY: post
post: newpost.sh
	bash newpost.sh || git bash newpost.sh