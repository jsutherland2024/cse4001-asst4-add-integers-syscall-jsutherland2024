# Container image that runs your code
FROM eribeirofit/cse4001:latest

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /root/os161/root/entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/root/os161/root/entrypoint.sh"]

