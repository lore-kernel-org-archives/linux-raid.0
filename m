From: Guillaume Filion <gfk@logidac.com>
Subject: Re: Crooked raid
Date: Tue, 15 Nov 2005 18:24:18 -0500
Message-ID: <ba2d056dae1a8945240b26f7e4996204@logidac.com>
References: <200511151844.jAFIil2k006410@cichlid.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200511151844.jAFIil2k006410@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your help Andrew. I'm not sure if I did something wrong, but=
=20
I'm having some problems...

Le 05-11-15, =E0 13:44, Andrew Burgess a =E9crit :
> Look at:
>   mdadm -E /dev/hdc
> If it has a superblock, zero it with 'mdadm --zero-superblock /dev/hd=
c'
 > Same for hdg

I did this, rebooted and the system wouldn't reboot. Yikes! I was=20
however able to boot with giving root=3D/dev/hdc2 to the kernel.
Do you have any idea about what's going on? Thanks.

BTW, I don't have a /dev/raidtab file.

Here's the relevant part of dmesg:
device-mapper: 4.1.1-ioctl (2004-04-07) initialised: dm-devel@redhat.co=
m
md: can not import ide/host0/bus1/target0/lun0/part2, has active inodes=
!
md: md_import_device returned -16
  [events: 00000067]
md: bind<ide/host2/bus1/target0/lun0/part2,1>
md: ide/host2/bus1/target0/lun0/part2's event counter: 00000067
md0: former device ide/host0/bus1/target0/lun0/part2 is unavailable,=20
removing from array!
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
raid1: device ide/host2/bus1/target0/lun0/part2 operational as mirror 0
raid1: md0, not all disks are operational -- trying to recover array
raid1: raid set md0 active with 1 out of 2 mirrors
md: updating md0 RAID superblock on device
md: ide/host2/bus1/target0/lun0/part2 [events: 00000068]<6>(write)=20
ide/host2/bus1/target0/lun0/part2's sb offset: 77508032
md: recovery thread got woken up ...
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...


Here's the state of my system:
gfk@ali:~$ cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 ide/host2/bus1/target0/lun0/part2[0]
       77508032 blocks [2/1] [U_]

unused devices: <none>
gfk@ali:~$ sudo mdadm -D /dev/md0
Password:
/dev/md0:
         Version : 00.90.00
   Creation Time : Wed Dec 29 21:32:26 2004
      Raid Level : raid1
      Array Size : 77508032 (73.92 GiB 79.37 GB)
     Device Size : 77508032 (73.92 GiB 79.37 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Nov 15 17:29:57 2005
           State : active, degraded
  Active Devices : 1
Working Devices : 1
  Failed Devices : 1
   Spare Devices : 0

            UUID : b013e39b:ec629293:98df4657:97255939
          Events : 0.104

     Number   Major   Minor   RaidDevice State
        0      34        2        0      active sync   /dev/hdg2
        1       0        0        1      faulty removed
gfk@ali:~$ sudo mdadm -E /dev/hdc
mdadm: No super block found on /dev/hdc (Expected magic a92b4efc, got=20
00000000)
gfk@ali:~$ sudo mdadm -E /dev/hdg
mdadm: No super block found on /dev/hdg (Expected magic a92b4efc, got=20
00000000)
gfk@ali:~$ sudo mdadm -E /dev/hdc2
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
gfk@ali:~$ sudo mdadm -E /dev/hdg2
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

--=20
Guillaume Filion, ing. jr
Logidac Tech., Beaumont, Qu=E9bec, Canada - http://logidac.com/
PGP Key and more: http://guillaume.filion.org/

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
