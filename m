From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Likely forced assemby with wrong disk during raid5 grow. Recoverable?
Date: Sun, 20 Feb 2011 14:47:54 +0000
Message-ID: <AANLkTink0VKa_yQpgxKqXsbxU67Kq++4RJEMW3p6UoBe@mail.gmail.com>
References: <AANLkTikhOAXQ6JAG1fK3x9V3icki8cjn0_ggyQwkGmnt@mail.gmail.com>
	<AANLkTi=5UZcMRKHTiXC3w8joh-qyi50gtTYwRf_scksW@mail.gmail.com>
	<20110220162509.2eb85a03@notabene.brown>
	<AANLkTi=-guMf-8YJDMvq9ybyY9Fppi+W0pqhH2Of=mKd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=-guMf-8YJDMvq9ybyY9Fppi+W0pqhH2Of=mKd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Claude Nobs <claudenobs@blunet.cc>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20 February 2011 14:44, Claude Nobs <claudenobs@blunet.cc> wrote:
> On Sun, Feb 20, 2011 at 06:25, NeilBrown <neilb@suse.de> wrote:
>> On Sun, 20 Feb 2011 04:23:09 +0100 Claude Nobs <claudenobs@blunet.cc=
> wrote:
>>
>>> Hi All,
>>>
>>> I was wondering if someone might be willing to share if this array =
is
>>> recoverable.
>>>
>>
>> Probably is. =C2=A0But don't do anything yet - any further action un=
til you have
>> read all of the following email, will probably cause more harm than =
good.
>>
>>> I had a clean, running raid5 using 4 block devices (two of those we=
re
>>> 2 disk raid0 md devices) in RAID 5. Last night I decided it was saf=
e
>>> to grow the array by one disk. But then a) a disk failed, b) a powe=
r
>>> loss occured, c) i probably switched the wrong disk and forced
>>> assembly, resulting in an inconsistent state. Here is a complete se=
t
>>> of actions taken :
>>
>> Providing this level of information is excellent!
>>
>>
>>>
>>> > bernstein@server:~$ sudo mdadm --grow --raid-devices=3D5 --backup=
-file=3D/raid.grow.backupfile /dev/md2
>>> > mdadm: Need to backup 768K of critical section..
>>> > mdadm: ... critical section passed.
>>> > bernstein@server:~$ cat /proc/mdstat
>>> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [rai=
d5] [raid4] [raid10]
>>> > md1 : active raid0 sdg1[1] sdf1[0]
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 976770944 blocks super 1.2 64k chu=
nks
>>> >
>>> > md2 : active raid5 sda1[5] md0[4] md1[3] sdd1[1] sdc1[0]
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2930281920 blocks super 1.2 level =
5, 64k chunk, algorithm 2 [5/5] [UUUUU]
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [>....................]=C2=A0 resh=
ape =3D=C2=A0 1.6% (16423164/976760640) finish=3D902.2min speed=3D17739=
K/sec
>>> >
>>> > md0 : active raid0 sdh1[0] sdb1[1]
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 976770944 blocks super 1.2 64k chu=
nks
>>> >
>>> > unused devices: <none>
>>
>> All looks good so-far.
>>
>>>
>>>
>>> now i thought /dev/sdg1 failed. unfortunately i have no log for thi=
s
>>> one, just my memory of seeing this changed to the one above :
>>>
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2930281920 blocks super 1.2 level =
5, 64k chunk, algorithm 2 [4/5] [UU_UU]
>>>
>>
>> Unfortunately it is not possible to know which drive is missing from=
 the
