From: NeilBrown <neilb@suse.de>
Subject: Re: [BISECT] Kernel panic, RIP bitmap_create
Date: Thu, 3 May 2012 16:25:50 +1000
Message-ID: <20120503162550.07dbc367@notabene.brown>
References: <CAOOwNtJhFa67EFTs5AdgSHzFseBr9xJGTsaEOyYnaYYNCeUMAQ@mail.gmail.com>
	<CAOOwNt+wjMU9+Dzrr3+d3dwML2_Q_CgT4X5OgiKvPA_bBoTYcg@mail.gmail.com>
	<20120503155850.2900067d@notabene.brown>
	<CAOOwNtK0xKg9E=gS46GR8uDVvjPqqL7+FbufY2d7iuW7yZgVwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aDR/ETsWAEB/+Z3=FRs=6LO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOOwNtK0xKg9E=gS46GR8uDVvjPqqL7+FbufY2d7iuW7yZgVwQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Karl Newman <siliconfiend@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/aDR/ETsWAEB/+Z3=FRs=6LO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 May 2012 23:14:09 -0700 Karl Newman <siliconfiend@gmail.com> wrot=
e:

> I'm not sure how to go about getting the full stack trace. The
> motherboard has no serial port, so that's not an option. Unless the
> kernel supports USB to serial adapters for that purpose, in which case
> I might be able to borrow a couple Keyspans. Or I could sit and try
> and transcribe the whole thing...(!)=20

A photo with a digital camera is usually easiest.   If you have wired
ethernet you could possible set up net-console.
Add something like

netconsole=3D@192.168.1.8/eth0,6666@192.168.1.3/00:14:85:fc:3b:de
           ^my address            ^other host IP / ethernet

Then on other-host run

  nc -u -l -p 6666 | tee -a /tmp/log


> I'm a little nervous about
> tripping the all-zeros UUID bug again, although it only happened once
> and it doesn't seem to be related to that commit.

IF you apply


--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8140,7 +8140,8 @@ static int md_notify_reboot(struct notifier_block *th=
is,
=20
        for_each_mddev(mddev, tmp) {
                if (mddev_trylock(mddev)) {
-                       __md_stop_writes(mddev);
+                       if (mddev->pers)
+                               __md_stop_writes(mddev);
                        mddev->safemode =3D 2;
                        mddev_unlock(mddev);
                }


to the kernel before you build it, that bug should not happen again.


>    Anyway, here's some
> data from the array:

Thanks.  Nothing jumps out at me, but I'll ponder it some more.

Thanks,
NeilBrown



>=20
> # mdadm -E /dev/sda3
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 60bf4ee8:e6e3e14f:073e21cd:ed2abb54
>   Creation Time : Wed May  2 20:22:47 2012
>      Raid Level : raid5
>   Used Dev Size : 29302400 (27.94 GiB 30.01 GB)
>      Array Size : 58604800 (55.89 GiB 60.01 GB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 127
>=20
>     Update Time : Wed May  2 23:01:45 2012
>           State : active
> Internal Bitmap : present
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 863c968f - correct
>          Events : 2
>=20
>          Layout : left-symmetric
>      Chunk Size : 128K
>=20
>       Number   Major   Minor   RaidDevice State
> this     0       8        3        0      active sync   /dev/sda3
>=20
>    0     0       8        3        0      active sync   /dev/sda3
>    1     1       8       19        1      active sync   /dev/sdb3
>    2     2       8       35        2      active sync   /dev/sdc3
>=20
> # mdadm -X /dev/sda3
>         Filename : /dev/sda3
>            Magic : 6d746962
>          Version : 4
>             UUID : 60bf4ee8:e6e3e14f:073e21cd:ed2abb54
>           Events : 1
>   Events Cleared : 1
>            State : OK
>        Chunksize : 64 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 29302400 (27.94 GiB 30.01 GB)
>           Bitmap : 448 bits (chunks), 0 dirty (0.0%)


--Sig_/aDR/ETsWAEB/+Z3=FRs=6LO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6Ik7jnsnt1WYoG5AQJTdw/+LLfei/bAo9/cVaMB6fLc2l/2g02TZVc4
LqbKXgWDru/ra5zLCXCt6hYWqESrTsFNJIMRzRU9TdHh9kOW4KOtkvFsB+/vbAfP
I9GWs4bZtK4EZBZay/bjOl0ay94f1efcMPxNSz0dHNtUz2zmNnhL4COK+MYW7rdC
A2Fz064qj71HcMNa2hVXNWa3xPbjmhNpuGrM/X/RAEpO4SElw0Wp+MKB+1zOyOT+
Ul3L2w6nL+IP5i9KkiXMkQHIJc4LnQLStPAQ4pYrOWS3jwCbFSQJU8rbZBTnW+Bz
mDy6mSmpB9+RQ6re9a4A4tBoDp7rMLyqxpdMccn53IdJtjYXl/huiiD+d231NoIC
HQLTb9jfp8ftQWvu20lQ0HlwNQDjFY3RzW9s8ceW1X1OuqvFtVweK4F6OFNlXzL4
0zbE7/if+ixaLWpUbWqoeicIZLM7kAxh0WrjuqWFtI0ovbayKiMRTDLoHbpuKxnW
0gHGtNL7VrPqj498gAt21dnceKzWGhphT8n7P8UuUrVIK7TAKUIkk2LakP7fLlRm
8N0ZUGmG2a8gD1HfgUQm39zQIcTY99EaeTj661HHeCtHHnCq89+2r3q/jHWbcla/
sTRYyspU/4RQSkXy0meiZTVc+0Wj2S3mMh+M8qDVYIl8U41zEqaythbBtObNqAPP
RZChu2J+jC8=
=0Ft2
-----END PGP SIGNATURE-----

--Sig_/aDR/ETsWAEB/+Z3=FRs=6LO--
