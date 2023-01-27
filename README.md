## Compatibility

This has been tested with:
1. Debian 11, Ubuntu 20.04 and Ubuntu 22.04 hosts
2. Nethermind 1.15 and 1.16.  Lower versions have a mildly different configuration file format

## Quick launch a nethermind node

1. Create an instance or set up a compatible machine.  Set up the instance or/and your local SSH config so that you can just `ssh machine_ip sudo echo hello` successfully
2. Fetch a platform-appropriate Nethermind release zipfile from [the Github releases page](https://github.com/nethermindEth/nethermind/releases). Example: `wget https://github.com/NethermindEth/nethermind/releases/download/1.16.1/nethermind-1.16.1-644fe89f-linux-x64.zip`
3. Rename the file to something simple, such as nethermind-1.16-x64.zip`
4. Revise the included inventory.yml to refer to your machine IP as the target host and the nethermind zipfile.
5. `ansible-playbook  -i inventory.yml  nethermind-deploy.yml`


After the playbook completes, Nethermind should successfully start and the machine appear on https://stats.testnet.shyft.network/ .

You can shut down Nethermind and clear off database and executables with # `ansible-playbook  -i inventory.yml  nethermind-reset.yml`

The playbook supports a number of extra features. Review the playbook and the config file templates to understand them.
- deploying sealer keys and passwords
- identifying prometheus push gateway for telemetry
- health checks


## Establishing an RPC

If you would like nginx to server as an http/https reverse proxy to this instance, drop a file in `/etc/nginx/sites-enabled` kind of like this:

```
server {
        listen 80;
        server_name myrpc.mycorp.com;

        location / {
                proxy_pass http://localhost:64739;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
        }
}


server {
        listen 443 ssl;
        server_name myrpc.mycorp.com;

        ssl_certificate /path/to/fullchain.pem;
        ssl_certificate_key /path/to/privkey.pem; 

        location / {
                proxy_pass http://localhost:64739;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
        }
}
```



