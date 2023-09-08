## Ansible code

1. Move to Ansible folder 
   
   ```sh
   cd ansible
   ```
2. Create `hosts.ini` from the template

   ```sh
   cp hosts_template.ini hosts.ini
   ```
3. Run the Ansible playbook 

   ```sh
   ansible-playbook main_playbook.yml -i hosts.ini --flush-cache
   ```