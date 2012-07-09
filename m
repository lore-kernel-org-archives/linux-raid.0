From: NeilBrown <neilb@suse.de>
Subject: Re: Raid1 resync problem with leap seconds ?
Date: Mon, 9 Jul 2012 11:35:28 +1000
Message-ID: <20120709113528.2c7de8e6@notabene.brown>
References: <4FF6DB2B.1090905@gmx.net>
	<20120709110956.0a66d577@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MJSyHgP_AqPIqRN5brmefds"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120709110956.0a66d577@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Arnold Schulz <arnysch@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/MJSyHgP_AqPIqRN5brmefds
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jul 2012 11:09:56 +1000 NeilBrown <neilb@suse.de> wrote:

> On Fri, 06 Jul 2012 14:33:47 +0200 Arnold Schulz <arnysch@gmx.net> wrote:
>=20
> > Hi all,
> >=20
> > about 8 seconds after inserting the leap second, a running raid1
> > resync crashed.
>=20
> Thanks for the report.
>=20
> I think you mean "8 minutes" (though it was really 7 minutes and 12 secon=
ds).
>=20
> Also it was a 'data-check' rather than a 'resync' :-)
>=20
> It is extremely unlikely that the two are related.
>=20
> There appears to be a use-after-free bug in the data-check code which you
> have manage to hit.  It has been there since 2006 (2.6.16) when data-chec=
k was
> added to raid1, and you are the first known victim.  Well done!
>=20
> I'll submit a patch shortly.
>=20

Below is that patch I'll be submitting, once it has been in -next for a day
or two.

Thanks,
NeilBrown


=46rom 2d4f4f3384d4ef4f7c571448e803a1ce721113d5 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 9 Jul 2012 11:34:13 +1000
Subject: [PATCH] md/raid1: fix use-after-free bug in RAID1 data-check code.

This bug has been present ever since data-check was introduce
in 2.6.16.  However it would only fire if a data-check were
done on a degraded array, which was only possible if the array
has 3 or more devices.  This is certainly possible, but is quite
uncommon.

Since hot-replace was added in 3.3 it can happen more often as
the same condition can arise if not all possible replacements are
present.

The problem is that as soon as we submit the last read request, the
'r1_bio' structure could be freed at any time, so we really should
stop looking at it.  If the last device is being read from we will
stop looking at it.  However if the last device is not due to be read
from, we will still check the bio pointer in the r1_bio, but the
r1_bio might already be free.

So use the read_targets counter to make sure we stop looking for bios
to submit as soon as we have submitted them all.

This fix is suitable for any -stable kernel since 2.6.16.

Cc: stable@vger.kernel.org
Reported-by: Arnold Schulz <arnysch@gmx.net>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8c2754f..240ff31 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2485,9 +2485,10 @@ static sector_t sync_request(struct mddev *mddev, se=
ctor_t sector_nr, int *skipp
 	 */
 	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		atomic_set(&r1_bio->remaining, read_targets);
-		for (i =3D 0; i < conf->raid_disks * 2; i++) {
+		for (i =3D 0; i < conf->raid_disks * 2 && read_targets; i++) {
 			bio =3D r1_bio->bios[i];
 			if (bio->bi_end_io =3D=3D end_sync_read) {
+				read_targets--;
 				md_sync_acct(bio->bi_bdev, nr_sectors);
 				generic_make_request(bio);
 			}

--Sig_/MJSyHgP_AqPIqRN5brmefds
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/o1YDnsnt1WYoG5AQJiVRAApLxRNVcwnKkGSthYYeUqA2sqGfBraGBr
w/XR4PQdI11JyQtr+nS/ZYExSHbmWEGdkBlfpY9LRzJDOB9lA02XprpLIkRqeyTz
jI3yOU67hZ3NSE+a8IG61KAmagnPctuP9Fym3U9EyXDIJdtbin2w+a5pppHV05jC
ivy69Pe48tRnzXSCgZj7x9IyB9DxL8gdz8ngCFEGJoBcCWWoiYAisWOMhzADpH3f
1krbid+dRbKncRbIVQbQbaqyd08WsPNZ1LsAH78jkTGTZejavHUoDZykg4VAr2Lz
Wkf+t51fd9rLqvLblHx+kWGGd2i/iYApABxTqt8Sc2WrXVW4du1EB5/q6OfKvP6G
cvApRItXtHbDeaAR8AqqE6u0m1jbgbg31cV+vLasFq3zKL++DHEBsRzfcCpPClh2
YxKgjlnOF6y5r0wpWVpIoCHtONBJ+HPgplTgJRT6t72NrNFjhZTeBhtbnFcD7BpQ
QWSnUHcf0h+IYs+hkr5nQL35y0920JsKs44byjzSWAGbxXUYe+yvJsIalEG35cxC
3kI7Hz+cjKOpTIwmPyvbk3aR5UGG9sffCgfolBVUxGB9z3anWcRzyTlbetAGcbID
CE431bAoCwrxUkjdIsXk8TEfy54Otrvn/VN1tFc8jrwRFqJVKOeY2vcjIdI5HN99
g99siTFto/o=
=2SaX
-----END PGP SIGNATURE-----

--Sig_/MJSyHgP_AqPIqRN5brmefds--
