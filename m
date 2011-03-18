From: Xavier Brochard <xavier@alternatif.org>
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 00:06:56 +0100
Message-ID: <201103190006.56887.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: hansbkk@gmail.com
List-Id: linux-raid.ids

Hello,

Le vendredi 18 mars 2011 23:22:51, NeilBrown  =E9crivait :
> On Fri, 18 Mar 2011 21:12:49 +0100 Xavier Brochard <xavier@alternatif=
=2Eorg>
> > Le vendredi 18 mars 2011 18:22:34 hansbkk@gmail.com, vous avez =E9c=
rit :
> > > On Fri, Mar 18, 2011 at 9:49 PM, Xavier Brochard
> > > <xavier@alternatif.org>
> >=20
> > wrote:
> > > > disk order is mixed between each boot - even with live-cd.
> > > > is that normal?
> > >=20
> > > If nothing is changing and the order is swapping really every boo=
t,
> > > then IMO that is odd.
> >=20
> > nothing has changed, except kernel minor version
>=20
> Yet you don't tell us what the kernel minor version changed from or t=
o.

Previously it was ubuntu 2.6.32-27-server or 2.6.32-28-server and now i=
t is=20
ubuntu 2.6.32-29.58-server 2.6.32.28+drm33.13

> That may not be important, but it might and you obviously don't know =
which.
> It is always better to give too much information rather than not enou=
gh.

Again sorry, my wednesday email was long and I thought it was too long!=
=20

> > exactly, in my case mdadm --examine output is somewhat weird as it =
shows:
> > /dev/sde1
> > this     0       8       33        0      active sync   /dev/sdd1
> > /dev/sdd1
> > this     0       8       33        0      active sync   /dev/sdc1
> > /dev/sdc1
> > this     0       8       33        0      active sync   /dev/sde1
> > and /dev/sdf1 as sdf1
>=20
> You are hiding lots of details again...
>=20
> Are these all from different arrays?  They all claim to be 'device 0'=
 of
> some array.

They are all from same md RAID10 array

> Infact,  "8, 33" is *always* /dev/sdc1,  so I think the above lines h=
ave
> been edited by hand because I'm 100% certain mdadm didn't output them=
=2E

You're right, I'm sorry. I  have copied this line, just changing the /d=
ev/sd?

Here's full output of mdadm --examine /dev/sd[cdefg]1
As you can see, disks sdc, sdd and sde claims to be different, is it a =
problem?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
  Creation Time : Sun Jan  2 16:41:45 2011
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Wed Mar 16 09:50:03 2011
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 2
  Spare Devices : 0
       Checksum : ec151590 - correct
         Events : 154

         Layout : near=3D2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       0        0        3      faulty removed
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
  Creation Time : Sun Jan  2 16:41:45 2011
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Wed Mar 16 07:43:45 2011
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1
       Checksum : ec14f740 - correct
         Events : 102

         Layout : near=3D2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       81        3      active sync   /dev/sdf1
   4     4       8       97        4      spare   /dev/sdg1
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
  Creation Time : Sun Jan  2 16:41:45 2011
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Wed Mar 16 07:43:45 2011
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1
       Checksum : ec14f752 - correct
         Events : 102

         Layout : near=3D2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       81        3      active sync   /dev/sdf1
   4     4       8       97        4      spare   /dev/sdg1
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
  Creation Time : Sun Jan  2 16:41:45 2011
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Wed Mar 16 07:43:45 2011
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1
       Checksum : ec14f776 - correct
         Events : 102

         Layout : near=3D2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       81        3      active sync   /dev/sdf1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       81        3      active sync   /dev/sdf1
   4     4       8       97        4      spare   /dev/sdg1
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : b784237b:5a021f4d:4cf004e3:2cb521cf
  Creation Time : Sun Jan  2 16:41:45 2011
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Wed Mar 16 07:43:45 2011
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1
       Checksum : ec14f782 - correct
         Events : 102

         Layout : near=3D2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       97        4      spare   /dev/sdg1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       81        3      active sync   /dev/sdf1
   4     4       8       97        4      spare   /dev/sdg1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


> > I think I can believe mdadm?
>=20
> Yes, you can believe mdadm - but only if you understand what it is sa=
ying,
> and there are times when that is not as easy as one might like....

Specially when a raid system is broken! One mind looks broken too and i=
t's a=20
bit hard to think clearly :-)

Thanks for the help

Xavier
xavier@alternatif.org - 09 54 06 16 26
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
