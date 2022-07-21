## Quick launch a nethermind node

- create an instance or set up a machine
- point to  the login key in `ansible.cfg`, and the machine's IP in `inventory.yaml`
- obtain a recent Nethermind release from [the Github releases page](https://github.com/nethermindEth/nethermind/releases)
- refer to the downloaded zip file in `inventory.yaml`
- `ansible-playbook nethermind-initbook.yaml` needs to be run once
- `ansible-playbook nethermind-deploybook.yaml` needs to be run to update or install nethermind on the instance. 

Your instance should successfully start and appear on https://fedstats.veriscope.network/ .

