{% set MANAGER = salt['grains.get']('master') %}
{% set MANAGER_URL = salt['pillar.get']('global:url_base', '') %}
{% set MANAGER_IP = salt['pillar.get']('global:managerip', '') %}

n8ndir:
  file.directory:
    - name: /opt/so/conf/n8n
    - user: 1000
    - group: 1000
    - makedirs: True

so-n8n:
  docker_container.running:
    - image: wlambert/n8n
    - hostname: n8n
    - name: so-n8n
    - environment:
      - N8N_HOST=0.0.0.0
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - SUBFOLDER=n8n
      - N8N_PATH=/n8n/
      - DATA_FOLDER=/root/n8n/
      - WEBHOOK_TUNNEL_URL=https://{{ MANAGER_IP}}/n8n/
      - VUE_APP_URL_BASE_API=https://{{ MANAGER_IP }}/n8n/
      - NODE_TLS_REJECT_UNAUTHORIZED=0
    - binds:
      - /opt/so/conf/n8n:/home/node/.n8n:rw
    - port_bindings:
      - 0.0.0.0:5678:5678
    - extra_hosts:
      - {{MANAGER_URL}}:{{MANAGER_IP}}
