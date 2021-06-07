FROM mattcen/sshbase

RUN sed  -i '1i [ `id -u` -eq 0 ] || exec ssh -oStrictHostKeyChecking=no mine' /etc/profile
RUN sed -i '/motd/s/^/#/' /etc/pam.d/*

COPY docker-entrypoint.sh .
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-eD"]
