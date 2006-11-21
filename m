From: "Andre' Breiler" <andre.breiler@null-mx.org>
Subject: kernel 2.4.33.4 md raid1 problem
Date: Tue, 21 Nov 2006 07:18:14 +0000 (GMT)
Message-ID: <Pine.LNX.4.33.0611210711400.30964-100000@pegasus.teamwerk.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I've just moved to the above kernel (from 2.4.20) and found the following
funny behaviour:
- raid get autoassembled (correctly afaik)
- size of raid is reported as 0
(and the fs on the raid can't be mounted)
.

The system is a SUN Netra t105.

---- snip dmesg -----
Booting Linux...
PROMLIB: Sun IEEE Boot Prom 3.10.24 1999/08/16 17:37
Linux version 2.4.33.4 (root@ewok) (gcc version 3.4.6 (Debian 3.4.6-4)) #2 Tue Nov 21 02:04:02 GMT 2006
ARCH: SUN4U

...

md: raid1 personality registered as nr 3
md: Autodetecting RAID arrays.
 [events: 00000040]
 [events: 00000048]
 [events: 00000040]
 [events: 00000048]
md: autorun ...
md: considering sdb7 ...
md:  adding sdb7 ...
md:  adding sda7 ...
md: created md2
md: bind<sda7,1>
md: bind<sdb7,2>
md: running: <sdb7><sda7>
md: sdb7's event counter: 00000048
md: sda7's event counter: 00000048
md: RAID level 1 does not need chunksize! Continuing anyway.
md2: max total readahead window set to 248k
md2: 1 data-disks, max readahead per data-disk: 248k
raid1: device sdb7 operational as mirror 1
raid1: device sda7 operational as mirror 0
raid1: raid set md2 active with 2 out of 2 mirrors
md: updating md2 RAID superblock on device
md: sdb7 [events: 00000049]<6>(write) sdb7's sb offset: 13460736
md: sda7 [events: 00000049]<6>(write) sda7's sb offset: 13460736
md: considering sdb5 ...
md:  adding sdb5 ...
md:  adding sda5 ...
md: created md1
md: bind<sda5,1>
md: bind<sdb5,2>
md: running: <sdb5><sda5>
md: sdb5's event counter: 00000040
md: sda5's event counter: 00000040
md: RAID level 1 does not need chunksize! Continuing anyway.
md1: max total readahead window set to 248k
md1: 1 data-disks, max readahead per data-disk: 248k
raid1: device sdb5 operational as mirror 1
raid1: device sda5 operational as mirror 0
raid1: raid set md1 active with 2 out of 2 mirrors
md: updating md1 RAID superblock on device
md: sdb5 [events: 00000041]<6>(write) sdb5's sb offset: 2046720
md: sda5 [events: 00000041]<6>(write) sda5's sb offset: 2046720
md: ... autorun DONE.
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
---- snap kernel ----

---- snip /proc/mdstat ----
(none):~ # cat /proc/mdstat
Personalities : [raid1]
read_ahead not set
md1 : active raid1 sdb5[1] sda5[0]
      0 blocks [2/2] [UU]

md2 : active raid1 sdb7[1] sda7[0]
      0 blocks [2/2] [UU]

unused devices: <none>
---- snap /proc/mdstat ----

Does someone have a guess/idea what went wrong ?

Thanx,
 Andre


