From: "Raffaella Leo" <gianluca.cecchi@tiscali.it>
Subject: raid 5 lost 2 of 3 disks. Help please
Date: Wed, 23 Jun 2004 01:03:39 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C6A479000253BA@mail-5.tiscali.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I'm using a very old sw raid5 mantained since about 1999.
It has reiserfs on it, and is composed by 3 disks configured in raid5.
My raidtab is:
raiddev                 /dev/md0
raid-level              5
nr-raid-disks           3
chunk-size              128
parity-algorithm        left-symmetric
persistent-superblock   1
device                  /dev/sdb1
raid-disk               0
device                  /dev/sdc1
raid-disk               1
device                  /dev/sdd1
raid-disk               2

My system is based at this moment on slackware-current with kernel 2.6.7
and raidstart v0.3d compiled for md raidtools-1.00.3
and I also have mdadm - v1.6.0 - 4 June 2004.
2 days ago I suppose I experienced a SCSI problem, as all operation
on that filesystem hung. With sysrq I tried to sync and then reboot.
At reboot I'm not able to start the array.
I'm trying to use mdadm to debug.
I create mdadm.conf so that 

root@tkamd:~# grep -v ^# /etc/mdadm.conf
gives:
DEVICE /dev/sdb1 /dev/sdc1 /dev/sdd1
ARRAY /dev/md0 devices=/dev/sdb1,/dev/sdc1,/dev/sdd1

and I get:

