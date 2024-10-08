FROM debian:bookworm

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies.
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		sudo systemd systemd-sysv \
		build-essential wget libffi-dev libssl-dev procps \
		ansible \
		iproute2 \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /usr/share/doc && rm -rf /usr/share/man \
	&& apt-get clean

COPY --chmod=555 initctl_faker /sbin/initctl

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Make sure systemd doesn't start agettys on tty[1-6].
RUN rm -f /lib/systemd/system/multi-user.target.wants/getty.target

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
