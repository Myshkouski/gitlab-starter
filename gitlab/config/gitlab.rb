external_url 'http://localhost/'
gitlab_rails['initial_root_password'] = File.read('/run/secrets/gitlab_root_password')
# GitLab Runner registration token
gitlab_rails['initial_shared_runners_registration_token'] = File.read('/run/secrets/gitlab_runner_registration_token')
# Disable the bundled Omnibus provided PostgreSQL
postgresql['enable'] = false
# PostgreSQL connection details
gitlab_rails['db_adapter'] = 'postgresql'
# IP/hostname of database server
gitlab_rails['db_host'] = 'gitlab-postgres' 
gitlab_rails['db_encoding'] = 'unicode'
gitlab_rails['db_database'] = File.read('/run/secrets/gitlab_postgres_db')
gitlab_rails['db_username'] = File.read('/run/secrets/gitlab_postgres_user')
gitlab_rails['db_password'] = File.read('/run/secrets/gitlab_postgres_password')