>> above info. =C2=A0The [numbers] is brackets don't exactly correspond=
s to the
>> positions in the array that you might thing they do. =C2=A0The mdsta=
t listing above
>> has numbers 0,1,3,4,5.
>>
>> They are the 'Number' column in the --detail output below. =C2=A0Thi=
s is /dev/md1
>> - I can tell from the --examine outputs, but it is a bit confusing. =
=C2=A0Newer
>> versions of mdadm make this a little less confusing. =C2=A0If you lo=
ok for
>> patterns of U and u =C2=A0in the 'Array State' line, the U is 'this =
device', the
>> 'u' is some other devices.
>
> Actually this is running a stock Ubunutu 10.10 server kernel. But as
> it is from my memory it could very well have been :
>
> =C2=A0 =C2=A0 =C2=A0 2930281920 blocks super 1.2 level 5, 64k chunk, =
algorithm 2 [4/5] [U_UUU]
>
>>
>> So /dev/md1 had a failure, so it could well have been sdg1.
>>
>>
>>> some 10 minutes later a power loss occurred, thanks to an ups the
>>> server shut down as with 'shutdown -h now'. now i exchanged /dev/sd=
g1,
>>> rebooted and in a lapse of judgement forced assembly:
>>
>> Perfect timing :-)
>>
>>>
>>> > bernstein@server:~$ sudo mdadm --assemble --run /dev/md2 /dev/md0=
 /dev/sda1 /dev/sdc1 /dev/sdd1
>>> > mdadm: Could not open /dev/sda1 for write - cannot Assemble array=
=2E
>>> > mdadm: Failed to restore critical section for reshape, sorry.
>>
>> This isn't actually a 'forced assembly' as you seem to think. =C2=A0=
There is no
>> '-f' or '--force'. =C2=A0It didn't cause any harm.
>
> phew... at last some luck! that "Failed to restore critical section
> for reshape, sorry" really scared the hell out of me.
> But then again it got me paying attention and stop making things wors=
e... :-)
>
>>
>>> >
>>> > bernstein@server:~$ sudo mdadm --detail /dev/md2
>>> > /dev/md2:
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 01.02
>>> > =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
>>> > =C2=A0 Used Dev Size : 976760640 (931.51 GiB 1000.20 GB)
>>> > =C2=A0=C2=A0 Raid Devices : 5
>>> > =C2=A0 Total Devices : 3
>>> > Preferred Minor : 3
>>> > =C2=A0=C2=A0=C2=A0 Persistence : Superblock is persistent
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:32:04 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : ac=
tive, degraded, Not Started
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^=
^^^^^^^^^^^
>>
>> mdadm has put the devices together as best it can, but has not start=
ed the
>> array because it didn't have enough devices. =C2=A0This is good.
>>
>>
>>> > =C2=A0Active Devices : 3
>>> > Working Devices : 3
>>> > =C2=A0Failed Devices : 0
>>> > =C2=A0 Spare Devices : 0
>>> >
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-sy=
mmetric
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>>> >
>>> > =C2=A0 Delta Devices : 1, (4->5)
>>> >
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name=
 : master:public
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 UUID=
 : c3b6db19:b61c3ba9:0a74b12b:3041a523
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133609
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Number=C2=A0=C2=A0 Major=C2=A0=C2=A0 Minor=C2=A0=
=C2=A0 RaidDevice State
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 33=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=A0=
=C2=A0 /dev/sdc1
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 removed
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 removed
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 9=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=
=A0=C2=A0 /dev/block/9:0
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=
=A0=C2=A0 /dev/sda1
>>
>> Some you now have 2 devices missing. =C2=A0Along as we can find the =
devices,
>> =C2=A0mdadm --assemble --force
>> should be able to put them togethe for you. =C2=A0But let's see =C2=A0=
what we have...
>>
>>>
>>> so i reattached the old disk, got /dev/md1 back and did the
>>> investigation i should have done before :
>>>
>>> > bernstein@server:~$ sudo mdadm --examine /dev/sdd1
>>> > /dev/sdd1:
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a9=
2b4efc
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
>>> > =C2=A0=C2=A0=C2=A0 Feature Map : 0x4
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:=
3041a523
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name=
 : master:public
>>> > =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
>>> > =C2=A0=C2=A0 Raid Devices : 5
>>> >
>>> > =C2=A0Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 7814085120 (3726.05 GiB 400=
0.81 GB)
>>> > =C2=A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
>>> > =C2=A0=C2=A0=C2=A0 Data Offset : 272 sectors
>>> > =C2=A0=C2=A0 Super Offset : 8 sectors
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : cl=
ean
>>> > =C2=A0=C2=A0=C2=A0 Device UUID : 5e37fc7c:50ff3b50:de3755a1:6bdbe=
bc6
>>> >
>>> > =C2=A0 Reshape pos'n : 489510400 (466.83 GiB 501.26 GB)
>>> > =C2=A0 Delta Devices : 1 (4->5)
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:23:09 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : fd0c1794 - correc=
t
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133567
>>> >
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-sy=
mmetric
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Array Slot : 1 (0, 1, failed, 2, 3, 4)
>>> > =C2=A0=C2=A0 Array State : uUuuu 1 failed
>>
>> This device thinks all is well. =C2=A0The "1 failed" is misleading. =
=C2=A0The
>> =C2=A0 uUuuu
>> patterns says that all the devices are though to be working.
>> Note for later reference:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events: 133567
>> =C2=A0Reshape pos'n : 489510400
>>
>>
>>> > bernstein@server:~$ sudo mdadm --examine /dev/sda1
>>> > /dev/sda1:
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a9=
2b4efc
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
>>> > =C2=A0=C2=A0=C2=A0 Feature Map : 0x4
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:=
3041a523
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name=
 : master:public
