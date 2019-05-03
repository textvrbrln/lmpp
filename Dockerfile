FROM ubuntu:16.04

ENV TERM=xterm

RUN 	apt-get update && apt-get install -y --no-install-recommends git firefox libxml-perl curl vim gedit imagemagick libxml-parser-perl libxml-dom-perl locales dbus

# Replace 1000 with your user / group id
RUN		export uid=1000 gid=1000 && \
    	mkdir -p /home/kkissling/github && \
		mkdir -p /etc/sudoers.d && \
		touch /etc/sudoers.d/kkissling && \
    	echo "kkissling:x:${uid}:${gid}:Developer,,,:/home/kkissling:/bin/bash" >> /etc/passwd && \
    	echo "kkissling:x:${uid}:" >> /etc/group && \
    	echo "kkissling ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/kkissling && \
    	chmod 0440 /etc/sudoers.d/kkissling

ADD 	https://raw.githubusercontent.com/textvrbrln/lmpp/master/lm_post_production /opt/lnm/bin/
ADD 	https://raw.githubusercontent.com/textvrbrln/lmpp/master/indd-exportcheck /opt/lnm/bin/
ADD 	https://raw.githubusercontent.com/textvrbrln/lmpp/master/Visual_Leserbriefe.png /opt/lnm/bin/

COPY 	lnm-tools /opt/lnm/bin/

RUN 	chmod -R 755 /opt/lnm/bin && \
		chown kkissling:kkissling -R /home/kkissling && \
		chown kkissling:kkissling /opt/lnm/bin/lm_post_production /opt/lnm/bin/indd-exportcheck && \
		locale-gen de_DE@euro && \
		dbus-uuidgen > /etc/machine-id

USER 	kkissling
ENV 	HOME /home/kkissling
ENV 	PATH /opt/lnm/bin:$PATH
ENV		LANG de_DE.ISO-8859-15@euro
ENV		LANGUAGE de_DE.ISO-8859-15@euro
ENV		LC_ALL de_DE.ISO-8859-15@euro

WORKDIR /home/kkissling
CMD 	/bin/bash