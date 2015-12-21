From: NeilBrown <neilb@suse.com>
Subject: Re: Problem w/ commit ac8fa4196d20 on older, slower hardware
Date: Mon, 21 Dec 2015 11:43:40 +1100
Message-ID: <87io3s637n.fsf@notabene.neil.brown.name>
References: <87twq0527k.fsf@notabene.neil.brown.name> <56451299.6090107@gentoo.org> <20151113000306.GA3563@EIS>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151113000306.GA3563@EIS>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Joshua Kinard <kumba@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13 2015, Andreas Klauer wrote:

> On Thu, Nov 12, 2015 at 05:28:41PM -0500, Joshua Kinard wrote:
>> running MD RAID5 and the XFS filesystem.  I have /, /home, /usr, /var,
>> and /tmp on separate partitions, each a RAID5 setup.
>
> Hi, sorry for butting in,
>
> I have the same issue, on a regular consumer Haswell i5 box,=20
> with a setup very very similar to yours:
>
> 7x2TB disks, multiple partitions, for each: RAID-5, LUKS, LVM, XFS.
>
> The issue occurs during regular RAID check which I run daily=20
> (different partition/RAID each day, so it's more like a=20
> evenly distributed weekly check).
>
> I have an application that uses `find -size +100M` on a directory=20
> tree with ~3k subdirs and ~6k files in total. It doesn't do anything=20
> with the find result, it's purely informal. So no big data involved,=20
> even though the files themselves aren't small.
>
> Yet, it's slooow. The following tests were on a completely idle box,=20
> apart from a running RAID check on the same /dev/mdX device.
>
> Kernel 4.2.3, unpatched:
>
> real	0m53.555s
> user	0m0.013s
> sys	0m0.037s
>
> real	1m3.777s
> user	0m0.013s
> sys	0m0.037s
>
> real	1m3.453s
> user	0m0.014s
> sys	0m0.036s
>
> Kernel 4.2.3, reverted ac8fa4196d20:
>
> real	0m3.206s
> user	0m0.010s
> sys	0m0.030s
>
> real	0m0.450s
> user	0m0.003s
> sys	0m0.014s
>
> real	0m0.375s
> user	0m0.003s
> sys	0m0.012s
>
> I did echo 3 > /proc/sys/vm/drop_caches between each find.=20
> For some reason, subsequent calls in the reverted kernel are=20
> considerably faster regardless. In the original kernel it=20
> stays slow... if I don't drop_caches, the time is 0.006s.
>
> I don't normally reboot (while a RAID sync or check is=20
> running) but while switching between kernels I noticed=20
> the shutdown was very slow also in the original kernel.
>
> Are small requests getting delayed a lot or something?

Thanks for all the details and sorry for the delay.

Are (either of) you able to test with this small incremental patch?

When the md resync notices there is other IO pending, the old code would
cause the resync to wait at least 500msec and possibly longer to get the
overall resync speed below a threshold.
Having the threshold fixed doesn't make sense when devices have such a
wide range of speeds.

The problem patch changes it to only wait until pending resync requests
have finished.  These means the wait is proportional to the speed of the
devices, which makes more sense.  The hope was that this would allow
quite a few regular IO request to slip in the gap between resync requests
so that regular IO would proceed reasonably quickly.  Sometimes that
worked, but obviously not for you.

This patch adds an extra delay, still proportional to the speed of the
devices, but with (hopefully) a lot more room for regular IO requests to
get queued and handled.

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c0c3e6dec248..8a25cf6087ed 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8070,8 +8070,10 @@ void md_do_sync(struct md_thread *thread)
 				 * Give other IO more of a chance.
 				 * The faster the devices, the less we wait.
 				 */
+				unsigned long start =3D jiffies;
 				wait_event(mddev->recovery_wait,
 					   !atomic_read(&mddev->recovery_active));
+				msleep(jiffies_to_msecs(jiffies - start));
 			}
 		}
 	}

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd0s8AAoJEDnsnt1WYoG5NKsP/2ikqdugeTilnSWZ4iGZNn7g
dHh4W1v9gRlPMp6syOkNpe74keCWQJciKhGCc52hbxcTrhm/aNpKSkNWTos5agMa
aSk6SxJoR8QMebRSdAPbfnS7thZ6aE6mkjdBEgNeL7lrarj8YcUtkZJH5TsVfOfc
fwymzRmPd4twGBKGcdYwo/CpdKkYgAOVUIv2XO09mymU601BBUd1nzFMqohWxLQS
LbOYmDiG9DMi7BArk+go3RKpnugH4mf/D7iiNxQJt7F3TSn5ATD4SkOP9IQQM++1
Q1CeDeG0y6Gi0RpNJ/NqZ0eNNCqX/rZYH8PCQCcZU5uqfsENjJh7TloxiuBzCsx3
o1U1iCtS+2kJlTheCF88gOIYfzfSOHsDE81is/FlsyqeLX8myz+rvuswShJ/vEKb
5ECdVO17l3NnfZrgAVnVkY+7k/pLpWdzPqOzz1uorz1fHhNRZiQz6bEGYGN6fXe4
d6tCXdUjynxZ5zHXY0EAcTt5vrEkYd7MasRwW1U+KyM2auXVQru9X8AXHFzi8/S7
riW8Wy8tiQd9RUE6IoYjd6RCAKhtywgRLbih2mLBImPLAG8Gmrs9dTzhLYkag3B4
Ehlqw64GznIrmH7R9LUOBEoVzQhVZm5L1RWyivpBV/SfBOQyClYWkHMZPyM3ISgQ
RX6Kn5j5/yrD4EIES4Xd
=Wve8
-----END PGP SIGNATURE-----
--=-=-=--
