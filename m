From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm: failed devices become spares!
Date: Wed, 19 May 2010 11:45:37 +1000
Message-ID: <20100519114537.551bc086@notabene.brown>
References: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com>
	<201005172010.36157.pierre@vigneras.name>
	<20100518113016.1981a08c@notabene.brown>
	<201005190107.41002.pierre@vigneras.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201005190107.41002.pierre@vigneras.name>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre =?UTF-8?B?VmlnbsOpcmFz?= <pierre@vigneras.name>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 19 May 2010 01:07:40 +0200
Pierre Vign=C3=A9ras <pierre@vigneras.name> wrote:

> On mardi 18 mai 2010, Neil Brown wrote:
> > On Mon, 17 May 2010 20:10:36 +0200
> >=20
> > Pierre Vign=C3=A9ras <pierre@vigneras.name> wrote:
> > > Did I miss something, or is there something really strange happen=
ing
> > > there?
> >=20
> > Something strange...
> > I cannot explain the 'SpareActive' messages.
> > Most of the rest makes sense.
> >=20
> > You had a RAID10 - 4 drives in near=3D2 mode.  So the first two dis=
ks contain
> > identical data, and the second two are also identical and contain t=
he rest.
> > The second device failed due to a write error.
> > Why it seemed to become a spare I'm not sure.  I'm not all sure it =
did
> > become a spare immediately- your logs aren't conclusive on that poi=
nt.
> > It did eventually become a spare, but that could be because you "re=
moved
> >  and added the devices" which would have changed them from 'fail' t=
o
> >  'spares'.
> >=20
> > Then the first device in the array reported an error and so was fai=
led.
> > After this you would not be able to read or write to the even chunk=
s of the
> > array, xfs noticed and complained.
> >=20
> > By this time sdf1 seemed to be a spare so it gave recovery a try.  =
The
> > recovery process discovered there was nowhere to read good data fro=
m and
> > immediately gave up.
> >=20
> > However if the devices really are OK, then sdf1 and sdc1 should con=
tain
> > identical data (except the superblock would be slightly different.
> > You could check this with "cmp -l", though that might not be very
> >  efficient. Also sdd1 and sde1 should be identical.
>=20
> Well, actually, here is what I have:
>=20
> phobos:~# mdadm --examine /dev/sd[c-f]1
> /dev/sdc1:                            =20
>           Magic : a92b4efc            =20
>         Version : 00.90.00            =20
>            UUID : b34f4192:f823df58:24bf28c1:396de87f (local to host =
phobos)
>   Creation Time : Thu Aug  6 01:59:44 2009                           =
      =20
>      Raid Level : raid10                                             =
      =20
>   Used Dev Size : 312568576 (298.09 GiB 320.07 GB)                   =
      =20
>      Array Size : 625137152 (596.18 GiB 640.14 GB)                   =
      =20
>    Raid Devices : 4                                                  =
      =20
>   Total Devices : 4                                                  =
      =20
> Preferred Minor : 2                                                  =
      =20
>=20
>     Update Time : Tue Apr 13 19:22:21 2010
>           State : clean                  =20
> Internal Bitmap : present                =20
>  Active Devices : 2                      =20
> Working Devices : 4                      =20
>  Failed Devices : 0                      =20
>   Spare Devices : 2                      =20
>        Checksum : 5baf7939 - correct     =20
>          Events : 90612                  =20
>=20
>          Layout : near=3D2, far=3D1
>      Chunk Size : 64K         =20
>=20
>       Number   Major   Minor   RaidDevice State
> this     2       8       33        2      active sync   /dev/sdc1
>=20
>    0     0       0        0        0      removed
>    1     1       0        0        1      faulty removed
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       65        3      active sync   /dev/sde1
>    4     4       8       81        4      spare   /dev/sdf1     =20
>    5     5       8       49        5      spare   /dev/sdd1     =20
> /dev/sdd1:                                                      =20
>           Magic : a92b4efc                                      =20
>         Version : 00.90.00                                      =20
>            UUID : b34f4192:f823df58:24bf28c1:396de87f (local to host =
phobos)
>   Creation Time : Thu Aug  6 01:59:44 2009                           =
      =20
>      Raid Level : raid10                                             =
      =20
>   Used Dev Size : 312568576 (298.09 GiB 320.07 GB)                   =
      =20
>      Array Size : 625137152 (596.18 GiB 640.14 GB)                   =
      =20
>    Raid Devices : 4                                                  =
      =20
>   Total Devices : 4                                                  =
      =20
> Preferred Minor : 2                                                  =
      =20
>=20
>     Update Time : Tue Apr 13 19:22:21 2010
>           State : clean                  =20
> Internal Bitmap : present                =20
>  Active Devices : 2                      =20
> Working Devices : 4                      =20
>  Failed Devices : 0                      =20
>   Spare Devices : 2                      =20
>        Checksum : 5baf7949 - correct     =20
>          Events : 90612                  =20
>=20
>          Layout : near=3D2, far=3D1
>      Chunk Size : 64K         =20
>=20
>       Number   Major   Minor   RaidDevice State
> this     5       8       49        5      spare   /dev/sdd1
>=20
>    0     0       0        0        0      removed
>    1     1       0        0        1      faulty removed
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       65        3      active sync   /dev/sde1
>    4     4       8       81        4      spare   /dev/sdf1     =20
>    5     5       8       49        5      spare   /dev/sdd1     =20
> /dev/sde1:                                                      =20
>           Magic : a92b4efc                                      =20
>         Version : 00.90.00                                      =20
>            UUID : b34f4192:f823df58:24bf28c1:396de87f (local to host =
phobos)
>   Creation Time : Thu Aug  6 01:59:44 2009                           =
      =20
>      Raid Level : raid10                                             =
      =20
>   Used Dev Size : 312568576 (298.09 GiB 320.07 GB)                   =
      =20
>      Array Size : 625137152 (596.18 GiB 640.14 GB)                   =
      =20
>    Raid Devices : 4                                                  =
      =20
>   Total Devices : 4                                                  =
      =20
> Preferred Minor : 2                                                  =
      =20
>=20
>     Update Time : Tue Apr 13 19:22:21 2010
>           State : clean                  =20
> Internal Bitmap : present                =20
>  Active Devices : 2                      =20
> Working Devices : 4                      =20
>  Failed Devices : 0                      =20
>   Spare Devices : 2                      =20
>        Checksum : 5baf795b - correct     =20
>          Events : 90612                  =20
>=20
>          Layout : near=3D2, far=3D1
>      Chunk Size : 64K         =20
>=20
>       Number   Major   Minor   RaidDevice State
> this     3       8       65        3      active sync   /dev/sde1
>=20
>    0     0       0        0        0      removed
>    1     1       0        0        1      faulty removed
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       65        3      active sync   /dev/sde1
>    4     4       8       81        4      spare   /dev/sdf1
>    5     5       8       49        5      spare   /dev/sdd1
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : b34f4192:f823df58:24bf28c1:396de87f (local to host =
phobos)
>   Creation Time : Thu Aug  6 01:59:44 2009
>      Raid Level : raid10
>   Used Dev Size : 312568576 (298.09 GiB 320.07 GB)
>      Array Size : 625137152 (596.18 GiB 640.14 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 2
>=20
>     Update Time : Tue Apr 13 19:22:21 2010
>           State : clean
> Internal Bitmap : present
>  Active Devices : 2
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 2
>        Checksum : 5baf7967 - correct
>          Events : 90612
>=20
>          Layout : near=3D2, far=3D1
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     4       8       81        4      spare   /dev/sdf1
>=20
>    0     0       0        0        0      removed
>    1     1       0        0        1      faulty removed
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       65        3      active sync   /dev/sde1
>    4     4       8       81        4      spare   /dev/sdf1
>    5     5       8       49        5      spare   /dev/sdd1
> phobos:~#
>=20
> > I suggest that you try:
> >=20
> >  mdadm -S /dev/md2
> >  mdadm -C /dev/md2 -l 10 -n 4 -c 64 -e 0.90 /dev/sdc1 missing /dev/=
sdd1
> >  missing  --assume-clean
> >=20
> > and then see what the data on md2 looks like.
> > You could equally try sdf1 in place of sdc1, or sde1 in place of sd=
d1
> > (make sure you double check the device names, don't assume I got th=
en
> >  right).
>=20
> So, I double checked the names. ;-)
>=20
> I first tried to get which devices  where mirrors using cmp -l (thank=
s for=20
> that command I didn't know), and here is the (strange) result:
>=20
> phobos:~# time cmp -l /dev/sdc1 /dev/sdd1 > /tmp/cmp-sdc1-sdd1
> ^C                                                           =20
>=20
> real    0m56.337s
> user    0m52.539s
> sys     0m3.016s=20
> phobos:~# time cmp -l /dev/sdc1 /dev/sde1 > /tmp/cmp-sdc1-sde1
> ^C                                                           =20
>=20
> real    0m54.733s
> user    0m0.380s=20
> sys     0m7.688s=20
> phobos:~# time cmp -l /dev/sdc1 /dev/sdf1 > /tmp/cmp-sdc1-sdf1
> ^C
>=20
> real    0m58.236s
> user    0m54.099s
> sys     0m3.216s
> phobos:~# time cmp -l /dev/sdd1 /dev/sde1 > /tmp/cmp-sdd1-sde1
> ^C
>=20
> real    0m57.932s
> user    0m53.063s
> sys     0m3.284s
> phobos:~# time cmp -l /dev/sdd1 /dev/sdf1 > /tmp/cmp-sdd1-sdf1
> ^C
>=20
> real    0m58.882s
> user    0m26.486s
> sys     0m6.152s
> phobos:~# time cmp -l /dev/sde1 /dev/sdf1 > /tmp/cmp-sde1-sdf1
> ^C
>=20
> real    0m57.996s
> user    0m49.639s
> sys     0m3.100s
> phobos:~# ls -lh /tmp/cmp-sd*
> -rw-r--r-- 1 root root 954M 2010-05-19 00:23 /tmp/cmp-sdc1-sdd1
> -rw-r--r-- 1 root root    0 2010-05-19 00:25 /tmp/cmp-sdc1-sde1
> -rw-r--r-- 1 root root 982M 2010-05-19 00:27 /tmp/cmp-sdc1-sdf1
> -rw-r--r-- 1 root root 964M 2010-05-19 00:28 /tmp/cmp-sdd1-sde1
> -rw-r--r-- 1 root root 466M 2010-05-19 00:30 /tmp/cmp-sdd1-sdf1
> -rw-r--r-- 1 root root 872M 2010-05-19 00:31 /tmp/cmp-sde1-sdf1
> phobos:~#

The fact that sdc1 appear to have the same content as sde1 perfectly ma=
tches
the fact that these two devices think the are devices "2" and "3" in th=
e
array, so they still contain half of your data.  This is good.

The fact that sdf1 appears to match sdd1 partly but not completely sugg=
ests
that they were devices "0" and "1", but that one of them has had other =
stuff
written to it.

It is hard to know based on available information which is the case.

>=20
> Therefore, as far as I understand, /dev/sdc1 does not hold the same d=
ata as=20
> /dev/sdd1 nor /dev/sdf1. Even if this short ~ 1 minute test does not =
prove=20
> anything, there is quite a good probability that /dev/sdc1 and /dev/s=
de1 was=20
> mirrors at some time.
>=20
> What should be considered strange? That sdc1 contains exactly the sam=
e content=20
> than sde1 on that 1 minute scan or that sdd1 and sdf1 are so  differe=
nt (~ 500=20
> MB/1min) ?
>=20
> Therefore, I am not sure that the command you suggested is the good o=
ne:
>=20
> mdadm -C /dev/md2 -l 10 -n 4 -c 64 -e 0.90 /dev/sdc1 missing /dev/sdd=
1 missing =20
> --assume-clean
>=20
> It seems that I only have half the data for sure (sdc1 and sde1), but=
 I don't=20
> know what is the other good part (sdd1 or sdf1)... Is there any way t=
o know?

The way to find out is to try and see.
If you create an array following the above pattern it will not change a=
ny
data on the devices, just the superblock, which you have a record of in=
 this
email now.
So you should try creating an array, run "fsck -n" and see if the files=
ystem
looks OK.  If it does, mount ( -o ro ) and see what it looks like.

Then try the other possibility and see how that compares.
Given the current names of devices, the list given to the mdadm command
should be:

   /dev/sdd1 missing /dev/sdc1 missing
or
   /dev/sdf1 missing /dev/sdc1 missing

Hopefully one of those will mount and fsck successfully.

NeilBrown



>=20
> According to this information, can you confirm that the above command=
 is the=20
> one I should execute?=20
> =20
> > BUT be warned.  Something cause some errors to be reported.  Unless=
 you
> >  find out what that was and fix it, errors will occur again.  I hav=
e no
> >  idea what might have caused those errors.  Bad media? bad controll=
er ? bad
> >  usb controller? bad luck?
>=20
> Well, all of those maybe! Anyway, I will consider using BBR. I have t=
he=20
> feeling that on such mass market USB drives of 1TB, even the internal=
=20
> "hardware" BBR is not sufficient. There are too much errors (at least=
 that is=20
> what my log suggests me)... It's a shame that BBR is not well documen=
ted and=20
> not as easy to set up using mdadm than using EVMS. =20
>=20
> > I wouldn't write new data, or even perform a recovery until you are=
 quite
> > confident of the devices.
>=20
> Sure.
> =20
> > NeilBrown
>=20
> Again, thanks a lot!
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
