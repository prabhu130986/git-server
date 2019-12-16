FROM qii404/git-server:latest

ARG USERNAME="git"
ARG PASSWORD="Techm@12345678"
ARG GIT_CODE=/git_codes

COPY create_project /usr/local/bin/

RUN chmod +x /usr/local/bin/create_project

RUN adduser -D -h "/home/$USERNAME" -s '/usr/bin/git-shell' $USERNAME \
    && echo "$USERNAME:$PASSWORD" | chpasswd

RUN mkdir -p /home/$USERNAME/.ssh

COPY id_rsa.pub /home/$USERNAME/.ssh/id_rsa.pub

RUN cat /home/$USERNAME/.ssh/id_rsa.pub > /home/$USERNAME/.ssh/authorized_keys \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh \
    && chmod 700 /home/$USERNAME/.ssh \
    && chmod -R 600 /home/$USERNAME/.ssh/*

RUN /usr/local/bin/create_project demo

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