root@tkamd:~# mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fbaeee10:09867c3e:d70fbd8f:b17d930f
  Creation Time : Mon Feb  5 01:06:17 2001
     Raid Level : raid5
    Device Size : 17920384 (17.09 GiB 18.35 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jun 21 20:53:55 2004
          State : dirty
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b37a0f18 - correct
         Events : 0.2323794

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1


root@tkamd:~# mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fbaeee10:09867c3e:d70fbd8f:b17d930f
  Creation Time : Mon Feb  5 01:06:17 2001
     Raid Level : raid5
    Device Size : 17920384 (17.09 GiB 18.35 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jun 21 21:04:52 2004
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 3
  Spare Devices : 0
       Checksum : b39d872c - correct
         Events : 0.2323799

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1
   0     0       0        0        0      removed
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       0        0        2      faulty removed

root@tkamd:~# mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fbaeee10:09867c3e:d70fbd8f:b17d930f
  Creation Time : Mon Feb  5 01:06:17 2001
     Raid Level : raid5
    Device Size : 17920384 (17.09 GiB 18.35 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jun 21 20:53:55 2004
          State : dirty
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : b37a0f45 - correct
         Events : 0.2323795

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2       8       49        2      active sync   /dev/sdd1
   0     0       0        0        0      removed
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1


oot@tkamd:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5]
md0 : inactive sdc1[1] sdd1[2] sdb1[0]
      53761152 blocks
unused devices: <none>

Before the problem at boot I got:

Jun 21 20:38:46 tkamd kernel: md: Autodetecting RAID arrays.
Jun 21 20:38:46 tkamd kernel: md: autorun ...
Jun 21 20:38:46 tkamd kernel: md: considering sdd1 ...
Jun 21 20:38:46 tkamd kernel: md:  adding sdd1 ...
Jun 21 20:38:46 tkamd kernel: md:  adding sdc1 ...
Jun 21 20:38:46 tkamd kernel: md:  adding sdb1 ...
Jun 21 20:38:46 tkamd kernel: md: created md0
Jun 21 20:38:46 tkamd kernel: md: bind<sdb1>
Jun 21 20:38:46 tkamd kernel: md: bind<sdc1>
Jun 21 20:38:46 tkamd kernel: md: bind<sdd1>
Jun 21 20:38:46 tkamd kernel: md: running: <sdd1><sdc1><sdb1>
Jun 21 20:38:46 tkamd kernel: raid5: device sdd1 operational as raid disk
2
Jun 21 20:38:46 tkamd kernel: raid5: device sdc1 operational as raid disk
1
Jun 21 20:38:46 tkamd kernel: raid5: device sdb1 operational as raid disk
0
Jun 21 20:38:46 tkamd kernel: raid5: allocated 3147kB for md0
Jun 21 20:38:46 tkamd kernel: md: ... autorun DONE.
[snip]
Jun 21 20:38:46 tkamd kernel: ReiserFS: md0: found reiserfs format "3.6"
with st
andard journal
Jun 21 20:38:46 tkamd kernel: ReiserFS: md0: using ordered data mode
Jun 21 20:38:46 tkamd kernel: ReiserFS: md0: journal params: device md0,
size 81
92, journal first block 18, max trans len 1024, max batch 900, max commit
age 30
, max trans age 30
Jun 21 20:38:46 tkamd kernel: ReiserFS: md0: checking transaction log (md0)
Jun 21 20:38:46 tkamd kernel: ReiserFS: md0: Using r5 hash to sort names

when I had the problem I got:

Jun 21 20:53:55 tkamd kernel: sym0: TARGET 10 has been reset.
Jun 21 20:53:56 tkamd kernel: sym0: TARGET 12 has been reset.
Jun 21 20:55:26 tkamd kernel: sym0: SCSI BUS has been reset.
[snip]
Jun 21 21:07:15 tkamd kernel: SysRq : Show Regs
Jun 21 21:07:25 tkamd last message repeated 7 times
Jun 21 21:07:32 tkamd kernel: SysRq : HELP : loglevel0-8 reBoot tErm kIll
saK sh
owMem powerOff showPc unRaw Sync showTasks Unmount
Jun 21 21:07:36 tkamd kernel: [<c0211da2>] do_con_write+0x292/0x760
Jun 21 21:07:38 tkamd kernel: 0000e f75ce310 f75ce4c0 f640d000 7fffffff
f640d930
 f640c000
Jun 21 21:07:41 tkamd kernel:  syscall_call+0x7/0xb
Jun 21 21:07:43 tkamd kernel: [<c0211da2>] do_con_write+0x292/0x760
Jun 21 21:07:44 tkamd kernel: fffff f640d930 f640c000
Jun 21 21:07:45 tkamd kernel: [<c02068cc>] read_chan+0x6ec/0x880
Jun 21 21:07:47 tkamd kernel: fffff f640d930 f640c000
Jun 21 21:07:49 tkamd kernel: SysRq : HELP : loglevel0-8 reBoot tErm kIll
saK sh
owMem powerOff showPc unRaw Sync showTasks Unmount
Jun 21 21:07:57 tkamd kernel: SysRq : Show Memory
Jun 21 21:07:57 tkamd kernel: SysRq : HELP : loglevel0-8 reBoot tErm kIll
saK sh
owMem powerOff showPc unRaw Sync showTasks Unmount
Jun 21 21:08:02 tkamd kernel: SysRq : Show Memory
Jun 21 21:08:05 tkamd last message repeated 4 times
Jun 21 21:08:05 tkamd kernel: SysRq : HELP : loglevel0-8 reBoot tErm kIll
saK sh
owMem powerOff showPc unRaw Sync showTasks Unmount
Jun 21 21:08:17 tkamd kernel: SysRq : Emergency Sync
Jun 21 21:08:32 tkamd kernel: SysRq : HELP : loglevel0-8 reBoot tErm kIll
saK sh
owMem powerOff showPc unRaw Sync showTasks Unmount
Jun 21 21:08:34 tkamd kernel: SysRq : Emergency Sync


After that, at boot I have
Jun 23 01:21:30 tkamd kernel: md: Autodetecting RAID arrays.
Jun 23 01:21:30 tkamd kernel: md: autorun ...
Jun 23 01:21:30 tkamd kernel: md: considering sdd1 ...
Jun 23 01:21:30 tkamd kernel: md:  adding sdd1 ...
Jun 23 01:21:30 tkamd kernel: md:  adding sdc1 ...
Jun 23 01:21:30 tkamd kernel: md:  adding sdb1 ...
Jun 23 01:21:30 tkamd kernel: md: created md0
Jun 23 01:21:30 tkamd kernel: md: bind<sdb1>
Jun 23 01:21:30 tkamd kernel: md: bind<sdc1>
Jun 23 01:21:30 tkamd kernel: md: bind<sdd1>
Jun 23 01:21:30 tkamd kernel: md: running: <sdd1><sdc1><sdb1>
Jun 23 01:21:30 tkamd kernel: md: unbind<sdd1>
Jun 23 01:21:30 tkamd kernel: md: export_rdev(sdd1)
Jun 23 01:21:30 tkamd kernel: md: unbind<sdb1>
Jun 23 01:21:30 tkamd kernel: md: export_rdev(sdb1)
Jun 23 01:21:30 tkamd kernel: raid5: device sdc1 operational as raid disk
1
Jun 23 01:21:30 tkamd kernel: md: md0 stopped.
Jun 23 01:21:30 tkamd kernel: md: unbind<sdc1>
Jun 23 01:21:30 tkamd kernel: md: export_rdev(sdc1)
Jun 23 01:21:30 tkamd kernel: md: ... autorun DONE.


root@tkamd:~# mdadm -A /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1
mdadm: /dev/md0 assembled from 1 drive - not enough to start the array.

I can see also now a message like:

Jun 23 01:41:40 tkamd kernel: sym0: TARGET 6 has been reset.
Jun 23 01:42:10 tkamd kernel: sym0: SCSI BUS has been reset.
Jun 23 01:42:10 tkamd kernel: sym0: TARGET 6 has been reset.

but I don't know if it depends on mdadm command or scsi error on bus...

I don't know if I'm totally lost and how to proceed.
Any help?
I'm not subscribed to the list, so please keep also me directly in 
your answers.
Thanks in advance.
Bye,
Gianluca

__________________________________________________________________
Tiscali ADSL libera la velocita'!
Attiva Senza Canone entro il 28 giugno: navighi a 1,5 euro l'ora per i primi
3 mesi,se scegli il modem e' tuo in comodato gratuito e in piu' hai gratis
SuperMail per 12 mesi. Non aspettare, attivala subito!
http://abbonati.tiscali.it/adsl/prodotti/640Kbps/



