
# Setup Ansible
1. Install ansibe on Ubuntu 22.04 
   ```sh 
   sudo apt update
   sudo apt install software-properties-common
   sudo add-apt-repository --yes --update ppa:ansible/ansible
   sudo apt install ansible
   ```

2. Add Jenkins master and slave as hosts 
Add jenkins master and slave private IPs in the inventory file 
in this case, we are using /opt is our working directory for Ansible.
 ```
[jenkins-master]
10.1.1.22
[jenkins-master:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/opt/dpw.pem
[jenkins-slave]
10.1.1.218
[jenkins-slave:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/opt/dpw.pem
   ```

1. Test the connection  
   ```sh
   ansible -i hosts all -m ping 
   ```
