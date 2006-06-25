From: Chris Allen <chris@cjx.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Sun, 25 Jun 2006 21:35:10 +0100
Message-ID: <449EF37E.80303@cjx.com>
References: <449AEB7C.6040108@cjx.com>	<op.tblclqd3cigqcu@apollo13>	<fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>	<449BE381.6070000@cjx.com>	<fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com>	<68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>	<449C0505.8000601@tmr.com>	<fd8d0180606230834t18427168jd776d33980f516b2@mail.gmail.com> <17564.52087.651968.635043@cse.unsw.edu.au> <449CF0D0.9080006@comcast.net> <449D0715.8050609@dgreaves.com> <449DC23E.4000604@comcast.net> <449EA2F9.3050503@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449EA2F9.3050503@comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <talbotx@comcast.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Adam Talbot wrote:
> ACK!
> At one point some one stated that they were having problems with XFS
> crashing under high NFS loads...  Did it look something like this?
> -Adam
>
>   
>   

nope, it looked like the trace below - and I could make it happen 
consistently by thrashing xfs.
Not even sure it was over NFS - this could well have been a local test.


----------------------

do_IRQ: stack overflow: 304
Unable to handle kernel paging request at virtual address a554b923
 printing eip:
c011b202
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: nfsd(U) lockd(U) md5(U) ipv6(U) autofs4(U) sunrpc(U) 
xfs(U) exportfs(U) video(U) button(U) battery(U) ac(U) uhci_hcd(U) 
ehci_hcd(U) i2c_i801(U) i2c_core(U) shpchp(U) e1000(U) floppy(U) 
dm_snapshot(U) dm_zero(U) dm_mirror(U) ext3(U) jbd(U) raid5(U) xor(U) 
dm_mod(U) ata_piix(U) libata(U) aar81xx(U) sd_mod(U) scsi_mod(U)
CPU:    10
EIP:    0060:[<c011b202>]    Tainted: P      VLI
EFLAGS: 00010086   (2.6.11-2.6.11)
EIP is at activate_task+0x34/0x9b
eax: e514b703   ebx: 00000000   ecx: 028f8800   edx: c0400200
esi: 028f8800   edi: 000f4352   ebp: f545d02c   esp: f545d018
ds: 007b   es: 007b   ss: 0068
Process  (pid: 947105536, threadinfo=f545c000 task=f5a27000)
Stack: badc0ded c3630160 f7ae4a80 c0400200 f7ae4a80 c3630160 f545d074 
c011b785
       00000000 c0220f39 00000001 00000086 00000000 00000001 00000003 
f7ae4a80
       00000082 00000001 0000000a 00000000 c02219da f7d7cf60 c035d914 
