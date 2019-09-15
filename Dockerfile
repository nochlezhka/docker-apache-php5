FROM debian:jessie-slim
# Add starter 
ADD start.sh /root/start.sh

RUN apt-get update && \
    apt-get install apache2 -y && \
    systemctl enable apache2 && \
    echo "SetEnv PROJECT_RUN_MODE docker" >> /etc/apache2/apache2.conf && \
    echo "PROJECT_RUN_MODE=docker" >> /etc/environment && \
    sed -i 's|^ServerTokens.*|ServerTokens Prod|' /etc/apache2/conf-available/security.conf && \
    sed -i 's|^ServerSignature.*|ServerSignature Off|' /etc/apache2/conf-available/security.conf && \
    ln -s /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/headers.load && \
    ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load && \
    ln -s /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/socache_shmcb.load && \
    ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ssl.conf && \
    ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load && \
    apt-get install php-gettext php-pear php-tcpdf php5-apcu php5-curl php5-gd php5-imagick php5-json php5-mcrypt php5-mysqlnd php5-readline php5-redis php5-imap php5-intl -y && \
    sed -i 's|^short_open_tag.*|short_open_tag = On|' /etc/php5/apache2/php.ini && \
    sed -i 's|^max_execution_time.*|max_execution_time = 300|' /etc/php5/apache2/php.ini && \
    sed -i 's|^max_input_time.*|max_input_time = 600|' /etc/php5/apache2/php.ini && \
    sed -i 's|^error_reporting.*|error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_NOTICE \& ~E_STRICT|' /etc/php5/apache2/php.ini && \
    sed -i 's|^;date.timezone.*|date.timezone = Europe/Moscow|' /etc/php5/apache2/php.ini && \
    sed -i 's|^;mbstring.func_overload.*|mbstring.func_overload = 2|' /etc/php5/apache2/php.ini && \
    sed -i 's|^upload_max_filesize.*|upload_max_filesize = 512M|' /etc/php5/apache2/php.ini && \
    sed -i 's|^post_max_size.*|post_max_size = 512M|' /etc/php5/apache2/php.ini && \
    sed -i 's|^;default_charset = *|default_charset = "utf-8"|' /etc/php5/apache2/php.ini && \
    sed -i 's|^short_open_tag.*|short_open_tag = On|' /etc/php5/cli/php.ini && \
    sed -i 's|^;error_log.*|error_log = /var/log/php_cli_errors.log|' /etc/php5/cli/php.ini && \
    sed -i 's|^error_reporting.*|error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_NOTICE \& ~E_STRICT|' /etc/php5/cli/php.ini && \
    sed -i 's|^;date.timezone.*|date.timezone = Europe/Moscow|' /etc/php5/cli/php.ini && \
    sed -i 's|^;mbstring.func_overload.*|mbstring.func_overload = 2|' /etc/php5/cli/php.ini && \
    sed -i 's|^;default_charset = *|default_charset = "utf-8"|' /etc/php5/cli/php.ini && \
    echo "apc.shm_size=64M" >> /etc/php5/mods-available/apcu.ini && \
    ln -snf /usr/share/zoneinfo/Europe/Moscow /etc/localtime && echo "Europe/Moscow" > /etc/timezone && \
    mv /etc/apache2 /etc/apache2-orig && \
    apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
    rm -rf /var/cache/debconf/*-old && rm -rf /var/lib/apt/lists/* && rm -rf /usr/share/doc/*

ADD apache2-prefork.conf /etc/apache2-orig/mods-available/mpm_prefork.conf

RUN chmod +x /root/start.sh
CMD ["/bin/bash", "/root/start.sh"]

EXPOSE 80 443

VOLUME ["/var/www", "/etc/apache2", "/var/log/apache2"]
