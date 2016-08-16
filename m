From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid5 reshape stuck at 0% - SuSE leap 42.1
Date: Tue, 16 Aug 2016 11:57:04 +0100
Message-ID: <57B2F180.1080804@youngman.org.uk>
References: <57A69012.1010406@youngman.org.uk>
 <alpine.DEB.2.02.1608071154110.3593@uplift.swm.pp.se>
 <57A719CC.6080301@youngman.org.uk> <57A724ED.5070808@youngman.org.uk>
 <alpine.DEB.2.02.1608071630050.3593@uplift.swm.pp.se>
 <57A766DC.4000207@youngman.org.uk>
 <alpine.DEB.2.02.1608071923410.3593@uplift.swm.pp.se>
 <57A776AE.3050308@youngman.org.uk>
 <alpine.DEB.2.02.1608072002400.3593@uplift.swm.pp.se>
 <57A7869D.2090203@youngman.org.uk>
 <alpine.DEB.2.02.1608081339310.3593@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1608081339310.3593@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <nfbrown@novell.com>
List-Id: linux-raid.ids

On 08/08/16 12:40, Mikael Abrahamsson wrote:
> On Sun, 7 Aug 2016, Wols Lists wrote:
> 
>> Note that I think this dmesg stuff overlaps with the last lot, namely
>> the start of this is the tail end of the array starting successfully
>> last time.
> 
> It helps if you supply output of /proc/mdstat before each operation, and
> also adding verbose output to mdadm command.
> 
Okay. Just tried to do this - and do Neil's thing where I was trying to
reduce the number of raid devices ... I now have a wedged 2-device raid
5 that I can't revert back to raid 1, or set off the required reshape.
Mikael - your --update=revert-reshape that worked fine last time, now
refuses to work ... :-( so I can't try Neil's --raid-devices=2 because I
can't get a clean full-working-order array. (The array is working fine,
so if it was a real live array I wouldn't be worried about losing
anything, but a wedged array is a wedged array - not good!)

As before, OS = SuSE Leap 42.1, "mdadm" is what comes with the OS,
"./mdadm" is Neil's git tree (a week or so old).

Attached is my xterm trace and the associated output from dmesg.

kanga:/home/anthony/mdadm # mdadm --stop /dev/md127
mdadm: stopped /dev/md127
kanga:/home/anthony/mdadm # ./mdadm --assemble /dev/md127 --verbose
--force --update=revert-reshape --invalid-backup
--backup-file=../raidbackup /dev/sdb /dev/sdc /dev/sdd /dev/sde
mdadm: looking for devices for /dev/md127
mdadm: No active reshape to revert on /dev/sdb
kanga:/home/anthony/mdadm # ./mdadm --assemble /dev/md127 --verbose
--force --update=revert-reshape --invalid-backup
--backup-file=../raidbackup /dev/sdc /dev/sdd /dev/sde     mdadm:
looking for devices for /dev/md127
mdadm: Merging with already-assembled /dev/md/testarray
mdadm: No active reshape to revert on /dev/sdb
kanga:/home/anthony/mdadm # mdadm --assemble --scan
mdadm: Merging with already-assembled /dev/md/testarray
mdadm: /dev/md/testarray has been started with 2 drives and 2 spares.
kanga:/home/anthony/mdadm # mdadm - D /dev/md127
mdadm: An option must be given to set the mode before a second device
       (D) is listed
kanga:/home/anthony/mdadm # mdadm -D /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Fri Aug  5 18:16:24 2016
     Raid Level : raid5
     Array Size : 8380416 (7.99 GiB 8.58 GB)
  Used Dev Size : 8380416 (7.99 GiB 8.58 GB)
   Raid Devices : 2
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Tue Aug 16 11:32:52 2016
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 64K

           Name : kanga:testarray  (local to host kanga)
           UUID : cf52ebc0:886a35cd:688274b4:3f16096c
         Events : 160

    Number   Major   Minor   RaidDevice State
       4       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc

       2       8       48        -      spare   /dev/sdd
       3       8       64        -      spare   /dev/sde
