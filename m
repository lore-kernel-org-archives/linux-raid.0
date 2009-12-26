From: Steven Haigh <netwiz@crc.id.au>
Subject: BUG: soft lockup - CPU#0 stuck for 10s [md2_raid1]
Date: Sat, 26 Dec 2009 19:23:04 +1100
Message-ID: <AD3EABA4-AA57-49A5-A393-80CFB5732C25@crc.id.au>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

I have another system that is eventually hanging when doing a resync on a software RAID1.

The system is another CentOS 5.4 install with a fairly vanilla config... The message is:

BUG: soft lockup - CPU#0 stuck for 10s! [md2_raid1:358]

Pid: 358, comm:            md2_raid1
EIP: 0060:[<c04ec5dd>] CPU: 0
EIP is at memcmp+0x12/0x22
 EFLAGS: 00000246    Not tainted  (2.6.18-164.6.1.el5 #1)
EAX: 00000000 EBX: e4fc7606 ECX: e4caf606 EDX: 00000000
ESI: 000009fa EDI: 00000054 EBP: e578b740 DS: 007b ES: 007b
CR0: 8005003b CR2: 0806af70 CR3: 30d7c000 CR4: 000006d0
 [<f8843c64>] raid1d+0x270/0xbea [raid1]
 [<c0616db8>] schedule+0x9cc/0xa55
 [<c061747b>] schedule_timeout+0x13/0x8c
 [<c05a7029>] md_thread+0xdf/0xf5
 [<c0434c17>] autoremove_wake_function+0x0/0x2d
 [<c05a6f4a>] md_thread+0x0/0xf5
 [<c0434b55>] kthread+0xc0/0xeb
 [<c0434a95>] kthread+0x0/0xeb
 [<c0405c53>] kernel_thread_helper+0x7/0x10
 =======================

I have tried this with kernel 2.6.18-164.6.1.el5 and 2.6.18-164.9.1.el5 with the same results.

md0/1/3 all check without causing any CPU locks.

# cat /proc/mdstat 
Personalities : [raid1] 
md0 : active raid1 hdc1[1] hda1[0]
      521984 blocks [2/2] [UU]
      
md1 : active raid1 hdc2[1] hda2[0]
      10482304 blocks [2/2] [UU]
      
md3 : active raid1 hdc4[1] hda4[0]
      1052160 blocks [2/2] [UU]
      
md2 : active raid1 hdc3[1] hda3[0]
      300511808 blocks [2/2] [UU]
      [>....................]  resync =  2.7% (8395136/300511808) finish=208.3min speed=23370K/sec
      
unused devices: <none>

# mdadm -Q --detail /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Mon Feb 23 17:15:41 2009
     Raid Level : raid1
     Array Size : 300511808 (286.59 GiB 307.72 GB)
  Used Dev Size : 300511808 (286.59 GiB 307.72 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sat Dec 26 19:21:36 2009
          State : active, resyncing
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

 Rebuild Status : 3% complete

           UUID : fed99e3d:d08fdcc9:b9593a45:2cc09736
         Events : 0.30587

    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1      22        3        1      active sync   /dev/hdc3

Interestingly, this is the same box that randomly comes up with an ext3 bad block on /dev/md2 and remounts the filesystem readonly that I posted about a few hours ago.

--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897




