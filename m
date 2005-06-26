From: Radu Filip <radu@tuiasi.ro>
Subject: Problem with software RAID-5
Date: Sun, 26 Jun 2005 07:20:16 +0300 (EEST)
Message-ID: <Pine.LNX.4.63.0506242010240.5345@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-admin@vger.kernel.org
List-Id: linux-raid.ids


Greetings,

I have encounered a wierd problem with software RAID 5: I can write files 
on the RAID volume, but when I read the files I get strange I/O errors:

Jun 25 23:40:39 raid1 kernel: attempt to access beyond end of device
Jun 25 23:40:39 raid1 kernel: md0: rw=0, want=10749025768, limit=1757815296
Jun 25 23:40:39 raid1 kernel: attempt to access beyond end of device
Jun 25 23:40:39 raid1 kernel: md0: rw=0, want=13199519200, limit=1757815296
Jun 25 23:40:39 raid1 kernel: attempt to access beyond end of device
[...]

Seems to be an ext3 error, but I think it is. Here is the long story:

I have few machines with TYAN motherboards, some with Intel CPU's, some 
with AMD Athlon. All with at least 1.5 GB of RAM. Some has 5 hard drives 
(ATA, using PCI exctention card), some has 6 hard drives. I think they are 
all Maxtor DiamondPlus drives.

The problem is the same on all three machines (which until recently ran 
RedHat 9.0 with software RAID0 with no problem; but now I have to make 
them RAID5). I think I can exclude hardware errors. On all these machines, 
I ran badblocks for few night, I also tested the drives with Maxtor 
utilities, and they are ok.

Memory is ok, I tested half a night with MemTest86.

I also tried different filesystems, not just Ext3. I tried also XFS and 
ReiserFS. No matter ther filesystem, when I try to read the test files I 
put there (and I fill up the RAID volume) I get strange errors, XFS hangs 
the machine, for example.

I also tried different kernels and different distributions. I tried Fedora 
Core 3, RedHat Enterprise 3 (both default kernel and updated kernel from 
update 3.5), Gentoo, CentOS 4 and CentOS 4.1. I also tried vanilla 
kernels, including the latest one 2.6.12.1. No matter whay I tried, and 
there are already three weeks since I am working on this, I always get on 
the damn error.

So in the end I think there are two possiblities:

1) either I am doing the same mistake all the time and I don't realize, 
even after I read the HOWTO-s for a number of times

2) there is something wrong in the Linux implementation of RAID5

Here is how I created the RAID5 the last time:

# mdadm --create /dev/md0 -c 128 -l 5 -n 5 /dev/hd{b,g,e,h}1 /dev/hda4

(I waited to volume to get into clean mode)

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid10] [faulty]
md0 : active raid5 hdh2[3] hdg2[2] hde2[1] hdc2[0] hda4[4]
        1084708352 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

unused devices: <none>

$ mdadm --misc -D /dev/md0
/dev/md0:
          Version : 00.90.01
    Creation Time : Fri May 27 03:34:20 2005
       Raid Level : raid5
       Array Size : 1084708352 (1034.46 GiB 1110.74 GB)
      Device Size : 271177088 (258.61 GiB 277.69 GB)
     Raid Devices : 5
    Total Devices : 5
Preferred Minor : 0
      Persistence : Superblock is persistent

      Update Time : Tue May 31 03:19:58 2005
            State : clean
   Active Devices : 5
Working Devices : 5
   Failed Devices : 0
    Spare Devices : 0

           Layout : left-symmetric
       Chunk Size : 64K

             UUID : 1f9feaed:d48e56c8:d68e1f66:0ff88b64
           Events : 0.8483

      Number   Major   Minor   RaidDevice State
         0      22        2        0      active sync   /dev/hdc2
         1      33        2        1      active sync   /dev/hde2
         2      34        2        2      active sync   /dev/hdg2
         3      34       66        3      active sync   /dev/hdh2
         4       3        4        4      active sync   /dev/hda4

I have formated the volume this way:
# mkfs.ext3 -v -b 4096 -R stride=32 /dev/md0



Usually, I gen only "attempt to access beyond end of device", but with 
several occasions I've also got:

Jun 14 08:36:47 raid1 kernel: ------------[ cut here ]------------
Jun 14 08:36:47 raid1 kernel: kernel BUG at drivers/md/raid5.c:813!
Jun 14 08:36:47 raid1 kernel: invalid operand: 0000 [#1]
Jun 14 08:36:47 raid1 kernel: Modules linked in: nfs lockd md5 ipv6 parport_pc lp parport autofs4 i2c_dev i2c_core sunrpc dm_mod button battery ac ohci_hcd ehci_hcd r8169 floppy ext3 jbd raid5 xor raid0
Jun 14 08:36:47 raid1 kernel: CPU:    0
Jun 14 08:36:47 raid1 kernel: EIP:    0060:[<628638bb>]    Not tainted VLI
Jun 14 08:36:47 raid1 kernel: EFLAGS: 00010016   (2.6.9-1.667)
Jun 14 08:36:47 raid1 kernel: EIP is at add_stripe_bio+0x195/0x3ec [raid5]
Jun 14 08:36:47 raid1 kernel: eax: 2362a9a0   ebx: 00000000   ecx: 2362a978   edx: 00000000
Jun 14 08:36:47 raid1 kernel: esi: 06e0da40   edi: 39f821c0   ebp: 39fdb3e0   esp: 0e1f6b38
Jun 14 08:36:47 raid1 kernel: ds: 007b   es: 007b   ss: 0068
Jun 14 08:36:47 raid1 kernel: Process md5sum (pid: 17070, threadinfo=0e1f6000 task=26cdb770)
Jun 14 08:36:47 raid1 kernel: Stack: 00000002 39fdb3e0 03e119b4 39f821c0 2362a978 00000000 39fdb3e0 62865405
Jun 14 08:36:47 raid1 kernel:        00000000 03e119b4 2362a980 00000000 00000004 00000005 39ff2a00 00000002
Jun 14 08:36:47 raid1 kernel:        00000000 60701c80 61c7fb50 39fdb3e0 00000000 022494f7 814eabf8 00000000
Jun 14 08:36:47 raid1 kernel: Call Trace:
Jun 14 08:36:47 raid1 kernel:  [<62865405>] make_request+0x112/0x3a9 [raid5]
Jun 14 08:36:47 raid1 kernel:  [<022494f7>] generic_make_request+0x190/0x1a0
Jun 14 08:36:47 raid1 kernel:  [<0218ede0>] mpage_end_io_read+0x0/0x5e
Jun 14 08:36:47 raid1 kernel:  [<022495ab>] submit_bio+0xa4/0xac
Jun 14 08:36:47 raid1 kernel:  [<628bdf03>] ext3_get_block+0x64/0x6c [ext3]
Jun 14 08:36:47 raid1 kernel:  [<0218ede0>] mpage_end_io_read+0x0/0x5e
Jun 14 08:36:47 raid1 kernel:  [<0218eeab>] mpage_bio_submit+0x19/0x1d
Jun 14 08:36:47 raid1 kernel:  [<0218f1f8>] do_mpage_readpage+0x259/0x352
Jun 14 08:36:47 raid1 kernel:  [<021db898>] radix_tree_node_alloc+0x10/0x41
Jun 14 08:36:47 raid1 kernel:  [<021dba2a>] radix_tree_insert+0x6e/0xe7
Jun 14 08:36:47 raid1 kernel:  [<0218f382>] mpage_readpages+0x91/0xf9
Jun 14 08:36:47 raid1 kernel:  [<628bde9f>] ext3_get_block+0x0/0x6c [ext3]
Jun 14 08:36:47 raid1 kernel:  [<021464e6>] __rmqueue+0xbb/0x106
Jun 14 08:36:47 raid1 kernel:  [<628bea38>] ext3_readpages+0x12/0x14 [ext3]
Jun 14 08:36:47 raid1 kernel:  [<628bde9f>] ext3_get_block+0x0/0x6c [ext3]
Jun 14 08:36:47 raid1 kernel:  [<021498a7>] read_pages+0x2d/0xd0
Jun 14 08:36:47 raid1 kernel:  [<02146b10>] buffered_rmqueue+0x1dd/0x200
Jun 14 08:36:47 raid1 kernel:  [<02146be7>] __alloc_pages+0xb4/0x298
Jun 14 08:36:47 raid1 kernel:  [<02149ee7>] do_page_cache_readahead+0x29a/0x2ba
Jun 14 08:36:47 raid1 kernel:  [<0214a072>] page_cache_readahead+0x16b/0x19e
Jun 14 08:36:47 raid1 kernel:  [<02142ed2>] do_generic_mapping_read+0xd9/0x37c
Jun 14 08:36:47 raid1 kernel:  [<021433d1>] __generic_file_aio_read+0x164/0x17e
Jun 14 08:36:47 raid1 kernel:  [<02143175>] file_read_actor+0x0/0xf8
Jun 14 08:36:47 raid1 kernel:  [<0214342b>] generic_file_aio_read+0x40/0x47
Jun 14 08:36:47 raid1 kernel:  [<02165467>] do_sync_read+0x97/0xc9
Jun 14 08:36:47 raid1 kernel:  [<0211cf5b>] autoremove_wake_function+0x0/0x2d
Jun 14 08:36:47 raid1 kernel:  [<0211ae71>] recalc_task_prio+0x128/0x133
[...]
Jun 14 08:36:47 raid1 kernel:  [<0211cf5b>] autoremove_wake_function+0x0/0x2d
Jun 14 08:36:47 raid1 kernel:  [<0211ae71>] recalc_task_prio+0x128/0x133
Jun 14 08:36:47 raid1 kernel:  [<0216554f>] vfs_read+0xb6/0xe2
Jun 14 08:36:47 raid1 kernel:  [<02165762>] sys_read+0x3c/0x62


So can somebody please help me to debug this RAID5 problem?

Thanks!