kanga:/home/anthony/mdadm # mdadm --grow /dev/md127 --continue
kanga:/home/anthony/mdadm # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid5 sdd[2](S) sde[3](S) sdc[1] sdb[4]
      8380416 blocks super 1.2 level 5, 64k chunk, algorithm 2 [2/2] [UU]

unused devices: <none>
kanga:/home/anthony/mdadm # mdadm --stop /dev/md127
mdadm: stopped /dev/md127
kanga:/home/anthony/mdadm # ./mdadm --assemble /dev/md127 --verbose
--force --update=revert-reshape --invalid-backup
--backup-file=../raidbackup /dev/sdb /dev/sdc /dev/sdd /dev/sde
mdadm: looking for devices for /dev/md127
mdadm: No active reshape to revert on /dev/sdb
kanga:/home/anthony/mdadm # ./mdadm --grow /dev/md127 --continue
mdadm: /dev/md127 is not an active md array - aborting
kanga:/home/anthony/mdadm # ./mdadm --assemble --scan
mdadm: Merging with already-assembled /dev/md/testarray
mdadm: /dev/md/testarray has been started with 2 drives and 2 spares.
kanga:/home/anthony/mdadm # ./mdadm --grow /dev/md127 --continue
kanga:/home/anthony/mdadm # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid5 sdd[2](S) sde[3](S) sdc[1] sdb[4]
      8380416 blocks super 1.2 level 5, 64k chunk, algorithm 2 [2/2] [UU]

unused devices: <none>
kanga:/home/anthony/mdadm # ps -fea | grep mdadm
root      1484  1855  0 11:42 pts/0    00:00:00 grep --color=auto mdadm
root      3586     1  0 09:53 ?        00:00:00 /sbin/mdadm --monitor -d
60 -m root@localhost --scan -c /etc/mdadm.conf
kanga:/home/anthony/mdadm #




