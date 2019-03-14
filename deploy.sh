# setup env vars
GCP_SA_KEY_PATH=$HOME/gcloud-service-key.json
IMAGE_NAME=$DOCKER_REGISTRY_HOST/$GCP_PROJECT_ID/$DOCKER_IMAGE_NAME:$TRAVIS_COMMIT

# configure gcloud, docker
echo $GCP_SA_KEY_BASE64 | base64 --decode --ignore-garbage > $GCP_SA_KEY_PATH
gcloud auth activate-service-account --key-file $GCP_SA_KEY_PATH
gcloud auth configure-docker --quiet

# build docker image
docker -v
docker build -t $IMAGE_NAME .
docker push $IMAGE_NAME
gcloud config set project $GCP_PROJECT_NAME

# configure kubectl helm, tiller
gcloud container clusters get-credentials $GCP_GKE_CLUSTER_NAME --zone $GCP_COMPUTE_ZONE --project $GCP_PROJECT_NAME
kubectl version
kubectl cluster-info
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
helm init --upgrade --wait

# deploy all manifests to k8s
helm upgrade hello-world ./k8s/ --install -f ./k8s/values.yaml --set image.tag=$TRAVIS_COMMIT
