From: NeilBrown <neilb@suse.de>
Subject: Re: Likely forced assemby with wrong disk during raid5 grow.
 Recoverable?
Date: Sun, 20 Feb 2011 16:25:09 +1100
Message-ID: <20110220162509.2eb85a03@notabene.brown>
References: <AANLkTikhOAXQ6JAG1fK3x9V3icki8cjn0_ggyQwkGmnt@mail.gmail.com>
	<AANLkTi=5UZcMRKHTiXC3w8joh-qyi50gtTYwRf_scksW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=5UZcMRKHTiXC3w8joh-qyi50gtTYwRf_scksW@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Claude Nobs <claudenobs@blunet.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 20 Feb 2011 04:23:09 +0100 Claude Nobs <claudenobs@blunet.cc> w=
rote:

> Hi All,
>=20
> I was wondering if someone might be willing to share if this array is
> recoverable.
>=20

Probably is.  But don't do anything yet - any further action until you =
have
read all of the following email, will probably cause more harm than goo=
d.

> I had a clean, running raid5 using 4 block devices (two of those were
> 2 disk raid0 md devices) in RAID 5. Last night I decided it was safe
> to grow the array by one disk. But then a) a disk failed, b) a power
> loss occured, c) i probably switched the wrong disk and forced
> assembly, resulting in an inconsistent state. Here is a complete set
> of actions taken :

Providing this level of information is excellent!


>=20
> > bernstein@server:~$ sudo mdadm --grow --raid-devices=3D5 --backup-f=
ile=3D/raid.grow.backupfile /dev/md2
> > mdadm: Need to backup 768K of critical section..
> > mdadm: ... critical section passed.
> > bernstein@server:~$ cat /proc/mdstat
> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
] [raid4] [raid10]
> > md1 : active raid0 sdg1[1] sdf1[0]
> > =A0=A0=A0=A0=A0 976770944 blocks super 1.2 64k chunks
> >
> > md2 : active raid5 sda1[5] md0[4] md1[3] sdd1[1] sdc1[0]
> > =A0=A0=A0=A0=A0 2930281920 blocks super 1.2 level 5, 64k chunk, alg=
orithm 2 [5/5] [UUUUU]
> > =A0=A0=A0=A0=A0 [>....................]=A0 reshape =3D=A0 1.6% (164=
23164/976760640) finish=3D902.2min speed=3D17739K/sec
> >
> > md0 : active raid0 sdh1[0] sdb1[1]
> > =A0=A0=A0=A0=A0 976770944 blocks super 1.2 64k chunks
> >
> > unused devices: <none>

All looks good so-far.

>=20
>=20
> now i thought /dev/sdg1 failed. unfortunately i have no log for this
> one, just my memory of seeing this changed to the one above :
>=20
> > =A0=A0=A0=A0=A0 2930281920 blocks super 1.2 level 5, 64k chunk, alg=
orithm 2 [4/5] [UU_UU]
>=20

Unfortunately it is not possible to know which drive is missing from th=
e
above info.  The [numbers] is brackets don't exactly corresponds to the
positions in the array that you might thing they do.  The mdstat listin=
g above
has numbers 0,1,3,4,5.

They are the 'Number' column in the --detail output below.  This is /de=
v/md1
- I can tell from the --examine outputs, but it is a bit confusing.  Ne=
wer
versions of mdadm make this a little less confusing.  If you look for
patterns of U and u  in the 'Array State' line, the U is 'this device',=
 the
'u' is some other devices.

So /dev/md1 had a failure, so it could well have been sdg1.


> some 10 minutes later a power loss occurred, thanks to an ups the
> server shut down as with 'shutdown -h now'. now i exchanged /dev/sdg1=
,
> rebooted and in a lapse of judgement forced assembly:

Perfect timing :-)

>=20
> > bernstein@server:~$ sudo mdadm --assemble --run /dev/md2 /dev/md0 /=
dev/sda1 /dev/sdc1 /dev/sdd1
> > mdadm: Could not open /dev/sda1 for write - cannot Assemble array.
> > mdadm: Failed to restore critical section for reshape, sorry.

This isn't actually a 'forced assembly' as you seem to think.  There is=
 no
'-f' or '--force'.  It didn't cause any harm.

> >
> > bernstein@server:~$ sudo mdadm --detail /dev/md2
> > /dev/md2:
> > =A0=A0=A0=A0=A0=A0=A0 Version : 01.02
> > =A0 Creation Time : Sat Jan 22 00:15:43 2011
> > =A0=A0=A0=A0 Raid Level : raid5
> > =A0 Used Dev Size : 976760640 (931.51 GiB 1000.20 GB)
> > =A0=A0 Raid Devices : 5
> > =A0 Total Devices : 3
> > Preferred Minor : 3
> > =A0=A0=A0 Persistence : Superblock is persistent
> >
> > =A0=A0=A0 Update Time : Sat Feb 19 22:32:04 2011
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active, degraded, Not Started
                                        ^^^^^^^^^^^^

