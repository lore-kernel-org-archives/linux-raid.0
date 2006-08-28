From: Ralf Herrmann <Ralf.Herrmann@TU-Ilmenau.de>
Subject: PROBLEM: system crash on AMD64 with 2.6.17.11 while accessing 3TB Software-RAID5
Date: Tue, 29 Aug 2006 00:10:41 +0200
Message-ID: <758194931.20060829001041@TU-Ilmenau.de>
Reply-To: Ralf.Herrmann@TU-Ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

i hope i picked the right list for this problem,
here's the formal report:

[1.] One line summary of the problem:

 System crashes while accessing a 3TB RAID5 on an AMD64 with 2.6.17.11.

[2.] Full description of the problem/report:

  We've been running a production SMB server with 5x400GB SATA HDDs
  as a software RAID5. The system is a quite normal PC (see below [7.]).
  It was running smoothly with a 2.6.12.2 vanilla kernel.
  File system is XFS with external log (on the system HDD).

  When the ~1.6TB were filled, it's been decided to switch to bigger hard
  drives (i know it is generally a bad idea to go for the latest drives,
  but it was the only option that our lab had), namely 750GB Seagate drives.

  After creating the new RAID5, which has now almost 3TB usable space,
  a backup restore was done. Because of some box freezes during the restore,
  i tried to switch to the latest stable kernel, currently 2.6.17.11.
  I was able to restore the backup, but rare crashes happend anyways.

  After putting the server back online for a production test, it froze again,
  when we tried to copy additional data onto the RAID.

  A relevant part of /var/log/messages for the latest crash is listed below in
  this mail. Although the files named in the log seem to be related to
  memory managment, the problem only appears when the RAID is accessed.
  The RAID was also the only thing that changed when the problem occurred.
  Nevertheless my first guess was a problem with memory or virtual memory.

  Here's a list of things i tried to resolve the problem or find the cause:

  - memtest of whole RAM: no problems occured
  - badblocks of system harddrive: no problems
  - badblocks for the HDDs: no problems
  - tried with all swap space turned off, did not help
  - compiled the 2.6.17.11 kernel with more conservative options
    (even without swap support), did not help
  - compiled the kernel with CONFIG_LBD=YES and CONFIG_LBD=NO,
    neither did help
  - the problems happened while accessing the XFS file system,
    so i upgraded to the lastest xfs-tools and did a xfs_repair,
    no change
  - tried to access the RAID at the block layer (badblocks/dd),
    this reproduced the problem, but always after different amounts of
    continous access time
  - Web search regarding Large Block Devices, RAID5 and kernel limitations,
    unfortunately there was no information on my particular symptoms

  Since the problem persists, when accessing the RAID at the block layer,
  it does not seem to be related to XFS.

  Unfortunately, when reading the messages from different crashes,
  different kernel files were mentioned:

  - mm/vmscan.c
  - mm/filemap.c
  - possibly others i missed

  As stated above, when i start the test command (see section [6.]
  in this mail), the problem occurs after different time intervals.

  In some cases, the machine immediately becomes inresposive.
  In other cases it just reports a kernel problem with the
  hint "Fixing recursive fault but reboot is needed!" and stops
  the process which accessed the RAID. In such cases the
  stopped process cannot be killed (not even with kill -9 <pid>)
  and i have to reboot the system to be able to access the RAID.

[3.] Keywords (i.e., modules, networking, kernel):

  - virtual memory management
  - large block devices
  - RAID5
  - kernel 2.6.12.2, 2.6.17.11
  
[4.] Kernel version (from /proc/version):

  Linux version 2.6.17.11custom (root@korn) (gcc version 3.3.4 (pre 3.3.5 20040809)) #5 Mon Aug 28 17:06:12 CEST 2006

[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)

  - Here's what i got from ksymoops when feeding it with the log in
    /var/log/messages after the last crash:

