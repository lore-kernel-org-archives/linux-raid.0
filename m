From: "Kevin A. Nesmith" <knesmith@si2.org>
Subject: Raid 5 Kernel Bug
Date: Thu, 22 Jul 2004 12:50:35 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407221250.35040.knesmith@si2.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am running SuSE Linux 9.1.  I have 8 SCSI harddrives all the same running raid 5.  It is just that simple.  
Nothing more, no third party stuff.  No other raid running on this box.  The harddrive that the OS is running 
on is an IDE at /dev/hda.  I386 AMD 900 MHZ 512 mg ram.  Any thoughts?

Thanks,
Kevin Nesmith
Sysadmin
Si2.org
512-342-2244 ext. 311

Jul 22 12:03:00 elpaso kernel: ------------[ cut here ]------------
Jul 22 12:03:00 elpaso kernel: kernel BUG at drivers/md/raid5.c:810!
Jul 22 12:03:00 elpaso kernel: invalid operand: 0000 [#1]
Jul 22 12:03:00 elpaso kernel: CPU:    0
Jul 22 12:03:01 elpaso kernel: EIP:    0060:[__crc_rpc_queue_upcall+1179697/1835050]    Not tainted
Jul 22 12:03:01 elpaso kernel: EIP:    0060:[<e0c59f48>]    Not tainted
Jul 22 12:03:01 elpaso kernel: EFLAGS: 00010002   (2.6.4-54.5-default)
Jul 22 12:03:01 elpaso kernel: EIP is at make_request+0x198/0x438 [raid5]
Jul 22 12:03:01 elpaso kernel: eax: 08bf82d8   ebx: d86a0540   ecx: cfe1d480   edx: 00000000
Jul 22 12:03:01 elpaso kernel: esi: 08bf82d0   edi: 00000000   ebp: df76523c   esp: d4a31b28
Jul 22 12:03:01 elpaso kernel: ds: 007b   es: 007b   ss: 0068
Jul 22 12:03:01 elpaso kernel: Process rsync (pid: 25990, threadinfo=d4a30000 task=dcf71250)
Jul 22 12:03:01 elpaso kernel: Stack: 2658c9f8 00000000 08bf7fe8 00000000 00000008 00000000 00000002 df765100
Jul 22 12:03:01 elpaso kernel:        08bf8308 00000000 08bf82d0 00000000 00000007 00000008 dfac7780 c15d4e80
Jul 22 12:03:01 elpaso kernel:        cfe1d480 00000002 00000001 00000038 00000000 df6b7080 cfe1d480 c02241bf
Jul 22 12:03:01 elpaso kernel: Call Trace:
Jul 22 12:03:01 elpaso kernel:  [generic_make_request+271/432] generic_make_request+0x10f/0x1b0
Jul 22 12:03:01 elpaso kernel:  [<c02241bf>] generic_make_request+0x10f/0x1b0
Jul 22 12:03:01 elpaso kernel:  [submit_bio+81/224] submit_bio+0x51/0xe0
Jul 22 12:03:01 elpaso kernel:  [<c02242b1>] submit_bio+0x51/0xe0
Jul 22 12:03:01 elpaso kernel:  [mpage_bio_submit+17/48] mpage_bio_submit+0x11/0x30
Jul 22 12:03:01 elpaso kernel:  [<c0170651>] mpage_bio_submit+0x11/0x30
Jul 22 12:03:01 elpaso kernel:  [do_mpage_readpage+800/1184] do_mpage_readpage+0x320/0x4a0
Jul 22 12:03:01 elpaso kernel:  [<c0171260>] do_mpage_readpage+0x320/0x4a0
Jul 22 12:03:01 elpaso kernel:  [tasklet_action+56/112] tasklet_action+0x38/0x70
Jul 22 12:03:01 elpaso kernel:  [<c0122b88>] tasklet_action+0x38/0x70
Jul 22 12:03:01 elpaso kernel:  [do_IRQ+277/368] do_IRQ+0x115/0x170
Jul 22 12:03:01 elpaso kernel:  [<c010a895>] do_IRQ+0x115/0x170
Jul 22 12:03:01 elpaso kernel:  [radix_tree_node_alloc+16/80] radix_tree_node_alloc+0x10/0x50
Jul 22 12:03:01 elpaso kernel:  [<c01db710>] radix_tree_node_alloc+0x10/0x50
Jul 22 12:03:01 elpaso kernel:  [radix_tree_insert+309/496] radix_tree_insert+0x135/0x1f0
Jul 22 12:03:01 elpaso kernel:  [<c01db885>] radix_tree_insert+0x135/0x1f0
Jul 22 12:03:01 elpaso kernel:  [__crc_ip_generic_getfrag+33055/4339610] reiserfs_get_block+0x0/0x1440 [reiserfs]
Jul 22 12:03:01 elpaso kernel:  [<e0d02060>] reiserfs_get_block+0x0/0x1440 [reiserfs]
Jul 22 12:03:01 elpaso kernel:  [mpage_readpages+345/448] mpage_readpages+0x159/0x1c0
Jul 22 12:03:01 elpaso kernel:  [<c0171579>] mpage_readpages+0x159/0x1c0
Jul 22 12:03:01 elpaso kernel:  [__crc_ip_generic_getfrag+33055/4339610] reiserfs_get_block+0x0/0x1440 [reiserfs]
Jul 22 12:03:01 elpaso kernel:  [<e0d02060>] reiserfs_get_block+0x0/0x1440 [reiserfs]
Jul 22 12:03:01 elpaso kernel:  [__crc_ip_generic_getfrag+25231/4339610] reiserfs_readpages+0x0/0x20 [reiserfs]
Jul 22 12:03:01 elpaso kernel:  [<e0d001d0>] reiserfs_readpages+0x0/0x20 [reiserfs]
Jul 22 12:03:01 elpaso kernel:  [__crc_ip_generic_getfrag+25249/4339610] reiserfs_readpages+0x12/0x20 [reiserfs]
Jul 22 12:03:01 elpaso kernel:  [<e0d001e2>] reiserfs_readpages+0x12/0x20 [reiserfs]
Jul 22 12:03:01 elpaso kernel:  [__crc_ip_generic_getfrag+33055/4339610] reiserfs_get_block+0x0/0x1440 [reiserfs]
Jul 22 12:03:01 elpaso kernel:  [<e0d02060>] reiserfs_get_block+0x0/0x1440 [reiserfs]
Jul 22 12:03:01 elpaso kernel:  [read_pages+386/416] read_pages+0x182/0x1a0
Jul 22 12:03:01 elpaso kernel:  [<c013f162>] read_pages+0x182/0x1a0
Jul 22 12:03:01 elpaso kernel:  [__alloc_pages+801/864] __alloc_pages+0x321/0x360
Jul 22 12:03:01 elpaso kernel:  [<c013e001>] __alloc_pages+0x321/0x360
Jul 22 12:03:01 elpaso kernel:  [do_page_cache_readahead+200/304] do_page_cache_readahead+0xc8/0x130
Jul 22 12:03:01 elpaso kernel:  [<c013f248>] do_page_cache_readahead+0xc8/0x130
Jul 22 12:03:01 elpaso kernel:  [page_cache_readahead+453/512] page_cache_readahead+0x1c5/0x200
Jul 22 12:03:01 elpaso kernel:  [<c013f475>] page_cache_readahead+0x1c5/0x200
Jul 22 12:03:01 elpaso kernel:  [do_generic_mapping_read+418/1712] do_generic_mapping_read+0x1a2/0x6b0
Jul 22 12:03:01 elpaso kernel:  [<c013a362>] do_generic_mapping_read+0x1a2/0x6b0
Jul 22 12:03:01 elpaso kernel:  [file_read_actor+0/224] file_read_actor+0x0/0xe0
Jul 22 12:03:01 elpaso kernel:  [<c0138dd0>] file_read_actor+0x0/0xe0
Jul 22 12:03:01 elpaso kernel:  [__generic_file_aio_read+397/464] __generic_file_aio_read+0x18d/0x1d0
Jul 22 12:03:01 elpaso kernel:  [<c013af3d>] __generic_file_aio_read+0x18d/0x1d0
Jul 22 12:03:01 elpaso kernel:  [file_read_actor+0/224] file_read_actor+0x0/0xe0
Jul 22 12:03:01 elpaso kernel:  [<c0138dd0>] file_read_actor+0x0/0xe0
Jul 22 12:03:01 elpaso kernel:  [generic_file_read+145/176] generic_file_read+0x91/0xb0
Jul 22 12:03:01 elpaso kernel:  [<c013b0c1>] generic_file_read+0x91/0xb0
Jul 22 12:03:01 elpaso kernel:  [inode_has_perm+74/160] inode_has_perm+0x4a/0xa0
Jul 22 12:03:01 elpaso kernel:  [<c01c9c8a>] inode_has_perm+0x4a/0xa0
Jul 22 12:03:01 elpaso kernel:  [autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
Jul 22 12:03:01 elpaso kernel:  [<c011ef60>] autoremove_wake_function+0x0/0x30
Jul 22 12:03:01 elpaso kernel:  [selinux_file_permission+352/368] selinux_file_permission+0x160/0x170
Jul 22 12:03:01 elpaso kernel:  [<c01ca300>] selinux_file_permission+0x160/0x170
Jul 22 12:03:01 elpaso kernel:  [generic_file_read+0/176] generic_file_read+0x0/0xb0
Jul 22 12:03:01 elpaso kernel:  [<c013b030>] generic_file_read+0x0/0xb0
Jul 22 12:03:01 elpaso kernel:  [vfs_read+174/240] vfs_read+0xae/0xf0
Jul 22 12:03:01 elpaso kernel:  [<c015573e>] vfs_read+0xae/0xf0
Jul 22 12:03:01 elpaso kernel:  [sys_read+44/80] sys_read+0x2c/0x50
Jul 22 12:03:01 elpaso kernel:  [<c015581c>] sys_read+0x2c/0x50
Jul 22 12:03:01 elpaso kernel:  [sysenter_past_esp+82/121] sysenter_past_esp+0x52/0x79
Jul 22 12:03:01 elpaso kernel:  [<c0107dc9>] sysenter_past_esp+0x52/0x79