mdadm has put the devices together as best it can, but has not started =
the
array because it didn't have enough devices.  This is good.


> > =A0Active Devices : 3
> > Working Devices : 3
> > =A0Failed Devices : 0
> > =A0 Spare Devices : 0
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
> > =A0=A0=A0=A0 Chunk Size : 64K
> >
> > =A0 Delta Devices : 1, (4->5)
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : master:public
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : c3b6db19:b61c3ba9:0a74b12b:30=
41a523
> > =A0=A0=A0=A0=A0=A0=A0=A0 Events : 133609
> >
> > =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
> > =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=
=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
> > =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 removed
> > =A0=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 removed
> > =A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 9=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/block/9:0
> > =A0=A0=A0=A0=A0=A0 5=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 1=A0=A0=
=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda1

Some you now have 2 devices missing.  Along as we can find the devices,=
=20
  mdadm --assemble --force
should be able to put them togethe for you.  But let's see  what we hav=
e...

>=20
> so i reattached the old disk, got /dev/md1 back and did the
> investigation i should have done before :
>=20
> > bernstein@server:~$ sudo mdadm --examine /dev/sdd1
> > /dev/sdd1:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
> > =A0=A0=A0=A0=A0=A0=A0 Version : 1.2
> > =A0=A0=A0 Feature Map : 0x4
> > =A0=A0=A0=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041a523
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : master:public
> > =A0 Creation Time : Sat Jan 22 00:15:43 2011
> > =A0=A0=A0=A0 Raid Level : raid5
> > =A0=A0 Raid Devices : 5
> >
> > =A0Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
> > =A0=A0=A0=A0 Array Size : 7814085120 (3726.05 GiB 4000.81 GB)
> > =A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
> > =A0=A0=A0 Data Offset : 272 sectors
> > =A0=A0 Super Offset : 8 sectors
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
> > =A0=A0=A0 Device UUID : 5e37fc7c:50ff3b50:de3755a1:6bdbebc6
> >
> > =A0 Reshape pos'n : 489510400 (466.83 GiB 501.26 GB)
> > =A0 Delta Devices : 1 (4->5)
> >
> > =A0=A0=A0 Update Time : Sat Feb 19 22:23:09 2011
> > =A0=A0=A0=A0=A0=A0 Checksum : fd0c1794 - correct
> > =A0=A0=A0=A0=A0=A0=A0=A0 Events : 133567
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
> > =A0=A0=A0=A0 Chunk Size : 64K
> >
> > =A0=A0=A0 Array Slot : 1 (0, 1, failed, 2, 3, 4)
> > =A0=A0 Array State : uUuuu 1 failed

This device thinks all is well.  The "1 failed" is misleading.  The
   uUuuu
patterns says that all the devices are though to be working.
Note for later reference:
         Events: 133567
 Reshape pos'n : 489510400


> > bernstein@server:~$ sudo mdadm --examine /dev/sda1
> > /dev/sda1:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
> > =A0=A0=A0=A0=A0=A0=A0 Version : 1.2
> > =A0=A0=A0 Feature Map : 0x4
> > =A0=A0=A0=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041a523
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : master:public
> > =A0 Creation Time : Sat Jan 22 00:15:43 2011
> > =A0=A0=A0=A0 Raid Level : raid5
> > =A0=A0 Raid Devices : 5
> >
> > =A0Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
> > =A0=A0=A0=A0 Array Size : 7814085120 (3726.05 GiB 4000.81 GB)
> > =A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
> > =A0=A0=A0 Data Offset : 272 sectors
> > =A0=A0 Super Offset : 8 sectors
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
> > =A0=A0=A0 Device UUID : baebd175:e4128e4c:f768b60f:4df18f77
> >
> > =A0 Reshape pos'n : 502815488 (479.52 GiB 514.88 GB)
> > =A0 Delta Devices : 1 (4->5)
> >
> > =A0=A0=A0 Update Time : Sat Feb 19 22:32:04 2011
> > =A0=A0=A0=A0=A0=A0 Checksum : 12c832c6 - correct
> > =A0=A0=A0=A0=A0=A0=A0=A0 Events : 133609
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
> > =A0=A0=A0=A0 Chunk Size : 64K
> >
> > =A0=A0=A0 Array Slot : 5 (0, failed, failed, failed, 3, 4)
> > =A0=A0 Array State : u__uU 3 failed

