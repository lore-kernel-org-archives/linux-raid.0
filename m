From: NeilBrown <neilb@suse.de>
Subject: Re: Request for help with "1st time through" RAID array renaming
Date: Thu, 15 Aug 2013 09:46:36 +1000
Message-ID: <20130815094636.3f804c9f@notabene.brown>
References: <1376497589.7879.9787867.21A861C2@webmail.messagingengine.com>
	<1376501238.20717.9810207.70E4DA12@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oM/.NEtC/XjgTP2dc.54AsH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376501238.20717.9810207.70E4DA12@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: ariel.work@fmgirl.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/oM/.NEtC/XjgTP2dc.54AsH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Aug 2013 10:27:18 -0700 ariel.work@fmgirl.com wrote:

> Doing 'my homework', to my read, this is what I think needs to be done.=20
> Am I right?
>=20
> In general
>=20
> (1) Boot from a LiveCD
> (2) stop the arrays
> (3) make changes
>=20
> The details should look like this.
>=20
> 1st checking
>=20
> 	cat /proc/mdstat  | grep ^md
> 		md0 : active raid1 sda1[0] sdb1[1]
> 		md1 : active raid1 sdb2[2] sda2[0]
> 		md2 : active raid10 sdc1[0] sdf1[3] sde1[2] sdd1[1]
>=20
>=20
> ???     QUESTION:  Why does the 'md1' line refer to "[2]" & "[0]"?  Why
> is there no "[1]" instead of "[2]"?  Is this a problem that needs
> fixing?
>=20
> For
>=20
> 	mdadm --detail --scan
> 		ARRAY /dev/md0         metadata=3D0.90               =20
> 		UUID=3Dxxx...
> 		ARRAY /dev/md/Rescue:1 metadata=3D1.0  name=3DRescue:1 =20
> 		UUID=3Dyyy...
> 		ARRAY /dev/md2         metadata=3D1.2  name=3Dserver:md2
> 		UUID=3Dzzz...
>=20
> I'd do this?
>=20
> 	mdadm --stop /dev/md0
> 	mdadm --stop /dev/md/Rescue:1
> 	mdadm --stop /dev/md2
>=20
> 	mdadm --uuid=3Dxxx... --update=3Dsuper-minor --assemble /dev/md0
> 	/dev/sd[ab]1
> 	mdadm --uuid=3Dyyy... --update=3Dsuper-minor --assemble /dev/md1
> 	/dev/sd[ab]2
> 	mdadm --uuid=3Dzzz... --update=3Dsuper-minor --assemble /dev/md2
> 	/dev/sd[cdef]1

As the man page says, super-minor is only relevant for 0.90 metadata, and
updating it is automatic for 2.6 and later.  So this step is not needed.

>=20
> 	mdadm --stop /dev/md0
> 	mdadm --stop /dev/md1
> 	mdadm --stop /dev/md2
>=20
> 	mdadm --uuid=3Dxxx... --update=3Dname --name=3Dserver1_boot  =20
> 	--homehost=3D"<none>" --assemble /dev/md0  /dev/sd[ab]1
> 	mdadm --uuid=3Dyyy... --update=3Dname --name=3Dserver1_root  =20
> 	--homehost=3D"<none>" --assemble /dev/md1  /dev/sd[ab]2
> 	mdadm --uuid=3Dzzz... --update=3Dname --name=3Dserver1_storage
> 	--homehost=3D"<none>" --assemble /dev/md2  /dev/sd[cdef]1

This should work and do what you expect, though "--assemble" needs to come
first.
And if you are explicitly listing the devices (/dev/sd[ab]1), then giving t=
he
uuid as well is fairly pointless (though it doesn't hurt).

>=20
> Then EDIT
>=20
> 	/etc/mdadm.conf
> +               HOMEHOST <ignore>
> 		CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
> 		DEVICE /dev/disk/by-id/ata-[DISK1]-part2
> 		/dev/disk/by-id/[DISK2]-part2
> 		DEVICE /dev/disk/by-id/ata-[DISK1]-part1
> 		/dev/disk/by-id/[DISK2]-part1
> 		DEVICE /dev/disk/by-id/ata-[DISK3]-part1
> 		/dev/disk/by-id/ata-[DISK4]-part1
> 		/dev/disk/by-id/ata-[DISK5]-part1
> 		/dev/disk/by-id/ata-[DISK6]-part1
> -               ARRAY /dev/md0  level=3Draid1  num-devices=3D2 metadata=
=3D0.90
> UUID=3Dxxx...
> -               ARRAY /dev/md1  level=3Draid1  num-devices=3D2 metadata=
=3D1.00
> UUID=3Dyyy...
> -               ARRAY /dev/md2  level=3Draid10 num-devices=3D4 metadata=
=3D1.02
> name=3Dserver:md2 UUID=3Dzzz...
> +               ARRAY /dev/md0  level=3Draid1  num-devices=3D2 metadata=
=3D0.90
> name=3Dserver1_boot    UUID=3Dxxx...
> +               ARRAY /dev/md1  level=3Draid1  num-devices=3D2 metadata=
=3D1.00
> name=3Dserver1_boot    UUID=3Dyyy...
> +               ARRAY /dev/md2  level=3Draid10 num-devices=3D4 metadata=
=3D1.02
> name=3Dserver1_storage UUID=3Dzzz...
>=20
> and finally,=20
>=20
> 	mkinitrd
> 	reboot
>=20
> How's that look?

Mostly good.

NeilBrown


>=20
> Ariel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/oM/.NEtC/XjgTP2dc.54AsH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgwW3Dnsnt1WYoG5AQIKkhAAjDIF4asJ/UoWaoPZoxGAdukiFbGzQMsb
E1n2woWy1jZbRPJiTXWt4V91JZ6nCGbAanbUwVEz9j83iy9hcf6I3UKN9AYORNxH
yDCvq+knecEabI9Ffjf5/K7NB4uVVUfYi4kJ/BLAKJwbGnuivFtKkfpWvwfgLWEI
J6Pv+hGBKKYqIyj/4EJEih9NR+KapxAQF8YlIRSJUSFZbBpn4nzNIgtRwcmTDTaF
aljs/praKgZx2fylsKT8V24syO7M/Q+g44CVIPoN1QoSc7dCw/PWir+g299LcCu7
OGXFZFnD7hq36YIUeCWBr55X0hOrBcu9E7TXiAx6W6yDeBL+2O6Pia+nGapJkbDE
udGtOvR3A6nZTHFiJax9sHXvQd87WtT8Rcz9n5j7nJwxq8yDhh9RLZFtKyD8azgl
05UVqZV8+gPMCKehmObAFOk2d3OabPe0wIefTv9V/aiS9WE71+LwBa/FzZYebyvS
7CPmff7g3mbtTjBArHZ51BOz7uKRjl0pAAqorlHEBmzHP3TqmK5iKS5DKwAxdY7v
ZnMVws78rxB6WgfMxOcdflR9HRF/s7FAAXmY9P8a7SGnIFl61ZrHtpkwZQGw9YV3
TzY9IezPoXKLRzksxU8FyMy3TW7rLXIZHwCKLKtf6yrgxoK7etlksbaNfAv/DVce
8aripeTN74E=
=Au34
-----END PGP SIGNATURE-----

--Sig_/oM/.NEtC/XjgTP2dc.54AsH--