00:00:00.000257 main     Log opened 2016-08-07T18:07:43.777555000Z
[22244.641971] 00:00:00.000481 main     OS Product: Linux
[22244.642016] 00:00:00.000526 main     OS Release: 4.1.15-8-default
[22244.642056] 00:00:00.000564 main     OS Version: #1 SMP PREEMPT Wed
Jan 20 16:41:00 UTC 2016 (0e3b3ab)
[22244.642206] 00:00:00.000604 main     Executable: /usr/sbin/VBoxService
00:00:00.000605 main     Process ID: 12443
00:00:00.000606 main     Package type: LINUX_64BITS_GENERIC (OSE)
[22244.643245] 00:00:00.001736 main     5.0.24_SUSE r108355 started.
Verbose level = 0
[22567.452608] SFW2-INext-DROP-DEFLT IN=eth0 OUT=
MAC=08:00:27:0b:0f:57:52:54:00:12:35:02:08:00 SRC=10.0.2.2 DST=10.0.2.15
LEN=576 TOS=0x10 PREC=0x00 TTL=64 ID=2252 PROTO=UDP SPT=67 DPT=68 LEN=556
[25196.727211] RAID conf printout:
[25196.727217]  --- level:5 rd:2 wd:2
[25196.727238]  disk 0, o:1, dev:sdb
[25196.727240]  disk 1, o:1, dev:sdc
[25196.727246] RAID conf printout:
[25196.727248]  --- level:5 rd:2 wd:2
[25196.727250]  disk 0, o:1, dev:sdb
[25196.727251]  disk 1, o:1, dev:sdc
[27195.944364] usb 2-1: USB disconnect, device number 2
[27196.148347] e1000: eth0 NIC Link is Down
[27196.572099] usb 2-1: new full-speed USB device number 3 using ohci-pci
[27196.832714] usb 2-1: New USB device found, idVendor=80ee, idProduct=0021
[27196.832721] usb 2-1: New USB device strings: Mfr=1, Product=3,
SerialNumber=0
[27196.832723] usb 2-1: Product: USB Tablet
[27196.832725] usb 2-1: Manufacturer: VirtualBox
[27196.841815] input: VirtualBox USB Tablet as
/devices/pci0000:00/0000:00:06.0/usb2/2-1/2-1:1.0/0003:80EE:0021.0002/input/input9
[27196.842185] hid-generic 0003:80EE:0021.0002: input,hidraw0: USB HID
v1.10 Mouse [VirtualBox USB Tablet] on usb-0000:00:06.0-1/input0
[27202.148448] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: RX
[27202.152800] SFW2-INext-DROP-DEFLT IN=eth0 OUT=
MAC=08:00:27:0b:0f:57:52:54:00:12:35:02:08:00 SRC=10.0.2.2 DST=10.0.2.15
LEN=576 TOS=0x10 PREC=0x00 TTL=64 ID=0 PROTO=UDP SPT=67 DPT=68 LEN=556
[27265.599076] BTRFS info (device sda2): relocating block group
16202596352 flags 36
[27266.319748] BTRFS info (device sda2): relocating block group
12410945536 flags 34
[27266.439613] BTRFS info (device sda2): relocating block group
16202596352 flags 34
[27266.542733] BTRFS info (device sda2): relocating block group
16236150784 flags 34
[27266.649202] BTRFS info (device sda2): relocating block group
16269705216 flags 34
[27266.757287] BTRFS info (device sda2): relocating block group
12444499968 flags 36
[27271.176254] BTRFS info (device sda2): found 1011 extents
[27271.426455] BTRFS info (device sda2): relocating block group
16303259648 flags 34
[27271.707481] BTRFS info (device sda2): relocating block group
14994636800 flags 36
[27277.442719] BTRFS info (device sda2): found 2417 extents
[27277.862520] BTRFS info (device sda2): relocating block group
13652459520 flags 36
[27283.603832] BTRFS info (device sda2): found 1696 extents
[27366.620131] md127: detected capacity change from 8581545984 to 0
[27366.620131] md: md127 stopped.
[27366.620131] md: unbind<sdb>
[27366.624318] md: export_rdev(sdb)
[27366.624318] md: unbind<sdd>
[27366.632107] md: export_rdev(sdd)
[27366.632137] md: unbind<sde>
[27366.640248] md: export_rdev(sde)
[27366.640248] md: unbind<sdc>
[27366.644324] md: export_rdev(sdc)
[27373.643627] md: md127 stopped.
[27373.775068] md: bind<sdb>
[27437.466705] md: array md127 already has disks!
[27437.467188] md: bind<sdc>
[27437.467593] md: bind<sde>
[27437.467976] md: bind<sdd>
[27437.509156] md/raid:md127: device sdc operational as raid disk 1
[27437.509161] md/raid:md127: device sdb operational as raid disk 0
[27437.509679] md/raid:md127: allocated 2250kB
[27437.520845] md/raid:md127: raid level 5 active with 2 out of 2
devices, algorithm 2
[27437.520850] RAID conf printout:
[27437.520852]  --- level:5 rd:2 wd:2
[27437.520854]  disk 0, o:1, dev:sdb
[27437.520856]  disk 1, o:1, dev:sdc
[27437.521657] md127: detected capacity change from 0 to 8581545984
[27437.523369] RAID conf printout:
[27437.523378]  --- level:5 rd:2 wd:2
[27437.523380]  disk 0, o:1, dev:sdb
[27437.523382]  disk 1, o:1, dev:sdc
[27437.523383] RAID conf printout:
[27437.523384]  --- level:5 rd:2 wd:2
[27437.523384]  disk 0, o:1, dev:sdb
[27437.523385]  disk 1, o:1, dev:sdc
[27587.102558] md127: detected capacity change from 8581545984 to 0
[27587.102569] md: md127 stopped.
[27587.102575] md: unbind<sdd>
[27587.108084] md: export_rdev(sdd)
[27587.108132] md: unbind<sde>
[27587.120239] md: export_rdev(sde)
[27587.120239] md: unbind<sdc>
[27587.128050] md: export_rdev(sdc)
[27587.128069] md: unbind<sdb>
[27587.132042] md: export_rdev(sdb)
[27603.862527] md: md127 stopped.
[27603.963036] md: bind<sdb>
anthony@kanga:/mnt/anthony>


