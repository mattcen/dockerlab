
# Set up:

```sh
docker network create --attachable lab
docker compose up -d
cd secrets
cp users.psv.exampel users.psv
./genkeys
cd ..
./start_lab_hosts
```
