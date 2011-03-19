From: NeilBrown <neilb@suse.de>
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 12:42:47 +1100
Message-ID: <20110319124247.41bac36a@notabene.brown>
References: <201103181549.20835.xavier@alternatif.org>
	<201103182350.19281.xavier@alternatif.org>
	<20110319102039.52cc2282@notabene.brown>
	<201103190059.08093.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103190059.08093.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: Xavier Brochard <xavier@alternatif.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 19 Mar 2011 00:59:07 +0100 Xavier Brochard <xavier@alternatif.o=
rg>
wrote:

> Le samedi 19 mars 2011 00:20:39 NeilBrown, vous avez =E9crit :
> > On Fri, 18 Mar 2011 23:50:18 +0100 Xavier Brochard <xavier@alternat=
if.org>
> > > Le vendredi 18 mars 2011 23:22:51, NeilBrown  =E9crivait :
> > > > On Fri, 18 Mar 2011 21:12:49 +0100 Xavier Brochard
> > > > > Le vendredi 18 mars 2011 18:22:34 hansbkk@gmail.com, vous ave=
z =E9crit :
> > > > > > On Fri, Mar 18, 2011 at 9:49 PM, Xavier Brochard
> > > > > > <xavier@alternatif.org>
> > > > >=20
> > > > > wrote:
> > > > > > > disk order is mixed between each boot - even with live-cd=
=2E
> > > > > > > is that normal?
> > > > > >=20
> > > > > > If nothing is changing and the order is swapping really eve=
ry boot,
> > > > > > then IMO that is odd.
> > > > >=20
> > > > > nothing has changed, except kernel minor version
> > > >=20
> > > > Yet you don't tell us what the kernel minor version changed fro=
m or to.
> > >=20
> > > Previously it was ubuntu 2.6.32-27-server or 2.6.32-28-server and=
 now it
> > > is ubuntu 2.6.32-29.58-server 2.6.32.28+drm33.13
> > >=20
> > > > That may not be important, but it might and you obviously don't=
 know
> > > > which. It is always better to give too much information rather =
than
> > > > not enough.
>=20
> > >=20
> > > Here's full output of mdadm --examine /dev/sd[cdefg]1
> > > As you can see, disks sdc, sdd and sde claims to be different, is=
 it a
