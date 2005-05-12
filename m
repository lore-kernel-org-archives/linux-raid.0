From: Tim Harvey <tim_harvey@yahoo.com>
Subject: SATA RAID5 kernel hang on 2.6.11-1.14_FC3
Date: Wed, 11 May 2005 22:37:16 -0700 (PDT)
Message-ID: <20050512053716.97460.qmail@web30504.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I'm attempting to run a RAID5 array with the following configuration:

ASUS TUSI-M Motherboard, Celeron 1GHz, 256MB SDRAM
Promise SATAII-150-TX4 4-port RAID controller
4 x Seagate ST300 300GB SATA NQC drives
Linux FC3 system with 2.6.11-1.14_FC3

I've been trying to determine the cause of a kernel hang that occurs when I
start to transfer a large ammount of data to the array over an NFS/SMB mount.

After anywhere from hours to a few seconds large transfers, the console starts
spewing endlessly the following:

do_IRQ: stack overflow: 312
 [<c0105686>] do_IRQ+0x83/0x85
 [<c0103a72>] common_interrupt+0x1a/0x20
 [<c029579e>] cfq_set_request+0x1b2/0x4fd
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<c02955ec>] cfq_set_request+0x0/0x4fd
 [<c0288218>] elv_set_request+0x20/0x23
 [<c028aa64>] get_request+0x21a/0x56e
 [<c028bb30>] __make_request+0x15b/0x629
 [<c028c742>] generic_make_request+0x19e/0x279
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<cf85710e>] handle_stripe+0xf7e/0x16a3 [raid5]
 [<cf854fcf>] raid5_build_block+0x65/0x70 [raid5]
 [<cf8545e6>] get_active_stripe+0x29e/0x560 [raid5]
 [<cf857ec1>] make_request+0x349/0x539 [raid5]
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<c014f244>] mempool_alloc+0x72/0x2a9
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<c028c742>] generic_make_request+0x19e/0x279
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<c017b4ef>] bio_clone+0xa1/0xa6
 [<cf8442db>] __map_bio+0x30/0xc8 [dm_mod]
 [<cf84450f>] __clone_and_map+0xcd/0x309 [dm_mod]
 [<cf8447e8>] __split_bio+0x9d/0x10b [dm_mod]
 [<cf8448b5>] dm_request+0x5f/0x88 [dm_mod]
 [<c028c742>] generic_make_request+0x19e/0x279
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<c01503d6>] prep_new_page+0x5c/0x5f
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<c028c868>] submit_bio+0x4b/0xc5
 [<c013d4c9>] autoremove_wake_function+0x0/0x37
 [<c017b690>] bio_add_page+0x29/0x2f
 [<cfac2331>] _pagebuf_ioapply+0x164/0x2d9 [xfs]
 [<cfac24d9>] pagebuf_iorequest+0x33/0x14a [xfs]
 [<cfac1527>] _pagebuf_find+0xd9/0x2f3 [xfs]
 [<cfac142e>] _pagebuf_map_pages+0x64/0x84 [xfs]
 [<cfac1805>] xfs_buf_get_flags+0xc4/0x108 [xfs]
 [<cfac209c>] pagebuf_iostart+0x53/0x8c [xfs]
 [<cfac1898>] xfs_buf_read_flags+0x4f/0x6c [xfs]
 [<cfab42ff>] xfs_trans_read_buf+0x1b9/0x31b [xfs]
...

I would like ot give a more detailed report, but I'm not really sure what to do
next.  It would seem that something in RAID5 code is recursing endlessly?  I'm
not quite sure how to proceed as I'm not getting an oops and the system is non
responsive (other than spewing the endless stack dump)

Any help would be greatly appreciated,

Tim

