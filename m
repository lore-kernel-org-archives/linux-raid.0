From: Vladimir Ivashchenko <hazard@francoudi.com>
Subject: sun x4500 soft lockup during raid creation
Date: Wed, 28 Jan 2009 22:30:33 +0200
Message-ID: <1233174633.7008.34.camel@hazard2.francoudi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

We've got these new Sun X4500 servers. The system I'm playing with now
has 48 x 250 GB SATA HDDs.

Right now I'm creating two RAID6 arrays, 24 and 22 drives each:

mdadm --verbose --create /dev/md3 --level=6
--raid-devices=24 /dev/sda /dev/sdaa /dev/sdab /dev/sdad /dev/sdae /dev/sdaf /dev/sdag /dev/sdah /dev/sdai /dev/sdaj /dev/sdak /dev/sdal /dev/sdam /dev/sdan /dev/sdao /dev/sdap /dev/sdaq /dev/sdar /dev/sdas /dev/sdat /dev/sdau /dev/sdav /dev/sdb /dev/sdc

mdadm --verbose --create /dev/md4 --level=6
--raid-devices=22 /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx /dev/sdz

mdadm --detail is reporting that everything is going smoothly, however
my /var/log/messages is full of "BUG: soft lockup - CPU#X stuck for
10s!" errors appearing every 1-3 minutes. 

CentOS 5.2, 2.6.18-92.1.22.el5PAE, sata_mv. Two dual-core Opterons @ 2.8
Ghz, 16 GB RAM.

The system does not crash and otherwise seems to be healthy. Arrays are
still under construction and I don't know if they will actually work
yet.

What I noticed is that at first it was complaining about lockups on md3
process, but once I started creating md4, complaints were exclusively
for md4 process only.

Any stability assurances or workarounds are highly appreciated. :)

