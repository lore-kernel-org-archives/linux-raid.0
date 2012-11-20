From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --wait returns while array under construction?
Date: Wed, 21 Nov 2012 08:43:57 +1100
Message-ID: <20121121084357.41f2f9d9@notabene.brown>
References: <1353434141.27671.13.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mjcKw5fwzAkDTdgdRqkGlMS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353434141.27671.13.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mjcKw5fwzAkDTdgdRqkGlMS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Nov 2012 09:55:41 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrot=
e:

> While switching the disks a RAID 1 is based on I used the --wait command
> to wait for the rebuild to finish.  It returned immediately, but a
> subsequent query showed it had not been rebuilt.  Have I misunderstood
> something, or is this an error?
>=20
> While doing these commands a much larger rebuild was going on with a
> different array, involving some of the same physical disks but different
> partitions.  The partitions being rebuilt are on different physical
> disks for the different arrays.
>=20
> Here are the logs, with version info at the end (Debian Lenny + more
> recent kernel):
....

> markov:~# uname -a
> Linux markov 2.6.32-5-amd64 #1 SMP Wed Jan 12 03:40:32 UTC 2011 x86_64 GN=
U/Linux
> markov:~# mdadm --version
> mdadm - v2.6.7.2 - 14th November 2008
>=20
>=20
> I notice that in this case, unlike the other array, the message during
> the rebuild (the last detail report) does not include a line like
> Rebuild Status : 0% complete
>=20
> I just tried --wait again to see if there was some kind of race, but
> once again it returned immediately, though detail says the spare is
> rebuilding.

Can you test this patch to see if it fixes the problem?

diff --git a/Monitor.c b/Monitor.c
index c4d57c3..a5e7aaa 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -973,7 +973,7 @@ int Wait(char *dev)
 			if (e->devnum =3D=3D devnum)
 				break;
=20
-		if (!e || e->percent < 0) {
+		if (!e || e->percent =3D=3D RESYNC_NONE) {
 			if (e && e->metadata_version &&
 			    strncmp(e->metadata_version, "external:", 9) =3D=3D 0) {
 				if (is_subarray(&e->metadata_version[9]))


NeilBrown

--Sig_/mjcKw5fwzAkDTdgdRqkGlMS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKv5njnsnt1WYoG5AQLX6w/9GdD9vQcKPyd3abEuOXR7uejVpebnlGTJ
zVXk/NcKw8dY5NBRUQD2DBwMae1t+xzjwu6Yn/KZtJu+8F/QxPOkDR9k64CpIs2N
fDYK1ka8M9yEO4lZtc7LhGqTV3OotOpYz/Dqn+1oJPAJ6iRNDP4uYGDbBbj6VdTP
9c9RcwTTMDCLN/r/sF43STj5iMDoSr8KQXROwZuwg2tKXrCpM00zwoGFThIc02l+
bwt/eJHLgzH88WIbtnubdYSK1wgtxwIuxUR17jCi/ItYWL0fA8rGBnJjLZvLgeec
DS7ynBn0RgNXZ30DYuGlzwJMPnauCstJZ54unnPi0u5n6tOtqwJIFRfE94schTgt
iqq+5tu7+HE7K0+lD7tXjAimiTezGjFhFnSFeLZx6OHqSaSN2V3IF+fNoocgwDow
PmxsA6ki5a+QPsX8B67ZFpVlt47PBEoWwYTQdoM9j1bl75HHaDXdQeJH5mxog0Gm
LgsF3iLIKlXn+N71PqNzFTlQGzKJqFkqNroQLZ7EL+qkMgfGVOHAP1R8PkSfCGW/
R8aN6ioY6uWVPjoVqF+9yf34g1haoiTTJ0denEA00WHQZghogcjC1koOSPqN4Znu
RxeTYbFgnpY7FIOf/4umqSOVHJTV7ScCxQCXgboNb7YyNaNmpDhVrL2Z8AVWSQSo
bRTd5dTfWF4=
=YgwC
-----END PGP SIGNATURE-----

--Sig_/mjcKw5fwzAkDTdgdRqkGlMS--
