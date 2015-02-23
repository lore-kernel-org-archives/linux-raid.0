From: NeilBrown <neilb@suse.de>
Subject: Re: An old "write-mostly" read balance issue
Date: Mon, 23 Feb 2015 11:03:32 +1100
Message-ID: <20150223110332.4c135de9@notabene.brown>
References: <54D78357.7020808@yandex.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/k4SzwAz771ffVNa9zy1ty+8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D78357.7020808@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>
Cc: linux-raid@vger.kernel.org, tomas.hodek@volny.cz
List-Id: linux-raid.ids

--Sig_/k4SzwAz771ffVNa9zy1ty+8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 08 Feb 2015 18:40:07 +0300 Dark Penguin <darkpenguin@yandex.ru> wro=
te:

> There is an old issue about RAID1 read-balancing when "write-mostly"=20
> disks are present.
>=20
> The problem is, according to the manual, "md driver will avoid reading=20
> from these devices if at all possible".
>=20
> One way to understand this statement is that these drives will never be=20
> read from, except when the main drive can not be read from. There are A=20
> LOT of situations when this is the expected and desired behaviour:
> - People mirroring an SSD with an HDD and suffering a performance loss;
> - People mirroring a fast HDD with a slow HDD for reliability, for=20
> example, mirroring a 300Gb WD Raptor to a 300Gb partition on a 3Tb 5900=20
> "green" drive for backup; since the larger drive may be used for=20
> something other than this RAID, many would prefer it to be spared the=20
> workload.
> - In my case, I have a home RAID1 storage, which is idle 95% of the=20
> time, and 95% of the remaining 5% I only read from it. So I want one of=20
> the drives to spin down and never turn on, in order to avoid wearing=20
> down the mechanics. They say, "The best way to keep a device from=20
> breaking is to turn it off and not use it". :) But even if I simply=20
> retrieve the contents of my volume, that request is apparently enough to=
=20
> load the first drive to 100% for a split second, which causes the second=
=20
> drive to spin up, which is extremely undesirable.
>=20
> I've spent a lot of time looking for the answer "why does it spin up",=20
> and "normal forum users" couldn not even help me, but then I found out=20
> that there is another way to read that statement: apparently, there are=20
> other people who would like to see whatever little benefit reading from=20
> the second drive could give them. I can not say which side is a=20
> majority, but I respect their wishes as well, and personally I'm fine=20
> with any default behaviour as long as I have what I need.
>=20
> I've found a patch for that:
> http://marc.info/?l=3Dlinux-raid&m=3D135982797322422
> Apparently, it can be used with any kernel, but I'm not good enough to=20
> make sure nothing's broken everytime I upgrade the kernel, and frankly,=20
> I think there are A LOT of people who wish to see the behaviour I would=20
> expect. So my plea is for the developers to accept this patch and make=20
> this behaviour optional, if not default. At least give us a compile=20
> option to build the kernel this way! There are people out there who use=20
> RAID1 at home and not in production, and therefore care less about=20
> performance than home storage idling, and who understand the words "if=20
> at all possible" in the more obvious way! I think that's the whole=20
> reason why the "write-mostly" option is there in the first place, but if=
=20
> there are people who don't agree with me - I'm not going to argue, they=20
> can have it their way, just give us the option to do what we want, too!
>=20
>=20

Hi,
 thanks for reporting this.  It is definitely a bug.  It was introduced by=
=20

commit 9dedf60313fa4dddfd5b9b226a0ef12a512bf9dc
    md/raid1: read balance chooses idlest disk for SSD


 I don't recall seeing the patch from Tomas Hodek which you provided a link
for  - sorry Tomas.

I prefer the second of the two patches.  I will submit the following to Lin=
us
some time this week.

Thanks for pursuing this Dark Penguin.

NeilBrown

From: Tomas Hodek <tomas.hodek@volny.cz>
Date: Mon, 23 Feb 2015 11:00:38 +1100
Subject: [PATCH] Subject: md/raid1: fix read balance when a drive is
 write-mostly.

