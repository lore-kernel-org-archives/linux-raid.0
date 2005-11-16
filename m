From: Guillaume Filion <gfk@logidac.com>
Subject: Re: Crooked raid
Date: Wed, 16 Nov 2005 11:39:15 -0500
Message-ID: <437B60B3.5030601@logidac.com>
References: <200511161541.jAGFfBjZ027253@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200511161541.jAGFfBjZ027253@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Burgess a =E9crit :
>>I did this, rebooted and the system wouldn't reboot. Yikes! I was=20
>>however able to boot with giving root=3D/dev/hdc2 to the kernel.
>=20
> I didn't realize we were talking about your root filesystem else I wo=
uld have
> been more cautious (or maybe just kept my mouth shut). Glad you got i=
t to boot!

Hey no problem there. I prefer having someone trying to help me and=20
having problems than getting no help at all.

> Do you recall why it didn't want to boot?=20

I don't remember the exact errors, I you need them, I can get them=20
tonight when I get back home. From memory, I got the first error very=20
early in the boot process -- before trying to load any md stuff -- the=20
error was something like:
Unable to boot from "0900"

Then I tried with an older kernel. This older kernel is bigger and I=20
suspect that it has the raid stuff compiled in. With this kernel, md=20
loaded and then I got this error:
Can't find Superblock on disk..

I was finally able to boot with the older kernel by specifying boot=3D/=
dev/hd2

It looks to me that it's still trying to mount md0 from hdc rather than=
=20
hdc2.

> What are the kernel command line args?

I don't think there's any. append=3D is commented out in lilo.conf