This device thinks devices 1 and 2 have failed (the '_'s).
So 'sdd1' above, and and md1.
        Events : 133609 - this has advanced a bit from sdd1
 Reshape Pos'n : 502815488 - this has advanced quite a lot.


> > bernstein@server:~$ sudo mdadm --examine /dev/sdc1
> > /dev/sdc1:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
> > =A0=A0=A0=A0=A0=A0=A0 Version : 1.2
> > =A0=A0=A0 Feature Map : 0x4
> > =A0=A0=A0=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041a523
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : master:public
> > =A0 Creation Time : Sat Jan 22 00:15:43 2011
> > =A0=A0=A0=A0 Raid Level : raid5
> > =A0=A0 Raid Devices : 5
> >
> > =A0Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
> > =A0=A0=A0=A0 Array Size : 7814085120 (3726.05 GiB 4000.81 GB)
> > =A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
> > =A0=A0=A0 Data Offset : 272 sectors
> > =A0=A0 Super Offset : 8 sectors
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
> > =A0=A0=A0 Device UUID : 82f5284a:2bffb837:19d366ab:ef2e3d94
> >
> > =A0 Reshape pos'n : 502815488 (479.52 GiB 514.88 GB)
> > =A0 Delta Devices : 1 (4->5)
> >
> > =A0=A0=A0 Update Time : Sat Feb 19 22:32:04 2011
> > =A0=A0=A0=A0=A0=A0 Checksum : 8aa7d094 - correct
> > =A0=A0=A0=A0=A0=A0=A0=A0 Events : 133609
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
> > =A0=A0=A0=A0 Chunk Size : 64K
> >
> > =A0=A0=A0 Array Slot : 0 (0, failed, failed, failed, 3, 4)
> > =A0=A0 Array State : U__uu 3 failed

 Reshape pos'n, Events, and Array State are identical to sda1.
So these two are in agreement.


> > bernstein@server:~$ sudo mdadm --examine /dev/md0
> > /dev/md0:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
> > =A0=A0=A0=A0=A0=A0=A0 Version : 1.2
> > =A0=A0=A0 Feature Map : 0x4
> > =A0=A0=A0=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041a523
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : master:public
> > =A0 Creation Time : Sat Jan 22 00:15:43 2011
> > =A0=A0=A0=A0 Raid Level : raid5
> > =A0=A0 Raid Devices : 5
> >
> > =A0Avail Dev Size : 1953541616 (931.52 GiB 1000.21 GB)
> > =A0=A0=A0=A0 Array Size : 7814085120 (3726.05 GiB 4000.81 GB)
> > =A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
> > =A0=A0=A0 Data Offset : 272 sectors
> > =A0=A0 Super Offset : 8 sectors
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
> > =A0=A0=A0 Device UUID : 83ecd60d:f3947a5e:a69c4353:3c4a0893
> >
> > =A0 Reshape pos'n : 502815488 (479.52 GiB 514.88 GB)
> > =A0 Delta Devices : 1 (4->5)
> >
> > =A0=A0=A0 Update Time : Sat Feb 19 22:32:04 2011
> > =A0=A0=A0=A0=A0=A0 Checksum : 1bbf913b - correct
> > =A0=A0=A0=A0=A0=A0=A0=A0 Events : 133609
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
> > =A0=A0=A0=A0 Chunk Size : 64K
> >
> > =A0=A0=A0 Array Slot : 4 (0, failed, failed, failed, 3, 4)
> > =A0=A0 Array State : u__Uu 3 failed

again, exactly the same as sda1 and sdc1.

> > bernstein@server:~$ sudo mdadm --examine /dev/md1
> > /dev/md1:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
> > =A0=A0=A0=A0=A0=A0=A0 Version : 1.2
> > =A0=A0=A0 Feature Map : 0x4
> > =A0=A0=A0=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041a523
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : master:public
> > =A0 Creation Time : Sat Jan 22 00:15:43 2011
> > =A0=A0=A0=A0 Raid Level : raid5
> > =A0=A0 Raid Devices : 5
> >
> > =A0Avail Dev Size : 1953541616 (931.52 GiB 1000.21 GB)
> > =A0=A0=A0=A0 Array Size : 7814085120 (3726.05 GiB 4000.81 GB)
> > =A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
> > =A0=A0=A0 Data Offset : 272 sectors
> > =A0=A0 Super Offset : 8 sectors
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
> > =A0=A0=A0 Device UUID : 3c7e2c3f:8b6c7c43:a0ce7e33:ad680bed
> >
> > =A0 Reshape pos'n : 502809856 (479.52 GiB 514.88 GB)
> > =A0 Delta Devices : 1 (4->5)
> >
> > =A0=A0=A0 Update Time : Sat Feb 19 22:30:29 2011
> > =A0=A0=A0=A0=A0=A0 Checksum : 6c591e90 - correct
> > =A0=A0=A0=A0=A0=A0=A0=A0 Events : 133603
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
> > =A0=A0=A0=A0 Chunk Size : 64K
> >
> > =A0=A0=A0 Array Slot : 3 (0, failed, failed, 2, 3, 4)
> > =A0=A0 Array State : u_Uuu 2 failed

