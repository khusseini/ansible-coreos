# Core OS Ansible Scripts

!! UNDER ACTIVE DEVELOPMENT !!

See `make help` or the Makefile for more information.


## Usage

### Step 0: Configure Inventory
See `ansible/inventory/vagrant/inventory.ini`
```
make coreos-bootstrapped.yml
```

### Step 1: Install CoreOS
```
make coreos-k8s/cloud-config.yml
make coreos-updated.yml
```

### Step 2: Configure Cluster
```
make coreos-k8s/kubectl.yml
make coreos-k8s/init-k8s.yml
```

#### Credits 
Ansible roles and cloud-config are inspired by and partially copied from
[cornelius-keller/ansible-coreos-kubernetes](https://github.com/cornelius-keller/ansible-coreos-kubernetes)
