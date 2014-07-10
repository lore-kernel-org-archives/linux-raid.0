From: NeilBrown <neilb@suse.de>
Subject: Re: no automatic resync after device disconnect then reconnect
Date: Thu, 10 Jul 2014 10:36:21 +1000
Message-ID: <20140710103621.0c1dd7d3@notabene.brown>
References: <883F6A2C-C8F6-4A27-B7BF-2FB98F395592@colorremedies.com>
 <20140710085840.78a65722@notabene.brown>
 <17DF6122-CD4A-4093-BA6B-4F1A98657655@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CRwKcGXjTIde.X9rqE7Q5Id"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17DF6122-CD4A-4093-BA6B-4F1A98657655@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CRwKcGXjTIde.X9rqE7Q5Id
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Jul 2014 17:57:03 -0600 Chris Murphy <lists@colorremedies.com>
wrote:

>=20
> On Jul 9, 2014, at 4:58 PM, NeilBrown <neilb@suse.de> wrote:
>=20
> > On Wed, 9 Jul 2014 16:44:27 -0600 Chris Murphy <lists@colorremedies.com>
> > wrote:
> >=20
> >> This is in a VM, no data at risk.
> >>=20
> >> Two problems:
> >>=20
> >> 1. I intentionally removed one of two md raid1 member devices, boot de=
graded succeeds, clean power off, reconnect the removed md member device, b=
oot succeeds but an automatic resync does not occur for the previously disc=
onnect md members. Maybe this is expected, I'm not sure, but I'd think a be=
tter user experience would be autoresync perhaps with a notification?
> >=20
> > Do you?  Maybe the device was removed from the array because it is faul=
ty.
> > Do you *really* want a faulty device automatically added back into your=
 array?
>=20
> OK maybe not.
>=20
> > It is quite possible to set up udev rules and configure mdadm policy to=
 do
> > this.  I just don't think it is a sensible default.
>=20
> Fair enough.
>=20
>=20
> >=20
> >>=20
> >> 2. For the raid set with a bitmap, this command succeeds
> >> # mdadm --manage /dev/md126 --re-add /dev/sdb3
> >=20
> > Good to know.
> >=20
> >>=20
> >> However, for the raid set without bitmap (seems the same otherwise, sa=
me metadata version), it fails:
> >> # mdadm --manage /dev/md127 --re-add /dev/sdb2
> >> mdadm: --re-add for /dev/sdb2 to /dev/md127 is not possible
> >=20
> > You need a bitmap to --re-add.
>=20
> OK.
>=20
> > Without a bit map, you are just adding an unused device to an array and
> > "--add" is the command to use.
> > If you set up the mdadm policy (in mdadm.conf) suitably then
> >   mdadm -I /dev/sdb2
> >=20
> > would find the add and --add it for you (I think).
>=20
>=20
> [root@localhost ~]# mdadm -I /dev/sdb2
> mdadm: not adding /dev/sdb2 to active array (without --run) /dev/md/boot

That is why I said "set up the mdadm policy".

 "mdadm mdadm.conf", search for POLICY and particular "action=3D".

NeilBrown

> [root@localhost ~]# mdadm -I /dev/sdb2 --run /dev/md/boot
> mdadm: --incremental can only handle one device.
> [root@localhost ~]# mdadm --manage /dev/md127 --add /dev/sdb2
> mdadm: added /dev/sdb2
>=20
> /proc/mdstat
> md127 : active raid1 sdb2[2] sda2[0]
>       716224 blocks super 1.2 [2/2] [UU]
>=20
>=20
>=20
> Thanks,
>=20
> Chris Murphy

--Sig_/CRwKcGXjTIde.X9rqE7Q5Id
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU73gBTnsnt1WYoG5AQJy2BAAultMz8rodY01KKMuaQPjiZoag04xtjmx
fY6pM4p2HKS3aNfsOzPFTf3nJfYFumjmFVApNHAZOUPp582a1VGga15ViBKaP44/
WlmbhM+dGSzi3nWJwjExNgz8GmtoPoeiMqkjoHIcweMYr+CKFYxWGZv2YcybadWB
YvcfNLGKYa2ZSNLwOLaXTTBJt4uJlM44aj5xROchaWjAgxFN2jOzyGt+CfzHm2aD
jZg54I4G9gYgLktZnuDcRAPGEPLkPEAjf/zrO6PccNCmctbtuejI/GrzlCLAH8ub
SyS7fQCgxCEUrNQOAzkAz/7wuAJvsVgYtZwpGNY9jFU/ifjLgvElXtm40qh/DljW
ZIemLlzD7ND71m37qEJOMrcMDDANpNXePR4ppDvMy2g2/LZ9fb/InQgJyrqSUVdR
ZOxvrC2MhgevG0X4ERDBle639d8eoo/mpJYH5rpm+cmgUA48WOd8AYSwB4ITvFsH
InypoB0PYdK0kl3wSo7Q7mN4hHXZrt5hs3qQX3ir0OWjfvy0VMmy8X07jK6hDqw3
AwBHLYkgVcTouc1J0ZBrIYb9GPGzvPM/a0CgTIpR02XUvp08Dmxl5l07Y1rlqHxK
avJ+GIm4Qigk3jXGpEyd4DtFk5HVFmpxmvG0anvEeu8ypIuC+TTP3GqFSAEmyzB6
rGuUj9docSE=
=uhrw
-----END PGP SIGNATURE-----

--Sig_/CRwKcGXjTIde.X9rqE7Q5Id--
