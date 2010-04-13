From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Tue, 13 Apr 2010 14:49:38 -0400
Message-ID: <4BC4BCC2.7040605@redhat.com>
References: <4BBA1289.4010705@redhat.com>	<20100407113035.3ca437f2@notabene.brown>	<4BBBE7D2.6090608@redhat.com>	<20100409093153.690ea963@notabene.brown> <20100409103330.37d9dff5@notabene.brown> <4BC43938.2020109@unart.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig422A0FC682924AFB9BD6EAD8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BC43938.2020109@unart.cz>
Sender: linux-raid-owner@vger.kernel.org
To: =?windows-1252?Q?Tom=E1=9A_Dul=EDk?= <dulik@unart.cz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig422A0FC682924AFB9BD6EAD8
Content-Type: multipart/mixed;
 boundary="------------040900050401050104050600"

This is a multi-part message in MIME format.
--------------040900050401050104050600
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/13/2010 05:28 AM, Tom=E1=9A Dul=EDk wrote:
> Hi Doug,
>=20
> first of all: thanks for your work on hot-unplug!
> I am new to Linux RAID, have been using HW RAID before but after my LSI=

> controller burned to ashes I decided I don't want to see HW RAID ... ev=
er.
>=20
> First thing I found weird on Linux RAID was the missing support for dea=
d
> device removal.
> I spent last 3 weeks trying to write various scripts for UDEV "remove"
> and mdadm "Fail" events handling, but finally I found the same thing
> like you - it is not possible to remove dead device from an array,
> because the events are issued too late. The only way to remove dead
> device is reboot, which is not what I would expect as solution in Linux=

> world.
>=20
> So I downloaded your code from Neil's git
> (http://neil.brown.name/git?p=3Dmdadm;a=3Dshortlog;h=3Drefs/heads/hotun=
plug)
> and also applied the "Minor incremental fixup" mentioned in your messag=
e
> below.
>=20
> The compiled mdadm works OK for normal operations (--fail, --remove,
> --add), but crashes with Segmentation fault for the "--incremental
> --fail" operation if I use it for a disk that I have just disconnected.=

> Here is what I've got:
>=20
> # gdb --args ./mdadm -If sda3
> GNU gdb 6.8-debian
> This GDB was configured as "x86_64-linux-gnu"...
> (gdb) run
> Starting program: /root/mdadm-git/mdadm/mdadm -If sda3
> Program received signal SIGSEGV, Segmentation fault.
> 0x000000000040a796 in mdstat_by_component (name=3D0x7fff0d0aee83 "sda3"=
)
> at mdstat.c:351
> 351                     if (ent->metadata_version &&
> (gdb) where
> #0  0x000000000040a796 in mdstat_by_component (name=3D0x7fff0d0aee83
> "sda3") at mdstat.c:351
> #1  0x000000000042411c in IncrementalRemove (devname=3D0x7fff0d0aee83
> "sda3", verbose=3D0) at Incremental.c:867
> #2  0x00000000004075a7 in main (argc=3D3, argv=3D0x7fff0d0ad698) at
> mdadm.c:1545
>=20
> It does not matter if I use sda3 or sda, the result is the same.
> What am I doing wrong?

There was a thinko in Neil's patch that is fixed with the attached patch.=


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------040900050401050104050600
Content-Type: text/plain;
 name="0001-hotunplug-we-are-testing-mdstat-not-ent-which-is-und.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-hotunplug-we-are-testing-mdstat-not-ent-which-is-und.pa";
 filename*1="tch"

=46rom b937950110190ce00f16d91a3423a66fde080a95 Mon Sep 17 00:00:00 2001
From: Doug Ledford <dledford@redhat.com>
Date: Tue, 13 Apr 2010 13:12:59 -0400
Subject: [PATCH 1/4] [hotunplug] we are testing mdstat, not ent which is =
undefined at this
 point

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 mdstat.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index 58d349d..3bb74fa 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -348,9 +348,9 @@ struct mdstat_ent *mdstat_by_component(char *name)
 	while (mdstat) {
 		struct dev_member *m;
 		struct mdstat_ent *ent;
-		if (ent->metadata_version &&
-		    strncmp(ent->metadata_version, "external:", 9) =3D=3D 0	 &&
-		    is_subarray(ent->metadata_version+9))
+		if (mdstat->metadata_version &&
+		    strncmp(mdstat->metadata_version, "external:", 9) =3D=3D 0 &&
+		    is_subarray(mdstat->metadata_version+9))
 			/* don't return subarrays, only containers */
 			;
 		else for (m =3D mdstat->members; m; m =3D m->next) {
--=20
1.6.6.1


--------------040900050401050104050600--

--------------enig422A0FC682924AFB9BD6EAD8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvEvMIACgkQg6WylM+/8ZRKXwCeL9HJNDqbsmkOzNn+n0+QUVyZ
FYwAn3tLxG+UzlKbaj1m871d9Bg3dS8E
=6vaA
-----END PGP SIGNATURE-----

--------------enig422A0FC682924AFB9BD6EAD8--
