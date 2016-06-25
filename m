From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recommendations needed for RAID5 recovery
Date: Sat, 25 Jun 2016 12:43:36 +0100
Message-ID: <576E6E68.9070209@youngman.org.uk>
References: <B1389BE8-B7B5-4AB4-BE12-1636D4B91BB5@seas.upenn.edu>
 <CAOS+5GGxVOWw1nEfEgpVcLY0+tHPVV3d48BzyRATjpApgvSkxg@mail.gmail.com>
 <22381.43040.31844.544728@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22381.43040.31844.544728@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24/06/16 22:37, John Stoffel wrote:
>=20
> Another> Before attempting any recovery can I suggest that you get 4 =
x
> Another> 2TB drives and dd the current drives so you have a backup.
>=20
> Not dd, dd_rescue instead.  But yes, try to get new hardware and clon=
e
> all the suspect drives before you do anything else.  Even just clonin=
g
> the most recently bad drive might be enough to get you going again.

As I got told rather sharply :-) there's a big difference between dd an=
d
ddrescue.

IFF dd completes successfully (it'll bomb on an error) then you have a
"known good" copy. In other words the problem with dd is it won't work
on a bad drive, but if it does work you're home and dry.

ddrescue will ALWAYS work - but if it can't read a block it will leave
an empty block in the copy! This is a bomb waiting to go off! In other
words, ddrescue is great at recovering what you can from a damaged
filesystem - less so at recovering a disk with a complicated setup on t=
op.

I know you're getting conflicting advice, but I'd try to get a good dd
backup first. I don't know of any utility that will do an md integrity
check on a ddrescue'd disk :-( so you'd need to do a fsck and hope ...

Oh - and make sure you new disks are proper raid - eg WD Red or Seagate
NAS. And are your current disks proper raid? If not, fix the timeout
problem and your life *may* be made a lot simpler ...

Have you got spare SATA ports? If not, go out and get an add-in card! I=
f
you can force the array to assemble, and create a temporary six-drive
array (the two dud ones being assembled with the --replace option to
move them to two new ones) that may be your best bet at recovery. If md
can get at a clean read from three drives for each block, then it'll be
able to rebuild the missing block.

Cheers,
Wol
>=20
> John
>=20
>=20
>=20
> Another> Then you can begin to think about performing the raid recove=
ry in the
> Another> knowledge you have a fallback position if it blows up.
>=20
> Another> Regards
>=20
> Another> Tony
>=20
> Another> On 24 June 2016 at 20:55, Peter Gebhard <pgeb@seas.upenn.edu=
> wrote:
>>> Hello,
>>>
>>> I have been asked to attempt data recovery on a RAID5 array which a=
ppears to have had two disk failures (in an array of four disks). I am =
gratefully hoping that some on this list could offer recommendations fo=
r my next steps. I have provided below the current state of the array p=
er https://raid.wiki.kernel.org/index.php/RAID_Recovery.
>>>
>>> It appears from the output below that one of the disks (sdd1) faile=
d last year and the admin did not notice this. Now, it appears a second=
 disk (sdg1) has recently had read errors and was kicked out of the arr=
ay.
>>>
>>> Should I try to restore the array using the recreate_array.pl scrip=
t provided on the RAID_Recovery site? Should I then try to recreate the=
 array and/or perform =E2=80=98fsck=E2=80=99?
>>>
>>> Thank you greatly in advance!
>>>
>>> raid.status:
>>>
>>> /dev/sdd1:
>>> Magic : a92b4efc
>>> Version : 1.2
>>> Feature Map : 0x0
>>> Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
>>> Name : <->:0
>>> Creation Time : Tue Nov 29 17:33:39 2011
>>> Raid Level : raid5
>>> Raid Devices : 4
>>>
>>> Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>>> Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
>>> Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>>> Data Offset : 2048 sectors
>>> Super Offset : 8 sectors
>>> State : clean
>>> Device UUID : ec1a6336:0a991298:5b409bf1:4585ccbe
>>>
>>> Update Time : Sun Jun  7 02:28:00 2015
>>> Checksum : f9323080 - correct
>>> Events : 96203
>>>
>>> Layout : left-symmetric
>>> Chunk Size : 512K
>>>
>>> Device Role : Active device 0
>>> Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
>>>
>>> /dev/sde1:
>>> Magic : a92b4efc
>>> Version : 1.2
>>> Feature Map : 0x0
>>> Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
>>> Name : <->:0
>>> Creation Time : Tue Nov 29 17:33:39 2011
>>> Raid Level : raid5
>>> Raid Devices : 4
>>>
>>> Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>>> Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
>>> Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>>> Data Offset : 2048 sectors
>>> Super Offset : 8 sectors
>>> State : clean
>>> Device UUID : ed13b045:ca75ab96:83045f97:e4fd62cb
>>>
>>> Update Time : Sun Jun 19 19:43:31 2016
>>> Checksum : bb6a905f - correct
>>> Events : 344993
>>>
>>> Layout : left-symmetric
>>> Chunk Size : 512K
>>>
>>> Device Role : Active device 3
>>> Array State : .A.A ('A' =3D=3D active, '.' =3D=3D missing)
>>>
>>> /dev/sdf1:
>>> Magic : a92b4efc
>>> Version : 1.2
>>> Feature Map : 0x0
>>> Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
>>> Name : <->:0
>>> Creation Time : Tue Nov 29 17:33:39 2011
>>> Raid Level : raid5
>>> Raid Devices : 4
>>>
>>> Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>>> Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
>>> Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>>> Data Offset : 2048 sectors
>>> Super Offset : 8 sectors
>>> State : clean
>>> Device UUID : a1ea11e0:6465fe26:483f133d:680014b3
>>>
>>> Update Time : Sun Jun 19 19:43:31 2016
>>> Checksum : 738493f3 - correct
>>> Events : 344993
>>>
>>> Layout : left-symmetric
>>> Chunk Size : 512K
>>>
>>> Device Role : Active device 1
>>> Array State : .A.A ('A' =3D=3D active, '.' =3D=3D missing)
>>>
>>> /dev/sdg1:
>>> Magic : a92b4efc
>>> Version : 1.2
>>> Feature Map : 0x0
>>> Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
>>> Name : <->:0
>>> Creation Time : Tue Nov 29 17:33:39 2011
>>> Raid Level : raid5
>>> Raid Devices : 4
>>>
>>> Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>>> Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
>>> Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>>> Data Offset : 2048 sectors
>>> Super Offset : 8 sectors
>>> State : active
>>> Device UUID : a9737439:17f81210:484d4f4c:c3d34a8a
>>>
>>> Update Time : Sun Jun 19 12:18:49 2016
>>> Checksum : 9c6d24bf - correct
>>> Events : 343949
>>>
>>> Layout : left-symmetric
>>> Chunk Size : 512K
>>>
>>> Device Role : Active device 2
>>> Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Another> --
> Another> To unsubscribe from this list: send the line "unsubscribe li=
nux-raid" in
> Another> the body of a message to majordomo@vger.kernel.org
> Another> More majordomo info at  http://vger.kernel.org/majordomo-inf=
o.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
