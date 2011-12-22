From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --monitor as non-root ?
Date: Fri, 23 Dec 2011 07:55:04 +1100
Message-ID: <20111223075504.054b0383@notabene.brown>
References: <20111222132815.GA26042@rivendell.home.ouaza.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iqlHMNYnzslHX/f/qU9Jls0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111222132815.GA26042@rivendell.home.ouaza.com>
Sender: linux-raid-owner@vger.kernel.org
To: Raphael Hertzog <hertzog@debian.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iqlHMNYnzslHX/f/qU9Jls0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Dec 2011 14:28:15 +0100 Raphael Hertzog <hertzog@debian.org> wro=
te:

> Hello,
>=20
> I'm interested in having desktop notifications for change in the status
> of my RAID devices and I saw your comment here:
> http://neil.brown.name/blog/20090129234603-021
>=20
> Unfortunately that doesn't work well in practice. The monitoring program
> must be run from the user's session and apparently mdadm --monitor
> only works as root:
> $ mdadm --monitor --no-sharing --alert notify-send
> mdadm: must be super-user to perform this action
>=20
> Is there a way to let mdadm do the monitoring for us without requiring
> root rights?

That is reasonable.  The next release of mdadm (later today) will not impose
that limitation - patch below.

Unfortunately the kernel does impose a limitation.  I'll fix it for 3.3, but
until then you will need to apply the second patch below.


>=20
> Cheers,
>=20
> PS: Is there a better place for this kind of feature requests ? Feel
> free to forward this mail to record it there (should it exist).

Best place is linux-raid@vger.kernel.org (you don't need to subscribe).  I'=
ve
Cced this reply there.

Thanks,
NeilBrown



=46rom ba3903d416524e0fb002eca971ce6026e5f2c3af Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Fri, 23 Dec 2011 07:42:23 +1100
Subject: [PATCH] allow --monitor to be run by non-privileged use.

Providing --no-sharing is given, monitoring should be permitted.

Unfortunately the kernel current rejects GET_DISK_INFO and
GET_ARRAY_INFO for non-privileged users which is unjustified.
The info is available in sysfs and we could get it from there,
but for now, require the kernel to be fixed.

Reported-by: Raphael Hertzog <hertzog@debian.org>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/mdadm.c b/mdadm.c
index c6a887a..f07fac2 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1209,7 +1209,8 @@ int main(int argc, char *argv[])
 		require_homehost =3D 0;
 	}
=20
-	if ((mode !=3D MISC || devmode !=3D 'E') &&
+	if (!((mode =3D=3D MISC && devmode =3D=3D 'E')
+	      || (mode =3D=3D MONITOR && spare_sharing =3D=3D 0)) &&
 	    geteuid() !=3D 0) {
 		fprintf(stderr, Name ": must be super-user to perform this action\n");
 		exit(1);



=46rom b56ca899650a7ad4f40b2986086f411286e90c4a Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Fri, 23 Dec 2011 07:46:36 +1100
Subject: [PATCH] md: allow non-privileged uses to GET_*_INFO about raid
 arrays.

The info is already available in /proc/mdstat and /sys/block in
an accessible form so there is no point in putting a road-block in
the ioctl for information gathering.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9dfa2d1..87022b5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6129,8 +6129,15 @@ static int md_ioctl(struct block_device *bdev, fmode=
_t mode,
 	struct mddev *mddev =3D NULL;
 	int ro;
=20
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+	switch (cmd) {
+	case RAID_VERSION:
+	case GET_ARRAY_INFO:
+	case GET_DISK_INFO:
+		break;
+	default:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+	}
=20
 	/*
 	 * Commands dealing with the RAID driver but not any

--Sig_/iqlHMNYnzslHX/f/qU9Jls0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvOZKDnsnt1WYoG5AQJrbQ//Wa4MHlfyLmyia2/fxJiovb1/tiXt3ttU
6G8lGMnAFGMBydgaIz6vVHoJ/ZAhzQ1V682XmhhomCGLia4N8sSw+VsDAUwn4j/3
yeDXCa/I8YLKcT0gBdcucUgkbuEfbeXvTFJzRifApAjK1DFYinKCDsfAFSFFLgBe
UJBdJ1mbi2/ZTCv3TvHCa13apfUR+SjI6gFlwV995v4BYpYD8S/0jl/FKJHVEq/5
53equ2rm8hiGt1kurrcPTi4nifavaS52M7UZ0kazoywndSGpS8H0+Sz2dY+gkT+z
wBit53jxY7VZp+QagpUZOH1a1yjLFwNEZtQ9Nct7ctCwVna69+sEs8BP3o9rLWcH
Egr+5ZNeBiidIOFYBdt9pLMTahd58Anm7hXgv6UlWPZXf7OQ5QgphN2iOGPeMiuk
uKmGTi5jLE5IhU8JJtEik4/VjRwc52u+5QmrBoWLwK+0qPZJxkejy16Q+16xf3Dq
z9wgmwHdBsoeR7vzWrlsGZzg6M1T1USgkKWJTzX3zMqM9qCrMEb4nDl+21Yf6aUg
oUake3BswAu0x3MxhTTrD+2GeymoozRWWNteLNkd3UPUMn2jGRhjU+n2KoT1oSpY
EIr+CMbpjBPvKuXjWLOKRsWGlQmF3G1arDanvZygyjow7isCgXe15fiwpuO+ohhX
f0o9cvdVxuY=
=bDX3
-----END PGP SIGNATURE-----

--Sig_/iqlHMNYnzslHX/f/qU9Jls0--