When a drive is marked write-mostly it should only be the
target of reads if there is no other option.

This behaviour was broken by

commit 9dedf60313fa4dddfd5b9b226a0ef12a512bf9dc
    md/raid1: read balance chooses idlest disk for SSD

which causes a write-mostly device to be *preferred* is some cases.

Restore correct behaviour by checking and setting
best_dist_disk and best_pending_disk rather than best_disk.

We only need to test one of these as they are both changed
from -1 or >=3D0 at the same time.

As we leave min_pending and best_dist unchanged, any non-write-mostly
device will appear better than the write-mostly device.

Reported-by: tomas.hodek@volny.cz
Reported-by: Dark Penguin <darkpenguin@yandex.ru>
Signed-off-by: NeilBrown <neilb@suse.de>
Link: http://marc.info/?l=3Dlinux-raid&m=3D135982797322422
Fixes: 9dedf60313fa4dddfd5b9b226a0ef12a512bf9dc
Cc: stable@vger.kernel.org (3.6+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0b6349f9c5c5..7742e0999bf2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -560,7 +560,7 @@ static int read_balance(struct r1conf *conf, struct r1b=
io *r1_bio, int *max_sect
 		if (test_bit(WriteMostly, &rdev->flags)) {
 			/* Don't balance among write-mostly, just
 			 * use the first as a last resort */
-			if (best_disk < 0) {
+			if (best_dist_disk < 0) {
 				if (is_badblock(rdev, this_sector, sectors,
 						&first_bad, &bad_sectors)) {
 					if (first_bad < this_sector)
@@ -569,7 +569,8 @@ static int read_balance(struct r1conf *conf, struct r1b=
io *r1_bio, int *max_sect
 					best_good_sectors =3D first_bad - this_sector;
 				} else
 					best_good_sectors =3D sectors;
-				best_disk =3D disk;
+				best_dist_disk =3D disk;
+				best_pending_disk =3D disk;
 			}
 			continue;
 		}

--Sig_/k4SzwAz771ffVNa9zy1ty+8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOpuVDnsnt1WYoG5AQJH0Q/8C5vc9+lRyXtPAcCKS2m9qKfGfCJaQ/g3
hCXXoFZIyCCuGjfEUeyVKHh2T6/vyhrJzzm+M7ea59arHeEiZimbnHErUZYLPS0H
LiWHMg575QbC53aNuAAV1IbH9vlELYuEcJl2MeeYI3V2riIb8mFeRfwAtuuO4CCX
zDO7YqUGpuKtC7qEBYILxft/qjiAwa7YnZ+UyB1oBhtTuEOFdSLAZ4kcblP1ktGv
JojbeFwkKHYktaKUtKkUudXBr1Qgp226tPoP2Pf1R4Uq8iS9v2mY6yE0lIwEf8Rp
MkbjsGEd9biLDLaZQXIoZ9oXPQz5/qPrJOPEW06b5bJ8LmBoUXaNR1DhgXIy+obY
ZaPGxPGAriREC1y/1dBl9mF5Q7b+dK2XstAhLJ2LiyVgYpeYivBhQh3Q51LcKVIL
5LSKvsiPUfOC3RUtV3BpIDKq/WQupPLlyNtYfRWAo8wpYSVDXRr9YhUrxhobHXyA
dQ0vBmd6TcKn7MNinvbX6EAkzDEK/QZCi30UiTaoMKSlB0whBf9eb21GKZ0/QYJ8
IkaCM33XqPWb/f21w/pcJNDIEFfJTsi0Olv0PmZ+wCqxhEmHujx0AZuaqfQ/YIIL
uUXpCALKKlRTcuDCa9bf+V40oPl12Wt2DrguhYRuKwji7F0J3K4rvfmYqYGOsRJL
YoSQGVzBZrY=
=NNJX
-----END PGP SIGNATURE-----

--Sig_/k4SzwAz771ffVNa9zy1ty+8--
