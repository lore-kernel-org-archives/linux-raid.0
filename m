From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: raid10 messed up by false multipath setup (was: raid10 messed up filesystem, lvm lv ok)
Date: Mon, 21 Jan 2008 02:32:08 -0800
Message-ID: <56BCADAE-B48A-45F6-A969-C78456D42F25@develooper.com>
References: <CA0AD0CD-9AB2-4468-BE7E-807650317101@develooper.com>
Mime-Version: 1.0 (Apple Message framework v915)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA0AD0CD-9AB2-4468-BE7E-807650317101@develooper.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 19, 2008, at 3:44 AM, Ask Bj=F8rn Hansen wrote:

Replying to myself with an update, mostly for the sake of the archives =
=20
(I went through the linux-raid mail from the last year yesterday while =
=20
waiting for my raw-partition backups to finish).

> I mentioned[1] my trouble with the multipath detection code on the =20
> Fedora rescue mode messing up my raid yesterday.
[...]
> I suspect that maybe the layout of the md device got messed up?  How =
=20
> can I find out if that's the case?  Would it be possible to recover =20
> from (assuming all the data still is on some of the disks).

I realized that of the 11 disks (9 in the raid, 2 spares) one of the =20
disks affected by the "fake multipath" mishap was a spare, so after =20
backing up all the raw partitions[2] I re-created the raid in place =20
with the other affected disk marked missing and it seems like the file =
=20
system is more or less okay.   Yes, I'm doing a backup now.  :-)

Lessons:

   1) Do backups of your raid'ed data.   Yes, it can be a pain but =20
figure it out.

   2) Keep your root partition on a simple raid1 (or on a lvm group =20
that's on a simple raid1).

   3) When the raid goes @#$ - don't panic, make sure nothing is being =
=20
written to the disks and stop.   (Some years ago I lost a raid5 to the =
=20
"oops, had a read-error, drop the last disk" issue and I suspect I =20
could have saved it had I been patient and stopped working on it until =
=20
I was more awake).

   4) Have/make copies of the mdadm -D / -E output.

   5) If you care about the data, do a backup of your raw partitions =20
before trying to restore.

   6) The "create the raid on top of the old raid" trick saves the day =
=20
again (for a while I had some kind of cabling problem on a box with a =20
raid6 - I lost track of how many times I did the recreate thing).

> Secondary question: I'm doing a "dd if=3D/dev/sdX5 bs=3D256k > /backu=
p/=20
> sdX5" for each disk -- is there a way to run mdadm on the copies and =
=20
> experiment on those?    (It took ~forever to copy a terabyte of the =20
> raw partitions).

(For the archives) - I didn't try it, but setting up the disk images =20
as loop devices should work.  I didn't think of that yesterday.


  - ask


> [1] http://marc.info/?l=3Dlinux-raid&m=3D120065542429935&w=3D2


[2] And oh man am I glad I backed them up.  On my first attempt at =20
recreating the raid I forgot the md device parameter and --assume-=20
clean, so it created a raid device on one of my source partitions and =20
immediately started syncing at ~120MB/sec.  Restoring the partitions =20
from the backup worked fine fortunately.

--=20
http://develooper.com/ - http://askask.com/


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
