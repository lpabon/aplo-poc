FROM heketi/heketi

MAINTAINER Luis Pabón lpabon@redhat.com
LABEL version="0.1"
LABEL description="Heketi with vagrant ssh private key"

ADD ./heketi.json /etc/heketi/heketi.json
ADD ./insecure_private_key /etc/heketi/insecure_private_key
USER root
RUN chmod 600 /etc/heketi/insecure_private_key
RUN chown heketi:heketi /etc/heketi/insecure_private_key

VOLUME [ "/etc/heketi", "/var/lib/heketi" ]

USER heketi
ENTRYPOINT ["/usr/bin/heketi"]
EXPOSE 8080

CMD ["-config=/etc/heketi/heketi.json"]
