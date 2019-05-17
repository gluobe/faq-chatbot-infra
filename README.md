# Faqchatbot pipeline

infrastructuur voor de faqchatbot
## Environment Variables
 Parameters die nodig zijn om alles goed te runnen
 deze moeten gemaakt woorden in de aws systems manager parameter store
 
* confluence-url
* confluence_pw
* confluence_usernaam
* database
* db_host
* db_password
* db_user
* github_token
* slack_acces_token
* slack_secret

Indien nieuwe enviroment variables nodig hebben in de ecs-service folder/main bij de containerdefinitie

## Usage
Installer [Terraform](https://www.terraform.io/downloads.html) na goed instalatie

```bash
Terraform init
Terraform apply
```

## License
[GLUO](http://www.gluo.be/)