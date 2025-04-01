jasonlws-docker-1 ssh: 1221
jasonlws-docker-2 ssh: 1222
jasonlws-docker-3 ssh: 1223

docker swarm init --advertise-addr <node1_IP_address>
docker node update --label-add key=value node_name

docker swarm join --token <token> <node1_IP_address>:2377

docker swarm join --token <token> <node1_IP_address>:2377