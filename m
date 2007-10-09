From: =?iso-8859-15?q?Fr=E9d=E9ric_Mantegazza?= <mantegazza@ill.fr>
Subject: Problem adding a new smaller partition in array
Date: Tue, 9 Oct 2007 16:02:23 +0200
Message-ID: <200710091602.24302.mantegazza@ill.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

=46irst, sorry for my request sent to the list, instead of the robot. T=
hat's a=20
long time I didn't make such mistake :o/

I have a problem with my raid config. Let me expose all the facts.

My system (debian etch) is totally (even the MBR) installed using 2 dis=
ks in=20
raid 1 (4 partitions). Initially, the 2 disks where exaclty the same. T=
wo=20
months ago, I had a crash. Checking the log file, I found that it occur=
ed=20
during the checkarray command (launched every first sunday of the month=
). I=20
also saw some strange errors on hda device. Before changing something=20
(could be the disk, the cable...), I waited to see more explicit errors=
=2E=20
But no error occured during the next month. And last sunday, it crashed=
=20
again during the checkarray command. Then, after relaunching the system=
,=20
all freezed because there where too much errors on hda device (bad=20
sectors...) during the synchronisation of the raid. So I decided to cha=
nge=20
the hda drive.

My spare drive is a little bit smaller (40GB, instead of 41.1GB) that t=
he=20
previous one (and so, the other one in the array). So, the last partiti=
on=20
(hda4) is now smaller than hdb4, and the raid can't add it in the array=
=20
("No space left on device").

I then shrinked the filesystem, using resize_reiserfs, reduced the part=
ition=20
on hdb4 to be smaller (it can't be equal) than hda4, and tried to re=20
assemble the array. Then, I get:

  # mdadm --assemble /dev/md3
  mdadm: /dev/hdb4 has no superblock - assembly aborted

Why superblock has been removed? What have I done wrong?

If I try to re create the array:

  # mdadm --create --verbose /dev/md3 -l 1 -n 2 /dev/hda4 /dev/hdb4
  mdadm: /dev/hda4 appears to be part of a raid array:
      level=3Draid1 devices=3D2 ctime=3DFri Nov  4 11:07:04 2005
  mdadm: /dev/hdb4 appears to contain a reiserfs file system
      size =3D 27040320K
  mdadm: size set to 29061504K
  Continue creating array? no
  mdadm: create aborted.

So, it seems that mdadm recognizes the filesystem. But does it destroy =
it if=20
I proceed (using --force)?

The other strange thing, is that the superblock is ok on hda4, the driv=
e I=20
changed! Who created it? The --assemble command?

Before I lost my datas (well, they are backuped up, but I would like to=
 be=20
able to reconstruct my raid without the need to re install datas), what=
 do=20
you suggest?

Do I have to force the creation using only the hdb4 partition? Then, ad=
ding=20
the hda4 device? Do I have to first zero the superblock on this device?

I also read something about event counters not matching, which could di=
ve to=20
loose datas (wrong sync way)...

Any advice welcome. And if I did something wrong, please let me know, t=
o be=20
able to do it right next time!

--=20
   Fr=E9d=E9ric
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
