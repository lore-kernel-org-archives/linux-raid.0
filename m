From: Enigma <enigma@thedonnerparty.com>
Subject: RAID 6 freezing system when stripe_cache_size is increased from
	default
Date: Thu, 19 Nov 2009 19:53:03 -0700
Message-ID: <e59c37290911191853n20377b90s5d871118a4b1731a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am in the process of migrating a 8x200 GB disk RAID 6 array to a
8x500 disk array.  I created the array with 2 missing disks and I
added them after the array is started.  The array synced fine at the
default of 256 for /sys/block/md0/md/stripe_cache_size, but if I
changed it to a higher value, for example  "echo 4096 >
/sys/block/md0/md/stripe_cache_size" the system freezes up.  The
previous array was running fine with a cache size of 8192.  The only
difference between my old array and this array is I increased the
chunk size to 512 from 256.  The machine is a dual Xeon w/
hyperthreading, 3 GB of main memory, kernel 2.6.29.1, mdadm v2.6.7.2.
I let the array sync at the default cache size (with fairly poor
performance) and tested the synced array and get the same behavior
under load.  Whenever the cache size > 256 I get the following hang:

[ 1453.847111] BUG: soft lockup - CPU#3 stuck for 61s! [md0_raid5:571]
[ 1453.863456] Modules linked in: ipv6 dm_mod iTCO_wdt intel_rng
rng_core pcspkr evdev i2c_i801 i2c_core e7xxx_edac edac_core
parport_pc parport containern
[ 1453.919458]
[ 1453.923455] Pid: 571, comm: md0_raid5 Not tainted (2.6.29.1-JJ #7) SE7501CW2
[ 1453.943454] EIP: 0060:[<c033ec4e>] EFLAGS: 00000286 CPU: 3
[ 1453.959453] EIP is at raid6_sse22_gen_syndrome+0x132/0x16c
[ 1453.979454] EAX: dcca66c0 EBX: ffffffff ECX: 000006c0 EDX: dd1be000
[ 1453.995452] ESI: f6005e60 EDI: f6005e5c EBP: 00000014 ESP: f6005e30
[ 1454.015452]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1454.031451] CR0: 80050033 CR2: b7ede195 CR3: 066e8000 CR4: 000006d0
[ 1454.051451] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1454.071450] DR6: ffff0ff0 DR7: 00000400
[ 1454.083450] Call Trace:
[ 1454.087450]  [<c033adc1>] ? compute_parity6+0x201/0x26c
[ 1454.103449]  [<c033b7b2>] ? handle_stripe+0x6bc/0xad0
[ 1454.119449]  [<c015537c>] ? rcu_process_callbacks+0x33/0x39
[ 1454.139449]  [<c012a24e>] ? __do_softirq+0x7f/0x125
[ 1454.151448]  [<c033bf6f>] ? raid5d+0x3a9/0x3b7
[ 1454.167448]  [<c03d1b87>] ? schedule_timeout+0x13/0x86
[ 1454.179447]  [<c01176f5>] ? default_spin_lock_flags+0x5/0x8
[ 1454.199447]  [<c0347c76>] ? md_thread+0xb6/0xcc
[ 1454.211446]  [<c0135a11>] ? autoremove_wake_function+0x0/0x2d
[ 1454.231446]  [<c0347bc0>] ? md_thread+0x0/0xcc
[ 1454.243446]  [<c0135952>] ? kthread+0x38/0x5e
[ 1454.255445]  [<c013591a>] ? kthread+0x0/0x5e
[ 1454.267445]  [<c0103b93>] ? kernel_thread_helper+0x7/0x10


In searching for a cause to the problem I have found a few other
people who had issues like this, but they all seemed to be on a older
kernel and the cause was a deadlock that should be resolved by my
version (ex. http://marc.info/?l=linux-raid&m=116946415327616&w=2).
Are there any known bugs that are present in my kernel that would
cause behavior like this?  Here is some info about the array:

#mdadm --examine /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 65f266b7:852d5253:a847f9a3:2c253025
  Creation Time : Thu Nov 19 01:57:33 2009
     Raid Level : raid6
  Used Dev Size : 401118720 (382.54 GiB 410.75 GB)
     Array Size : 2406712320 (2295.22 GiB 2464.47 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Thu Nov 19 19:40:26 2009
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 16b3ddef - correct
         Events : 1150

     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       66        4      active sync   /dev/sde2
   5     5       8       98        5      active sync   /dev/sdg2
   6     6       8       82        6      active sync   /dev/sdf2
   7     7       8      114        7      active sync   /dev/sdh2



# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md1 : active raid1 hdc1[1] hda1[0]
      4200896 blocks [2/2] [UU]

md0 : active raid6 sdh2[7] sdg2[5] sdf2[6] sde2[4] sdd2[3] sdc2[2]
sdb2[1] sda2[0]
      2406712320 blocks level 6, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]

unused devices: <none>



Can anyone point me at some information to debug this problem?