> > > problem?
> >=20
> > Where all of these outputs collected at the same time?
>=20
> yes
>=20
> > They seem
> > inconsistent.
>=20
> > In particular, sdc1 has a higher 'events' number than the others (1=
54 vs
> > 102) yet an earlier Update Time.  It also thinks that the array is
> > completely failed.
>=20
> When I removed that disk (sdc is number 2) and another one (I tried w=
ith=20
> different disks), all other disks display (with mdadm -E):
> 0	Active
> 1	Active
> 2	Active
> 3 	Active
> 4	Spare
>=20
> But when I removed that disk (#2) and #0, it start to recover and all=
 other=20
> disks display (with mdadm -E):
> 0	Removed
> 1	Active
> 2	Faulty removed
> 3	Active
> 4	Spare
> That looks coherent for me, now.
>=20
> > So I suspect that device is badly confused and you probably want to=
 zero
> > it's metadata ... but don't do that too hastily.
> >=20
> > All the other devices think the array is working correctly with a f=
ull
> > compliment of devices.  However there is no device which claims to
> > be "RaidDevice 2" - except sdc1 and it is obviously confused..
> >=20
> > The device name listed in the table at the end of --examine output.
> > It is the name that the device had when the metadata was last writt=
en.  And
> > device names can change on reboot.
> > The fact that the names don't line up suggest that the metadata has=
n't been
> > written since the last reboot - so presumably you aren't really usi=
ng the
> > array.(???)
> >=20
> > [the newer 1.x metadata format doesn't try to record the names of d=
evices
> > in the superblock so it doesn't result in some of this confusion).
> >=20
> >=20
> > Based on your earlier email, it would appear that the device discov=
ery for
> > some of your devices is happening in parallel at boot time, so or o=
rdering
> > could be random - each time you boot you get a different order.  Th=
is will
> > not confuse md or mdadm - they look at the content of the devices r=
ather
> > than the name.
> > If you want a definitive name for each device, it might be a good i=
dea to
> > look in /dev/disk/by-path or /dev/disk/by-id and use names from the=
re.
> >=20
> > Could you please sent a complete output of:
> >=20
> >    cat /proc/mdstat
> >    mdadm -D /dev/md0
> >    mdadm -E /dev/sd?1
> >=20
> > all collected at the same time.  Then I will suggest if there is an=
y action
> > you should take to repair anything.
>=20
> Here it is, thankyou for you help
>=20

I suggest you:

  mdadm --zero /dev/sdb1

having first double-checked that sdb1 is the devices with Events of 154=
,

then

 mdadm -S /dev/md0
 mdadm -As /dev/md0


and let the  array rebuild the spare.
Then check the data and make sure it is all good.
Then add /dev/sdb1 back in as the spare
  mdadm /dev/md0 --add /dev/sdb1

and everything should be fine - providing you don't hit any hardware er=
rors
etc.


NeilBrown




> mdstat:
> =3D=3D=3D=3D=3D
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4]=20
> [raid10]=20
> md0 : inactive sdb1[2](S) sdf1[4](S) sdd1[3](S) sdc1[1](S) sde1[0](S)
>       2441919680 blocks
>       =20
> unused devices: <none>
> =3D=3D=3D=3D
> obviously, mdadm -D /dev/md0 output nothing
>=20
> mdadm -E /dev/sd?1
> =3D=3D=3D=3D
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
>   Creation Time : Sun Jan  2 16:41:45 2011
>      Raid Level : raid10
>   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>      Array Size : 976767872 (931.52 GiB 1000.21 GB)
>    Raid Devices : 4
>   Total Devices : 5
> Preferred Minor : 0
>=20
>     Update Time : Wed Mar 16 09:50:03 2011
>           State : clean
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : ec151590 - correct
>          Events : 154
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     2       8       65        2      active sync   /dev/sde1
>=20
>    0     0       0        0        0      removed
>    1     1       0        0        1      faulty removed
>    2     2       8       65        2      active sync   /dev/sde1
>    3     3       0        0        3      faulty removed
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
>   Creation Time : Sun Jan  2 16:41:45 2011
>      Raid Level : raid10
>   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>      Array Size : 976767872 (931.52 GiB 1000.21 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>=20
>     Update Time : Fri Mar 18 16:37:45 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 1
>        Checksum : ec181672 - correct
>          Events : 107
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     1       8       17        1      active sync   /dev/sdb1
>=20
>    0     0       0        0        0      removed
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       0        0        2      faulty removed
>    3     3       8       49        3      active sync   /dev/sdd1
>    4     4       8       33        4      spare   /dev/sdc1
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
>   Creation Time : Sun Jan  2 16:41:45 2011
>      Raid Level : raid10
>   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>      Array Size : 976767872 (931.52 GiB 1000.21 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>=20
>     Update Time : Fri Mar 18 16:37:45 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 1
>        Checksum : ec181696 - correct
>          Events : 107
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     3       8       49        3      active sync   /dev/sdd1
>=20
>    0     0       0        0        0      removed
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       0        0        2      faulty removed
>    3     3       8       49        3      active sync   /dev/sdd1
>    4     4       8       33        4      spare   /dev/sdc1
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
>   Creation Time : Sun Jan  2 16:41:45 2011
>      Raid Level : raid10
>   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>      Array Size : 976767872 (931.52 GiB 1000.21 GB)
>    Raid Devices : 4
>   Total Devices : 5
> Preferred Minor : 0
>=20
>     Update Time : Wed Mar 16 07:43:45 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 1
>        Checksum : ec14f740 - correct
>          Events : 102
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     0       8       33        0      active sync   /dev/sdc1
>=20
>    0     0       8       33        0      active sync   /dev/sdc1
>    1     1       8       49        1      active sync   /dev/sdd1
>    2     2       8       65        2      active sync   /dev/sde1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8       97        4      spare
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
>   Creation Time : Sun Jan  2 16:41:45 2011
>      Raid Level : raid10
>   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>      Array Size : 976767872 (931.52 GiB 1000.21 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>=20
>     Update Time : Fri Mar 18 16:37:45 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 1
>        Checksum : ec181682 - correct
>          Events : 107
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     4       8       33        4      spare   /dev/sdc1
>=20
>    0     0       0        0        0      removed
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       0        0        2      faulty removed
>    3     3       8       49        3      active sync   /dev/sdd1
>    4     4       8       33        4      spare   /dev/sdc1
> =3D=3D=3D=3D
>=20
>=20
>=20
> Xavier
> xavier@alternatif.org - 09 54 06 16 26

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