> Did you check for a bootup script somewhere screwing things up?
>   egrep -i 'raid|mdadm' /etc/rc.d/* /etc/rc.d/init.d/* /etc/*

There's /etc/init.d/mdadm-raid that starts "/sbin/mdadm -A -s -a" if=20
/etc/mdadm/mdadm.conf exists -- and it does, see below.

There's /etc/init.d/raid2 which would start raids from /etc/raidtab but=
=20
  there's no raidtab and /etc/default/raid2 says to disable this.

Other than that I have this in /etc/modules.conf :
root@ali:~# egrep -i 'raid|mdadm' /etc/modules.conf
### update-modules: start processing /etc/modutils/raidtools2
alias md-personality-2 raid0
alias md-personality-3 raid1
alias md-personality-4 raid5
### update-modules: end processing /etc/modutils/raidtools2

> And did you already say that you don't have a mdadm.conf file?

I have a /etc/mdadm/mdadm.conf file:
DEVICE /dev/hdc2 /dev/hdg2
ARRAY /dev/md0 level=3Draid1 num-devices=3D2=20
UUID=3Db013e39b:ec629293:98df4657:97255939

> You might need to pick which mirror (hdc2 or hdg2) you trust more as =
your root
> filesystem (since they may be different now) and then start over and =
follow the
> HowTo for making a normal root filesystem into a raided one.
>=20
> But if you can't find out why the system is still looking at hdc then=
 it might
> all happen again...
>=20
>=20
>>Here's the relevant part of dmesg:
>>device-mapper: 4.1.1-ioctl (2004-04-07) initialised: dm-devel@redhat.=
com
>>md: can not import ide/host0/bus1/target0/lun0/part2, has active inod=
es!
>=20
> I guess this is because you booted from it as hdc2 so its busy and md=
adm
> won't try to use it?

Yeah, that makes sense.

> Do you know why the system sometimes says ide/host0/bus1/target0/lun0=
/part2 and
> sometimes says hd[cg]2 ? Its confusing...

No, that's something that confuses me too. I installed devfsd sometime=20
in the past but deinstalled it because I didn't need it.

> Any other raid superblocks around?
>   for dev in /dev/hd? /dev/hd??; do mdadm -E $dev; done

root@ali:~# for dev in /dev/hd? /dev/hd??; do mdadm -E $dev; done 2>&1 =
|=20
egrep -v 'cannot|small'
mdadm: No super block found on /dev/hdc (Expected magic a92b4efc, got=20
00000000)
mdadm: No super block found on /dev/hde (Expected magic a92b4efc, got=20
69686766)
mdadm: No super block found on /dev/hdg (Expected magic a92b4efc, got=20
00000000)
mdadm: No super block found on /dev/hdc1 (Expected magic a92b4efc, got=20
ffffffff)
/dev/hdc2:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : b013e39b:ec629293:98df4657:97255939
   Creation Time : Wed Dec 29 21:32:26 2004
      Raid Level : raid1
    Raid Devices : 2
   Total Devices : 3
Preferred Minor : 0

     Update Time : Tue Nov 15 16:01:25 2005
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 0
        Checksum : ff92c98b - correct
          Events : 0.103


       Number   Major   Minor   RaidDevice State
this     1      22        2        1      active sync   /dev/hdc2

    0     0      34        2        0      active sync   /dev/hdg2
    1     1      22        2        1      active sync   /dev/hdc2
mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc, got=20
00000000)
mdadm: No super block found on /dev/hdg1 (Expected magic a92b4efc, got=20
c8938b73)
/dev/hdg2:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : b013e39b:ec629293:98df4657:97255939
   Creation Time : Wed Dec 29 21:32:26 2004
      Raid Level : raid1
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Tue Nov 15 17:29:57 2005
           State : active
  Active Devices : 1
Working Devices : 1
  Failed Devices : 1
   Spare Devices : 0
        Checksum : ff92de3d - correct
          Events : 0.104


       Number   Major   Minor   RaidDevice State
this     0      34        2        0      active sync   /dev/hdg2

    0     0      34        2        0      active sync   /dev/hdg2
    1     1       0        0        1      faulty removed



> And any raid autodetect partitions around?
>   fdisk -l | grep raid

fdisk -l doesn't output anything.

One thing that might be a clue about the problem is the warnings that I=
=20
get when I run lilo -v:
root@ali:~# lilo -v
LILO version 22.6.1, Copyright (C) 1992-1998 Werner Almesberger
Development beyond version 21 Copyright (C) 1999-2004 John Coffman
Released 17-Nov-2004, and compiled at 20:01:15 on Sep 29 2005
Debian GNU/Linux

Reading boot sector from /dev/hde
Warning: '/proc/partitions' does not match '/dev' directory structure.
     Name change: '/dev/ide/host2/bus1/target0/lun0/disc' -> '/dev/hdg'
     Name change: '/dev/ide/host2/bus1/target0/lun0/part1' -> '/dev/hdg=
1'
Warning: Kernel & BIOS return differing head/sector geometries for=20
device 0x81
     Kernel: 23989 cylinders, 16 heads, 63 sectors
       BIOS: 1024 cylinders, 255 heads, 63 sectors
     Name change: '/dev/ide/host2/bus1/target0/lun0/part2' -> '/dev/hdg=
2'
     Name change: '/dev/ide/host2/bus0/target0/lun0/disc' -> '/dev/hde'
     Name change: '/dev/ide/host2/bus0/target0/lun0/part1' -> '/dev/hde=
1'
     Name change: '/dev/ide/host0/bus1/target0/lun0/disc' -> '/dev/hdc'
     Name change: '/dev/ide/host0/bus1/target0/lun0/part1' -> '/dev/hdc=
1'
     Name change: '/dev/ide/host0/bus1/target0/lun0/part2' -> '/dev/hdc=
2'
     Name change: '/dev/md/0' -> '/dev/md0'
/boot/boot.1600 exists - no master disk volume ID record backup copy ma=
de.
Backup copy of master disk volume ID record in /boot/boot.2200
=2E..

In case you need to see it, /proc/partitions looks like this:
root@ali:~# cat /proc/partitions
major minor  #blocks  name     rio rmerge rsect ruse wio wmerge wsect=20
wuse running use aveq

   34     0   78150744 ide/host2/bus1/target0/lun0/disc 38 240 688 190 =
3=20
0 12 0 -166 22379007 12182291
   34     1     642568 ide/host2/bus1/target0/lun0/part1 9 12 168 60 0 =
0=20
0 0 0 60 60
   34     2   77508144 ide/host2/bus1/target0/lun0/part2 14 127 288 80 =
1=20
0 8 0 0 80 80
   33     0     251392 ide/host2/bus0/target0/lun0/disc 400 713 2226 76=
0=20
4330 3059 14778 146790 0 128510 147550
   33     1     251632 ide/host2/bus0/target0/lun0/part1 387 626 2026=20
720 4328 3059 14774 146710 0 128390 147430
   22     0   78150744 ide/host0/bus1/target0/lun0/disc 183212 108424=20
2332636 2782770 503378 1212603 13756060 27924377 -167 22375017 20476641
   22     1     642568 ide/host0/bus1/target0/lun0/part1 62 104 1328 40=
0=20
287 2195 21104 13580 0 2430 13980
   22     2   77508144 ide/host0/bus1/target0/lun0/part2 183135 108219=20
2331076 2782170 503089 1210408 13734952 27910797 0 2151990 30704027
    9     0   77508032 md/0 0 0 0 0 0 0 0 0 0 0 0

Thanks,
GFK's
--=20
Guillaume Filion, ing. jr
Logidac Tech., Beaumont, Qu=E9bec, Canada - http://logidac.com/
PGP Key and more: http://guillaume.filion.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
