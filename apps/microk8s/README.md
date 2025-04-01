# Environment

Environment: Ubuntu 20.04 with MicroK8S installed

### Install a Box

This will download the box named `generic/ubuntu2004` from HashiCorp's Vagrant Cloud box catalog, where you can find and host boxes.

```
vagrant box add generic/ubuntu2004
```

### Bring up a virtual machine

Run the following from your terminal:

```
vagrant up
```

### Destroy a virtual machine

Run the following from your terminal:

```
vagrant destroy jasonlws-microk8s -f
```

### SSH

SSH Connection Information:

Host: `127.0.0.1`

Port: `2222`

User: `root`

Password: `P@ssw0rd`

### Access Kubernetes Dashboard

Access [https://127.0.0.1:31625](https://127.0.0.1:31625) and copy the token from the last statement after `vagrant up` command.

## License

MIT - a permissive free software license originating at the Massachusetts Institute of Technology (MIT), it puts only very limited restriction on reuse and has, therefore, an excellent license compatibility. It permits reuse within proprietary software provided that all copies of the licensed software include a copy of the MIT License terms and the copyright notice.

Check the [LICENSE file](../LICENSE) for more details.