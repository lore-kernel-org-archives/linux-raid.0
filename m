From: Steven Haigh <netwiz@crc.id.au>
Subject: BUG: soft lockup - CPU#0 stuck for 10s! [md2_raid1:358]
Date: Wed, 21 Oct 2009 13:46:53 +1100
Message-ID: <F574C415-FFB3-4BF0-A00F-85C8FC41691C@crc.id.au>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When trying to run a check using:
	echo check > /sys/block/md2/md/sync_action

I got the following errors printed to the console:

Oct 21 13:31:03 wireless kernel: md: syncing RAID array md2
Oct 21 13:31:03 wireless kernel: md: minimum _guaranteed_  
reconstruction speed: 1000 KB/sec/disc.
Oct 21 13:31:03 wireless kernel: md: using maximum available idle IO  
bandwidth (but not more than 20000 KB/sec) for reconstruction.
Oct 21 13:31:03 wireless kernel: md: using 128k window, over a total  
of 300511808 blocks.
BUG: soft lockup - CPU#0 stuck for 10s! [md2_raid1:358]

Pid: 358, comm:            md2_raid1
EIP: 0060:[<c04ec1bc>] CPU: 0
EIP is at memcmp+0xd/0x22
  EFLAGS: 00000202    Not tainted  (2.6.18-164.el5 #1)
EAX: 00000000 EBX: e2826fe0 ECX: d15f3fe0 EDX: 00000000
ESI: 00000020 EDI: 00000090 EBP: f70b8e40 DS: 007b ES: 007b
CR0: 8005003b CR2: 0806af70 CR3: 37872000 CR4: 000006d0
  [<f8843c64>] raid1d+0x270/0xbea [raid1]
  [<c0616870>] schedule+0x9cc/0xa55
  [<c0616f33>] schedule_timeout+0x13/0x8c
  [<c05a6b5e>] md_thread+0xdf/0xf5
  [<c0434907>] autoremove_wake_function+0x0/0x2d
  [<c05a6a7f>] md_thread+0x0/0xf5
  [<c0434845>] kthread+0xc0/0xeb
  [<c0434785>] kthread+0x0/0xeb
  [<c0405c53>] kernel_thread_helper+0x7/0x10
  =======================
Oct 21 13:37:50 wireless kernel: BUG: soft lockup - CPU#0 stuck for  
10s! [md2_raid1:358]
Oct 21 13:37:50 wireless kernel:
Oct 21 13:37:50 wireless kernel: Pid: 358, comm:            md2_raid1
Oct 21 13:37:50 wireless kernel: EIP: 0060:[<c04ec1bc>] CPU: 0
Oct 21 13:37:50 wireless kernel: EIP is at memcmp+0xd/0x22
Oct 21 13:37:50 wireless kernel:  EFLAGS: 00000202    Not tainted   
(2.6.18-164.el5 #1)
Oct 21 13:37:50 wireless kernel: EAX: 00000000 EBX: e2826fe0 ECX:  
d15f3fe0 EDX: 00000000
Oct 21 13:37:50 wireless kernel: ESI: 00000020 EDI: 00000090 EBP:  
f70b8e40 DS: 007b ES: 007b
Oct 21 13:37:50 wireless kernel: CR0: 8005003b CR2: 0806af70 CR3:  
37872000 CR4: 000006d0
Oct 21 13:37:50 wireless kernel:  [<f8843c64>] raid1d+0x270/0xbea  
[raid1]
Oct 21 13:37:50 wireless kernel:  [<c0616870>] schedule+0x9cc/0xa55
Oct 21 13:37:50 wireless kernel:  [<c0616f33>] schedule_timeout 
+0x13/0x8c
Oct 21 13:37:50 wireless kernel:  [<c05a6b5e>] md_thread+0xdf/0xf5
Oct 21 13:37:51 wireless kernel:  [<c0434907>] autoremove_wake_function 
+0x0/0x2d
Oct 21 13:37:51 wireless kernel:  [<c05a6a7f>] md_thread+0x0/0xf5
Oct 21 13:37:51 wireless kernel:  [<c0434845>] kthread+0xc0/0xeb
Oct 21 13:37:51 wireless kernel:  [<c0434785>] kthread+0x0/0xeb
Oct 21 13:37:51 wireless kernel:  [<c0405c53>] kernel_thread_helper 
+0x7/0x10
Oct 21 13:37:51 wireless kernel:  =======================

This is using CentOS 5.3 with Kernel 2.6.18-164.el5 on an i686.

Is this a serious type error? Is there anything else I can supply to  
diagnose things more?

# mdadm --detail /dev/md2
/dev/md2:
         Version : 00.90.03
   Creation Time : Mon Feb 23 17:15:41 2009
      Raid Level : raid1
      Array Size : 300511808 (286.59 GiB 307.72 GB)
   Used Dev Size : 300511808 (286.59 GiB 307.72 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Wed Oct 21 13:46:28 2009
           State : clean, resyncing
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

  Rebuild Status : 5% complete

            UUID : fed99e3d:d08fdcc9:b9593a45:2cc09736
          Events : 0.30584

     Number   Major   Minor   RaidDevice State
        0       3        3        0      active sync   /dev/hda3
        1      22        3        1      active sync   /dev/hdc3


--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897




