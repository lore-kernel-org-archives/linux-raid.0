From: syrius.ml@no-log.org
Subject: Re: [Evms-devel] 2.6.10-ac10 + 2.6.10udm1 + latest evms => not nice
Date: Fri, 21 Jan 2005 18:53:13 +0100
Message-ID: <87u0par7rx.87sm4ur7rx@87r7ker7rx.message.id>
References: <87brbinaey.87acr2naey@878y6mnaey.message.id>
	<20050121144738.GM25714@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050121144738.GM25714@marowsky-bree.de> (Lars Marowsky-Bree's
 message of "Fri, 21 Jan 2005 15:47:38 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: evms-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree <lmb@suse.de> writes:

> [...]
> Does the attached patch apply & fix the problem for you?

unfortunatly it did not.

here is the new oops (not sure it will help more)

device-mapper: 4.3.0-ioctl (2004-09-30) initialised: dm-devel@redhat.com
md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bind<dm-0>
md: bind<dm-1>
md: bind<dm-2>
md: bind<dm-3>
md: bind<dm-4>
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :   988.000 MB/sec
raid5: using function: pIII_sse (988.000 MB/sec)
md: raid5 personality registered as nr 4
raid5: device dm-4 operational as raid disk 4
raid5: device dm-3 operational as raid disk 3
raid5: device dm-2 operational as raid disk 2
raid5: device dm-1 operational as raid disk 1
raid5: device dm-0 operational as raid disk 0
raid5: allocated 5235kB for md0
raid5: raid level 5 set md0 active with 5 out of 5 devices, algorithm 2
RAID5 conf printout:
 --- rd:5 wd:5 fd:0
 disk 0, o:1, dev:dm-0
 disk 1, o:1, dev:dm-1
 disk 2, o:1, dev:dm-2
 disk 3, o:1, dev:dm-3
 disk 4, o:1, dev:dm-4
Unable to handle kernel NULL pointer dereference at virtual address 00000004
 printing eip:
c02214eb
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: raid5 xor md dm_mod md5 ipv6 adm1021 eeprom i2c_piix4 i2c_isa
 lm75 lm78 w83781d i2c_sensor i2c_core agpgart scsi_mod 3c59x
CPU:    1
EIP:    0060:[<c02214eb>]    Not tainted VLI
EFLAGS: 00010202   (2.6.10-ac10)
eax: 00000000   ebx: f7c33488   ecx: 00000000   edx: c19374e0
esi: f7c33488   edi: 00000000   ebp: c19374e0   esp: f7b7f81c
ds: 007b   es: 007b   ss: 0068
Process evms_activate (pid: 1455, threadinfo=f7b7e000 task=f78f4a80)
Stack: c18ee3e0 00000200 00000000 f78f4a80 000000bf f7b7f850 00000008 00000000
       f7c33488 f79c9c80 c01317f0 c19374e0 c0221d77 f7c33488 c19374e0 00000000
       00000000 00000000 f78f4a80 c01317f0 f7b7f88c f7b7f88c c015f110 c18fd8a0
Call Trace:
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c0221d77>] generic_make_request+0x157/0x1f0
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c015f110>] bio_alloc+0x20/0x1e0
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c015f3af>] bio_clone+0x9f/0xc0
 [<f88b835a>] __map_bio+0x4a/0x120 [dm_mod]
 [<f88b87bd>] __clone_and_map+0x2ad/0x2c0 [dm_mod]
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<f88b8888>] __split_bio+0xb8/0x140 [dm_mod]
 [<c0103bcc>] apic_timer_interrupt+0x1c/0x24
 [<f88b898c>] dm_request+0x7c/0xb0 [dm_mod]
 [<c0221d77>] generic_make_request+0x157/0x1f0
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<f88d6ce0>] compute_blocknr+0xb0/0x120 [raid5]
 [<f88d7dbe>] handle_stripe+0x79e/0xea0 [raid5]
 [<f88d6a74>] raid5_build_block+0x74/0x90 [raid5]
 [<f88d6311>] get_active_stripe+0x71/0x2f0 [raid5]
 [<c0125599>] __mod_timer+0xf9/0x140
 [<f88d88f8>] make_request+0x178/0x270 [raid5]
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c0221d77>] generic_make_request+0x157/0x1f0
 [<c0112db3>] unmask_IO_APIC_irq+0x23/0x40
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c015f3c1>] bio_clone+0xb1/0xc0
 [<f88b835a>] __map_bio+0x4a/0x120 [dm_mod]
 [<f88b87bd>] __clone_and_map+0x2ad/0x2c0 [dm_mod]
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<f88b8888>] __split_bio+0xb8/0x140 [dm_mod]
 [<f88b898c>] dm_request+0x7c/0xb0 [dm_mod]
 [<c0221d77>] generic_make_request+0x157/0x1f0
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c013181f>] autoremove_wake_function+0x2f/0x60
 [<c013de63>] mempool_alloc+0x73/0x140
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c0221e80>] submit_bio+0x70/0x120
 [<c015f1d7>] bio_alloc+0xe7/0x1e0
 [<c015bba0>] end_buffer_async_read+0x0/0xe0
 [<c015ea06>] submit_bh+0xd6/0x130
 [<c015d894>] block_read_full_page+0x1b4/0x2e0
 [<c013a69d>] add_to_page_cache+0xbd/0xe0
 [<c0142264>] read_pages+0xf4/0x140
 [<c0161930>] blkdev_get_block+0x0/0x60
 [<c013f3a4>] __alloc_pages+0x1d4/0x370
 [<f88b8a90>] dm_any_congested+0x30/0x60 [dm_mod]
 [<c01425a9>] do_page_cache_readahead+0x119/0x190
 [<c014271a>] page_cache_readahead+0xfa/0x1f0
 [<c013ae67>] do_generic_mapping_read+0x127/0x500
 [<c013b542>] __generic_file_aio_read+0x212/0x250
 [<c013b240>] file_read_actor+0x0/0xf0
 [<c02248d6>] get_disk+0x66/0xd0
 [<c013b6b4>] generic_file_read+0xb4/0xd0
 [<c0162376>] do_open+0x96/0x360
 [<c0162704>] blkdev_open+0x34/0x70
 [<c015928c>] dentry_open+0x11c/0x260
 [<c01317f0>] autoremove_wake_function+0x0/0x60
 [<c0159f18>] vfs_read+0xb8/0x130
 [<c015b072>] fget_light+0x82/0x90
 [<c015a201>] sys_read+0x51/0x80
 [<c0103179>] sysenter_past_esp+0x52/0x75
Code: 55 57 31 ff 56 53 83 ec 20 8b 54 24 38 8b 74 24 34 8b 02 89 44 24 10 8b 42 1c c1 e8 09 89 44 24 18 8b 4a 2c 0f b7 42 16 8d 04 40 <8b> 44 81 04 c1 e8 09 89 44 24 14 8b 5a 10 8d 44 24 38 89 44 24


Thanks.

-- 
