From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid 5 created with 7 out of 8
Date: Sun, 9 Jan 2005 22:24:27 -0500
Message-ID: <200501100324.j0A3OZ919388@www.watkins-home.com>
References: <f4146e7c0501091738200dd32e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f4146e7c0501091738200dd32e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?'Bj=F8rn_Eikeland'?= <beikeland@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46rom 1.8.1:
This is a "development" release of mdadm.  It should *not* be
considered stable and should be used primarily for testing.
The current "stable" version is 1.8.0.

Your email shows "VERS =3D 9000".  Was that a command line option?  Or =
output
from mdadm?

The only other odd thing I see...  You have the largest chunk size I ha=
ve
seen (-c512).  But I don't know of any limits.

I did create an array with this command line.  No problems.
mdadm -C /dev/md3 -l5 -n8 -c512 /dev/ram[0-7]

from cat /proc/mdstat:
md3 : active raid5 [dev 01:07][7] [dev 01:06][6] [dev 01:05][5] [dev
01:04][4] [dev 01:03][3] [dev 01:02][2] [dev 01:01][1] [dev 01:00][0]
      25088 blocks level 5, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]

Send output of:
mdadm -D /dev/md0

I am using mdadm V1.8.0 and kernel 2.4.28.

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Bj=F8rn Eikeland
Sent: Sunday, January 09, 2005 8:39 PM
To: linux-raid@vger.kernel.org
Subject: raid 5 created with 7 out of 8

Hi, I'm trying to set up a raid5 array using 8 ide drives (
/dev/hd[e-l] ) but I'm having a hard time.

I'm using slackware 10, kernel 2.4.26 and madm 1.8.1 (downloading
2.4.28 overnight now)

The problem is mdadm creates the array with 7 of 8 drives up and
running and the last as a spare and does not start recovering with the
spare. And it will not let me remove it and re-add it. Below follows a
script output of the whole thing (less repartitioning the drives and
zero'ing any remaining superblocks)

Any help will be greatly appreciated.
-thanks

root@filebear:~# mdadm -C /dev/md0 -l5 -n8 -c512 /dev/hd[e-l]1
VERS =3D 9000
mdadm: array /dev/md0 started.
root@filebear:~# cat /proc/mdstat=20
Personalities : [linear] [raid0] [raid1] [raid5]=20
read_ahead 1024 sectors
md0 : active raid5 hdl1[8] hdk1[6] hdj1[5] hdi1[4] hdh1[3] hdg1[2]
hdf1[1] hde1[0]
      1094017792 blocks level 5, 512k chunk, algorithm 2 [8/7] [UUUUUUU=
_]
     =20
unused devices: <none>
root@filebear:~# mdadm /dev/md0 -f /dev/hdl1
mdadm: set /dev/hdl1 faulty in /dev/md0
root@filebear:~# mdadm /dev/md0 -r /dev/hdl
mdadm: hot removed /dev/hdl1
root@filebear:~# mdadm /dev/md0 -a /dev/hdl1
mdadm: hot add failed for /dev/hdl1: No space left on device
root@filebear:~# mdadm /dev/md0 -f /dev/hde1
mdadm: set /dev/hde1 faulty in /dev/md0
root@filebear:~# mdadm /dev/md0 -r /dev/hde1
mdadm: hot removed /dev/hde1
root@filebear:~# mdadm /dev/md0 -a /dev/hde1
mdadm: hot add failed for /dev/hde1: No space left on device
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
