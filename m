From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5: failing an active component during spare rebuild -
 arrays hangs
Date: Tue, 6 Dec 2011 14:16:08 +1100
Message-ID: <20111206141608.0cca224a@notabene.brown>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
	<20110622125409.14428883@notabene.brown>
	<BANLkTinijekK8Y6TTk6TYtYhv4Dn2YGQbA@mail.gmail.com>
	<20110628122921.42480f72@notabene.brown>
	<CAGRgLy5uK5As96j2Tprfrx+qNhYqvFiVUEnOJ+3AAwpPMHCDYg@mail.gmail.com>
	<CAGRgLy5huVzdA8q6V887Ay384kJ4ywgst6dEGgYuRg9+SxHB0A@mail.gmail.com>
	<20110831124646.21be9e25@notabene.brown>
	<CAGRgLy62uavK+9qosizaOey1Utz6STC+2fvOVqEbmi0HZbrQtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WPdWqobpjA4DvMuWS+T/n04"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy62uavK+9qosizaOey1Utz6STC+2fvOVqEbmi0HZbrQtw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WPdWqobpjA4DvMuWS+T/n04
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Nov 2011 11:56:17 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> we have compiled the natty kernel with dynamic debugging enabled for
> raid456, and reproduced the problem.
> The kernel log is available at
> https://docs.google.com/open?id=3D0B9rmyUifdvMLMzk1YjYwZDUtYzhhYi00MDRlLT=
kzYjItMDM0Y2ZhZmU3ZDRk
>=20
> Some more information:
> - array was created at Nov 27 11:28:03
> - manual drive failure was issued at 11:28:09
>=20
> Please let me know if you need any additional information.
>=20

Hi,
 sorry for the long delay, I've had a lot of distractions this past week.

I looks like you are hitting the bug fixed by upstream commit
    355840e7a7e56bb2834fd3b0da64da5465f8aeaa

The symptoms are slightly different to those described in that commit but I=
'm
sure the root problem is the same.

That patch doesn't apply to 2.6.38 though.
Use this one.

NeilBrown

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 78536fd..8144126 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3086,7 +3086,7 @@ static void handle_stripe5(struct stripe_head *sh)
 			/* Not in-sync */;
 		else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
-		else {
+		else if (!test_bit(Faulty, &rdev->flags)) {
 			/* could be in-sync depending on recovery/reshape status */
 			if (sh->sector + STRIPE_SECTORS <=3D rdev->recovery_offset)
 				set_bit(R5_Insync, &dev->flags);
@@ -3377,7 +3377,7 @@ static void handle_stripe6(struct stripe_head *sh)
 			/* Not in-sync */;
 		else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
-		else {
+		else if (!test_bit(Faulty, &rdev->flags)) {
 			/* in sync if before recovery_offset */
 			if (sh->sector + STRIPE_SECTORS <=3D rdev->recovery_offset)
 				set_bit(R5_Insync, &dev->flags);

--Sig_/WPdWqobpjA4DvMuWS+T/n04
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt2I+Dnsnt1WYoG5AQJ1TA/+IqBPBHIBc5Jbiv7yhOZk1NEBZAk3bQxv
C1UlcHT+W7zeHMZwf1oKuXy3FIptjtamshhg7nDY3Z2WxLV1pGazxsUYcCcdK47A
C/q7kIqd1Xo6tN11xSJRMe0UIweqwEa79G83k70UctMYOIkOC61kQzL99+nUzsY2
Q6LUvSoCaKgl1H6qM1wAH5VDIj/sV1/dVNZ4GK4otpzyFZAk2E3j6CKQEMneudOd
WiH0q5zCt0uLdlPME/wBTgAGrzWSV39zm7xSOo1Laagy7vriRhkqxMJvmLD+dRYg
6zBcDzj2qqMKg9QA2RKIsy9ARDGG/vZqUSXxAXaOYfnNtGlDYR8dcbwB8hZTLttO
7neAVlzrS2geQ6bkTrUPNSmM1UtjsWaja7K7+dC2ML4TK/+D4+Jvvbwm4iV4WXCz
H8NXrFEZmVF+RIVzmtPh04MCNcsb9hzVu5d1V8kbKIC+UhJ4xQFTEWrBuc47IYn+
7LBoH34k/tWJ9HaVkKE8TBSC4KPavjQsjOGviZfpdbiBlzr6iKeQitc6QXKT/hMJ
1d9h8DnkWYnncGauaTFlYMEcpMTVR9dG835VQ2PuZJClwdIjJgzWqgcBnn8oO3Sq
nF6zrwh7tgCCyZffHsy++kMN1QKkEuvpYlzpSz8EspPxgkRdLrJO5jK1xW5qy+qB
wN4Zf+PVxf4=
=Fi7t
-----END PGP SIGNATURE-----

--Sig_/WPdWqobpjA4DvMuWS+T/n04--
