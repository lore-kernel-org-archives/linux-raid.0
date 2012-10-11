From: NeilBrown <neilb@suse.de>
Subject: Re: Assemble-Resize-Stop loop doesn't work correctly
Date: Thu, 11 Oct 2012 11:42:30 +1100
Message-ID: <20121011114230.54fa9c5a@notabene.brown>
References: <50744987.8010903@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zfjWdrb3TlM1UB6Jbq3d+pt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50744987.8010903@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/zfjWdrb3TlM1UB6Jbq3d+pt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 09 Oct 2012 17:57:59 +0200 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> Hi Neil,
>=20
> I've tested with the following script grow with "--assume-clean" in a
> loop. The first grow succeeds - following grows fail - mdadm 3.2.5,
> kernel 3.4.10.
>=20
>=20
> #!/bin/bash
>=20
> FIRST=3D"/dev/sda"
> SECON=3D"/dev/sdd"
> MDDEV=3D"/dev/md0"
> SIZE=3D1
>=20
> mdadm --zero-superblock $FIRST
> mdadm --zero-superblock $SECON
> echo y | mdadm -C $MDDEV -e 1.2 \
> --assume-clean -z "${SIZE}G" --force -l 1 -n 2 $FIRST $SECON
> sleep 3
> mdadm -S $MDDEV
> for ((i=3D0; i<4; i++)); do
>   mdadm -A $MDDEV $FIRST $SECON
>   let "SIZE++"
>   mdadm -G $MDDEV -z ${SIZE}G --assume-clean
>   cat /proc/mdstat
> #  mdadm -D $MDDEV > /dev/null
>   mdadm -S $MDDEV
> done
>=20
>=20
> Output looks like this:
>=20
> mdadm: /dev/md0 has been started with 2 drives.
> mdadm: component size of /dev/md0 has been set to 2097152K
> Personalities : [raid1]
> md0 : active raid1 sda[0] sdd[1]
>       2097152 blocks super 1.2 [2/2] [UU]
>     =20
> unused devices: <none>
> mdadm: stopped /dev/md0
> mdadm: /dev/md0 has been started with 2 drives.
> mdadm: /dev/md0 is performing resync/recovery and cannot be reshaped
> Personalities : [raid1]
> md0 : active raid1 sda[0] sdd[1]
>       2097152 blocks super 1.2 [2/2] [UU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..........]  resync =3D 50.0% (1050=
624/2097152)
> finish=3D8.4min speed=3D2048K/sec
>=20
>=20
> Now the output with "Detail"-Mode after resize:
>=20
> mdadm: /dev/md0 has been started with 2 drives.
> mdadm: component size of /dev/md0 has been set to 2097152K
> Personalities : [raid1]
> md0 : active raid1 sda[0] sdd[1]
>       2097152 blocks super 1.2 [2/2] [UU]
>     =20
> unused devices: <none>
> mdadm: stopped /dev/md0
> mdadm: /dev/md0 has been started with 2 drives.
> mdadm: component size of /dev/md0 has been set to 3145728K
> Personalities : [raid1]
> md0 : active raid1 sda[0] sdd[1]
>       3145728 blocks super 1.2 [2/2] [UU]
>=20
>=20
> This one works. Is this wanted behaviour?
>=20
> Cheers,
> Sebastian


You've hit an unlikely corner-case there.  Thanks.

This patch fixes it.

NeilBrown

=46rom 2225a657ce9fb4a5390a4a82c03e6a0f937b4327 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 11 Oct 2012 11:41:14 +1100
Subject: [PATCH] md: make sure manual changes to recovery checkpoint are
 saved.

If you make an array bigger but suppress resync of the new region with
  mdadm --grow /dev/mdX --size=3Dmax --assume-clean

then stop the array before anything is written to it, the effect of
the "--assume-clean" is lost and the array will resync the new space
when restarted.
So ensure that we update the metadata in the case.

Reported-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e868f0c..dff013a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3819,6 +3819,8 @@ resync_start_store(struct mddev *mddev, const char *b=
uf, size_t len)
 		return -EINVAL;
=20
 	mddev->recovery_cp =3D n;
+	if (mddev->pers)
+		set_bit(MD_CHANGE_CLEAN, &mddev->flags);
 	return len;
 }
 static struct md_sysfs_entry md_resync_start =3D

--Sig_/zfjWdrb3TlM1UB6Jbq3d+pt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHYV9jnsnt1WYoG5AQII3hAAhsjiM7b+dIU18SZQt9ox2WgOkk35Umpq
JthBlddpNt+AroOrwFff+IjF81tdwzVIwSpLWpbgq4PRXudT2e/EYDh1jZfULao5
/FZW33Od2j8fZjggNW+BiVorjWcSLbmyDWEh1vLT+xJ5v2xusMEgYlGkXSLzDLAp
YAnRsu1MF1Z3ogrjCcHIlSEj+H97PbWqRqaYC2aC/3urciEvIw1utdk9JEo+K2kA
IoRXVMy2TnE999NVcXVo9mm9LnzlrSIE/3btMS1fkbcvOKku7U5prGAljJ85HEjj
JKZMpduHxnIvPMYudPzY/g7U0pq+6KfBGmU1GrPPmoONxiB4mx9psTmhPhD+Ouo4
0Y268WK9jmPqeWRxQWGBJmGS9NSVqHEx2ofLWpfByGZAC+gopG5XcEs6MGPMbb05
MaFjVUEVHFMIbGLuNNboDPVi3gg0X3mSv92AL9qjp/QwjsJAup1OSsAjtOGlYwmj
yUemyayX0gk1mGtMlA768s2nqeMWHXL41XGxOZiKrHDdKnhjJMea3cWSPbE0pyWp
rbIfCNajdnHYUtIuSfzkn9tItIjZE63JynkVCfxGG2lbZpFi8yjbDbXSDQXN3CmD
mj2USP86mBU7R0+SKLhyjY4XcGWbyeTS4bcCjJl6qdkiqgWmLZJHERhhDWyM8Jrq
JuPb7xRktj8=
=nPPL
-----END PGP SIGNATURE-----

--Sig_/zfjWdrb3TlM1UB6Jbq3d+pt--