Jan 28 21:31:32 SunSTG kernel: BUG: soft lockup - CPU#0 stuck for 10s!
[md3_raid5:5672]
Jan 28 21:31:32 SunSTG kernel:
Jan 28 21:31:32 SunSTG kernel: Pid: 5672, comm:            md3_raid5
Jan 28 21:31:32 SunSTG kernel: EIP: 0060:[<f8d68162>] CPU: 0
Jan 28 21:31:32 SunSTG kernel: EIP is at raid6_sse22_gen_syndrome
+0x10a/0x1b6 [raid456]
Jan 28 21:31:32 SunSTG kernel:  EFLAGS: 00000202    Not tainted
(2.6.18-92.1.22.el5PAE #1)
Jan 28 21:31:32 SunSTG kernel: EAX: ea0774e0 EBX: 000004e0 ECX: ead0ad30
EDX: ea077000
Jan 28 21:31:32 SunSTG kernel: ESI: ead0ade0 EDI: 00000004 EBP: ead0add0
DS: 007b ES: 007b
Jan 28 21:31:32 SunSTG kernel: CR0: 80050033 CR2: 0806e000 CR3: 373239e0
CR4: 000006f0
Jan 28 21:31:32 SunSTG kernel:  [<f8d63562>] compute_parity6+0x21c/0x28a
[raid456]
Jan 28 21:31:32 SunSTG kernel:  [<f8d6452e>] handle_stripe+0xc8b/0x215e
[raid456]
Jan 28 21:31:32 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
Jan 28 21:31:32 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
Jan 28 21:31:32 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
Jan 28 21:31:32 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
Jan 28 21:31:32 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
[raid456]
Jan 28 21:31:33 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
[raid456]
Jan 28 21:31:33 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
Jan 28 21:31:33 SunSTG kernel:  [<c0436347>] autoremove_wake_function
+0x0/0x2d
Jan 28 21:31:33 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
Jan 28 21:31:33 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
Jan 28 21:31:33 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
Jan 28 21:31:33 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
+0x7/0x10

Jan 28 21:31:33 SunSTG kernel:  =======================
Jan 28 21:32:26 SunSTG kernel: BUG: soft lockup - CPU#2 stuck for 10s!
[md3_raid5:5672]
Jan 28 21:32:26 SunSTG kernel:
Jan 28 21:32:26 SunSTG kernel: Pid: 5672, comm:            md3_raid5
Jan 28 21:32:26 SunSTG kernel: EIP: 0060:[<f8d68170>] CPU: 2
Jan 28 21:32:26 SunSTG kernel: EIP is at raid6_sse22_gen_syndrome
+0x118/0x1b6 [raid456]
Jan 28 21:32:26 SunSTG kernel:  EFLAGS: 00000202    Not tainted
(2.6.18-92.1.22.el5PAE #1)
Jan 28 21:32:26 SunSTG kernel: EAX: ea784040 EBX: 00000040 ECX: ead0ad30
EDX: ea784000
Jan 28 21:32:26 SunSTG kernel: ESI: ead0adf0 EDI: 00000008 EBP: ead0add0
DS: 007b ES: 007b
Jan 28 21:32:26 SunSTG kernel: CR0: 80050033 CR2: b7f6f000 CR3: 3714e920
CR4: 000006f0
Jan 28 21:32:26 SunSTG kernel:  [<f8d63562>] compute_parity6+0x21c/0x28a
[raid456]
Jan 28 21:32:26 SunSTG kernel:  [<f8d6452e>] handle_stripe+0xc8b/0x215e
[raid456]
Jan 28 21:32:26 SunSTG kernel:  [<c041f34b>] find_busiest_group
+0x177/0x462
Jan 28 21:32:26 SunSTG kernel:  [<c041fc53>] task_rq_lock+0x31/0x58
Jan 28 21:32:26 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
Jan 28 21:32:26 SunSTG kernel:  [<f8d6171e>] __release_stripe+0xfc/0x101
[raid456]
Jan 28 21:32:26 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
[raid456]
Jan 28 21:32:26 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
[raid456]
Jan 28 21:32:26 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
Jan 28 21:32:26 SunSTG kernel:  [<c0436347>] autoremove_wake_function
+0x0/0x2d
Jan 28 21:32:26 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
Jan 28 21:32:26 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
Jan 28 21:32:26 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
Jan 28 21:32:26 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
+0x7/0x10
Jan 28 21:32:26 SunSTG kernel:  =======================

<somewhere here I issue commands to create md4>

Jan 28 21:32:43 SunSTG kernel: md: syncing RAID array md4
Jan 28 21:32:43 SunSTG kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Jan 28 21:32:43 SunSTG kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Jan 28 21:32:43 SunSTG kernel: md: using 128k window, over a total of
244195200 blocks.
Jan 28 21:33:20 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 10s!
[md4_raid5:5694]
Jan 28 21:33:20 SunSTG kernel:
Jan 28 21:33:20 SunSTG kernel: Pid: 5694, comm:            md4_raid5
Jan 28 21:33:20 SunSTG kernel: EIP: 0060:[<f8d63aff>] CPU: 3
Jan 28 21:33:20 SunSTG kernel: EIP is at handle_stripe+0x25c/0x215e
[raid456]
Jan 28 21:33:20 SunSTG kernel:  EFLAGS: 00000282    Not tainted
(2.6.18-92.1.22.el5PAE #1)
Jan 28 21:33:20 SunSTG kernel: EAX: f6a2b404 EBX: 00000001 ECX: f53d17c0
EDX: e8c532c0
Jan 28 21:33:20 SunSTG kernel: ESI: e8c532c4 EDI: 00000016 EBP: e8c52b64
DS: 007b ES: 007b
Jan 28 21:33:20 SunSTG kernel: CR0: 8005003b CR2: b7cfc000 CR3: 3714ef00
CR4: 000006f0
Jan 28 21:33:20 SunSTG kernel:  [<c041f34b>] find_busiest_group
+0x177/0x462
Jan 28 21:33:20 SunSTG kernel:  [<c041fc53>] task_rq_lock+0x31/0x58
Jan 28 21:33:20 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
Jan 28 21:33:20 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
Jan 28 21:33:20 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
Jan 28 21:33:20 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
Jan 28 21:33:20 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
[raid456]
Jan 28 21:33:20 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
[raid456]
Jan 28 21:33:20 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
Jan 28 21:33:20 SunSTG kernel:  [<c0436347>] autoremove_wake_function
+0x0/0x2d
Jan 28 21:33:20 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
Jan 28 21:33:21 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
Jan 28 21:33:21 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
Jan 28 21:33:21 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
+0x7/0x10
Jan 28 21:33:21 SunSTG kernel:  =======================
Jan 28 21:33:50 SunSTG kernel: BUG: soft lockup - CPU#3 stuck for 10s!
[md4_raid5:5694]
Jan 28 21:33:50 SunSTG kernel:
Jan 28 21:33:50 SunSTG kernel: Pid: 5694, comm:            md4_raid5
Jan 28 21:33:50 SunSTG kernel: EIP: 0060:[<f8bf9813>] CPU: 3
Jan 28 21:33:50 SunSTG kernel: EIP is at xor_sse_5+0xa0/0x3b5 [xor]
Jan 28 21:33:50 SunSTG kernel:  EFLAGS: 00000202    Not tainted
(2.6.18-92.1.22.el5PAE #1)
Jan 28 21:33:50 SunSTG kernel: EAX: 0000000b EBX: e8e66500 ECX: e8e69500
EDX: e8e6e500
Jan 28 21:33:50 SunSTG kernel: ESI: e8e67500 EDI: e8e68500 EBP: e96b5dd4
DS: 007b ES: 007b
Jan 28 21:33:50 SunSTG kernel: CR0: 80050033 CR2: b7cfc000 CR3: 3714ef00
CR4: 000006f0
Jan 28 21:33:50 SunSTG kernel:  [<f8bfa200>] xor_block+0x74/0x7d [xor]
Jan 28 21:33:50 SunSTG kernel:  [<f8d636b3>] compute_block_1+0xe3/0x13a
[raid456]
Jan 28 21:33:50 SunSTG kernel:  [<f8d644ba>] handle_stripe+0xc17/0x215e
[raid456]
Jan 28 21:33:50 SunSTG kernel:  [<c041f34b>] find_busiest_group
+0x177/0x462
Jan 28 21:33:50 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
Jan 28 21:33:50 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
Jan 28 21:33:50 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
Jan 28 21:33:50 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
Jan 28 21:33:50 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
[raid456]
Jan 28 21:33:50 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
[raid456]
Jan 28 21:33:50 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
Jan 28 21:33:50 SunSTG kernel:  [<c0436347>] autoremove_wake_function
+0x0/0x2d
Jan 28 21:33:50 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
Jan 28 21:33:51 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
Jan 28 21:33:51 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
Jan 28 21:33:51 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
+0x7/0x10
Jan 28 21:33:51 SunSTG kernel:  =======================
... and it goes on complaining about md4_raid5:5694.

[root@SunSTG ~]# mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90.03
  Creation Time : Wed Jan 28 21:30:50 2009
     Raid Level : raid6
     Array Size : 5372294400 (5123.42 GiB 5501.23 GB)
  Used Dev Size : 244195200 (232.88 GiB 250.06 GB)
   Raid Devices : 24
  Total Devices : 24
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Wed Jan 28 21:30:50 2009
          State : clean, resyncing
 Active Devices : 24
Working Devices : 24
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

 Rebuild Status : 15% complete

           UUID : d8c2b5ce:576a117b:f2494cd1:626a774c
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1      65      160        1      active sync   /dev/sdaa
       2      65      176        2      active sync   /dev/sdab
       3      65      208        3      active sync   /dev/sdad
       4      65      224        4      active sync   /dev/sdae
       5      65      240        5      active sync   /dev/sdaf
       6      66        0        6      active sync   /dev/sdag
       7      66       16        7      active sync   /dev/sdah
       8      66       32        8      active sync   /dev/sdai
       9      66       48        9      active sync   /dev/sdaj
      10      66       64       10      active sync   /dev/sdak
      11      66       80       11      active sync   /dev/sdal
      12      66       96       12      active sync   /dev/sdam
      13      66      112       13      active sync   /dev/sdan
      14      66      128       14      active sync   /dev/sdao
      15      66      144       15      active sync   /dev/sdap
      16      66      160       16      active sync   /dev/sdaq
      17      66      176       17      active sync   /dev/sdar
      18      66      192       18      active sync   /dev/sdas
      19      66      208       19      active sync   /dev/sdat
      20      66      224       20      active sync   /dev/sdau
      21      66      240       21      active sync   /dev/sdav
      22       8       16       22      active sync   /dev/sdb
      23       8       32       23      active sync   /dev/sdc
[root@SunSTG ~]# mdadm --detail /dev/md4
/dev/md4:
        Version : 00.90.03
  Creation Time : Wed Jan 28 21:32:39 2009
     Raid Level : raid6
     Array Size : 4883904000 (4657.65 GiB 5001.12 GB)
  Used Dev Size : 244195200 (232.88 GiB 250.06 GB)
   Raid Devices : 22
  Total Devices : 22
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Wed Jan 28 21:32:39 2009
          State : clean, resyncing
 Active Devices : 22
Working Devices : 22
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

 Rebuild Status : 17% complete

           UUID : 7e2c7f35:f51c9047:40130c15:63a7cfa6
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8       48        0      active sync   /dev/sdd
       1       8       64        1      active sync   /dev/sde
       2       8       80        2      active sync   /dev/sdf
       3       8       96        3      active sync   /dev/sdg
       4       8      112        4      active sync   /dev/sdh
       5       8      128        5      active sync   /dev/sdi
       6       8      144        6      active sync   /dev/sdj
       7       8      160        7      active sync   /dev/sdk
       8       8      176        8      active sync   /dev/sdl
       9       8      192        9      active sync   /dev/sdm
      10       8      208       10      active sync   /dev/sdn
      11       8      224       11      active sync   /dev/sdo
      12       8      240       12      active sync   /dev/sdp
      13      65        0       13      active sync   /dev/sdq
      14      65       16       14      active sync   /dev/sdr
      15      65       32       15      active sync   /dev/sds
      16      65       48       16      active sync   /dev/sdt
      17      65       64       17      active sync   /dev/sdu
      18      65       80       18      active sync   /dev/sdv
      19      65       96       19      active sync   /dev/sdw
      20      65      112       20      active sync   /dev/sdx
      21      65      144       21      active sync   /dev/sdz


-- 
Best Regards,
Vladimir Ivashchenko
Chief Technology Officer
PrimeTel PLC, Cyprus - www.prime-tel.com
Tel: +357 25 100100 Fax: +357 2210 2211