>>> > =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
>>> > =C2=A0=C2=A0 Raid Devices : 5
>>> >
>>> > =C2=A0Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 7814085120 (3726.05 GiB 400=
0.81 GB)
>>> > =C2=A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
>>> > =C2=A0=C2=A0=C2=A0 Data Offset : 272 sectors
>>> > =C2=A0=C2=A0 Super Offset : 8 sectors
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : cl=
ean
>>> > =C2=A0=C2=A0=C2=A0 Device UUID : baebd175:e4128e4c:f768b60f:4df18=
f77
>>> >
>>> > =C2=A0 Reshape pos'n : 502815488 (479.52 GiB 514.88 GB)
>>> > =C2=A0 Delta Devices : 1 (4->5)
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:32:04 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : 12c832c6 - correc=
t
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133609
>>> >
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-sy=
mmetric
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Array Slot : 5 (0, failed, failed, failed, 3, =
4)
>>> > =C2=A0=C2=A0 Array State : u__uU 3 failed
>>
>> This device thinks devices 1 and 2 have failed (the '_'s).
>> So 'sdd1' above, and and md1.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 133609 - this has advanced a bit=
 from sdd1
>> =C2=A0Reshape Pos'n : 502815488 - this has advanced quite a lot.
>>
>>
>>> > bernstein@server:~$ sudo mdadm --examine /dev/sdc1
>>> > /dev/sdc1:
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a9=
2b4efc
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
>>> > =C2=A0=C2=A0=C2=A0 Feature Map : 0x4
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:=
3041a523
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name=
 : master:public
>>> > =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
>>> > =C2=A0=C2=A0 Raid Devices : 5
>>> >
>>> > =C2=A0Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 7814085120 (3726.05 GiB 400=
0.81 GB)
>>> > =C2=A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
>>> > =C2=A0=C2=A0=C2=A0 Data Offset : 272 sectors
>>> > =C2=A0=C2=A0 Super Offset : 8 sectors
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : cl=
ean
>>> > =C2=A0=C2=A0=C2=A0 Device UUID : 82f5284a:2bffb837:19d366ab:ef2e3=
d94
>>> >
>>> > =C2=A0 Reshape pos'n : 502815488 (479.52 GiB 514.88 GB)
>>> > =C2=A0 Delta Devices : 1 (4->5)
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:32:04 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : 8aa7d094 - correc=
t
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133609
>>> >
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-sy=
mmetric
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Array Slot : 0 (0, failed, failed, failed, 3, =
4)
>>> > =C2=A0=C2=A0 Array State : U__uu 3 failed
>>
>> =C2=A0Reshape pos'n, Events, and Array State are identical to sda1.
>> So these two are in agreement.
>>
>>
>>> > bernstein@server:~$ sudo mdadm --examine /dev/md0
>>> > /dev/md0:
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a9=
2b4efc
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
>>> > =C2=A0=C2=A0=C2=A0 Feature Map : 0x4
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:=
3041a523
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name=
 : master:public
