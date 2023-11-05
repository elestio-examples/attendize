<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Attendize, verified and packaged by Elestio

[Attendize](https://www.attendize.com/) is an Open-source ticket selling and event management platform and is everything you need for a successful event. Attendize has a wide array of features aimed at making organising events as effortless as possible.

<img src="https://github.com/elestio-examples/attendize/raw/main/attendize.png" alt="attendize" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/attendize">fully managed Attendize</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

[![deploy](https://github.com/elestio-examples/attendize/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/attendize)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/attendize.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Run the project with the following command

    ./scripts/preInstall.sh
    docker-compose up -d
    ./scripts/postInstall.sh

You can access the Web UI at: `http://your-domain:20403`

## Docker-compose

Here are some example snippets to help you get started creating a container.

    version: "3.2"

    services:
        web:
            user: 0:0
            image: elestio4test/attendize-web:latest
            ports:
                - "172.17.0.1:20403:443"
            volumes:
                - ./.env:/usr/share/nginx/html/.env
                - ./config/Install.php:/usr/share/nginx/html/app/Console/Commands/Install.php
                # - ./config/installed:/usr/share/nginx/html/installed
            depends_on:
                - db
                - redis
                - worker
            env_file:
                - ./.env
        worker:
            user: 0:0
            image: elestio4test/attendize-worker:latest
            depends_on:
                - db
                - redis
            volumes:
                - ./.env:/usr/share/nginx/html/.env
        db:
            image: elestio/mysql:8.0
            restart: always
            env_file:
                - ./.env
            environment:
                MYSQL_ROOT_PASSWORD: "yes"
                MYSQL_HOST: ${DB_HOST}
                MYSQL_DATABASE: ${DB_DATABASE}
                MYSQL_USER: ${DB_USERNAME}
                MYSQL_PASSWORD: ${DB_PASSWORD}
            ports:
                - "172.17.0.1:41525:3306"
            volumes:
                - "./storage/mysql:/var/lib/mysql"
        redis:
            image: elestio/redis:7.0
            volumes:
                - ./storage/redis:/data
            command: --requirepass ${REDIS_PASSWORD}

        pma:
            image: elestio/phpmyadmin:latest
            restart: always
            links:
                - db:db
            ports:
                - "172.17.0.1:61927:80"
            environment:
                PMA_HOST: db
                PMA_PORT: 3306
                PMA_USER: ${DB_USERNAME}
                PMA_PASSWORD: ${ADMIN_PASSWORD}
                UPLOAD_LIMIT: 500M
                MYSQL_USERNAME: ${DB_USERNAME}
                MYSQL_ROOT_PASSWORD: ${ADMIN_PASSWORD}
            depends_on:
                - db

### Environment variables

|           Variable           |              Value (example)               |
| :--------------------------: | :----------------------------------------: |
|     SOFTWARE_VERSION_TAG     |                   latest                   |
|         ADMIN_EMAIL          |               your@email.com               |
|        ADMIN_PASSWORD        |               your-password                |
|            DOMAIN            |                your.domain                 |
|        ATTENDIZE_DEV         |                    true                    |
|       ATTENDIZE_CLOUD        |                   false                    |
|           APP_NAME           |                 Attendize                  |
|          APP_DEBUG           |                    true                    |
|           APP_URL            |            https://your.domain             |
|         LOG_CHANNEL          |                   stack                    |
|        DB_CONNECTION         |                   mysql                    |
|           DB_HOST            |                     db                     |
|           DB_PORT            |                    3306                    |
|         DB_DATABASE          |                 attendize                  |
|         DB_USERNAME          |                 attendize                  |
|         DB_PASSWORD          |               your-password                |
|       BROADCAST_DRIVER       |                    log                     |
|         CACHE_DRIVER         |                    file                    |
|       QUEUE_CONNECTION       |                    sync                    |
|        SESSION_DRIVER        |                    file                    |
|       SESSION_LIFETIME       |                    120                     |
|          REDIS_HOST          |                   redis                    |
|        REDIS_PASSWORD        |               your-password                |
|          REDIS_PORT          |                    6379                    |
|         MAIL_DRIVER          |                    smtp                    |
|          MAIL_HOST           |                 172.17.0.1                 |
|          MAIL_PORT           |                     25                     |
|        MAIL_USERNAME         |                    null                    |
|        MAIL_PASSWORD         |                    null                    |
|       MAIL_ENCRYPTION        |                    null                    |
| DEFAULT_DATEPICKER_SEPERATOR |                     -                      |
|  DEFAULT_DATEPICKER_FORMAT   |             'yyyy-MM-dd HH:mm'             |
|   DEFAULT_DATETIME_FORMAT    |                'Y-m-d H:i'                 |
|      MAIL_FROM_ADDRESS       |              sender@email.com              |
|        MAIL_FROM_NAME        |                 Attendize                  |
|     WKHTML2PDF_BIN_FILE      |             wkhtmltopdf-amd64              |
|        CAPTCHA_IS_ON         |                   false                    |
|             LOG              |                  errorlog                  |
|           APP_KEY            | must be empty, will be filled automaticaly |

# Maintenance

## Logging

The Elestio Attendize Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://www.attendize.com/">Attendize documentation</a>

- <a target="_blank" href="https://github.com/Attendize/Attendize">Attendize Github repository</a>

- <a target="_blank" href="https://github.com/elestio-examples/attendize">Elestio/Attendize Github repository</a>