And here is md1.  Thinks device 2 - sdd1 - has failed.
        Events : 133603 - slightly behind the 3 good devices, be well a=
fter
                                                  sdd1
 Reshape Pos'n : 502809856 - just a little before the 3 good devices to=
o.

>=20
> so obviously not /dev/sdd1 failed. however (due to that silly forced
> assembly?!) the reshape pos'n field of md0, sd[ac]1 differs from md1 =
a
> few bytes, resulting in an inconsistent state...

The way I read it is:

  sdd1 failed first - shortly after Sat Feb 19 22:23:09 2011 - the upda=
te
                      time on sdd1
reshape continued until some time between Sat Feb 19 22:30:29 2011
and Sat Feb 19 22:32:04 2011 when md1 had a failure.
The reshape couldn't continue now, so it stopped.

So the data on sdd1 is only (there has been about 8 minutes of reshape =
since
then) and cannot be used.
The data on md1 is very close to the rest.  The data that was in the pr=
ocess
of being relocated lives in two locations on the 'good' drives, both th=
e new
and the old.  It only lives in the 'old' location on md1.

So what we need to do is re-assemble the array, but telling it that the
reshape has only gone as far as md1 thinks it has.  This will make sure=
 it
repeats that last part of the reshape.

mdadm -Af should do that BUT IT DOESN'T.  Assuming I have thought throu=
gh
this properly (and I should go through it again with more care), mdadm =
won't
do the right thing for you.  I need to get it to handle 'reshape' speci=
ally
when doing a --force assemble.

>=20
> > bernstein@server:~$ sudo mdadm --assemble /dev/md2 /dev/sda1 /dev/m=
d0 /dev/md1 /dev/sdd1 /dev/sdc1
> >
> > mdadm: /dev/md2 assembled from 3 drives - not enough to start the a=
rray.
> > bernstein@server:~$ cat /proc/mdstat
> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
] [raid4] [raid10]
> > md2 : inactive sdc1[0](S) sda1[5](S) md0[4](S) md1[3](S) sdd1[1](S)
> > =A0=A0=A0=A0=A0 4883823704 blocks super 1.2
> >
> > md1 : active raid0 sdf1[0] sdg1[1]
> > =A0=A0=A0=A0=A0 976770944 blocks super 1.2 64k chunks
> >
> > md0 : active raid0 sdb1[1] sdh1[0]
> > =A0=A0=A0=A0=A0 976770944 blocks super 1.2 64k chunks
> >
> > unused devices: <none>
>=20
> i do have a backup but since recovery from it takes a few days, i'd
> like to know if there is a way to recover the array or if it's
> completely lost.
>=20
> Any suggestions gratefully received,

The fact that you have a backup is excellent.  You might need it, but I=
 hope
not.

I would like to provide you with a modified version of mdadm which you =
can
then user to --force assemble the array.  It should be able to get you =
access
to all your data.
The array will be degraded and will finish reshape in that state.  Then=
 you
will need to add sdd1 back in (Assuming you are confident that it works=
) and
it will be rebuilt.

Just to go through some of the numbers...

Chunk size is 64K.  Reshape was 4->5, so 3 -> 4 data disks.
So old stripes have 192K, new stripes have 256K.

The 'good' disks think reshape has reached 502815488K which is
1964123 new stripes. (2618830.66 old stripes)
md1 thinks reshape has only reached 489510400K which is 1912150
new stripes (2549533.33 old stripes).

So of the 51973 stripes that have been reshaped since the last metadata
update on sdd1, some will have been done on sdd1, but some not, and we =
don't
really know how many.  But it is perfectly safe to repeat those stripes
as all writes to that region will have been suspended (and you probably
weren't writing anyway).

So I need to change the loop in Assemble.c which calls ->update_super
with "force-one" to also make sure the reshape_position in the 'chosen'
superblock match the oldest 'forced' superblock.

So if you are able to wait a day, I'll try to write a patch first thing
tomorrow and send it to you.

Thanks for the excellent problem report.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
