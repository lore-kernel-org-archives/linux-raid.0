From: Tapani Utriainen <tapani@cs.chalmers.se>
Subject: Bug in mdadm?
Date: Mon, 7 Jul 2003 15:34:01 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.SOL.4.30.0307071346570.9925-100000@hotlips.cs.chalmers.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I have struck into something that seems to be a bug in mdadm, and/or in the kernel (2.4.20).

I wanted to create a RAID 5 with 6 disks with mdadm:

# mdadm --create /dev/md0 --level=5 --chunk=256 --raid-devices=6 --spare-devices=0 /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/hdg /dev/hde

Despite the explicit statement of SIX disks and NO spares it
created an array of SEVEN disks, with ONE spare and ONE missing/failed+removed?!

Output from 'mdadm -D' is found at the end of this message. This is very
likely to be a bug in mdadm.

Now, in case this was just a quirk of some other kind I proceeded with
creating a reiserfs ; mount ; fiddle ; testing of redundancy by
marking a drive as failed.

# mdadm /dev/md0 -f /dev/sdf

After this all processes accessing the fs goes into disk sleep.
(If functional, the array was expected to go into degenerate mode, and me
still being able to access the fs).

In the logs there is an indication of a kernel bug. (See the dump at the
very end of this message)

However I am no software raid expert, and this might just be a result of
severe misusage/misunderstanding of the tools..

//Tapani



* * * * *  MISCONFIGURED ARRAY ?  * * * * *




# mdadm --create /dev/md0 --level=5 --chunk=256 --raid-devices=6 --spare-devices=0 /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/hdg /dev/hde

# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Mon Jul  7 13:45:47 2003
     Raid Level : raid5
     Array Size : 603136000 (575.20 GiB 617.61 GB)
    Device Size : 120627200 (115.04 GiB 123.52 GB)
   Raid Devices : 6
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Jul  7 13:45:47 2003
          State : dirty, no-errors
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 256K

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       8       48        1      active sync   /dev/sdd
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf
       4      34        0        4      active sync   /dev/hdg
       5       0        0        5      faulty
       6      33        0        6        /dev/hde
           UUID : faa0f80f:a5bacb7f:1caf43d5:d0147d81
         Events : 0.1





* * * * *  KERNEL BUG ?  * * * * *




# mdadm /dev/md0 -f /dev/sdf
mdadm: set /dev/sdf faulty in /dev/md0

From the logs:

# dmesg

...

raid5: Disk failure on sdf, disabling device. Operation continuing on 4
devices
md: updating md0 RAID superblock on device
md: hde [events: 00000002]<6>(write) hde's sb offset: 120627264
md: hdg [events: 00000002]<6>(write) hdg's sb offset: 120627264
md: md_do_sync() got signal ... exiting
RAID5 conf printout:
 --- rd:6 wd:4 fd:2
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdc
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdd
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sde
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdf
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:hdg
 disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 00:00]
RAID5 conf printout:
 --- rd:6 wd:4 fd:2
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdc
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdd
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sde
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdf
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:hdg
 disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 00:00]
md: recovery thread finished ...
md: recovery thread got woken up ...
md0: resyncing spare disk hde to replace failed disk
RAID5 conf printout:
 --- rd:6 wd:4 fd:2
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdc
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdd
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sde
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdf
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:hdg
 disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 00:00]
RAID5 conf printout:
 --- rd:6 wd:4 fd:2
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdc
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdd
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sde
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdf
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:hdg
 disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 00:00]
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000 KB/sec) for reconstruction.
md: using 124k window, over a total of 120627200 blocks.
md: md_do_sync() got signal ... exiting
RAID5 conf printout:
 --- rd:6 wd:4 fd:2
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdc
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdd
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sde
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdf
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:hdg
 disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 00:00]
RAID5 conf printout:
 --- rd:6 wd:4 fd:2
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdc
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdd
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sde
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:sdf
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:hdg
 disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 00:00]
md: recovery thread finished ...
md: (skipping faulty sdf )
md: sde [events: 00000002]<6>(write) sde's sb offset: 120627264
md: sdd [events: 00000002]<6>(write) sdd's sb offset: 120627264
md: sdc [events: 00000002]<6>(write) sdc's sb offset: 120627264
journal-601, buffer write failed
kernel BUG at prints.c:334!

invalid operand: 0000
CPU:    0
EIP:    0010:[<c01aa4b8>]    Not tainted
EFLAGS: 00010282
eax: 00000024   ebx: f7b3b000   ecx: 00000012   edx: ef66ff7c
esi: 00000000   edi: f7b3b000   ebp: 00000003   esp: f7bd3ec0
ds: 0018   es: 0018   ss: 0018
Process kupdated (pid: 7, stackpage=f7bd3000)
Stack: c02bade6 c0355ce0 f7b3b000 f8d264ec c01b584a f7b3b000 c02bc900 00001000
       eecbef80 00000006 00000004 00000000 ee621e40 00000000 00000008 ecb5c000
       00000004 c01b9991 f7b3b000 f8d264ec 00000001 00000006 f8d2f58c 00000004
Call Trace:    [<c01b584a>] [<c01b9991>] [<c01b8ba4>] [<c01a7240>] [<c0141d0a>]
  [<c0140e14>] [<c014118d>] [<c0105000>] [<c0105000>] [<c01058ce>] [<c0141090>]

Code: 0f 0b 4e 01 ec ad 2b c0 85 db 74 0e 0f b7 43 08 89 04 24 e8