ksymoops 2.4.9 on x86_64 2.6.17.11custom.  Options used
     -V (default)
     -k /proc/kallsyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.17.11custom/ (default)
     -m /boot/System.map-2.6.17.11custom (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Warning (read_ksyms): no kernel symbols in ksyms, is /proc/kallsyms a valid ksyms file?
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Aug 28 18:49:39 korn kernel: Kernel BUG at mm/vmscan.c:591
Aug 28 18:49:39 korn kernel: CPU 0
Aug 28 18:49:39 korn kernel: Pid: 291, comm: kswapd0 Not tainted 2.6.17.11custom #5
Aug 28 18:49:39 korn kernel: RIP: 0010:[<ffffffff802540c1>] <ffffffff802540c1>{isolate_lru_pages+65}
Using defaults from ksymoops -t elf64-x86-64 -a i386:x86-64
Aug 28 18:49:39 korn kernel: RSP: 0018:ffff81007fa65b78  EFLAGS: 00010046
Aug 28 18:49:39 korn kernel: RAX: 00000000309fb250 RBX: ffff81007fa65d28 RCX: 0000000000000014
Aug 28 18:49:39 korn kernel: RDX: ffff810001bbd9b8 RSI: ffffffff807a8380 RDI: 0000000000000020
Aug 28 18:49:39 korn kernel: RBP: ffff81007fa65c08 R08: ffff810001a89c68 R09: ffff810001a89c40
Aug 28 18:49:39 korn kernel: R10: ffff81007fa65d28 R11: 0000000000000014 R12: 0000000000000003
Aug 28 18:49:39 korn kernel: R13: ffff81007a8ace58 R14: ffff81007fa65d28 R15: ffff81007a8ace58
Aug 28 18:49:39 korn kernel: FS:  00002b73867de4c0(0000) GS:ffffffff808cf000(0000) knlGS:0000000000000000
Aug 28 18:49:39 korn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug 28 18:49:39 korn kernel: CR2: 00002ae45fa38b00 CR3: 0000000078592000 CR4: 00000000000006e0
Aug 28 18:49:39 korn kernel: Stack: 0000000000000001 ffff81000195a658 ffffffff807a81e8 ffffffff802549bb
Aug 28 18:49:39 korn kernel:        ffff81007fa65cc8 ffffffff807a8380 0000000100000256 0000000000000020
Aug 28 18:49:39 korn kernel:        000000007fa65bf8 0000000000000020
Aug 28 18:49:39 korn kernel: Call Trace: <ffffffff802549bb>{shrink_zone+1467} <ffffffff8025512f>{shrink_slab+351}
Aug 28 18:49:39 korn kernel:        <ffffffff80255380>{balance_pgdat+560} <ffffffff80621fc3>{thread_return+0}
Aug 28 18:49:39 korn kernel:        <ffffffff8023a982>{prepare_to_wait+66} <ffffffff80255617>{kswapd+295}
Aug 28 18:49:39 korn kernel:        <ffffffff8023a990>{autoremove_wake_function+0} <ffffffff8023a990>{autoremove_wake_function+0}
Aug 28 18:49:39 korn kernel:        <ffffffff8020a42a>{child_rip+8} <ffffffff802554f0>{kswapd+0}
Aug 28 18:49:39 korn kernel:        <ffffffff8020a422>{child_rip+0}
Aug 28 18:49:39 korn kernel: Code: 0f 0b 68 21 09 67 80 c2 4f 02 66 66 90 66 90 49 8b 50 08 49


>>RIP; ffffffff802540c1 <isolate_lru_pages+41/e0>   <=====

>>RAX; 00000000309fb250 <phys_startup_64+307fb150/ffffffff7fffff00>
>>RBX; ffff81007fa65d28 <phys_startup_64+ffff81007f865c28/ffffffff7fffff00>
>>RDX; ffff810001bbd9b8 <phys_startup_64+ffff8100019bd8b8/ffffffff7fffff00>
>>RSI; ffffffff807a8380 <contig_page_data+3c0/9c0>
>>RBP; ffff81007fa65c08 <phys_startup_64+ffff81007f865b08/ffffffff7fffff00>
>>R08; ffff810001a89c68 <phys_startup_64+ffff810001889b68/ffffffff7fffff00>
>>R09; ffff810001a89c40 <phys_startup_64+ffff810001889b40/ffffffff7fffff00>
>>R10; ffff81007fa65d28 <phys_startup_64+ffff81007f865c28/ffffffff7fffff00>
>>R13; ffff81007a8ace58 <phys_startup_64+ffff81007a6acd58/ffffffff7fffff00>
>>R14; ffff81007fa65d28 <phys_startup_64+ffff81007f865c28/ffffffff7fffff00>
>>R15; ffff81007a8ace58 <phys_startup_64+ffff81007a6acd58/ffffffff7fffff00>

Trace; ffffffff802549bb <shrink_zone+5bb/bd0>
Trace; ffffffff80255380 <balance_pgdat+230/3a0>
Trace; ffffffff8023a982 <prepare_to_wait+42/50>
Trace; ffffffff8023a990 <autoremove_wake_function+0/30>
Trace; ffffffff8020a42a <child_rip+8/12>
Trace; ffffffff8020a422 <child_rip+0/12>

Code;  ffffffff802540c1 <isolate_lru_pages+41/e0>
0000000000000000 <_RIP>:
Code;  ffffffff802540c1 <isolate_lru_pages+41/e0>   <=====
   0:   0f 0b                     ud2a      <=====
Code;  ffffffff802540c3 <isolate_lru_pages+43/e0>
   2:   68 21 09 67 80            pushq  $0xffffffff80670921
Code;  ffffffff802540c8 <isolate_lru_pages+48/e0>
   7:   c2 4f 02                  retq   $0x24f
Code;  ffffffff802540cb <isolate_lru_pages+4b/e0>
   a:   66                        data16
Code;  ffffffff802540cc <isolate_lru_pages+4c/e0>
   b:   66                        data16
Code;  ffffffff802540cd <isolate_lru_pages+4d/e0>
   c:   90                        nop
Code;  ffffffff802540ce <isolate_lru_pages+4e/e0>
   d:   66                        data16
Code;  ffffffff802540cf <isolate_lru_pages+4f/e0>
   e:   90                        nop
Code;  ffffffff802540d0 <isolate_lru_pages+50/e0>
   f:   49 8b 50 08               mov    0x8(%r8),%rdx
Code;  ffffffff802540d4 <isolate_lru_pages+54/e0>
  13:   49 00 00                  rex64Z add    %al,(%r8)

Aug 28 18:49:39 korn kernel: Kernel BUG at mm/vmscan.c:591
Aug 28 18:49:39 korn kernel: CPU 0
Aug 28 18:49:39 korn kernel: Pid: 6445, comm: dd Not tainted 2.6.17.11custom #5
Aug 28 18:49:39 korn kernel: RIP: 0010:[<ffffffff802540c1>] <ffffffff802540c1>{isolate_lru_pages+65}
Aug 28 18:49:39 korn kernel: RSP: 0018:ffff81007c1037d8  EFLAGS: 00010046
Aug 28 18:49:39 korn kernel: RAX: 00000000309fb250 RBX: ffff81007c103988 RCX: 0000000000000000
Aug 28 18:49:39 korn kernel: RDX: ffff81007c103988 RSI: ffffffff807a8380 RDI: 0000000000000020
Aug 28 18:49:39 korn kernel: RBP: ffff81007c103868 R08: ffff810001a89c68 R09: ffff810001a89c40
Aug 28 18:49:39 korn kernel: R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff807a81e8
Aug 28 18:49:39 korn kernel: R13: 0000000000000000 R14: ffff81007c103988 R15: 0000000000000000
Aug 28 18:49:39 korn kernel: FS:  00002b73867de4c0(0000) GS:ffffffff808cf000(0000) knlGS:0000000000000000
Aug 28 18:49:39 korn kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 28 18:49:39 korn kernel: CR2: 0000000000510918 CR3: 0000000078592000 CR4: 00000000000006e0
Aug 28 18:49:39 korn kernel: Stack: 0000000000000000 ffffffff807a8860 ffffffff807a81e8 ffffffff802549bb
Aug 28 18:49:39 korn kernel:        0000000300000000 ffffffff807a8380 ffff81007ede7090 ffff81007ede7040
Aug 28 18:49:39 korn kernel:        0000000000000000 0000000000000000
Aug 28 18:49:39 korn kernel: Call Trace: <ffffffff802549bb>{shrink_zone+1467} <ffffffff80550277>{handle_stripe+4647}
Aug 28 18:49:39 korn kernel:        <ffffffff80551eb4>{make_request+1108} <ffffffff8023a990>{autoremove_wake_function+0}
Aug 28 18:49:39 korn kernel:        <ffffffff8023a990>{autoremove_wake_function+0} <ffffffff80418546>{generic_make_request+518}
Aug 28 18:49:39 korn kernel:        <ffffffff80269df9>{init_buffer_head+25} <ffffffff802655d4>{cache_alloc_refill+996}
Aug 28 18:49:39 korn kernel:        <ffffffff80418638>{submit_bio+216} <ffffffff8025581b>{try_to_free_pages+315}
Aug 28 18:49:39 korn kernel:        <ffffffff802518ae>{__alloc_pages+430} <ffffffff80252a9d>{__do_page_cache_readahead+189}
Aug 28 18:49:39 korn kernel:        <ffffffff80252c8d>{blockable_page_cache_readahead+109}
Aug 28 18:49:39 korn kernel:        <ffffffff80252d86>{make_ahead_window+134} <ffffffff80252f55>{page_cache_readahead+421}
Aug 28 18:49:39 korn kernel:        <ffffffff8024d117>{do_generic_mapping_read+343} <ffffffff8024c1a0>{file_read_actor+0}
Aug 28 18:49:39 korn kernel:        <ffffffff8024ece7>{__generic_file_aio_read+407} <ffffffff8024ee9b>{generic_file_read+171}
Aug 28 18:49:39 korn kernel:        <ffffffff8023a990>{autoremove_wake_function+0} <ffffffff80269319>{vfs_read+233}
Aug 28 18:49:39 korn kernel:        <ffffffff802694c3>{sys_read+83} <ffffffff802099ee>{system_call+126}
Aug 28 18:49:39 korn kernel: Code: 0f 0b 68 21 09 67 80 c2 4f 02 66 66 90 66 90 49 8b 50 08 49


>>RIP; ffffffff802540c1 <isolate_lru_pages+41/e0>   <=====

>>RAX; 00000000309fb250 <phys_startup_64+307fb150/ffffffff7fffff00>
>>RBX; ffff81007c103988 <phys_startup_64+ffff81007bf03888/ffffffff7fffff00>
>>RDX; ffff81007c103988 <phys_startup_64+ffff81007bf03888/ffffffff7fffff00>
>>RSI; ffffffff807a8380 <contig_page_data+3c0/9c0>
>>RBP; ffff81007c103868 <phys_startup_64+ffff81007bf03768/ffffffff7fffff00>
>>R08; ffff810001a89c68 <phys_startup_64+ffff810001889b68/ffffffff7fffff00>
>>R09; ffff810001a89c40 <phys_startup_64+ffff810001889b40/ffffffff7fffff00>
>>R12; ffffffff807a81e8 <contig_page_data+228/9c0>
>>R14; ffff81007c103988 <phys_startup_64+ffff81007bf03888/ffffffff7fffff00>

Trace; ffffffff802549bb <shrink_zone+5bb/bd0>
Trace; ffffffff80551eb4 <make_request+454/4b0>
Trace; ffffffff8023a990 <autoremove_wake_function+0/30>
Trace; ffffffff80269df9 <init_buffer_head+19/30>
Trace; ffffffff80418638 <submit_bio+d8/100>
Trace; ffffffff802518ae <__alloc_pages+1ae/2c0>
Trace; ffffffff80252c8d <blockable_page_cache_readahead+6d/e0>
Trace; ffffffff80252d86 <make_ahead_window+86/b0>
Trace; ffffffff8024d117 <do_generic_mapping_read+157/490>
Trace; ffffffff8024ece7 <__generic_file_aio_read+197/1f0>
Trace; ffffffff8023a990 <autoremove_wake_function+0/30>
Trace; ffffffff802694c3 <sys_read+53/90>

Code;  ffffffff802540c1 <isolate_lru_pages+41/e0>
0000000000000000 <_RIP>:
Code;  ffffffff802540c1 <isolate_lru_pages+41/e0>   <=====
   0:   0f 0b                     ud2a      <=====
Code;  ffffffff802540c3 <isolate_lru_pages+43/e0>
   2:   68 21 09 67 80            pushq  $0xffffffff80670921
Code;  ffffffff802540c8 <isolate_lru_pages+48/e0>
   7:   c2 4f 02                  retq   $0x24f
Code;  ffffffff802540cb <isolate_lru_pages+4b/e0>
   a:   66                        data16
Code;  ffffffff802540cc <isolate_lru_pages+4c/e0>
   b:   66                        data16
Code;  ffffffff802540cd <isolate_lru_pages+4d/e0>
   c:   90                        nop
Code;  ffffffff802540ce <isolate_lru_pages+4e/e0>
   d:   66                        data16
Code;  ffffffff802540cf <isolate_lru_pages+4f/e0>
   e:   90                        nop
Code;  ffffffff802540d0 <isolate_lru_pages+50/e0>
   f:   49 8b 50 08               mov    0x8(%r8),%rdx
Code;  ffffffff802540d4 <isolate_lru_pages+54/e0>
  13:   49 00 00                  rex64Z add    %al,(%r8)

Aug 28 18:49:39 korn kernel:  <1>Unable to handle kernel NULL pointer dereference at 00000000000001f8 RIP:
Aug 28 18:49:39 korn kernel: <ffffffff8024bd28>{page_waitqueue+72}
Aug 28 18:49:39 korn kernel: Oops: 0000 [3]
Aug 28 18:49:39 korn kernel: CPU 0
Aug 28 18:49:39 korn kernel: Pid: 6445, comm: dd Not tainted 2.6.17.11custom #5
Aug 28 18:49:39 korn kernel: RIP: 0010:[<ffffffff8024bd28>] <ffffffff8024bd28>{page_waitqueue+72}
Aug 28 18:49:39 korn kernel: RSP: 0018:ffff81007c103430  EFLAGS: 00010202
Aug 28 18:49:39 korn kernel: RAX: 62bf7a5d90089c68 RBX: ffff810001a89c68 RCX: 0000000000000040
Aug 28 18:49:39 korn kernel: RDX: 0000000000000000 RSI: ffff8100330efac8 RDI: 0000000000000000
Aug 28 18:49:39 korn kernel: RBP: 000000001d5eb715 R08: 0000000000000002 R09: ffff81007c103336
Aug 28 18:49:39 korn kernel: R10: 0000000000000000 R11: ffff81007c103388 R12: 000000000000000c
Aug 28 18:49:39 korn kernel: R13: ffffffffffffffff R14: ffff81007a8ace58 R15: ffff81007c103458
Aug 28 18:49:39 korn kernel: FS:  00002b73867de4c0(0000) GS:ffffffff808cf000(0000) knlGS:0000000000000000
Aug 28 18:49:39 korn kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 28 18:49:39 korn kernel: CR2: 00000000000001f8 CR3: 0000000078592000 CR4: 00000000000006e0
Aug 28 18:49:39 korn kernel: Stack: ffffffff8024c5a0 ffff810001a89c68 ffffffff80253cf8 0000000000000000
Aug 28 18:49:39 korn kernel:        0000000000070beb 000000000000000e 0000000000000000 ffff81000195b848
Aug 28 18:49:39 korn kernel:        ffff8100018737e0 ffff810001873818
Aug 28 18:49:39 korn kernel: Call Trace: <ffffffff8024c5a0>{unlock_page+32} <ffffffff80253cf8>{invalidate_mapping_pages+168}
Aug 28 18:49:39 korn kernel:        <ffffffff8026ffce>{kill_bdev+14} <ffffffff802705c5>{blkdev_put+85}
Aug 28 18:49:39 korn kernel:        <ffffffff80269972>{__fput+178} <ffffffff802666be>{filp_close+110}
Aug 28 18:49:39 korn kernel:        <ffffffff802298e3>{put_files_struct+115} <ffffffff8022aeb9>{do_exit+585}
Aug 28 18:49:39 korn kernel:        <ffffffff804ab6c5>{do_unblank_screen+21} <ffffffff8020b3c1>{die+81}
Aug 28 18:49:39 korn kernel:        <ffffffff8020bd1b>{do_invalid_op+155} <ffffffff802540c1>{isolate_lru_pages+65}
Aug 28 18:49:39 korn kernel:        <ffffffff8041a1c4>{get_request_wait+36} <ffffffff80416c01>{blk_recount_segments+145}
Aug 28 18:49:39 korn kernel:        <ffffffff8020a271>{error_exit+0} <ffffffff802540c1>{isolate_lru_pages+65}
Aug 28 18:49:39 korn kernel:        <ffffffff80418546>{generic_make_request+518} <ffffffff802549bb>{shrink_zone+1467}
Aug 28 18:49:39 korn kernel:        <ffffffff80550277>{handle_stripe+4647} <ffffffff80551eb4>{make_request+1108}
Aug 28 18:49:39 korn kernel:        <ffffffff8023a990>{autoremove_wake_function+0} <ffffffff8023a990>{autoremove_wake_function+0}
Aug 28 18:49:39 korn kernel:        <ffffffff80418546>{generic_make_request+518} <ffffffff80269df9>{init_buffer_head+25}
Aug 28 18:49:39 korn kernel:        <ffffffff802655d4>{cache_alloc_refill+996} <ffffffff80418638>{submit_bio+216}
Aug 28 18:49:39 korn kernel:        <ffffffff8025581b>{try_to_free_pages+315} <ffffffff802518ae>{__alloc_pages+430}
Aug 28 18:49:39 korn kernel:        <ffffffff80252a9d>{__do_page_cache_readahead+189} <ffffffff80252c8d>{blockable_page_cache_readahead+109}
Aug 28 18:49:39 korn kernel:        <ffffffff80252d86>{make_ahead_window+134} <ffffffff80252f55>{page_cache_readahead+421}
Aug 28 18:49:39 korn kernel:        <ffffffff8024d117>{do_generic_mapping_read+343} <ffffffff8024c1a0>{file_read_actor+0}
Aug 28 18:49:39 korn kernel:        <ffffffff8024ece7>{__generic_file_aio_read+407} <ffffffff8024ee9b>{generic_file_read+171}
Aug 28 18:49:39 korn kernel:        <ffffffff8023a990>{autoremove_wake_function+0} <ffffffff80269319>{vfs_read+233}
Aug 28 18:49:39 korn kernel:        <ffffffff802694c3>{sys_read+83} <ffffffff802099ee>{system_call+126}
Aug 28 18:49:39 korn kernel: Code: 2b 8a f8 01 00 00 48 d3 e8 48 c1 e0 04 48 03 82 e8 01 00 00


>>RIP; ffffffff8024bd28 <page_waitqueue+48/60>   <=====

>>RAX; 62bf7a5d90089c68 <phys_startup_64+62bf7a5d8fe89b68/ffffffff7fffff00>
>>RBX; ffff810001a89c68 <phys_startup_64+ffff810001889b68/ffffffff7fffff00>
>>RSI; ffff8100330efac8 <phys_startup_64+ffff810032eef9c8/ffffffff7fffff00>
>>RBP; 000000001d5eb715 <phys_startup_64+1d3eb615/ffffffff7fffff00>
>>R09; ffff81007c103336 <phys_startup_64+ffff81007bf03236/ffffffff7fffff00>
>>R11; ffff81007c103388 <phys_startup_64+ffff81007bf03288/ffffffff7fffff00>
>>R14; ffff81007a8ace58 <phys_startup_64+ffff81007a6acd58/ffffffff7fffff00>
>>R15; ffff81007c103458 <phys_startup_64+ffff81007bf03358/ffffffff7fffff00>

Trace; ffffffff8024c5a0 <unlock_page+20/30>
Trace; ffffffff8026ffce <kill_bdev+e/30>
Trace; ffffffff80269972 <__fput+b2/1a0>
Trace; ffffffff802298e3 <put_files_struct+73/c0>
Trace; ffffffff804ab6c5 <do_unblank_screen+15/150>
Trace; ffffffff8020bd1b <do_invalid_op+9b/b0>
Trace; ffffffff8041a1c4 <get_request_wait+24/1a0>
Trace; ffffffff8020a271 <error_exit+0/84>
Trace; ffffffff80418546 <generic_make_request+206/220>
Trace; ffffffff80550277 <handle_stripe+1227/1280>
Trace; ffffffff8023a990 <autoremove_wake_function+0/30>
Trace; ffffffff80418546 <generic_make_request+206/220>
Trace; ffffffff802655d4 <cache_alloc_refill+3e4/490>
Trace; ffffffff8025581b <try_to_free_pages+13b/240>
Trace; ffffffff80252a9d <__do_page_cache_readahead+bd/240>
Trace; ffffffff80252d86 <make_ahead_window+86/b0>
Trace; ffffffff8024d117 <do_generic_mapping_read+157/490>
Trace; ffffffff8024ece7 <__generic_file_aio_read+197/1f0>
Trace; ffffffff8023a990 <autoremove_wake_function+0/30>
Trace; ffffffff802694c3 <sys_read+53/90>

Code;  ffffffff8024bd28 <page_waitqueue+48/60>
0000000000000000 <_RIP>:
Code;  ffffffff8024bd28 <page_waitqueue+48/60>   <=====
   0:   2b 8a f8 01 00 00         sub    0x1f8(%rdx),%ecx   <=====
Code;  ffffffff8024bd2e <page_waitqueue+4e/60>
   6:   48 d3 e8                  shr    %cl,%rax
Code;  ffffffff8024bd31 <page_waitqueue+51/60>
   9:   48 c1 e0 04               shl    $0x4,%rax
Code;  ffffffff8024bd35 <page_waitqueue+55/60>
   d:   48 03 82 e8 01 00 00      add    0x1e8(%rdx),%rax

Aug 28 18:49:39 korn kernel: CR2: 00000000000001f8

  - this is the log of an earlier crash, this time a different kernel file seems
    to be affected, although this happened with the earlier kernel 2.6.12.2,
    that's why i have no symbol information:

Aug 26 15:33:25 korn kernel: ----------- [cut here ] --------- [please bite here ] ---------
Aug 26 15:33:25 korn kernel: Kernel BUG at "mm/filemap.c":459
Aug 26 15:33:25 korn kernel: invalid operand: 0000 [1]
Aug 26 15:33:25 korn kernel: CPU 0
Aug 26 15:33:25 korn kernel: Modules linked in: edd ip6table_mangle ip_nat_ftp ip_conntrack_ftp ip6table_filter ip6_tables ipv6
Aug 26 15:33:25 korn kernel: Pid: 1060, comm: md0_raid5 Not tainted 2.6.12.2custom
Aug 26 15:33:25 korn kernel: RIP: 0010:[<ffffffff801524ee>] <ffffffff801524ee>{unlock_page+14}
Aug 26 15:33:25 korn kernel: RSP: 0018:ffff81007f739df8  EFLAGS: 00010246
Aug 26 15:33:25 korn kernel: RAX: 0000000000000000 RBX: ffff810001c8d898 RCX: 0000000000000035
Aug 26 15:33:25 korn kernel: RDX: ffff810037ead298 RSI: ffff810037ead298 RDI: ffff810001c8d898
Aug 26 15:33:25 korn kernel: RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
Aug 26 15:33:25 korn kernel: R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
Aug 26 15:33:25 korn kernel: R13: ffff81007effe820 R14: 0000000000000000 R15: 0000000000000004
Aug 26 15:33:25 korn kernel: FS:  00002aaaaade44c0(0000) GS:ffffffff80722b00(0000) knlGS:0000000000000000
Aug 26 15:33:25 korn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug 26 15:33:25 korn kernel: CR2: 00002aaaaaef2b00 CR3: 0000000077921000 CR4: 00000000000006e0
Aug 26 15:33:25 korn kernel: Process md0_raid5 (pid: 1060, threadinfo ffff81007f738000, task ffff81007f5b41b0)
Aug 26 15:33:25 korn kernel: Stack: ffff810072aea380 ffffffff8017134e ffff810072aea380 ffffffff8043d398
Aug 26 15:33:25 korn kernel:        ffff81007ee45478 0000000000000000 0000000000000000 0000000000000000
Aug 26 15:33:25 korn kernel:        0000000400000000 0000000000000000
Aug 26 15:33:25 korn kernel: Call Trace:<ffffffff8017134e>{end_bio_bh_io_sync+46} <ffffffff8043d398>{handle_stripe+3256}
Aug 26 15:33:25 korn kernel:        <ffffffff8043e4f3>{raid5d+227} <ffffffff80449467>{md_thread+327}
Aug 26 15:33:25 korn kernel:        <ffffffff80144af0>{autoremove_wake_function+0} <ffffffff80144af0>{autoremove_wake_function+0}
Aug 26 15:33:25 korn kernel:        <ffffffff8043e410>{raid5d+0} <ffffffff8010f17b>{child_rip+8}
Aug 26 15:33:25 korn kernel:        <ffffffff8043e410>{raid5d+0} <ffffffff80449320>{md_thread+0}
Aug 26 15:33:25 korn kernel:        <ffffffff8010f173>{child_rip+0}
Aug 26 15:33:25 korn kernel:
Aug 26 15:33:25 korn kernel: Code: 0f 0b 95 89 52 80 ff ff ff ff cb 01 48 89 df e8 3e f7 ff ff
Aug 26 15:33:25 korn kernel: RIP <ffffffff801524ee>{unlock_page+14} RSP <ffff81007f739df8>

  ... a disassemble of the "Code: ...." via gdb gives:

Dump of assembler code for function str1:
0x0000000000500890 <str1+0>:    ud2a
0x0000000000500892 <str1+2>:    xchg   %eax,%ebp
0x0000000000500893 <str1+3>:    mov    %edx,0xffffffffffffff80(%rdx)
0x0000000000500896 <str1+6>:    (bad)
0x0000000000500897 <str1+7>:    (bad)
0x0000000000500898 <str1+8>:    (bad)
0x0000000000500899 <str1+9>:    dec    %ebx
0x000000000050089b <str1+11>:   add    %ecx,0xffffffffffffff89(%rax)
0x000000000050089e <str1+14>:   fucomip %st(0),%st
0x00000000005008a0 <str1+16>:   ds
0x00000000005008a1 <str1+17>:   idiv   %edi
0x00000000005008a3 <str1+19>:   incl   (%rax)
0x00000000005008a5 <str1+21>:   add    %al,(%rax)
0x00000000005008a7 <str1+23>:   add    %al,(%rax)
0x00000000005008a9 <str1+25>:   add    %al,(%rax)
0x00000000005008ab <str1+27>:   add    %al,(%rax)
0x00000000005008ad <str1+29>:   add    %al,(%rax)
0x00000000005008af <str1+31>:   add    %cl,(%rdi)
End of assembler dump.

[6.] A small shell script or example program which triggers the
     problem (if possible)

  - dd of the RAID partition (bash-shell):

    dd if=/dev/md0 skip=1048576 of=/dev/null bs=1048576 count=1048576 >/root/dd_1 2>/root/dd_2 &

[7.] Environment

  - AMD64 PC with 2x1GB DDR DIMM (Dual-Channel configuration)
  - System HDD: WDC WD800JB-00DUA3, 80GB, PATA, UDMA
  - RAID HDD, 5x Seagate ST3750640AS, 750GB, SATA2

[7.1.] Software (add the output of the ver_linux script here)

  - OS: Suse Linux 9.2, on vanilla kernel

  - ver_linux output is as follows:
  
Linux korn 2.6.17.11custom #5 Mon Aug 28 17:06:12 CEST 2006 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  3.3.4
Gnu make               3.80
binutils               2.15.91.0.2
util-linux             2.12c
mount                  2.12c
module-init-tools      3.1-pre5
e2fsprogs              1.35
jfsutils               1.1.7
reiserfsprogs          3.6.18
xfsprogs               2.8.10
quota-tools            3.11.
Linux C Library        02 04:13 /lib64/tls/libc.so.6
Dynamic linker (ldd)   2.3.3
Linux C++ Library      5.0.7
Procps                 3.2.3
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
udev                   030
Modules Loaded         edd ip6t_REJECT ip6table_mangle ip6table_filter ip6_tables ipv6

[7.2.] Processor information (from /proc/cpuinfo):

  - cpuinfo:
  
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 31
model name      : AMD Athlon(tm) 64 Processor 3000+
stepping        : 0
cpu MHz         : 1809.298
cache size      : 512 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow lahf_lm
bogomips        : 3620.74
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp


[7.3.] Module information (from /proc/modules):

  - loaded modules:

edd 12448 0 - Live 0xffffffff88055000
ip6t_REJECT 6656 3 - Live 0xffffffff88052000
ip6table_mangle 3456 0 - Live 0xffffffff88050000
ip6table_filter 3712 1 - Live 0xffffffff8804e000
ip6_tables 16352 2 ip6table_mangle,ip6table_filter, Live 0xffffffff88049000
ipv6 293568 11 ip6t_REJECT, Live 0xffffffff88000000

  - Note: the SATA HDDs and controllers are accessed through the following
    modules compiled into the kernel

    * sata_nv        (onboard nVidia controller)
    * sata_sil       (SiI3112A PCI card)
  
[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

  - ioports:

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
0290-0297 : it87-isa
02f8-02ff : serial
0330-0333 : i2c-pca-isa
03c0-03df : vga+
03f6-03f6 : ide0
03f8-03ff : serial
0960-0967 : 0000:00:08.0
  0960-0967 : sata_nv
0970-0977 : 0000:00:07.0
  0970-0977 : sata_nv
09e0-09e7 : 0000:00:08.0
  09e0-09e7 : sata_nv
09f0-09f7 : 0000:00:07.0
  09f0-09f7 : sata_nv
0b60-0b63 : 0000:00:08.0
  0b60-0b63 : sata_nv
0b70-0b73 : 0000:00:07.0
  0b70-0b73 : sata_nv
0be0-0be3 : 0000:00:08.0
  0be0-0be3 : sata_nv
0bf0-0bf3 : 0000:00:07.0
  0bf0-0bf3 : sata_nv
1000-107f : motherboard
  1000-1003 : PM1a_EVT_BLK
  1004-1005 : PM1a_CNT_BLK
  1008-100b : PM_TMR
  1010-1015 : ACPI CPU throttle
  101c-101c : PM2_CNT_BLK
  1020-1027 : GPE0_BLK
1080-10ff : motherboard
  1080-10ff : pnp 00:00
1400-147f : motherboard
  1400-147f : pnp 00:00
1480-14ff : motherboard
  14a0-14af : GPE1_BLK
1800-187f : motherboard
  1800-187f : pnp 00:00
1880-18ff : motherboard
  1880-18ff : pnp 00:00
1c00-1c3f : 0000:00:01.1
  1c00-1c07 : nForce2_smbus
1c40-1c7f : 0000:00:01.1
  1c40-1c47 : nForce2_smbus
5000-5fff : PCI Bus #05
6000-6fff : PCI Bus #04
7000-7fff : PCI Bus #03
8000-8fff : PCI Bus #02
9000-afff : PCI Bus #01
  9000-90ff : 0000:01:07.0
  9400-9407 : 0000:01:08.0
    9400-9407 : sata_sil
  9800-9803 : 0000:01:08.0
    9800-9803 : sata_sil
  9c00-9c07 : 0000:01:08.0
    9c00-9c07 : sata_sil
  a000-a003 : 0000:01:08.0
    a000-a003 : sata_sil
  a400-a40f : 0000:01:08.0
    a400-a40f : sata_sil
d000-d00f : 0000:00:07.0
  d000-d00f : sata_nv
e400-e40f : 0000:00:08.0
  e400-e40f : sata_nv
e800-e81f : 0000:00:01.1
f000-f00f : 0000:00:06.0
  f000-f007 : ide0


  - iomem:

00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000cc7ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-7ffeffff : System RAM
  00200000-00625830 : Kernel code
  00625831-0086c28f : Kernel data
7fff0000-7fff2fff : ACPI Non-volatile Storage
7fff3000-7fffffff : ACPI Tables
88000000-880fffff : PCI Bus #01
  88000000-8807ffff : 0000:01:08.0
  88080000-8808ffff : 0000:01:06.0
  88090000-8809ffff : 0000:01:07.0
e0000000-efffffff : reserved
f0000000-f1ffffff : PCI Bus #01
  f1000000-f17fffff : 0000:01:06.0
  f1800000-f1800fff : 0000:01:07.0
  f1801000-f18011ff : 0000:01:08.0
    f1801000-f18011ff : sata_sil
f2000000-f20000ff : 0000:00:02.1
f2002000-f2002fff : 0000:00:07.0
  f2002000-f2002fff : sata_nv
f2003000-f2003fff : 0000:00:08.0
  f2003000-f2003fff : sata_nv
f2004000-f2004fff : 0000:00:02.0
fec00000-fec00fff : reserved
fee00000-fee00fff : reserved
ffff0000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)

  - PCI information:

0000:00:00.0 Memory controller: nVidia Corporation: Unknown device 005e (rev a2)
        Subsystem: Giga-byte Technology: Unknown device 5000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [44] #08 [01e0]
        Capabilities: [e0] #08 [a801]

0000:00:01.0 ISA bridge: nVidia Corporation: Unknown device 0050 (rev a2)
        Subsystem: Giga-byte Technology: Unknown device 0c11
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

0000:00:01.1 SMBus: nVidia Corporation: Unknown device 0052 (rev a2)
        Subsystem: Giga-byte Technology: Unknown device 0c11
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at e800
        Region 4: I/O ports at 1c00 [size=64]
        Region 5: I/O ports at 1c40 [size=64]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:02.0 USB Controller: nVidia Corporation: Unknown device 005a (rev a2) (prog-if 10 [OHCI])
        Subsystem: Giga-byte Technology: Unknown device 5004
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f2004000 (32-bit, non-prefetchable)
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:02.1 USB Controller: nVidia Corporation: Unknown device 005b (rev a2) (prog-if 20 [EHCI])
        Subsystem: Giga-byte Technology: Unknown device 5004
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin B routed to IRQ 5
        Region 0: Memory at f2000000 (32-bit, non-prefetchable)
        Capabilities: [44] #0a [2098]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:06.0 IDE interface: nVidia Corporation: Unknown device 0053 (rev a2) (prog-if 8a [Master SecP PriP])
        Subsystem: Giga-byte Technology: Unknown device 5002
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Region 4: I/O ports at f000 [size=16]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:07.0 IDE interface: nVidia Corporation: Unknown device 0054 (rev a2) (prog-if 85 [Master SecO PriO])
        Subsystem: Giga-byte Technology: Unknown device b003
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 193
        Region 0: I/O ports at 09f0
        Region 1: I/O ports at 0bf0 [size=4]
        Region 2: I/O ports at 0970 [size=8]
        Region 3: I/O ports at 0b70 [size=4]
        Region 4: I/O ports at d000 [size=16]
        Region 5: Memory at f2002000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:08.0 IDE interface: nVidia Corporation: Unknown device 0055 (rev a2) (prog-if 85 [Master SecO PriO])
        Subsystem: Giga-byte Technology: Unknown device b003
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 201
        Region 0: I/O ports at 09e0
        Region 1: I/O ports at 0be0 [size=4]
        Region 2: I/O ports at 0960 [size=8]
        Region 3: I/O ports at 0b60 [size=4]
        Region 4: I/O ports at e400 [size=16]
        Region 5: Memory at f2003000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:09.0 PCI bridge: nVidia Corporation: Unknown device 005c (rev a2) (prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        I/O behind bridge: 00009000-0000afff
        Memory behind bridge: f0000000-f1ffffff
        Prefetchable memory behind bridge: 88000000-880fffff
        Expansion ROM at 00009000 [disabled] [size=8K]
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

0000:00:0b.0 PCI bridge: nVidia Corporation: Unknown device 005d (rev a2) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, cache line size 08
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 00008000-00008fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Expansion ROM at 00008000 [disabled] [size=4K]
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [58] #08 [a800]
        Capabilities: [80] #10 [0141]

0000:00:0c.0 PCI bridge: nVidia Corporation: Unknown device 005d (rev a2) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, cache line size 08
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 00007000-00007fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Expansion ROM at 00007000 [disabled] [size=4K]
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [58] #08 [a800]
        Capabilities: [80] #10 [0141]

0000:00:0d.0 PCI bridge: nVidia Corporation: Unknown device 005d (rev a2) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, cache line size 08
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 00006000-00006fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Expansion ROM at 00006000 [disabled] [size=4K]
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [58] #08 [a800]
        Capabilities: [80] #10 [0141]

0000:00:0e.0 PCI bridge: nVidia Corporation: Unknown device 005d (rev a2) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, cache line size 08
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Expansion ROM at 00005000 [disabled] [size=4K]
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [58] #08 [a800]
        Capabilities: [80] #10 [0141]

0000:00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Capabilities: [80] #08 [2101]

0000:00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

0000:00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

0000:00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

0000:01:06.0 VGA compatible controller: S3 Inc. 86c764/765 [Trio32/64/64V+] (prog-if 00 [VGA])
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at f1000000 (32-bit, non-prefetchable) [size=88080000]
        Expansion ROM at 00010000 [disabled]

0000:01:07.0 Ethernet controller: National Semiconductor Corporation DP83820 10/100/1000 Ethernet Controller
        Subsystem: Netgear: Unknown device 621a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, cache line size 08
        Interrupt: pin A routed to IRQ 177
        Region 0: I/O ports at 9000 [size=88090000]
        Region 1: Memory at f1800000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at 00010000 [disabled]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:01:08.0 Unknown mass storage controller: Silicon Image, Inc. (formerly CMD Technology Inc) SiI 3112
             [SATALink/SATARaid] Serial ATA Controller (rev 02)
        Subsystem: Silicon Image, Inc. (formerly CMD Technology Inc) SiI 3112 SATALink Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 08
        Interrupt: pin A routed to IRQ 185
        Region 0: I/O ports at 9400 [size=88000000]
        Region 1: I/O ports at 9800 [size=4]
        Region 2: I/O ports at 9c00 [size=8]
        Region 3: I/O ports at a000 [size=4]
        Region 4: I/O ports at a400 [size=16]
        Region 5: Memory at f1801000 (32-bit, non-prefetchable) [size=512]
        Expansion ROM at 00080000 [disabled]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

[7.6.] SCSI information (from /proc/scsi/scsi)

  - scsi drives

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3750640AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3750640AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3750640AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3750640AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3750640AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI SCSI revision: 05

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

  I have no idea what further information would be useful,
  since i'm not a kernel developer.

  If you need any additional information or would like me to
  run other command and tests, please let me know.

[X.] Other notes, patches, fixes, workarounds:

  I really hope that someone can point me in the right direction in order
  to resolve that problem or even provide a patch.
  I've been trying to fix it for 2 weeks now, but i'm stuck with it.

  I'm neither a linux nor a kernel expert but i hope that
  problem report is useful for you.

  If possible, please CC answers to my mail address.

Thanks very much for your consideration,
i'd appreciate any help.

Best regards,

Ralf Herrmann
-- 
Technical University Ilmenau
EMR Lab
Germany

