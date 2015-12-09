 #! /bin/sh
 #
 # - Download and install kubectl from binary release
 # - Setup kubectl config for the vagrant kube cluster

kube_release=v1.0.6

# Detect the OS name/arch so that we can find our binary
case "$(uname -s)" in
  Darwin)
    host_os=darwin
    ;;
  Linux)
    host_os=linux
    ;;
  *)
    echo "Unsupported host OS.  Must be Linux or Mac OS X." >&2
    exit 1
    ;;
esac

case "$(uname -m)" in
  x86_64*)
    host_arch=amd64
    ;;
  i?86_64*)
    host_arch=amd64
    ;;
  amd64*)
    host_arch=amd64
    ;;
  arm*)
    host_arch=arm
    ;;
  i?86*)
    host_arch=386
    ;;
  s390x*)
    host_arch=s390x
    ;;
  *)
    echo "Unsupported host arch. Must be x86_64, 386, arm or s390x." >&2
    exit 1
    ;;
esac

echo "download https://storage.googleapis.com/kubernetes-release/release/$kube_release/bin/$host_os/$host_arch/kubectl"
curl -so kubectl https://storage.googleapis.com/kubernetes-release/release/$kube_release/bin/$host_os/$host_arch/kubectl
chmod +x kubectl
sudo  mv kubectl /usr/local/bin/kubectl

echo "kubectl config set-cluster vagrant --server=https://172.17.4.101:443 --certificate-authority=${PWD}/ssl/ca.pem"
kubectl config set-cluster vagrant --server=https://172.17.4.101:443 --certificate-authority=${PWD}/ssl/ca.pem
echo "kubectl config set-credentials vagrant-admin --certificate-authority=${PWD}/ssl/ca.pem --client-key=${PWD}/ssl/admin-key.pem --client-certificate=${PWD}/ssl/admin.pem"
kubectl config set-credentials vagrant-admin --certificate-authority=${PWD}/ssl/ca.pem --client-key=${PWD}/ssl/admin-key.pem --client-certificate=${PWD}/ssl/admin.pem
echo "kubectl config set-context vagrant --cluster=vagrant --user=vagrant-admin"
kubectl config set-context vagrant --cluster=vagrant --user=vagrant-admin
echo "kubectl config use-context vagrant"
kubectl config use-context vagrant