From: Guillaume Filion <gfk@logidac.com>
Subject: Crooked raid
Date: Tue, 15 Nov 2005 10:20:40 -0500
Message-ID: <4379FCC8.5090903@logidac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Some time ago, I wanted to setup a software RAID-1 between hdc2 and=20
hdg2. However, not being familiar with mdadm and software raid, I made =
a=20
couple of bad commands. I don't remember the exact commands, but it's i=
n=20
  the order of setting /dev/hdc, /dev/hdc2, /dev/hdg and /dev/hdg2 in=20
the same RAID. Because of this, I was getting all sorts of errors in my=
=20
dmesg (see dmesg-broken below), but otherwise the RAID would work fine.

After setting my /etc/mdadm/mdadm.conf to:
DEVICE /dev/hdc2 /dev/hdg2
ARRAY /dev/md0 level=3Draid1 num-devices=3D2=20
UUID=3Db013e39b:ec629293:98df4657:97255939

I don't get theses errors in my dmesg (see dmesg-now), but I can still=20
see incoherent data when looking at md0 -- see the lines Total Devices=20
and Failed Devices in mdadm below.

I tried to
mdadm /dev/md0 --remove /dev/hdc
but without success:
mdadm: hot remove failed for /dev/hdc: No such device or address

I'm wondering what would be the easiest way to correct this. If=20
possible, I'd prefer not having to start from scratch.

I'm running kernel 2.4.27-2-k7 on debian testing and using mdadm v1.12.=
0.

Thanks in advance,
GFK's

=3D=3D=3D=3D=3D=3D=3D=3D=3D dmesg-broken =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
device-mapper: 4.1.1-ioctl (2004-04-07) initialised: dm-devel@redhat.co=
m
VFS: Disk change detected on device 21:00
  /dev/ide/host2/bus0/target0/lun0: p1
VFS: Disk change detected on device 21:00
  /dev/ide/host2/bus0/target0/lun0: p1
  /dev/ide/host2/bus0/target0/lun0: p1
  /dev/ide/host2/bus0/target0/lun0: p1
VFS: Disk change detected on device 21:00
  /dev/ide/host2/bus0/target0/lun0: p1
VFS: Disk change detected on device 21:00
  /dev/ide/host2/bus0/target0/lun0: p1
  [events: 0000005d]
md: bind<ide/host0/bus1/target0/lun0/part2,1>
  [events: 00000027]
md0: WARNING: ide/host0/bus1/target0/lun0/disc appears to be on the sam=
e=20
physical disk as ide/host0/bus1/target0/lun0/part2. True
      protection against single-disk failure might be compromised.
md: bind<ide/host0/bus1/target0/lun0/disc,2>
  [events: 0000002a]
md: bind<ide/host2/bus1/target0/lun0/disc,3>
  [events: 0000005d]
md0: WARNING: ide/host2/bus1/target0/lun0/part2 appears to be on the=20
same physical disk as ide/host2/bus1/target0/lun0/disc. True
      protection against single-disk failure might be compromised.
md: bind<ide/host2/bus1/target0/lun0/part2,4>
md: ide/host2/bus1/target0/lun0/part2's event counter: 0000005d
md: ide/host2/bus1/target0/lun0/disc's event counter: 0000002a
md: ide/host0/bus1/target0/lun0/disc's event counter: 00000027
md: ide/host0/bus1/target0/lun0/part2's event counter: 0000005d
md: superblock update time inconsistency -- using the most recent one
md: freshest: ide/host2/bus1/target0/lun0/part2
md: kicking non-fresh ide/host2/bus1/target0/lun0/disc from array!
md: unbind<ide/host2/bus1/target0/lun0/disc,3>
md: export_rdev(ide/host2/bus1/target0/lun0/disc)
md: kicking non-fresh ide/host0/bus1/target0/lun0/disc from array!
md: unbind<ide/host0/bus1/target0/lun0/disc,2>
md: export_rdev(ide/host0/bus1/target0/lun0/disc)
md0: max total readahead window set to 124k
raid1: device ide/host2/bus1/target0/lun0/part2 operational as mirror 0
raid1: device ide/host0/bus1/target0/lun0/part2 operational as mirror 1
raid1: raid set md0 active with 2 out of 2 mirrors
md: updating md0 RAID superblock on device
md: ide/host2/bus1/target0/lun0/part2 [events: 0000005e]<6>(write)=20
ide/host2/bus1/target0/lun0/part2's sb offset: 77508032
md: ide/host0/bus1/target0/lun0/part2 [events: 0000005e]<6>(write)=20
ide/host0/bus1/target0/lun0/part2's sb offset: 77508032
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D dmesg-now =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
Partition check:
  /dev/ide/host0/bus1/target0/lun0: p1 p2
  /dev/ide/host2/bus0/target0/lun0: p1
  /dev/ide/host2/bus1/target0/lun0: p1 p2
  [events: 00000065]
md: bind<ide/host0/bus1/target0/lun0/part2,1>
  [events: 00000065]
md: bind<ide/host2/bus1/target0/lun0/part2,2>
md: ide/host2/bus1/target0/lun0/part2's event counter: 00000065
md: ide/host0/bus1/target0/lun0/part2's event counter: 00000065
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
raid1: device ide/host2/bus1/target0/lun0/part2 operational as mirror 0
raid1: device ide/host0/bus1/target0/lun0/part2 operational as mirror 1
raid1: raid set md0 active with 2 out of 2 mirrors
md: updating md0 RAID superblock on device
md: ide/host2/bus1/target0/lun0/part2 [events: 00000066]<6>(write)=20
ide/host2/bus1/target0/lun0/part2's sb offset: 77508032
md: ide/host0/bus1/target0/lun0/part2 [events: 00000066]<6>(write)=20
ide/host0/bus1/target0/lun0/part2's sb offset: 77508032
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D mdadm =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
gfk@ali:~$ sudo mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.00
   Creation Time : Wed Dec 29 21:32:26 2004
      Raid Level : raid1
      Array Size : 77508032 (73.92 GiB 79.37 GB)
     Device Size : 77508032 (73.92 GiB 79.37 GB)
    Raid Devices : 2
   Total Devices : 3
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Mon Nov 14 19:17:30 2005
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 0

            UUID : b013e39b:ec629293:98df4657:97255939
          Events : 0.102

     Number   Major   Minor   RaidDevice State
        0      34        2        0      active sync   /dev/hdg2
        1      22        2        1      active sync   /dev/hdc2
gfk@ali:~$
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

--=20
Guillaume Filion, ing. jr
Logidac Tech., Beaumont, Qu=E9bec, Canada - http://logidac.com/
PGP Key and more: http://guillaume.filion.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
