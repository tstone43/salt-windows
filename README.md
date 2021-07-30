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

- This previous configuration was necessary to be able to use the new syntax format for module.run that was used in win_enable_administrator state file.  Note that "- module.run" has a 2 space indent that I couldn't show with Markdown
- The "rename_computer.sls" file under the saltstack/salt directory in this repo is known as a State file. 
- Here are some important points about this state file:
  - The 1st line in the State file is the ID: rename_computer, which is a name you could reference to call this State file from another file such as a "top.sls" file.
  - The 2nd line represents what Salt State you will be using and also which function you will be using from the State.  For this example, "system" would be the Salt State and the function belonging to this State that I'm using is "hostname".
  - The 3rd line is attributes that are being passed to the State function.  This State is going to ensure the hostname is set to "salt-dc01"
  - The 4th line here is an ID of "reboot_computer"
  - In the 5th line I'm using the "system" State once again, but this time using the "reboot" function.
  - Lines 6-8 are attributes for the reboot function
- The win_set_ip_address.sls, the win_timezone.sls, and win_updates.sls are additional State files.
- Before executing State files on your Master you will need to make sure that your State files exist in the default location on your Master, which is /srv/salt.  I learned the hard way if they are not here they will not execute at all.
- Here's an example of how to apply a State file to a minion named "salt-dc01":

```sudo salt salt-dc01 state.apply win_timezone```
- Note in the example above you don't specify ".sls" after "win_timezone" when running the command.
- The win_enable_administrator.sls file was more complicated than these other State files to get working.  This file makes use of a Salt Module and also references a secret setup in a Pillar.
- In Salt, Pillars are used to store secrets, file paths, and other common things that would be shared across systems.
- Since Pillars could have secrets, they shouldn't be stored in the same area as your other State files.  The files related to a Pillar should be stored under /srv/pillar on the Master.
- In my /srv/pillar directory on my Master, I've created 2 files:
  - default.sls - has a key value pair in it that helps me define value for "admin_password"
  - top.sls - helps me specify which hosts will be targeted with key values defined in default.sls file.
- After you have defined these 2 files above you need to instruct your Minions to refresh the Pillar data just described above:

```sudo salt '*' saltutil.refresh_pillar```
- Here's a breakdown of win_enable_administrator.sls:
  - The 1st line again is just the ID: win_enable_administrator
  - The 2nd line is how you call a Salt Module.  
  - The 3rd line has the Salt Module I'm using, which is "user".  It also has the function of the module, "update".
  - The proceeding lines once again are attributes of the "user.update" function.
- As mentioned the win_enable_administrator is a Salt Module and not a Salt State.
- A Salt Module is executed each and every time that it is run.
- A Salt State will only make changes when the Minion is not in the desired state described by the State file.
- The win_enable_administrator file can be executed just as if it was a State:

```sudo salt salt-dc01 state.apply win_enable_administrator```
- The next State file is win_server_features, which will install the AD-Domain-Servers and DNS features
- If you want to see what features are available to install on a Minion you can run this:

```sudo salt salt-dc01 win_servermanager.list_available```
- Note that Salt requires the short name of the role, which is returned in right column of previous command

### Useful Commands for Salt
- To retrieve a list of the various state functions do this:

```sudo salt '*' sys.list_functions```



