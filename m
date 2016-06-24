From: "John Stoffel" <john@stoffel.org>
Subject: Re: Recommendations needed for RAID5 recovery
Date: Fri, 24 Jun 2016 17:37:36 -0400
Message-ID: <22381.43040.31844.544728@quad.stoffel.home>
References: <B1389BE8-B7B5-4AB4-BE12-1636D4B91BB5@seas.upenn.edu>
	<CAOS+5GGxVOWw1nEfEgpVcLY0+tHPVV3d48BzyRATjpApgvSkxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GGxVOWw1nEfEgpVcLY0+tHPVV3d48BzyRATjpApgvSkxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Another> Before attempting any recovery can I suggest that you get 4 x
Another> 2TB drives and dd the current drives so you have a backup.

Not dd, dd_rescue instead.  But yes, try to get new hardware and clone
all the suspect drives before you do anything else.  Even just cloning
the most recently bad drive might be enough to get you going again.

John



Another> Then you can begin to think about performing the raid recovery=
 in the
Another> knowledge you have a fallback position if it blows up.

Another> Regards

Another> Tony

Another> On 24 June 2016 at 20:55, Peter Gebhard <pgeb@seas.upenn.edu> =
wrote:
>> Hello,
>>=20
>> I have been asked to attempt data recovery on a RAID5 array which ap=
pears to have had two disk failures (in an array of four disks). I am g=
ratefully hoping that some on this list could offer recommendations for=
 my next steps. I have provided below the current state of the array pe=
r https://raid.wiki.kernel.org/index.php/RAID_Recovery.
>>=20
>> It appears from the output below that one of the disks (sdd1) failed=
 last year and the admin did not notice this. Now, it appears a second =
disk (sdg1) has recently had read errors and was kicked out of the arra=
y.
>>=20
>> Should I try to restore the array using the recreate_array.pl script=
 provided on the RAID_Recovery site? Should I then try to recreate the =
array and/or perform =E2=80=98fsck=E2=80=99?
>>=20
>> Thank you greatly in advance!
>>=20
>> raid.status:
>>=20
>> /dev/sdd1:
>> Magic : a92b4efc
>> Version : 1.2
>> Feature Map : 0x0
>> Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
>> Name : <->:0
>> Creation Time : Tue Nov 29 17:33:39 2011
>> Raid Level : raid5
>> Raid Devices : 4
>>=20
>> Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>> Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
>> Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>> Data Offset : 2048 sectors
>> Super Offset : 8 sectors
>> State : clean
>> Device UUID : ec1a6336:0a991298:5b409bf1:4585ccbe
>>=20
>> Update Time : Sun Jun  7 02:28:00 2015
>> Checksum : f9323080 - correct
>> Events : 96203
>>=20
>> Layout : left-symmetric
>> Chunk Size : 512K
>>=20
>> Device Role : Active device 0
>> Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
>>=20
>> /dev/sde1:
>> Magic : a92b4efc
>> Version : 1.2
>> Feature Map : 0x0
>> Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
>> Name : <->:0
>> Creation Time : Tue Nov 29 17:33:39 2011
>> Raid Level : raid5
>> Raid Devices : 4
>>=20
>> Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>> Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
>> Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>> Data Offset : 2048 sectors
>> Super Offset : 8 sectors
>> State : clean
>> Device UUID : ed13b045:ca75ab96:83045f97:e4fd62cb
>>=20
>> Update Time : Sun Jun 19 19:43:31 2016
>> Checksum : bb6a905f - correct
>> Events : 344993
>>=20
>> Layout : left-symmetric
>> Chunk Size : 512K
>>=20
>> Device Role : Active device 3
>> Array State : .A.A ('A' =3D=3D active, '.' =3D=3D missing)
>>=20
>> /dev/sdf1:
>> Magic : a92b4efc
>> Version : 1.2
>> Feature Map : 0x0
>> Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
>> Name : <->:0
>> Creation Time : Tue Nov 29 17:33:39 2011
>> Raid Level : raid5
>> Raid Devices : 4
>>=20
>> Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>> Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
>> Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>> Data Offset : 2048 sectors
>> Super Offset : 8 sectors
>> State : clean
>> Device UUID : a1ea11e0:6465fe26:483f133d:680014b3
>>=20
>> Update Time : Sun Jun 19 19:43:31 2016
>> Checksum : 738493f3 - correct
>> Events : 344993
>>=20
>> Layout : left-symmetric
>> Chunk Size : 512K
>>=20
>> Device Role : Active device 1
>> Array State : .A.A ('A' =3D=3D active, '.' =3D=3D missing)
>>=20
>> /dev/sdg1:
>> Magic : a92b4efc
>> Version : 1.2
>> Feature Map : 0x0
>> Array UUID : bfb03f95:834b520d:60f773d8:ecb6b9e3
>> Name : <->:0
>> Creation Time : Tue Nov 29 17:33:39 2011
>> Raid Level : raid5
>> Raid Devices : 4
>>=20
>> Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>> Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
>> Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>> Data Offset : 2048 sectors
>> Super Offset : 8 sectors
>> State : active
>> Device UUID : a9737439:17f81210:484d4f4c:c3d34a8a
>>=20
>> Update Time : Sun Jun 19 12:18:49 2016
>> Checksum : 9c6d24bf - correct
>> Events : 343949
>>=20
>> Layout : left-symmetric
>> Chunk Size : 512K
>>=20
>> Device Role : Active device 2
>> Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Another> --
Another> To unsubscribe from this list: send the line "unsubscribe linu=
x-raid" in
Another> the body of a message to majordomo@vger.kernel.org
Another> More majordomo info at  http://vger.kernel.org/majordomo-info.=
html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