00000000
Call Trace:
 [<c011b785>] try_to_wake_up+0x24a/0x2aa
 [<c0220f39>] scrup+0xcf/0xd9
 [<c02219da>] set_cursor+0x4f/0x60
 [<c01348b0>] autoremove_wake_function+0x15/0x37
 [<c011d197>] __wake_up_common+0x39/0x59
 [<c011d1e9>] __wake_up+0x32/0x43
 [<c0121e2c>] release_console_sem+0xad/0xb5
 [<c0121c48>] vprintk+0x1e7/0x29e
 [<c0121a5d>] printk+0x1b/0x1f
 [<c010664b>] do_IRQ+0x7f/0x86
 [<c0104a3e>] common_interrupt+0x1a/0x20
 [<c024b5fa>] cfq_may_queue+0x0/0xcd
 [<c02425e4>] get_request+0xf2/0x2b7
 [<c02430cc>] __make_request+0xbe/0x472
 [<c024375b>] generic_make_request+0x91/0x234
 [<f881be38>] compute_blocknr+0xe5/0x16e [raid5]
 [<c013489b>] autoremove_wake_function+0x0/0x37
 [<f881d0c2>] handle_stripe+0x736/0x109e [raid5]
 [<f881b45a>] get_active_stripe+0x1fb/0x36c [raid5]
 [<f881deed>] make_request+0x2e1/0x30d [raid5]
 [<c013489b>] autoremove_wake_function+0x0/0x37
 [<c024375b>] generic_make_request+0x91/0x234
 [<c03054e1>] schedule+0x431/0xc5e
 [<c024a3f4>] cfq_sort_rr_list+0x9b/0xe6
 [<c0148c27>] buffered_rmqueue+0xc4/0x1fb
 [<c013489b>] autoremove_wake_function+0x0/0x37
 [<c0243944>] submit_bio+0x46/0xcc
 [<c0147aae>] mempool_alloc+0x6f/0x108
 [<c013489b>] autoremove_wake_function+0x0/0x37
 [<c0166696>] bio_add_page+0x26/0x2c
 [<f9419fe7>] _pagebuf_ioapply+0x175/0x2e3 [xfs]
 [<f941a185>] pagebuf_iorequest+0x30/0x133 [xfs]
 [<f9419643>] xfs_buf_get_flags+0xe8/0x147 [xfs]
 [<f9419d45>] pagebuf_iostart+0x76/0x82 [xfs]
 [<f9419707>] xfs_buf_read_flags+0x65/0x89 [xfs]
 [<f940c105>] xfs_trans_read_buf+0x122/0x334 [xfs]
 [<f93d9dc2>] xfs_btree_read_bufs+0x7d/0x97 [xfs]
 [<f93c0d7a>] xfs_alloc_lookup+0x326/0x47b [xfs]
 [<f93bc96b>] xfs_alloc_fixup_trees+0x14f/0x320 [xfs]
 [<f93d99d9>] xfs_btree_init_cursor+0x1d/0x17f [xfs]
 [<f93bdc38>] xfs_alloc_ag_vextent_size+0x377/0x456 [xfs]
 [<f93bcbdb>] xfs_alloc_read_agfl+0x9f/0xb9 [xfs]
 [<f93bccf5>] xfs_alloc_ag_vextent+0x100/0x102 [xfs]
 [<f93be929>] xfs_alloc_fix_freelist+0x2ca/0x478 [xfs]
 [<f93bf087>] xfs_alloc_vextent+0x182/0x570 [xfs]
 [<f93cdff3>] xfs_bmap_alloc+0x111e/0x18e9 [xfs]
 [<c013489b>] autoremove_wake_function+0x0/0x37
 [<c024375b>] generic_make_request+0x91/0x234
 [<f891eb40>] EdmaReqQueueInsert+0x70/0x80 [aar81xx]
 [<c011cf79>] scheduler_tick+0x236/0x40f
 [<c011cf79>] scheduler_tick+0x236/0x40f
 [<f93d833e>] xfs_bmbt_get_state+0x13/0x1c [xfs]
 [<f93cfebf>] xfs_bmap_do_search_extents+0xc3/0x476 [xfs]
 [<f93d1b9f>] xfs_bmapi+0x72a/0x1670 [xfs]
 [<f93d833e>] xfs_bmbt_get_state+0x13/0x1c [xfs]
 [<f93ffdf7>] xlog_grant_log_space+0x329/0x350 [xfs]
 [<f93fb3d0>] xfs_iomap_write_allocate+0x2d1/0x572 [xfs]
 [<c0243944>] submit_bio+0x46/0xcc
 [<c0147aae>] mempool_alloc+0x6f/0x108
 [<f93fa368>] xfs_iomap+0x3ef/0x50c [xfs]
 [<f94173fd>] xfs_map_blocks+0x39/0x71 [xfs]
 [<f94183b3>] xfs_page_state_convert+0x4b9/0x6ab [xfs]
 [<f9418b1d>] linvfs_writepage+0x57/0xd5 [xfs]
 [<c014e71d>] pageout+0x84/0x101
 [<c014ea1b>] shrink_list+0x281/0x454
 [<c014db1b>] __pagevec_lru_add+0xac/0xbb
 [<c014ed82>] shrink_cache+0xe7/0x26c
 [<c014f33f>] shrink_zone+0x76/0xbb
 [<c014f3e5>] shrink_caches+0x61/0x6f
 [<c014f4b8>] try_to_free_pages+0xc5/0x18d
 [<c0148fbb>] __alloc_pages+0x1cc/0x407
 [<c014674a>] generic_file_buffered_write+0x148/0x60c
 [<c0180ee8>] __mark_inode_dirty+0x28/0x199
 [<f941f444>] xfs_write+0xa36/0xd03 [xfs]
 [<f941b89d>] linvfs_write+0xe9/0x102 [xfs]
 [<c013489b>] autoremove_wake_function+0x0/0x37
 [<c014294d>] audit_syscall_entry+0x10b/0x15e
 [<f941b7b4>] linvfs_write+0x0/0x102 [xfs]
 [<c0161a27>] vfs_write+0x9e/0x110
 [<c0161b44>] sys_write+0x41/0x6a
 [<c0104009>] syscall_call+0x7/0xb
Code: 89 45 f0 89 55 ec 89 cb e8 24 57 ff ff 89 c6 89 d7 85 db 75 27 ba 
00 02 40 c0 b8 00 f0 ff ff 21 e0 8b 40 10 8b 04 85 20 50 40 c0 <2b> 74 
02 20 1b 7c 02 24 8b 45 ec 03 70 20 13 78 24 89 f2 89 f9
 hr_ioreq_timedout: (0,5,0) opcode 0x28: Enter






