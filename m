From: jahammonds prost <gmitch64@yahoo.com>
Subject: Failed RAID 6 array advice
Date: Tue, 1 Mar 2011 21:05:33 -0800 (PST)
Message-ID: <65522.87245.qm@web55807.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've just had a 3rd drive fail on one of my RAID 6 arrays, and I'm look=
ing for=20
some advice on how to get it back enough that I can=A0recover the data,=
 and then=20
replacing the other failed drives.


mdadm -V
mdadm - v3.0.3 - 22nd October 2009


Not the most up to date release, but it seems to be the latest one avai=
lable on=20
=46C12



The /etc/mdadm.conf file is

ARRAY /dev/md0 uuid=3D1470c671:4236b155:67287625:899db153


Which explains why I didn't get emailed about the drive failures. This =
isn't my=20
standard file, and I don't know how it was changed, but that's another =
issue for=20
another day.



mdadm --detail /dev/md0
/dev/md0:
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0 Creation Time : Sat Jun=A0 5 10:38:11 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0 Used Dev Size : 488383488 (465.76 GiB 500.10 GB)
=A0=A0 Raid Devices : 15
=A0 Total Devices : 12
=A0=A0=A0 Persistence : Superblock is persistent
=A0=A0=A0 Update Time : Tue Mar=A0 1 22:17:41 2011
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active, degraded, Not Started
=A0Active Devices : 12
Working Devices : 12
=A0Failed Devices : 0
=A0 Spare Devices : 0
=A0=A0=A0=A0 Chunk Size : 512K
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : file00bert.woodlea.org.uk:0=A0 (l=
ocal to host=20
file00bert.woodlea.org.uk)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 1470c671:4236b155:67287625:899db1=
53
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 254890
=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 113=A0=A0=A0=A0=
=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdh1
=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=A0=
=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
=A0=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 177=A0=A0=A0=A0=
=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdl1
=A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 removed
=A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=A0=
=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
=A0=A0=A0=A0=A0=A0 5=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 193=A0=A0=A0=A0=
=A0=A0=A0 5=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdm1
=A0=A0=A0=A0=A0=A0 6=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0 6=A0=A0=A0=A0=A0 removed
=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 49=A0=A0=A0=A0=
=A0=A0=A0 7=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdd1
=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 209=A0=A0=A0=A0=
=A0=A0=A0 8=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdn1
=A0=A0=A0=A0=A0=A0 9=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 161=A0=A0=A0=A0=
=A0=A0=A0 9=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdk1
=A0=A0=A0=A0=A0 10=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=
=A0=A0 10=A0=A0=A0=A0=A0 removed
=A0=A0=A0=A0=A0 11=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 225=A0=A0=A0=A0=A0=
=A0 11=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdo1
=A0=A0=A0=A0=A0 12=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 81=A0=A0=A0=A0=
=A0=A0 12=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdf1
=A0=A0=A0=A0=A0 13=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 241=A0=A0=A0=A0=A0=
=A0 13=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdp1
=A0=A0=A0=A0=A0 14=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=
=A0=A0 14=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda1



The output from the=A0failed drives are as follows.


mdadm --examine /dev/sde1
/dev/sde1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x1
=A0=A0=A0=A0 Array UUID : 1470c671:4236b155:67287625:899db153
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : file00bert.woodlea.org.uk:0=A0 (l=
ocal to host=20
file00bert.woodlea.org.uk)
=A0 Creation Time : Sat Jun=A0 5 10:38:11 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 15
=A0Avail Dev Size : 976767730 (465.76 GiB 500.11 GB)
=A0=A0=A0=A0 Array Size : 12697970688 (6054.86 GiB 6501.36 GB)
=A0 Used Dev Size : 976766976 (465.76 GiB 500.10 GB)
=A0=A0=A0 Data Offset : 272 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 3e284f2e:d939fb97:0b74eb88:326e879c
Internal Bitmap : 2 sectors from superblock
=A0=A0=A0 Update Time : Tue Mar=A0 1 21:53:31 2011
=A0=A0=A0=A0=A0=A0 Checksum : 768f0f34 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 254591
=A0=A0=A0=A0 Chunk Size : 512K
=A0=A0 Device Role : Active device 10
=A0=A0 Array State : AAA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D mis=
sing)


The above=A0is the drive that failed tonight, and the one I would like =
to re add=20
back into the array. There have been no writes to the filesystem on the=
 array in=20
the last couple of days (other than what ext4 would do on it's own).


=A0mdadm --examine /dev/sdi1
/dev/sdi1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x1
=A0=A0=A0=A0 Array UUID : 1470c671:4236b155:67287625:899db153
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : file00bert.woodlea.org.uk:0=A0 (l=
ocal to host=20
file00bert.woodlea.org.uk)
=A0 Creation Time : Sat Jun=A0 5 10:38:11 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 15
=A0Avail Dev Size : 976767730 (465.76 GiB 500.11 GB)
=A0=A0=A0=A0 Array Size : 12697970688 (6054.86 GiB 6501.36 GB)
=A0 Used Dev Size : 976766976 (465.76 GiB 500.10 GB)
=A0=A0=A0 Data Offset : 272 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
=A0=A0=A0 Device UUID : 8e668e39:06d8281b:b79aa3ab:a1d55fb5
Internal Bitmap : 2 sectors from superblock
=A0=A0=A0 Update Time : Thu Feb 10 18:20:54 2011
=A0=A0=A0=A0=A0=A0 Checksum : 4078396b - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 254075
=A0=A0=A0=A0 Chunk Size : 512K
=A0=A0 Device Role : Active device 3
=A0=A0 Array State : AAAAAA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D mis=
sing)


mdadm --examine /dev/sdj1
/dev/sdj1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x1
=A0=A0=A0=A0 Array UUID : 1470c671:4236b155:67287625:899db153
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : file00bert.woodlea.org.uk:0=A0 (l=
ocal to host=20
file00bert.woodlea.org.uk)
=A0 Creation Time : Sat Jun=A0 5 10:38:11 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 15
=A0Avail Dev Size : 976767730 (465.76 GiB 500.11 GB)
=A0=A0=A0=A0 Array Size : 12697970688 (6054.86 GiB 6501.36 GB)
=A0 Used Dev Size : 976766976 (465.76 GiB 500.10 GB)
=A0=A0=A0 Data Offset : 272 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
=A0=A0=A0 Device UUID : 37d422cc:8436960a:c3c4d11c:81a8e4fa
Internal Bitmap : 2 sectors from superblock
=A0=A0=A0 Update Time : Thu Oct 21 23:45:06 2010
=A0=A0=A0=A0=A0=A0 Checksum : 78950bb5 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 21435
=A0=A0=A0=A0 Chunk Size : 512K
=A0=A0 Device Role : Active device 6
=A0=A0 Array State : AAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D mis=
sing)


Looks like sdj1 failed waaay back in Oct last year (sigh). As I said, I=
 am not=20
to bothered about adding these last 2 drives back into the array, since=
 they=20
failed so long ago. I have a couple of spare drives sitting here, and I=
 will=20
replace these 2 drives with them (once I have completed a badblocks on =
them).=20
Looking at the output of dmesg, there are no other errors showing for t=
he 3=20
drives, other than them being kicked out of the array for being non fre=
sh.

I guess I have a couple of questions.

What's the correct process for adding the failed /dev/sde1 back into th=
e array=20
so I can start it. I don't want to rush into this and make things worse=
=2E

What's the correct process for replacing the 2 other drives?
I am presuming that I need to --fail, then --remove then --add the driv=
es (one=20
at a time?), but I want to make sure.


Thanks for your help.


Graham.


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
