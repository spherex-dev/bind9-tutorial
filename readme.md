## Introduction

This repository provides and outline on how to setup a dns server using docker. Basic knowledge about dns records and network masks is assumed.

A basic setup is provided to allow machines inside of a network to set their own dns records. Authentication to the dns server is not setup, however this can be restricted via using a key or restricted using an ip address. If you are interested in learning more about the configuration syntax, documentation is available at this [link](https://bind9.readthedocs.io/en/latest/)

A blog post about this setup can be found at our spherx site [here](https://www.spherex.com/use-bind9-to-setup-a-home-domain/).

# Prerequisites

It is assume that you are running on a unix system like Ubuntu. Installaton of `bind9-utils` is required to generate an rndc.key file which is used by bind9. Installation can be done using `sudo apt-get install bind9-utils` if you are on Ubuntu. Please use the approrpriate command for your distro.

# The Setup

This repository assumes that you are looking to setup a home network called `home.int` which has an acl set to a private network of `172.16.0.0/12` via the `home` acl defined in `./etc/bind/named.conf` feel free to change this subnet to match the ip address range of your home network.

Zones are defined in the `/etc/bind/named.conf.local` file. The following is an example of a zone definition:

```
zone "home.int" {
	type master;
	file "/var/lib/bind/home.int.hosts";
	allow-update {
		home;
		};
	allow-transfer {
		home;
		};
	allow-query {
		home;
		};
	};
```


# Setup Steps

1. Run the `create-rndc-key.sh` script to generate a rndc.key file. Delete the `options` block if necessary in the generated `./etc/bind/rndc.key` file. An example of what the file should look like is provided below:
```
key "rndc-key" {
	algorithm hmac-sha256;
	secret "some secret";
};
```
1. Modify the `./etc/bind/named.conf` file to update the CIDR mask to suit the ip range of the network. This allows machines on your network to set their own dns records.
1. (optional) update the `./etc/bind/named.conf.options` file to point to the upstream dns servers of your choice.
1. (optional) update the `./var/lib/bind/home.int.hosts` replacing `my-machine` with the name of the machine in the domain and optionally adding an e-mail address in the SOA.
1. When you are ready to run the docker image, run the  `set-bind.sh` script to update the file permissions of the `etc` and `var` directories to user `101` as this is expected user id needed to allow bind to read the files.
1. copy the `docker-compose-example.yml` file to `docker-compose.yml` and update the ip address of the host that will run the bind9 server. I've left in an example value of `172.16.81.120` which you can modify to suit your needs.
1. run `docker-compose up -d` to start the bind9 container.
1. update the `./scripts/update-record-example` to point to the correct dns server and set the ip address of some A record and run `nsupdate ./scripts/update-record-example` to update the record.
1. To test that dns record has been set you can run `host test.home.int 172.16.81.120` (replace 172.16.81.120 with your ip address) to verify that the record has been set.