>>> > =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
>>> > =C2=A0=C2=A0 Raid Devices : 5
>>> >
>>> > =C2=A0Avail Dev Size : 1953541616 (931.52 GiB 1000.21 GB)
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 7814085120 (3726.05 GiB 400=
0.81 GB)
>>> > =C2=A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
>>> > =C2=A0=C2=A0=C2=A0 Data Offset : 272 sectors
>>> > =C2=A0=C2=A0 Super Offset : 8 sectors
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : cl=
ean
>>> > =C2=A0=C2=A0=C2=A0 Device UUID : 83ecd60d:f3947a5e:a69c4353:3c4a0=
893
>>> >
>>> > =C2=A0 Reshape pos'n : 502815488 (479.52 GiB 514.88 GB)
>>> > =C2=A0 Delta Devices : 1 (4->5)
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:32:04 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : 1bbf913b - correc=
t
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133609
>>> >
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-sy=
mmetric
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Array Slot : 4 (0, failed, failed, failed, 3, =
4)
>>> > =C2=A0=C2=A0 Array State : u__Uu 3 failed
>>
>> again, exactly the same as sda1 and sdc1.
>>
>>> > bernstein@server:~$ sudo mdadm --examine /dev/md1
>>> > /dev/md1:
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a9=
2b4efc
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
>>> > =C2=A0=C2=A0=C2=A0 Feature Map : 0x4
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:=
3041a523
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name=
 : master:public
>>> > =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
>>> > =C2=A0=C2=A0 Raid Devices : 5
>>> >
>>> > =C2=A0Avail Dev Size : 1953541616 (931.52 GiB 1000.21 GB)
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 7814085120 (3726.05 GiB 400=
0.81 GB)
>>> > =C2=A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
>>> > =C2=A0=C2=A0=C2=A0 Data Offset : 272 sectors
>>> > =C2=A0=C2=A0 Super Offset : 8 sectors
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : cl=
ean
>>> > =C2=A0=C2=A0=C2=A0 Device UUID : 3c7e2c3f:8b6c7c43:a0ce7e33:ad680=
bed
>>> >
>>> > =C2=A0 Reshape pos'n : 502809856 (479.52 GiB 514.88 GB)
>>> > =C2=A0 Delta Devices : 1 (4->5)
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:30:29 2011
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : 6c591e90 - correc=
t
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133603
>>> >
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-sy=
mmetric
>>> > =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>>> >
>>> > =C2=A0=C2=A0=C2=A0 Array Slot : 3 (0, failed, failed, 2, 3, 4)
>>> > =C2=A0=C2=A0 Array State : u_Uuu 2 failed
>>
>> And here is md1. =C2=A0Thinks device 2 - sdd1 - has failed.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 133603 - slightly behind the 3 g=
ood devices, be well after
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sdd1
>> =C2=A0Reshape Pos'n : 502809856 - just a little before the 3 good de=
vices too.
>>
>>>
>>> so obviously not /dev/sdd1 failed. however (due to that silly force=
d
>>> assembly?!) the reshape pos'n field of md0, sd[ac]1 differs from md=
1 a
>>> few bytes, resulting in an inconsistent state...
>>
>> The way I read it is:
>>
>> =C2=A0sdd1 failed first - shortly after Sat Feb 19 22:23:09 2011 - t=
he update=C2=A0time on sdd1
>> reshape continued until some time between Sat Feb 19 22:30:29 2011
>> and Sat Feb 19 22:32:04 2011 when md1 had a failure.
>> The reshape couldn't continue now, so it stopped.
>>
>> So the data on sdd1 is only (there has been about 8 minutes of resha=
pe since
>> then) and cannot be used.
>> The data on md1 is very close to the rest. =C2=A0The data that was i=
n the process
>> of being relocated lives in two locations on the 'good' drives, both=
 the new
>> and the old. =C2=A0It only lives in the 'old' location on md1.
>>
>> So what we need to do is re-assemble the array, but telling it that =
the
>> reshape has only gone as far as md1 thinks it has. =C2=A0This will m=
ake sure it
>> repeats that last part of the reshape.
>>
>> mdadm -Af should do that BUT IT DOESN'T. =C2=A0Assuming I have thoug=
ht through
>> this properly (and I should go through it again with more care), mda=
dm won't
>> do the right thing for you. =C2=A0I need to get it to handle 'reshap=
e' specially
>> when doing a --force assemble.
>
> exactly what i was thinking of doing, glad i waited and asked.
>
>>
>>>
>>> > bernstein@server:~$ sudo mdadm --assemble /dev/md2 /dev/sda1 /dev=
/md0 /dev/md1 /dev/sdd1 /dev/sdc1
>>> >
>>> > mdadm: /dev/md2 assembled from 3 drives - not enough to start the=
 array.
