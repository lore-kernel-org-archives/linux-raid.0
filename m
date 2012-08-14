From: NeilBrown <neilb@suse.de>
Subject: Re: Error in rebuild of two "layered" md devices in container
Date: Wed, 15 Aug 2012 09:43:52 +1000
Message-ID: <20120815094352.38550670@notabene.brown>
References: <CAGkViCEBCMgPXbByGPe8MgTKsSkn1Dc=_XLgCCDCfSrEGwEs_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZMTXEezYOxTDmd3TcOfg+2M"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGkViCEBCMgPXbByGPe8MgTKsSkn1Dc=_XLgCCDCfSrEGwEs_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ZMTXEezYOxTDmd3TcOfg+2M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Aug 2012 19:52:51 +0200 Albert Pauw <albert.pauw@gmail.com> wrote:

> Hi Neil,
>=20
> found another bug.
>=20
> - Created a container with six disks
> - Created two md devices in it:
>=20
> mdadm -CR /dev/md0 -l 6 -n 6 -z 50M
> mdadm -CR /dev/md1 -l 5 -n 6 -z 50M
>=20
> The md devices are "layered" in the container across all disks.
>=20
> They both get build and are online.
>=20
> - Fail one disk, both md devices are affected
> - Remove disk
> - Clear superblock of removed disk
> - Add disk again (in essence, I just added a spare disk)
>=20
> Now comes the error:
>=20
> - md0 is rebuild
> - md1 is NOT rebuild

The reason for this is somewhat messy.
mdadm will currently only add a 'spare' device to an array which needs a
replacement device.
In DDF the whole device is either 'active' or 'spare'.  There isn't a conce=
pt
of 'partly active, partly spare'.
So when mdadm adds part of the disk to one array it stops being spare and
started being active.  So when mdadm looks for a spare to add to the second
array, there are no spare devices.

I can hack around it by allowing any non-failed device to be considered as a
spare but I need to find a better solution.  That might take a while.  I've
made a note on my to-do list, but it is a rather long list.

Thanks,
NeilBrown

diff --git a/super-ddf.c b/super-ddf.c
index d006a04..11b98f7 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2616,7 +2616,7 @@ static int validate_geometry_ddf(struct supertype *st,
 	if (chunk && *chunk =3D=3D UnSet)
 		*chunk =3D DEFAULT_CHUNK;
=20
-
+	if (level =3D=3D -1000000) level =3D LEVEL_CONTAINER;
 	if (level =3D=3D LEVEL_CONTAINER) {
 		/* Must be a fresh device to add to a container */
 		return validate_geometry_ddf_container(st, level, layout,
@@ -3701,6 +3701,10 @@ static struct mdinfo *ddf_activate_spare(struct acti=
ve_array *a,
 			} else if (ddf->phys->entries[dl->pdnum].type &
 				   __cpu_to_be16(DDF_Global_Spare)) {
 				is_global =3D 1;
+			} else if (!(ddf->phys->entries[dl->pdnum].state &
+				     __cpu_to_be16(DDF_Failed))) {
+				/* we can possibly use some of this */
+				is_global =3D 1;
 			}
 			if ( ! (is_dedicated ||
 				(is_global && global_ok))) {

--Sig_/ZMTXEezYOxTDmd3TcOfg+2M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCriuDnsnt1WYoG5AQKALA//br3KMtwhY8Y/QLnIjDBPHetOeXN+Nc6T
k9LQ2evXqenurRneuReWt/mVNNKufPBDzNI86uQzufWeoAEYzxyVChnD2noIgk+B
e2pc0VDmBlFVd2nK9BdpmUydCXe0+Y0YZU9dCdHSmGrNfA4grRu+HLGcTh4bhrz0
bblccJRftIHkrriL0jmLO6d6bcj+SGWEXojIDQgqEj7bgO0vtq8CvJ1TyMXEG3m5
3QmKZucB3dNVXDEvsHCBBNo0K7isv0h4lV+yXykRxbkR7zg2FdR2vaPVmX1wL9+g
UNaIpRy3LmeH9h0psFPCBYWXzKVDybfIUhDVzu9aJPGiOhm7g9et7tDu0InMjPpD
XuKRrCId6Ab2Fx2trZV9v7Z2IEbieHDMj9HZeFWOJ6T1a6e0EXmLtTsCbTLnA+OK
40MbIt7vwMWB0/n/sOo6PY18XruxP9slxKBUPtuDHu1gI07EZJTjfYr/IvIhwiCn
jN5Enr1njV3PQNdKT2AfLz/H9oZ4M30W8dOjohngWTIq8IpAX6/b6VdxE+USB6n+
gKffxtKH1xJVKNe05PAuGWCwLCxGkc5dnmGNrWKJRUT6qmII74N/XMjytYHJJAs1
yzF2MbHazQ/+Ch9aIc/UVudVBxqyozI9gxogjiN7bM/JWZtJKFpgsuvXVVXhNsUW
RU7D0W+ZaE0=
=PLx9
-----END PGP SIGNATURE-----

--Sig_/ZMTXEezYOxTDmd3TcOfg+2M--
