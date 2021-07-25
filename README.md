## salt-windows

### Setup Linux Host to be Salt Master
- Linux host is Ubuntu, so using instructions from here to setup Salt Master: https://repo.saltproject.io/#ubuntu
- In Terminal on Ubuntu run the following command to add GPG key for Salt:

```sudo curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg```
- Next in Terminal run the following to add the Salt repo:

```echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list```
- Next in Terminal run: 

```sudo apt-get install salt-master```
- It doesn't look like you need to run 'salt-master' on Linux host to daemonize the process.  Looks like it is already done

### Setup Windows Server 2016 to be Salt Minion
- Go to the following site to get the Windows installer for Salt Minion: https://repo.saltproject.io/#windows
- I installed the 64-bit version of the Salt Minion on my Windows host
- During install I was asked what Master to point it to, so I input the IP of my Linux host
- I was also asked what Minion name I would like to use, so I chose "salt-dc01"

### Post Installation
- Probably a good idea to verify the certificates that are in use between the Master and the Minion.
- You can verify what keys are available on the Master by running this command on the Master:

```salt-key -F master```
- I'm running the following command on my Windows Minion to see the Minion key fingerprint:

```salt-call --local key.finger```
- I can see that the unaccepted key shown when I ran the command on the Master matches the Minion's key
- If you want to list the keys on the Master, so we can work towards accepting the Minion's key you can run this:

```sudo salt-key -L```
- In the output I can see that my Windows Minion has an unaccepted key
- If you want to accept all unaccepted Minions you can run this command:

```sudo salt-key -A```
- I only want to accept a certain key just for learning purposes, so I will run this:

```sudo salt-key -a salt-dc01```
- Run the following command from the Master to see if you can the agent version from Minion:

```sudo salt salt-dc01 test.version```
- If you wanted to send the same command to all Minions you could run this:

```salt '*' test.version```
- Grains in Salt is similar to what Facts is in Ansible.  Grains store detail about the system you're managing.
- The following command will list the grains and their associated data:

```salt '*' grains.items```
- If you want to see the IP address of the Windows Minion you could do this:

```sudo salt salt-dc01 cmd.run 'ipconfig /all'```
- Lets say you want to target based off whether the Minion is Windows.  You could use grains like this:

```sudo salt -G 'os:Windows' test.ping```

### Working with Salt States
- On the Windows Minion I had to open the config file at C:\salt\conf\minion and add to lines as follows to end of file:

<p>use_superseded:<br>
     - module.run</p>
- This previous configuration was necessary to be able to use the new syntax format for module.run that was used in win_enable_administrator state file.     

### Useful Commands for Salt
- To retrieve a list of the various state functions do this:

```sudo salt '*' sys.list_functions```