>>> > bernstein@server:~$ cat /proc/mdstat
>>> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [rai=
d5] [raid4] [raid10]
>>> > md2 : inactive sdc1[0](S) sda1[5](S) md0[4](S) md1[3](S) sdd1[1](=
S)
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4883823704 blocks super 1.2
>>> >
>>> > md1 : active raid0 sdf1[0] sdg1[1]
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 976770944 blocks super 1.2 64k chu=
nks
>>> >
>>> > md0 : active raid0 sdb1[1] sdh1[0]
>>> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 976770944 blocks super 1.2 64k chu=
nks
>>> >
>>> > unused devices: <none>
>>>
>>> i do have a backup but since recovery from it takes a few days, i'd
>>> like to know if there is a way to recover the array or if it's
>>> completely lost.
>>>
>>> Any suggestions gratefully received,
>>
>> The fact that you have a backup is excellent. =C2=A0You might need i=
t, but I hope
>> not.
>>
>> I would like to provide you with a modified version of mdadm which y=
ou can
>> then user to --force assemble the array. =C2=A0It should be able to =
get you access
>> to all your data.
>> The array will be degraded and will finish reshape in that state. =C2=
=A0Then you
>> will need to add sdd1 back in (Assuming you are confident that it wo=
rks) and
>> it will be rebuilt.
>>
>> Just to go through some of the numbers...
>>
>> Chunk size is 64K. =C2=A0Reshape was 4->5, so 3 -> 4 data disks.
>> So old stripes have 192K, new stripes have 256K.
>>
>> The 'good' disks think reshape has reached 502815488K which is
>> 1964123 new stripes. (2618830.66 old stripes)
>> md1 thinks reshape has only reached 489510400K which is 1912150
>> new stripes (2549533.33 old stripes).
>
> i think you mixed up sdd1 with md1 here? (the numbers above for md1
> are for sdd1. md1 would be : =C2=A0reshape has reached 502809856K whi=
ch
> would be 1964101 new stripes. so the difference between the good disk=
s
> and md1 would be 22 stripes.)
>
>>
>> So of the 51973 stripes that have been reshaped since the last metad=
ata
>> update on sdd1, some will have been done on sdd1, but some not, and =
we don't
>> really know how many. =C2=A0But it is perfectly safe to repeat those=
 stripes
>> as all writes to that region will have been suspended (and you proba=
bly
>> weren't writing anyway).
>
> jep there was nothing writing to the array. so now i am a little
> confused, if you meant sdd1 (which failed first is 51973 stripes
> behind) this would imply that at least so many stripes of data are
> kept of the old (3 data disks) configuration as well as the new one?
> if continuing from there is possible then the array would no longer b=
e
> degraded right? so i think you meant md1 (22 stripes behind), as
> keeping 5.5M of data from the old and new config seems more
> reasonable. however this is just a guess :-)
>
>>
>> So I need to change the loop in Assemble.c which calls ->update_supe=
r
>> with "force-one" to also make sure the reshape_position in the 'chos=
en'
>> superblock match the oldest 'forced' superblock.
>
> uh... ah... probably, i have zero knowledge of kernel code :-)
> i guess it should take into account that the oldest superblock (sdd1
> in this case) may already be out of the section were the data (in the
> old config) still exists? but i guess you already thought of that...
>
>>
>> So if you are able to wait a day, I'll try to write a patch first th=
ing
>> tomorrow and send it to you.
>
> sure, that would be awesome! that boils down to compiling the patched
> kernel doesn't it? this will probably take a few days as the system i=
s
> quite slow and i'd have to get up to speed with kernel compiling. but
> shouldn't be a problem. would i have to patch the ubuntu kernel (base=
d
> on 2.6.35.4) or the latest 2.6.38-rc from kernel.org?
>
>>
>> Thanks for the excellent problem report.
>>
>> NeilBrown
>
> Well i thank you for providing such an elaborate and friendly answer!
> this is actually my first mailing list post and considering how many
> questions get ignored (don't know about this list though) i just hope=
d
> someone would at least answer with a one liner... i never expected
> this. so thanks again.
>
> Claude
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Just a quick FYI, you can find (new, and unreleased) Ubuntu kernels
here: http://kernel.ubuntu.com/~kernel-ppa/mainline/

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
