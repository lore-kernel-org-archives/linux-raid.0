From: Stevie Trujillo <stevie.trujillo@gmail.com>
Subject: Freeze with cryptsetup->mdadm->lvm2->xfs(->nfs) get_active_stripe?
Date: Tue, 26 Jun 2012 23:59:01 +0200
Message-ID: <CAJiZuY0qUqQg6LQ-n0C4wEEqQDnDCLgY=kNJsFxTRRSgCA66gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fs@vger.kernel.org
List-Id: linux-raid.ids

Hello,

after upgrading from 2.6.39.1 in December, I've been having freezes
with 3.1.x, 3.2.2.
In an attempt to find the cause, when upgrading to 3.3.1 in the
beginning of April I enabled all the debug settings I could find in
the kernel, but it never froze and I assumed that the bug had been
fixed.
4-5 days ago I upgraded to 3.4.3 without debug flags (they made
everything horribly slow), and today it froze again!

I can ssh in, but don't get further than "Last login: Tue Jun 26
11:26:10 CEST 2012 from 10.0.0.2 on pts/4". I assume it tries to write
new info to /var/log/ and hangs.

I got around 10 disks connected to the Intel motherboard controller
(ahci) and two sata_sil24 PCI-e cards.
They're not partitioned very wisely: All the disks have a cryptsetup
partition. Mdadm runs on top of the encrypted volumes. Lvm2 on the big
/dev/md0 device. With xfs filesystems inside. And this is also served
over nfs.
That is: cryptsetup -> mdadm -> lvm2 -> xfs (-> nfs).

Here is Show Blocked State from netconsole.  To me it looks like the
problem might be in get_active_stripe, but I don't understand much of
threads/synchronization.

Jun 26 22:27:29 [368353.502333] SysRq : Show Blocked State
Jun 26 22:27:29 [368353.502414]   task                        PC stack
  pid father
Jun 26 22:27:29 [368353.502478] flush-254:12    D ffff88010db48cc0
0  5522      2 0x00000000
Jun 26 22:27:29 [368353.502600]  ffff88010cfc9640 0000000000000046
ffff88010cfc95d0 ffff88010c3ccc80
Jun 26 22:27:29 [368353.502764]  ffff88010f0029c0 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.502924]  ffff88010db48cc0 00000000000107c0
ffff88010cfc9fd8 ffff88010cfc9fd8
Jun 26 22:27:29 [368353.503085] Call Trace:
Jun 26 22:27:29 [368353.503127]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.503176]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.503220]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.503392]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.503564]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.503738]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.503970]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:29 [368353.504140]  [<ffffffff811c9c8c>] ? linear_merge+0x4d/0x58
Jun 26 22:27:29 [368353.504310]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.504480]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:29 [368353.504659]  [<ffffffffa01023e5>]
xfs_submit_ioend_bio.clone.19+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.504967]  [<ffffffffa01024b5>]
xfs_submit_ioend+0xce/0xee [xfs]
Jun 26 22:27:29 [368353.505144]  [<ffffffffa0102859>]
xfs_vm_writepage+0x384/0x412 [xfs]
Jun 26 22:27:29 [368353.505316]  [<ffffffff8108a23e>] __writepage+0x12/0x2b
Jun 26 22:27:29 [368353.505485]  [<ffffffff8108aa5c>]
write_cache_pages+0x225/0x377
Jun 26 22:27:29 [368353.505656]  [<ffffffff8108a22c>] ? set_page_dirty+0x5b/0x5b
Jun 26 22:27:29 [368353.505826]  [<ffffffff8108abee>]
generic_writepages+0x40/0x57
Jun 26 22:27:29 [368353.506001]  [<ffffffffa0101c06>]
xfs_vm_writepages+0x47/0x4e [xfs]
Jun 26 22:27:29 [368353.506172]  [<ffffffff8108bbec>] do_writepages+0x1c/0x25
Jun 26 22:27:29 [368353.506342]  [<ffffffff810d1c17>]
writeback_single_inode+0xcf/0x232
Jun 26 22:27:29 [368353.506513]  [<ffffffff810d2015>]
writeback_sb_inodes+0x163/0x1fe
Jun 26 22:27:29 [368353.506684]  [<ffffffff810d240e>]
__writeback_inodes_wb+0x6d/0xab
Jun 26 22:27:29 [368353.506854]  [<ffffffff810d26dd>] wb_writeback+0xfc/0x182
Jun 26 22:27:29 [368353.507024]  [<ffffffff810c91b9>] ?
get_nr_inodes_unused+0x43/0x5a
Jun 26 22:27:29 [368353.507195]  [<ffffffff8125f1d9>] ?
_raw_spin_lock_irqsave+0xd/0x27
Jun 26 22:27:29 [368353.507365]  [<ffffffff810d2dbd>]
wb_do_writeback+0x111/0x16d
Jun 26 22:27:29 [368353.507537]  [<ffffffff81033322>] ?
run_timer_softirq+0x1ef/0x1ef
Jun 26 22:27:29 [368353.507707]  [<ffffffff810d2e9e>]
bdi_writeback_thread+0x85/0x14a
Jun 26 22:27:29 [368353.507877]  [<ffffffff810d2e19>] ?
wb_do_writeback+0x16d/0x16d
Jun 26 22:27:29 [368353.508047]  [<ffffffff810d2e19>] ?
wb_do_writeback+0x16d/0x16d
Jun 26 22:27:29 [368353.508217]  [<ffffffff8103fba9>] kthread+0x84/0x8c
Jun 26 22:27:29 [368353.508386]  [<ffffffff81260b54>]
kernel_thread_helper+0x4/0x10
Jun 26 22:27:29 [368353.508556]  [<ffffffff8103fb25>] ?
kthread_freezable_should_stop+0x41/0x41
Jun 26 22:27:29 [368353.508728]  [<ffffffff81260b50>] ? gs_change+0xb/0xb
Jun 26 22:27:29 [368353.508899] dhcpcd          D ffff88010b2d2ca0
0  6706      1 0x00000000
Jun 26 22:27:29 [368353.509131]  ffff88010c8c7828 0000000000000082
ffff88010c8c77b8 ffff88010dd1d940
Jun 26 22:27:29 [368353.509636]  0000000000000005 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.510056]  ffff88010b2d2ca0 00000000000107c0
ffff88010c8c7fd8 ffff88010c8c7fd8
Jun 26 22:27:29 [368353.510475] Call Trace:
Jun 26 22:27:29 [368353.510640]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.510811]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.510982]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.511153]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.511323]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.511496]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.511666]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:29 [368353.511835]  [<ffffffff811c9c8c>] ? linear_merge+0x4d/0x58
Jun 26 22:27:29 [368353.512005]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.512176]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:29 [368353.512325]  [<ffffffffa01023e5>]
xfs_submit_ioend_bio.clone.19+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa01024b5>]
xfs_submit_ioend+0xce/0xee [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0102859>]
xfs_vm_writepage+0x384/0x412 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffff8108a23e>] __writepage+0x12/0x2b
Jun 26 22:27:29 [368353.512325]  [<ffffffff8108aa5c>]
write_cache_pages+0x225/0x377
Jun 26 22:27:29 [368353.512325]  [<ffffffff8108a22c>] ? set_page_dirty+0x5b/0x5b
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0105bb2>] ?
xfs_rw_iunlock+0x24/0x29 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa01067c5>] ?
xfs_file_buffered_aio_write+0xfd/0x110 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffff8108abee>]
generic_writepages+0x40/0x57
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0101c06>]
xfs_vm_writepages+0x47/0x4e [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffff8108bbec>] do_writepages+0x1c/0x25
Jun 26 22:27:29 [368353.512325]  [<ffffffff81084a71>]
__filemap_fdatawrite_range+0x4e/0x50
Jun 26 22:27:29 [368353.512325]  [<ffffffff810855e3>]
filemap_fdatawrite_range+0xe/0x10
Jun 26 22:27:29 [368353.512325]  [<ffffffffa010822a>]
xfs_flush_pages+0x5c/0x8e [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0112ebd>]
xfs_release+0xe8/0x1ab [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0105eb4>]
xfs_file_release+0x10/0x14 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffff810b729c>] fput+0xf9/0x1bd
Jun 26 22:27:29 [368353.512325]  [<ffffffff810b449a>] filp_close+0x6b/0x76
Jun 26 22:27:29 [368353.512325]  [<ffffffff810b4523>] sys_close+0x7e/0xbb
Jun 26 22:27:29 [368353.512325]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.512325] nfsd            D ffffffffffffffff
0  7164      2 0x00000000
Jun 26 22:27:29 [368353.512325]  ffff880107f99b18 0000000000000046
ffff88010a330d80 ffff88010dd1bfc0
Jun 26 22:27:29 [368353.512325]  ffffffff810c7402 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.512325]  ffff88010c8ea640 00000000000107c0
ffff880107f99fd8 ffff880107f99fd8
Jun 26 22:27:29 [368353.512325] Call Trace:
Jun 26 22:27:29 [368353.512325]  [<ffffffff810c7402>] ?
d_obtain_alias+0x142/0x14e
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0105975>] ?
xfs_dir_fsync+0x77/0x77 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.512325]  [<ffffffff8125efa0>]
rwsem_down_failed_common+0xd7/0x109
Jun 26 22:27:29 [368353.512325]  [<ffffffff8125eff9>]
rwsem_down_read_failed+0x12/0x14
Jun 26 22:27:29 [368353.512325]  [<ffffffff81136a84>]
call_rwsem_down_read_failed+0x14/0x30
Jun 26 22:27:29 [368353.512325]  [<ffffffff810b6eb8>] ?
get_empty_filp+0x66/0x113
Jun 26 22:27:29 [368353.512325]  [<ffffffff8125de47>] ? down_read+0x12/0x14
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0108483>] xfs_ilock+0x59/0x5e [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa01084b8>]
xfs_ilock_map_shared+0x30/0x36 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa010599e>]
xfs_dir_open+0x29/0x58 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffff810b4899>]
__dentry_open.clone.14+0x149/0x263
Jun 26 22:27:29 [368353.512325]  [<ffffffff810b4a04>] dentry_open+0x51/0x5a
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0315c76>]
nfsd_open+0x11f/0x158 [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0316797>]
nfsd_readdir+0x43/0x1cf [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa031d750>] ?
nfs3svc_encode_entry+0xe/0xe [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa027b4b7>] ?
cache_check+0x1f4/0x216 [sunrpc]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa031b59c>]
nfsd3_proc_readdirplus+0x8b/0x16f [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa031279e>]
nfsd_dispatch+0xa5/0x15c [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0272b39>]
svc_process+0x3a5/0x567 [sunrpc]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa031205f>] ?
nfsd_get_default_max_blksize+0x3a/0x3a [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0312149>] nfsd+0xea/0x12e [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa031205f>] ?
nfsd_get_default_max_blksize+0x3a/0x3a [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffff8103fba9>] kthread+0x84/0x8c
Jun 26 22:27:29 [368353.512325]  [<ffffffff81260b54>]
kernel_thread_helper+0x4/0x10
Jun 26 22:27:29 [368353.512325]  [<ffffffff8103fb25>] ?
kthread_freezable_should_stop+0x41/0x41
Jun 26 22:27:29 [368353.512325]  [<ffffffff81260b50>] ? gs_change+0xb/0xb
Jun 26 22:27:29 [368353.512325] nfsd            D ffffffffffffffff
0  7166      2 0x00000000
Jun 26 22:27:29 [368353.512325]  ffff8801028a5b18 0000000000000046
ffff88010a330d80 ffff88010dd1bfc0
Jun 26 22:27:29 [368353.512325]  ffffffff810c7402 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.512325]  ffff88010c8e8660 00000000000107c0
ffff8801028a5fd8 ffff8801028a5fd8
Jun 26 22:27:29 [368353.512325] Call Trace:
Jun 26 22:27:29 [368353.512325]  [<ffffffff810c7402>] ?
d_obtain_alias+0x142/0x14e
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0105975>] ?
xfs_dir_fsync+0x77/0x77 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.512325]  [<ffffffff8125efa0>]
rwsem_down_failed_common+0xd7/0x109
Jun 26 22:27:29 [368353.512325]  [<ffffffff8125eff9>]
rwsem_down_read_failed+0x12/0x14
Jun 26 22:27:29 [368353.512325]  [<ffffffff81136a84>]
call_rwsem_down_read_failed+0x14/0x30
Jun 26 22:27:29 [368353.512325]  [<ffffffff810b6eb8>] ?
get_empty_filp+0x66/0x113
Jun 26 22:27:29 [368353.512325]  [<ffffffff8125de47>] ? down_read+0x12/0x14
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0108483>] xfs_ilock+0x59/0x5e [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa01084b8>]
xfs_ilock_map_shared+0x30/0x36 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa010599e>]
xfs_dir_open+0x29/0x58 [xfs]
Jun 26 22:27:29 [368353.512325]  [<ffffffff810b4899>]
__dentry_open.clone.14+0x149/0x263
Jun 26 22:27:29 [368353.512325]  [<ffffffff810b4a04>] dentry_open+0x51/0x5a
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0315c76>]
nfsd_open+0x11f/0x158 [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0316797>]
nfsd_readdir+0x43/0x1cf [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa031d750>] ?
nfs3svc_encode_entry+0xe/0xe [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa027b4b7>] ?
cache_check+0x1f4/0x216 [sunrpc]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa031b59c>]
nfsd3_proc_readdirplus+0x8b/0x16f [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa031279e>]
nfsd_dispatch+0xa5/0x15c [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0272b39>]
svc_process+0x3a5/0x567 [sunrpc]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa031205f>] ?
nfsd_get_default_max_blksize+0x3a/0x3a [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa0312149>] nfsd+0xea/0x12e [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffffa031205f>] ?
nfsd_get_default_max_blksize+0x3a/0x3a [nfsd]
Jun 26 22:27:29 [368353.512325]  [<ffffffff8103fba9>] kthread+0x84/0x8c
Jun 26 22:27:29 [368353.512325]  [<ffffffff81260b54>]
kernel_thread_helper+0x4/0x10
Jun 26 22:27:29 [368353.512325]  [<ffffffff8103fb25>] ?
kthread_freezable_should_stop+0x41/0x41
Jun 26 22:27:29 [368353.512325]  [<ffffffff81260b50>] ? gs_change+0xb/0xb
Jun 26 22:27:29 [368353.512325] agetty          D ffff880101e3bb18
0  7323      1 0x00000000
Jun 26 22:27:29 [368353.512325]  ffff880101e3ba68 0000000000000082
ffff880101e3b9e8 ffff88010dd1d940
Jun 26 22:27:29 [368353.530119]  ffff880101e3ba18 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010c8bb960 00000000000107c0
ffff880101e3bfd8 ffff880101e3bfd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108403a>] ? sleep_on_page+0xd/0xd
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e81e>] io_schedule+0x5e/0x79
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084043>]
sleep_on_page_killable+0x9/0x23
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d7cb>]
__wait_on_bit_lock+0x41/0x8a
Jun 26 22:27:29 [368353.530119]  [<ffffffff81083f77>]
__lock_page_killable+0x61/0x68
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fff4>] ?
autoremove_wake_function+0x34/0x34
Jun 26 22:27:29 [368353.530119]  [<ffffffff8113144a>] ?
radix_tree_lookup_slot+0xe/0x10
Jun 26 22:27:29 [368353.530119]  [<ffffffff81083f9f>]
lock_page_killable+0x21/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffff810853a3>]
generic_file_aio_read+0x454/0x61e
Jun 26 22:27:29 [368353.530119]  [<ffffffff8104ac69>] ? update_curr+0x42/0x79
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01062a1>]
xfs_file_aio_read+0x1a4/0x1fa [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b592c>] do_sync_read+0xc9/0x106
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0110fdf>] ?
xfs_xattr_get+0x37/0x40 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cf77c>] ?
generic_getxattr+0x4e/0x5b
Jun 26 22:27:29 [368353.530119]  [<ffffffff811166b4>] ?
get_vfs_caps_from_disk+0x54/0xcd
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125f01c>] ? _raw_spin_lock+0x9/0xb
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6032>] vfs_read+0xa4/0xf7
Jun 26 22:27:29 [368353.530119]  [<ffffffff810ba035>] kernel_read+0x3c/0x4c
Jun 26 22:27:29 [368353.530119]  [<ffffffff810ba126>] prepare_binprm+0xe1/0xe5
Jun 26 22:27:29 [368353.530119]  [<ffffffff810bb998>]
do_execve_common.clone.35+0x223/0x392
Jun 26 22:27:29 [368353.530119]  [<ffffffff810bbb1d>] do_execve+0x16/0x18
Jun 26 22:27:29 [368353.530119]  [<ffffffff81009c54>] sys_execve+0x3e/0x55
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fe2c>] stub_execve+0x6c/0xc0
Jun 26 22:27:29 [368353.530119] agetty          D ffff88010c8b8000
0  7324      1 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff880101e5b588 0000000000000086
ffff880101e5b518 ffff88010dd1f2c0
Jun 26 22:27:29 [368353.530119]  0000000000000400 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010c8b8000 00000000000107c0
ffff880101e5bfd8 ffff880101e5bfd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffff810defa8>]
do_mpage_readpage+0x443/0x4f7
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108cb59>] ?
__lru_cache_add+0x2f/0x56
Jun 26 22:27:29 [368353.530119]  [<ffffffff810df1aa>] mpage_readpages+0xe9/0x134
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101a00>] ?
xfs_get_blocks_direct+0x11/0x11 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01037a4>] ?
xfs_buf_rele+0x32/0x8c [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101a00>] ?
xfs_get_blocks_direct+0x11/0x11 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101bbd>]
xfs_vm_readpages+0x18/0x1a [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108be39>]
__do_page_cache_readahead+0x135/0x1d2
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108c14c>] ra_submit+0x1c/0x20
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108c307>]
ondemand_readahead+0x1b7/0x1c6
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c5f00>] ?
dentry_update_name_case+0x1c/0x56
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108c3cb>]
page_cache_sync_readahead+0x38/0x3d
Jun 26 22:27:29 [368353.530119]  [<ffffffff810851ec>]
generic_file_aio_read+0x29d/0x61e
Jun 26 22:27:29 [368353.530119]  [<ffffffff8104ac69>] ? update_curr+0x42/0x79
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01062a1>]
xfs_file_aio_read+0x1a4/0x1fa [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b592c>] do_sync_read+0xc9/0x106
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0110fdf>] ?
xfs_xattr_get+0x37/0x40 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cf77c>] ?
generic_getxattr+0x4e/0x5b
Jun 26 22:27:29 [368353.530119]  [<ffffffff811166b4>] ?
get_vfs_caps_from_disk+0x54/0xcd
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125f01c>] ? _raw_spin_lock+0x9/0xb
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6032>] vfs_read+0xa4/0xf7
Jun 26 22:27:29 [368353.530119]  [<ffffffff810ba035>] kernel_read+0x3c/0x4c
Jun 26 22:27:29 [368353.530119]  [<ffffffff810ba126>] prepare_binprm+0xe1/0xe5
Jun 26 22:27:29 [368353.530119]  [<ffffffff810bb998>]
do_execve_common.clone.35+0x223/0x392
Jun 26 22:27:29 [368353.530119]  [<ffffffff810bbb1d>] do_execve+0x16/0x18
Jun 26 22:27:29 [368353.530119]  [<ffffffff81009c54>] sys_execve+0x3e/0x55
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fe2c>] stub_execve+0x6c/0xc0
Jun 26 22:27:29 [368353.530119] irssi           D ffffffff8108402d
0  7343      1 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff880100487a38 0000000000000082
ffff8801004879b8 ffff88010c3c8cc0
Jun 26 22:27:29 [368353.530119]  ffff8801004879e8 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010c8bd940 00000000000107c0
ffff880100487fd8 ffff880100487fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108402d>] ? lock_page+0x22/0x22
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e81e>] io_schedule+0x5e/0x79
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084036>] sleep_on_page+0x9/0xd
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d8cb>] __wait_on_bit+0x43/0x76
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0140b02>] ?
xfs_trans_free_item_desc+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810841e3>] wait_on_page_bit+0x6d/0x74
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fff4>] ?
autoremove_wake_function+0x34/0x34
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084109>] ? find_lock_page+0x32/0x56
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084200>]
wait_on_page_writeback+0x16/0x18
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108443a>]
grab_cache_page_write_begin+0xa9/0xbb
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d83b6>]
block_write_begin+0x27/0x77
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101a00>] ?
xfs_get_blocks_direct+0x11/0x11 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102393>]
xfs_vm_write_begin+0x37/0x5b [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d197a>] ? inode_to_bdi+0x21/0x3f
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108370b>]
generic_file_buffered_write+0x105/0x255
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cb70c>] ?
mnt_drop_write_file+0xd/0xf
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c89d8>] ?
file_update_time+0xd4/0xeb
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010677b>]
xfs_file_buffered_aio_write+0xb3/0x110 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0106934>]
xfs_file_aio_write+0x15c/0x1b0 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8109e1ac>] ? vma_link+0x85/0xa7
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5826>] do_sync_write+0xc9/0x106
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5f3b>] vfs_write+0xa7/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6133>] sys_write+0x45/0x69
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] flush-254:11    D ffff88010c8b9980
0  7345      2 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff8801004a1640 0000000000000046
ffff8801004a15d0 ffff88010c3cd2e0
Jun 26 22:27:29 [368353.530119]  ffff88010f0029c0 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010c8b9980 00000000000107c0
ffff8801004a1fd8 ffff8801004a1fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c9c8c>] ? linear_merge+0x4d/0x58
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01023e5>]
xfs_submit_ioend_bio.clone.19+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01024b5>]
xfs_submit_ioend+0xce/0xee [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102859>]
xfs_vm_writepage+0x384/0x412 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108a23e>] __writepage+0x12/0x2b
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108aa5c>]
write_cache_pages+0x225/0x377
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108a22c>] ? set_page_dirty+0x5b/0x5b
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0067408>] ?
plugger_unplug+0x38/0x3c [md_mod]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8111ba86>] ?
blk_flush_plug_list+0x94/0x1b1
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108abee>]
generic_writepages+0x40/0x57
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101c06>]
xfs_vm_writepages+0x47/0x4e [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108bbec>] do_writepages+0x1c/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d1c17>]
writeback_single_inode+0xcf/0x232
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d2015>]
writeback_sb_inodes+0x163/0x1fe
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d240e>]
__writeback_inodes_wb+0x6d/0xab
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d26dd>] wb_writeback+0xfc/0x182
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c91b9>] ?
get_nr_inodes_unused+0x43/0x5a
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125f1d9>] ?
_raw_spin_lock_irqsave+0xd/0x27
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d2dbd>]
wb_do_writeback+0x111/0x16d
Jun 26 22:27:29 [368353.530119]  [<ffffffff81033322>] ?
run_timer_softirq+0x1ef/0x1ef
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d2e9e>]
bdi_writeback_thread+0x85/0x14a
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d2e19>] ?
wb_do_writeback+0x16d/0x16d
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d2e19>] ?
wb_do_writeback+0x16d/0x16d
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fba9>] kthread+0x84/0x8c
Jun 26 22:27:29 [368353.530119]  [<ffffffff81260b54>]
kernel_thread_helper+0x4/0x10
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fb25>] ?
kthread_freezable_should_stop+0x41/0x41
Jun 26 22:27:29 [368353.530119]  [<ffffffff81260b50>] ? gs_change+0xb/0xb
Jun 26 22:27:29 [368353.530119] irssi           D ffffffff8108402d
0  7382      1 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff88007f8e3a38 0000000000000082
0000000000000004 ffff88010dd1bfc0
Jun 26 22:27:29 [368353.530119]  ffff88007f8e3a08 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010c8b8660 00000000000107c0
ffff88007f8e3fd8 ffff88007f8e3fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108402d>] ? lock_page+0x22/0x22
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e81e>] io_schedule+0x5e/0x79
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084036>] sleep_on_page+0x9/0xd
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d8cb>] __wait_on_bit+0x43/0x76
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0140b02>] ?
xfs_trans_free_item_desc+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810841e3>] wait_on_page_bit+0x6d/0x74
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fff4>] ?
autoremove_wake_function+0x34/0x34
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084109>] ? find_lock_page+0x32/0x56
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084200>]
wait_on_page_writeback+0x16/0x18
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108443a>]
grab_cache_page_write_begin+0xa9/0xbb
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d83b6>]
block_write_begin+0x27/0x77
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101a00>] ?
xfs_get_blocks_direct+0x11/0x11 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102393>]
xfs_vm_write_begin+0x37/0x5b [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d197a>] ? inode_to_bdi+0x21/0x3f
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108370b>]
generic_file_buffered_write+0x105/0x255
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cb70c>] ?
mnt_drop_write_file+0xd/0xf
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c89d8>] ?
file_update_time+0xd4/0xeb
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010677b>]
xfs_file_buffered_aio_write+0xb3/0x110 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0106934>]
xfs_file_aio_write+0x15c/0x1b0 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5826>] do_sync_write+0xc9/0x106
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5f3b>] vfs_write+0xa7/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6133>] sys_write+0x45/0x69
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] irssi           D ffffffff8108402d
0  7383      1 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff88007f9f9a38 0000000000000082
0000000000000004 ffff88010dd1f2c0
Jun 26 22:27:29 [368353.530119]  ffff88007f9f9a08 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010db4aca0 00000000000107c0
ffff88007f9f9fd8 ffff88007f9f9fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108402d>] ? lock_page+0x22/0x22
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e81e>] io_schedule+0x5e/0x79
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084036>] sleep_on_page+0x9/0xd
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d8cb>] __wait_on_bit+0x43/0x76
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0140b02>] ?
xfs_trans_free_item_desc+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810841e3>] wait_on_page_bit+0x6d/0x74
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fff4>] ?
autoremove_wake_function+0x34/0x34
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084109>] ? find_lock_page+0x32/0x56
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084200>]
wait_on_page_writeback+0x16/0x18
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108443a>]
grab_cache_page_write_begin+0xa9/0xbb
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d83b6>]
block_write_begin+0x27/0x77
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101a00>] ?
xfs_get_blocks_direct+0x11/0x11 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102393>]
xfs_vm_write_begin+0x37/0x5b [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d197a>] ? inode_to_bdi+0x21/0x3f
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108370b>]
generic_file_buffered_write+0x105/0x255
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cb70c>] ?
mnt_drop_write_file+0xd/0xf
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c89d8>] ?
file_update_time+0xd4/0xeb
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010677b>]
xfs_file_buffered_aio_write+0xb3/0x110 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0106934>]
xfs_file_aio_write+0x15c/0x1b0 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5826>] do_sync_write+0xc9/0x106
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5f3b>] vfs_write+0xa7/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6133>] sys_write+0x45/0x69
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] ping.py         D ffff88010c5fcc80
0  4347   4337 0x00000004
Jun 26 22:27:29 [368353.530119]  ffff88002c791758 0000000000000082
ffff88002c7916e8 ffff88010c3c8cc0
Jun 26 22:27:29 [368353.530119]  0000000000000400 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010c5fcc80 00000000000107c0
ffff88002c791fd8 ffff88002c791fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c9c8c>] ? linear_merge+0x4d/0x58
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01023e5>]
xfs_submit_ioend_bio.clone.19+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01024b5>]
xfs_submit_ioend+0xce/0xee [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102859>]
xfs_vm_writepage+0x384/0x412 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108a23e>] __writepage+0x12/0x2b
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108aa5c>]
write_cache_pages+0x225/0x377
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108a22c>] ? set_page_dirty+0x5b/0x5b
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102338>] ?
xfs_vm_write_end+0x22/0x46 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810837e2>] ?
generic_file_buffered_write+0x1dc/0x255
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cb70c>] ?
mnt_drop_write_file+0xd/0xf
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108abee>]
generic_writepages+0x40/0x57
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101c06>]
xfs_vm_writepages+0x47/0x4e [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108bbec>] do_writepages+0x1c/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084a71>]
__filemap_fdatawrite_range+0x4e/0x50
Jun 26 22:27:29 [368353.530119]  [<ffffffff810855e3>]
filemap_fdatawrite_range+0xe/0x10
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010822a>]
xfs_flush_pages+0x5c/0x8e [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010c6b0>]
xfs_setattr_size+0x135/0x348 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8102e526>] ?
current_fs_time+0x22/0x29
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010c8de>]
xfs_vn_setattr+0x1b/0x2f [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810ca449>] notify_change+0x1a1/0x27a
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b4bac>] do_truncate+0x65/0x82
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5707>] ?
fsnotify_modify+0x5d/0x65
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6dba>] ? fget+0x37/0x4c
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b4d7b>] sys_ftruncate+0xa4/0xa6
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] kworker/3:3     D ffff880113d907c0
0 29654      2 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff880106145cd0 0000000000000046
00000e3100000000 ffff880072938660
Jun 26 22:27:29 [368353.530119]  0000000081049200 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010b2d3960 00000000000107c0
ffff880106145fd8 ffff880106145fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa014210f>] xlog_wait+0x58/0x70 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01442a9>]
_xfs_log_force_lsn+0x1bf/0x1f5 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0141a69>]
xfs_trans_commit+0xdc/0x1d8 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa011007b>] ?
xfs_ifunlock+0x3f/0x3f [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0108011>]
xfs_fs_log_dummy+0x6f/0x76 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0143482>] ?
xfs_log_need_covered+0x52/0x94 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01100b9>]
xfs_sync_worker+0x3e/0x64 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103bbd0>]
process_one_work+0x161/0x22b
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103c724>] worker_thread+0xfe/0x182
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103c626>] ?
manage_workers.clone.22+0x16d/0x16d
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103c626>] ?
manage_workers.clone.22+0x16d/0x16d
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fba9>] kthread+0x84/0x8c
Jun 26 22:27:29 [368353.530119]  [<ffffffff81260b54>]
kernel_thread_helper+0x4/0x10
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fb25>] ?
kthread_freezable_should_stop+0x41/0x41
Jun 26 22:27:29 [368353.530119]  [<ffffffff81260b50>] ? gs_change+0xb/0xb
Jun 26 22:27:29 [368353.530119] kworker/0:0     D ffff88010cfa6c60
0  1339      2 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff880035d53cd0 0000000000000046
0000023100000000 ffff88010c3c8cc0
Jun 26 22:27:29 [368353.530119]  0000000081049200 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010cfa6c60 00000000000107c0
ffff880035d53fd8 ffff880035d53fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa014210f>] xlog_wait+0x58/0x70 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01442a9>]
_xfs_log_force_lsn+0x1bf/0x1f5 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0141a69>]
xfs_trans_commit+0xdc/0x1d8 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa011007b>] ?
xfs_ifunlock+0x3f/0x3f [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0108011>]
xfs_fs_log_dummy+0x6f/0x76 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0143493>] ?
xfs_log_need_covered+0x63/0x94 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01100b9>]
xfs_sync_worker+0x3e/0x64 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103bbd0>]
process_one_work+0x161/0x22b
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103c724>] worker_thread+0xfe/0x182
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103c626>] ?
manage_workers.clone.22+0x16d/0x16d
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103c626>] ?
manage_workers.clone.22+0x16d/0x16d
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fba9>] kthread+0x84/0x8c
Jun 26 22:27:29 [368353.530119]  [<ffffffff81260b54>]
kernel_thread_helper+0x4/0x10
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fb25>] ?
kthread_freezable_should_stop+0x41/0x41
Jun 26 22:27:29 [368353.530119]  [<ffffffff81260b50>] ? gs_change+0xb/0xb
Jun 26 22:27:29 [368353.530119] kworker/3:2     D ffff88010cfa0000
0  1968      2 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff8800e6f57ac0 0000000000000046
ffffea00040b7900 ffff88010c3cec60
Jun 26 22:27:29 [368353.530119]  ffff8800e6f57ae0 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010cfa0000 00000000000107c0
ffff8800e6f57fd8 ffff8800e6f57fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00d52a9>] ?
ata_scsi_em_message_show+0x2f/0x2f [libata]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119a05>] ?
generic_make_request_checks+0x154/0x189
Jun 26 22:27:29 [368353.530119]  [<ffffffff810daed8>] ?
bio_alloc_bioset+0x71/0xbf
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6ba2>] ? dm_request+0x1c3/0x1c3
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c5c7e>] __map_bio+0x4f/0xb0
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c67ae>]
__split_and_process_bio+0x246/0x477
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c5c13>] ? dec_pending+0x24c/0x268
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6ba2>] ? dm_request+0x1c3/0x1c3
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6c33>] dm_wq_work+0x91/0xb2
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103bbd0>]
process_one_work+0x161/0x22b
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103c724>] worker_thread+0xfe/0x182
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103c626>] ?
manage_workers.clone.22+0x16d/0x16d
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103c626>] ?
manage_workers.clone.22+0x16d/0x16d
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fba9>] kthread+0x84/0x8c
Jun 26 22:27:29 [368353.530119]  [<ffffffff81260b54>]
kernel_thread_helper+0x4/0x10
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fb25>] ?
kthread_freezable_should_stop+0x41/0x41
Jun 26 22:27:29 [368353.530119]  [<ffffffff81260b50>] ? gs_change+0xb/0xb
Jun 26 22:27:29 [368353.530119] cleanup         D ffff88010de5aca0
0  7088   7286 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff880038865868 0000000000000082
ffff8800388657f8 ffffffff81359020
Jun 26 22:27:29 [368353.530119]  0000000000000005 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010de5aca0 00000000000107c0
ffff880038865fd8 ffff880038865fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c9c8c>] ? linear_merge+0x4d/0x58
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01023e5>]
xfs_submit_ioend_bio.clone.19+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01024b5>]
xfs_submit_ioend+0xce/0xee [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102859>]
xfs_vm_writepage+0x384/0x412 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108a23e>] __writepage+0x12/0x2b
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108aa5c>]
write_cache_pages+0x225/0x377
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108a22c>] ? set_page_dirty+0x5b/0x5b
Jun 26 22:27:29 [368353.530119]  [<ffffffffa014d43a>] ?
xfs_get_acl+0x23/0x104 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa014d669>] ?
xfs_acl_chmod+0x2c/0x7b [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108abee>]
generic_writepages+0x40/0x57
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101c06>]
xfs_vm_writepages+0x47/0x4e [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108bbec>] do_writepages+0x1c/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084a71>]
__filemap_fdatawrite_range+0x4e/0x50
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084a9b>]
filemap_write_and_wait_range+0x28/0x51
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0105d97>]
xfs_file_fsync+0x3c/0x149 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d589e>] vfs_fsync_range+0x1e/0x20
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d58b7>] vfs_fsync+0x17/0x19
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d5923>] do_fsync+0x29/0x3e
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d5b52>] sys_fsync+0xb/0xf
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] deliver         D ffff88007293aca0
0  7095   7094 0x00000004
Jun 26 22:27:29 [368353.530119]  ffff880035d21868 0000000000000086
ffff880035d217f8 ffff88010dd1d940
Jun 26 22:27:29 [368353.530119]  0000000000000005 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88007293aca0 00000000000107c0
ffff880035d21fd8 ffff880035d21fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c9c8c>] ? linear_merge+0x4d/0x58
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01023e5>]
xfs_submit_ioend_bio.clone.19+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01024b5>]
xfs_submit_ioend+0xce/0xee [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102859>]
xfs_vm_writepage+0x384/0x412 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108a23e>] __writepage+0x12/0x2b
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108aa5c>]
write_cache_pages+0x225/0x377
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108a22c>] ? set_page_dirty+0x5b/0x5b
Jun 26 22:27:29 [368353.530119]  [<ffffffff8109afb4>] ?
handle_pte_fault+0x25d/0x615
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010c517>] ?
xfs_setattr_nonsize+0x433/0x497 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108abee>]
generic_writepages+0x40/0x57
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101c06>]
xfs_vm_writepages+0x47/0x4e [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108bbec>] do_writepages+0x1c/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084a71>]
__filemap_fdatawrite_range+0x4e/0x50
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084a9b>]
filemap_write_and_wait_range+0x28/0x51
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0105d97>]
xfs_file_fsync+0x3c/0x149 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d589e>] vfs_fsync_range+0x1e/0x20
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d58b7>] vfs_fsync+0x17/0x19
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d5923>] do_fsync+0x29/0x3e
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d5b52>] sys_fsync+0xb/0xf
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] fetchmail       D ffff88010ca1ec60
0  7104   7099 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff8800388b36d8 0000000000000086
ffff88007293dfe8 ffff88010b2d4620
Jun 26 22:27:29 [368353.530119]  ffff8800388b3678 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010ca1ec60 00000000000107c0
ffff8800388b3fd8 ffff8800388b3fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125f1d9>] ?
_raw_spin_lock_irqsave+0xd/0x27
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d686>] schedule_timeout+0x22/0xd5
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0114bd2>] ?
kmem_zone_alloc+0x38/0x82 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125defb>] __down_common+0x90/0xe5
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125dfaf>] __down+0x18/0x1a
Jun 26 22:27:29 [368353.530119]  [<ffffffff81043ef9>] down+0x28/0x38
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010399f>]
xfs_buf_lock+0x37/0x3b [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0103b1b>]
_xfs_buf_find+0x178/0x1d6 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0103d0d>]
xfs_buf_get+0x25/0x13b [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0104019>]
xfs_buf_read+0x13/0x80 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01478b9>]
xfs_trans_read_buf+0x181/0x248 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa012b2ec>]
xfs_da_do_buf+0x2fe/0x518 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa012b558>]
xfs_da_read_buf+0x1c/0x1e [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103feed>] ? bit_waitqueue+0x12/0x92
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01309ed>]
xfs_dir2_leaf_addname+0x43/0x59e [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0121665>] ?
xfs_bmap_last_extent.clone.23+0x62/0x75 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa012d714>]
xfs_dir_createname+0x14f/0x16b [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0113723>]
xfs_create+0x31e/0x4a6 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010bf55>]
xfs_vn_mknod+0xd1/0x153 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010bff8>]
xfs_vn_create+0xe/0x10 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c05a5>] vfs_create+0x52/0x72
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c0d82>] do_last+0x220/0x573
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c17c3>] path_openat+0xcb/0x319
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c1aff>] do_filp_open+0x38/0x84
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cb079>] ? alloc_fd+0x6f/0xfe
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b54bf>] do_sys_open+0x70/0x102
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b556d>] sys_open+0x1c/0x1e
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] munin-update    D ffffffff8108402d
0  7113   7105 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff88005ea15a38 0000000000000082
0000000000000018 ffffffff81359020
Jun 26 22:27:29 [368353.530119]  ffff88005ea15a28 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010de59320 00000000000107c0
ffff88005ea15fd8 ffff88005ea15fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108402d>] ? lock_page+0x22/0x22
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e81e>] io_schedule+0x5e/0x79
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084036>] sleep_on_page+0x9/0xd
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d8cb>] __wait_on_bit+0x43/0x76
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0140b02>] ?
xfs_trans_free_item_desc+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810841e3>] wait_on_page_bit+0x6d/0x74
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fff4>] ?
autoremove_wake_function+0x34/0x34
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084109>] ? find_lock_page+0x32/0x56
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084200>]
wait_on_page_writeback+0x16/0x18
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108443a>]
grab_cache_page_write_begin+0xa9/0xbb
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d83b6>]
block_write_begin+0x27/0x77
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101a00>] ?
xfs_get_blocks_direct+0x11/0x11 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102393>]
xfs_vm_write_begin+0x37/0x5b [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d197a>] ? inode_to_bdi+0x21/0x3f
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108370b>]
generic_file_buffered_write+0x105/0x255
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cb70c>] ?
mnt_drop_write_file+0xd/0xf
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c89d8>] ?
file_update_time+0xd4/0xeb
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010677b>]
xfs_file_buffered_aio_write+0xb3/0x110 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0106934>]
xfs_file_aio_write+0x15c/0x1b0 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5826>] do_sync_write+0xc9/0x106
Jun 26 22:27:29 [368353.530119]  [<ffffffff8109b5a5>] ?
handle_mm_fault+0xe1/0xf6
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5f3b>] vfs_write+0xa7/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6133>] sys_write+0x45/0x69
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] fetchmail       D 0000000000000002
0  7144   7138 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff88007f8cbc78 0000000000000082
ffff88010ede7b40 ffffffff81359020
Jun 26 22:27:29 [368353.530119]  ffff88007f8cbd48 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88007293f920 00000000000107c0
ffff88007f8cbfd8 ffff88007f8cbfd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e95b>]
schedule_preempt_disabled+0x9/0xb
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125db87>]
__mutex_lock_common.clone.5+0x11d/0x17e
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125dbf6>]
__mutex_lock_slowpath+0xe/0x10
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d988>] mutex_lock+0x16/0x27
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c0cf7>] do_last+0x195/0x573
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c17c3>] path_openat+0xcb/0x319
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c1aff>] do_filp_open+0x38/0x84
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cb079>] ? alloc_fd+0x6f/0xfe
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b54bf>] do_sys_open+0x70/0x102
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b556d>] sys_open+0x1c/0x1e
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] munin-update    D 0000000000000002
0  7145   7141 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff8800389ddbe8 0000000000000086
ffff8800389ddbd8 ffff88010dd1d940
Jun 26 22:27:29 [368353.530119]  0000000000000002 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010b2d5fa0 00000000000107c0
ffff8800389ddfd8 ffff8800389ddfd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e95b>]
schedule_preempt_disabled+0x9/0xb
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125db87>]
__mutex_lock_common.clone.5+0x11d/0x17e
Jun 26 22:27:29 [368353.530119]  [<ffffffff810858d0>] ?
filemap_fault+0x1ee/0x34f
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125dbf6>]
__mutex_lock_slowpath+0xe/0x10
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d988>] mutex_lock+0x16/0x27
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0105b7c>]
xfs_rw_ilock+0x21/0x33 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0106715>]
xfs_file_buffered_aio_write+0x4d/0x110 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0106934>]
xfs_file_aio_write+0x15c/0x1b0 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5826>] do_sync_write+0xc9/0x106
Jun 26 22:27:29 [368353.530119]  [<ffffffff8109b5a5>] ?
handle_mm_fault+0xe1/0xf6
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5f3b>] vfs_write+0xa7/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6133>] sys_write+0x45/0x69
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] fetchmail       D 0000000000000002
0  7181   7175 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff880038901c78 0000000000000086
ffff88010ede7b40 ffff88007293c620
Jun 26 22:27:29 [368353.530119]  ffff880038901d48 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88007293bfc0 00000000000107c0
ffff880038901fd8 ffff880038901fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e95b>]
schedule_preempt_disabled+0x9/0xb
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125db87>]
__mutex_lock_common.clone.5+0x11d/0x17e
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125dbf6>]
__mutex_lock_slowpath+0xe/0x10
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d988>] mutex_lock+0x16/0x27
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c0cf7>] do_last+0x195/0x573
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c17c3>] path_openat+0xcb/0x319
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c1aff>] do_filp_open+0x38/0x84
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cb079>] ? alloc_fd+0x6f/0xfe
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b54bf>] do_sys_open+0x70/0x102
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b556d>] sys_open+0x1c/0x1e
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] munin-update    D 0000000000000002
0  7189   7183 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff880037793be8 0000000000000082
ffff880037793bd8 ffff88010dd1bfc0
Jun 26 22:27:29 [368353.530119]  0000000000000002 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010de59fe0 00000000000107c0
ffff880037793fd8 ffff880037793fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e95b>]
schedule_preempt_disabled+0x9/0xb
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125db87>]
__mutex_lock_common.clone.5+0x11d/0x17e
Jun 26 22:27:29 [368353.530119]  [<ffffffff810858d0>] ?
filemap_fault+0x1ee/0x34f
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125dbf6>]
__mutex_lock_slowpath+0xe/0x10
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d988>] mutex_lock+0x16/0x27
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0105b7c>]
xfs_rw_ilock+0x21/0x33 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0106715>]
xfs_file_buffered_aio_write+0x4d/0x110 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0106934>]
xfs_file_aio_write+0x15c/0x1b0 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5826>] do_sync_write+0xc9/0x106
Jun 26 22:27:29 [368353.530119]  [<ffffffff8109b5a5>] ?
handle_mm_fault+0xe1/0xf6
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5f3b>] vfs_write+0xa7/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6133>] sys_write+0x45/0x69
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] apache2         D ffff88010de5ec60
0  7208  17519 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff8800e440d778 0000000000000086
ffff8800e440d708 ffff88010dd1f2c0
Jun 26 22:27:29 [368353.530119]  0000000000000000 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010de5ec60 00000000000107c0
ffff8800e440dfd8 ffff8800e440dfd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108cb59>] ?
__lru_cache_add+0x2f/0x56
Jun 26 22:27:29 [368353.530119]  [<ffffffff810df1e1>]
mpage_readpages+0x120/0x134
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101a00>] ?
xfs_get_blocks_direct+0x11/0x11 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101a00>] ?
xfs_get_blocks_direct+0x11/0x11 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101bbd>]
xfs_vm_readpages+0x18/0x1a [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108be39>]
__do_page_cache_readahead+0x135/0x1d2
Jun 26 22:27:29 [368353.530119]  [<ffffffff810afc43>] ? signal_pending+0x12/0x1c
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108c14c>] ra_submit+0x1c/0x20
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108c307>]
ondemand_readahead+0x1b7/0x1c6
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108c3cb>]
page_cache_sync_readahead+0x38/0x3d
Jun 26 22:27:29 [368353.530119]  [<ffffffff810851ec>]
generic_file_aio_read+0x29d/0x61e
Jun 26 22:27:29 [368353.530119]  [<ffffffff810a239d>] ?
page_add_new_anon_rmap+0x5b/0x6e
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01062a1>]
xfs_file_aio_read+0x1a4/0x1fa [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b592c>] do_sync_read+0xc9/0x106
Jun 26 22:27:29 [368353.530119]  [<ffffffff8109b5a5>] ?
handle_mm_fault+0xe1/0xf6
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6032>] vfs_read+0xa4/0xf7
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b60ca>] sys_read+0x45/0x69
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] cleanup         D ffff88010bd6e600
0  7210   7286 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff88003ac71868 0000000000000082
ffff88003ac717f8 ffff88010dd1bfc0
Jun 26 22:27:29 [368353.530119]  0000000000000005 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88010bd6e600 00000000000107c0
ffff88003ac71fd8 ffff88003ac71fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c9c8c>] ? linear_merge+0x4d/0x58
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01023e5>]
xfs_submit_ioend_bio.clone.19+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01024b5>]
xfs_submit_ioend+0xce/0xee [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102859>]
xfs_vm_writepage+0x384/0x412 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108a23e>] __writepage+0x12/0x2b
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108aa5c>]
write_cache_pages+0x225/0x377
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108a22c>] ? set_page_dirty+0x5b/0x5b
Jun 26 22:27:29 [368353.530119]  [<ffffffffa014d669>] ?
xfs_acl_chmod+0x2c/0x7b [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108abee>]
generic_writepages+0x40/0x57
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101c06>]
xfs_vm_writepages+0x47/0x4e [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108bbec>] do_writepages+0x1c/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084a71>]
__filemap_fdatawrite_range+0x4e/0x50
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084a9b>]
filemap_write_and_wait_range+0x28/0x51
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0105d97>]
xfs_file_fsync+0x3c/0x149 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d589e>] vfs_fsync_range+0x1e/0x20
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d58b7>] vfs_fsync+0x17/0x19
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d5923>] do_fsync+0x29/0x3e
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d5b52>] sys_fsync+0xb/0xf
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] local           D ffffffff8108402d
0  7213   7286 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff8800e6e17a38 0000000000000086
ffff8800e6e179b8 ffff88010dd1d940
Jun 26 22:27:29 [368353.530119]  ffff88010f002240 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff880072938cc0 00000000000107c0
ffff8800e6e17fd8 ffff8800e6e17fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108402d>] ? lock_page+0x22/0x22
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e81e>] io_schedule+0x5e/0x79
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084036>] sleep_on_page+0x9/0xd
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125d8cb>] __wait_on_bit+0x43/0x76
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0140b02>] ?
xfs_trans_free_item_desc+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810841e3>] wait_on_page_bit+0x6d/0x74
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103fff4>] ?
autoremove_wake_function+0x34/0x34
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084109>] ? find_lock_page+0x32/0x56
Jun 26 22:27:29 [368353.530119]  [<ffffffff81084200>]
wait_on_page_writeback+0x16/0x18
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108443a>]
grab_cache_page_write_begin+0xa9/0xbb
Jun 26 22:27:29 [368353.530119]  [<ffffffff810d83b6>]
block_write_begin+0x27/0x77
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0101a00>] ?
xfs_get_blocks_direct+0x11/0x11 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102393>]
xfs_vm_write_begin+0x37/0x5b [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8108370b>]
generic_file_buffered_write+0x105/0x255
Jun 26 22:27:29 [368353.530119]  [<ffffffff810cb70c>] ?
mnt_drop_write_file+0xd/0xf
Jun 26 22:27:29 [368353.530119]  [<ffffffff810c89d8>] ?
file_update_time+0xd4/0xeb
Jun 26 22:27:29 [368353.530119]  [<ffffffffa010677b>]
xfs_file_buffered_aio_write+0xb3/0x110 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0106934>]
xfs_file_aio_write+0x15c/0x1b0 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5826>] do_sync_write+0xc9/0x106
Jun 26 22:27:29 [368353.530119]  [<ffffffff8109b5a5>] ?
handle_mm_fault+0xe1/0xf6
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b5f3b>] vfs_write+0xa7/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffff810b6133>] sys_write+0x45/0x69
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:29 [368353.530119] sshd            D ffff88007293d2e0
0  7221      1 0x00000000
Jun 26 22:27:29 [368353.530119]  ffff880035da5868 0000000000000082
ffff880035da57f8 ffff88010dd1d940
Jun 26 22:27:29 [368353.530119]  ffff88010f0029c0 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:29 [368353.530119]  ffff88007293d2e0 00000000000107c0
ffff880035da5fd8 ffff880035da5fd8
Jun 26 22:27:29 [368353.530119] Call Trace:
Jun 26 22:27:29 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:29 [368353.530119]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:29 [368353.530119]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:29 [368353.530119]  [<ffffffff811c9c8c>] ? linear_merge+0x4d/0x58
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:29 [368353.530119]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01023e5>]
xfs_submit_ioend_bio.clone.19+0x2e/0x30 [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa01024b5>]
xfs_submit_ioend+0xce/0xee [xfs]
Jun 26 22:27:29 [368353.530119]  [<ffffffffa0102859>]
xfs_vm_writepage+0x384/0x412 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff8108a23e>] __writepage+0x12/0x2b
Jun 26 22:27:30 [368353.530119]  [<ffffffff8108aa5c>]
write_cache_pages+0x225/0x377
Jun 26 22:27:30 [368353.530119]  [<ffffffff8108a22c>] ? set_page_dirty+0x5b/0x5b
Jun 26 22:27:30 [368353.530119]  [<ffffffffa010696b>] ?
xfs_file_aio_write+0x193/0x1b0 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff8108abee>]
generic_writepages+0x40/0x57
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0101c06>]
xfs_vm_writepages+0x47/0x4e [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff8108bbec>] do_writepages+0x1c/0x25
Jun 26 22:27:30 [368353.530119]  [<ffffffff81084a71>]
__filemap_fdatawrite_range+0x4e/0x50
Jun 26 22:27:30 [368353.530119]  [<ffffffff81084a9b>]
filemap_write_and_wait_range+0x28/0x51
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0105d97>]
xfs_file_fsync+0x3c/0x149 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b5707>] ?
fsnotify_modify+0x5d/0x65
Jun 26 22:27:30 [368353.530119]  [<ffffffff810d589e>] vfs_fsync_range+0x1e/0x20
Jun 26 22:27:30 [368353.530119]  [<ffffffff810d58b7>] vfs_fsync+0x17/0x19
Jun 26 22:27:30 [368353.530119]  [<ffffffff810d5923>] do_fsync+0x29/0x3e
Jun 26 22:27:30 [368353.530119]  [<ffffffff810d5b52>] sys_fsync+0xb/0xf
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:30 [368353.530119] bash            D fffffffeffffffff
0  7226   7225 0x00000000
Jun 26 22:27:30 [368353.530119]  ffff880073ebfb70 0000000000000082
4000000000000000 ffffffff81359020
Jun 26 22:27:30 [368353.530119]  0000000000000202 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:30 [368353.530119]  ffff88010bd6f920 00000000000107c0
ffff880073ebffd8 ffff880073ebffd8
Jun 26 22:27:30 [368353.530119] Call Trace:
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0105975>] ?
xfs_dir_fsync+0x77/0x77 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125efa0>]
rwsem_down_failed_common+0xd7/0x109
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125eff9>]
rwsem_down_read_failed+0x12/0x14
Jun 26 22:27:30 [368353.530119]  [<ffffffff81136a84>]
call_rwsem_down_read_failed+0x14/0x30
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125de47>] ? down_read+0x12/0x14
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0108483>] xfs_ilock+0x59/0x5e [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01084b8>]
xfs_ilock_map_shared+0x30/0x36 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa010599e>]
xfs_dir_open+0x29/0x58 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b4899>]
__dentry_open.clone.14+0x149/0x263
Jun 26 22:27:30 [368353.530119]  [<ffffffff810cbe68>] ? mntget+0x1b/0x21
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b5448>]
nameidata_to_filp+0x43/0x4a
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c10c1>] do_last+0x55f/0x573
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c17c3>] path_openat+0xcb/0x319
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c1aff>] do_filp_open+0x38/0x84
Jun 26 22:27:30 [368353.530119]  [<ffffffff810cb079>] ? alloc_fd+0x6f/0xfe
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b54bf>] do_sys_open+0x70/0x102
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b557e>] sys_openat+0xf/0x11
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:30 [368353.530119] fetchmail       D 0000000000000002
0  7237   7231 0x00000000
Jun 26 22:27:30 [368353.530119]  ffff8800e6fedc78 0000000000000086
ffff88010ede7b40 ffffffff81359020
Jun 26 22:27:30 [368353.530119]  ffff8800e6fedd48 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:30 [368353.530119]  ffff880072939980 00000000000107c0
ffff8800e6fedfd8 ffff8800e6fedfd8
Jun 26 22:27:30 [368353.530119] Call Trace:
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125e95b>]
schedule_preempt_disabled+0x9/0xb
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125db87>]
__mutex_lock_common.clone.5+0x11d/0x17e
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125dbf6>]
__mutex_lock_slowpath+0xe/0x10
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125d988>] mutex_lock+0x16/0x27
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c0cf7>] do_last+0x195/0x573
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c17c3>] path_openat+0xcb/0x319
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c1aff>] do_filp_open+0x38/0x84
Jun 26 22:27:30 [368353.530119]  [<ffffffff810cb079>] ? alloc_fd+0x6f/0xfe
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b54bf>] do_sys_open+0x70/0x102
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b556d>] sys_open+0x1c/0x1e
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:30 [368353.530119] munin-update    D 0000000000000002
0  7238   7235 0x00000000
Jun 26 22:27:30 [368353.530119]  ffff88002c7fbbe8 0000000000000082
ffff88002c7fbbd8 ffff88010dd1d940
Jun 26 22:27:30 [368353.530119]  0000000000000002 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:30 [368353.530119]  ffff88010b2d0000 00000000000107c0
ffff88002c7fbfd8 ffff88002c7fbfd8
Jun 26 22:27:30 [368353.530119] Call Trace:
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125e95b>]
schedule_preempt_disabled+0x9/0xb
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125db87>]
__mutex_lock_common.clone.5+0x11d/0x17e
Jun 26 22:27:30 [368353.530119]  [<ffffffff810858d0>] ?
filemap_fault+0x1ee/0x34f
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125dbf6>]
__mutex_lock_slowpath+0xe/0x10
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125d988>] mutex_lock+0x16/0x27
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0105b7c>]
xfs_rw_ilock+0x21/0x33 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0106715>]
xfs_file_buffered_aio_write+0x4d/0x110 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0106934>]
xfs_file_aio_write+0x15c/0x1b0 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b5826>] do_sync_write+0xc9/0x106
Jun 26 22:27:30 [368353.530119]  [<ffffffff8109b5a5>] ?
handle_mm_fault+0xe1/0xf6
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b5f3b>] vfs_write+0xa7/0xfa
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b6133>] sys_write+0x45/0x69
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:30 [368353.530119] ping.py         D ffff88010b2d3fc0
0  7248   7247 0x00000000
Jun 26 22:27:30 [368353.530119]  ffff880035cf1288 0000000000000082
0000000000000010 ffff88010dd1f2c0
Jun 26 22:27:30 [368353.530119]  0000000000000000 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:30 [368353.530119]  ffff88010b2d3fc0 00000000000107c0
ffff880035cf1fd8 ffff880035cf1fd8
Jun 26 22:27:30 [368353.530119] Call Trace:
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:30 [368353.530119]  [<ffffffffa00b38ff>]
get_active_stripe+0x256/0x564 [raid456]
Jun 26 22:27:30 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:30 [368353.530119]  [<ffffffffa00b5976>]
make_request+0x1dd/0x3bc [raid456]
Jun 26 22:27:30 [368353.530119]  [<ffffffff8103ffc0>] ? wake_up_bit+0x25/0x25
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0069ef1>]
md_make_request+0xd0/0x1c2 [md_mod]
Jun 26 22:27:30 [368353.530119]  [<ffffffff811c6b93>] ? dm_request+0x1b4/0x1c3
Jun 26 22:27:30 [368353.530119]  [<ffffffff81119ad1>]
generic_make_request+0x97/0xd9
Jun 26 22:27:30 [368353.530119]  [<ffffffff81119bee>] submit_bio+0xdb/0xfa
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0102e32>]
_xfs_buf_ioapply+0x157/0x182 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0103f86>]
xfs_buf_iorequest+0x31/0x4a [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01420b1>]
xlog_bdstrat+0x3c/0x42 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0142b4b>]
xlog_sync+0x1ea/0x2de [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0143583>]
xlog_state_release_iclog+0x8f/0x94 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0143fe5>]
_xfs_log_force+0xef/0x1be [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01440c7>]
xfs_log_force+0x13/0x36 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0103960>]
xfs_buf_trylock+0x40/0x48 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0103a4c>]
_xfs_buf_find+0xa9/0x1d6 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0103d0d>]
xfs_buf_get+0x25/0x13b [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01476ae>]
xfs_trans_get_buf+0x9b/0xc3 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff81049200>] ?
try_to_wake_up+0x1ae/0x1ae
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0134403>]
xfs_ialloc_inode_init+0xd1/0x18b [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0134a13>]
xfs_ialloc_ag_alloc+0x2ef/0x446 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0134bd1>] ?
xfs_read_agi+0x67/0xe1 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0117c29>] ?
__xfs_alloc_vextent+0x388/0x388 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa013571c>]
xfs_dialloc+0x123/0x75a [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0137096>]
xfs_ialloc+0x53/0x4e2 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01427db>] ?
xlog_grant_head_check+0x4b/0xbc [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01119b8>]
xfs_dir_ialloc+0x6c/0x238 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01136bb>]
xfs_create+0x2b6/0x4a6 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c5fe9>] ? __d_rehash+0x1e/0x54
Jun 26 22:27:30 [368353.530119]  [<ffffffffa010bf55>]
xfs_vn_mknod+0xd1/0x153 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa010bff8>]
xfs_vn_create+0xe/0x10 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c05a5>] vfs_create+0x52/0x72
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c0d82>] do_last+0x220/0x573
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c17c3>] path_openat+0xcb/0x319
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c1aff>] do_filp_open+0x38/0x84
Jun 26 22:27:30 [368353.530119]  [<ffffffff810cb079>] ? alloc_fd+0x6f/0xfe
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b54bf>] do_sys_open+0x70/0x102
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b556d>] sys_open+0x1c/0x1e
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
Jun 26 22:27:30 [368353.530119] cleanup         D ffff88010b2d1320
0  7250   7286 0x00000000
Jun 26 22:27:30 [368353.530119]  ffff88003779f658 0000000000000086
01ff880113c107c0 ffffffff81359020
Jun 26 22:27:30 [368353.530119]  ffff880113d0d450 00000000000107c0
00000000000107c0 00000000000107c0
Jun 26 22:27:30 [368353.530119]  ffff88010b2d1320 00000000000107c0
ffff88003779ffd8 ffff88003779ffd8
Jun 26 22:27:30 [368353.530119] Call Trace:
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125e7be>] schedule+0x5f/0x61
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125d686>] schedule_timeout+0x22/0xd5
Jun 26 22:27:30 [368353.530119]  [<ffffffff8104c1f7>] ?
update_group_power+0xd5/0x134
Jun 26 22:27:30 [368353.530119]  [<ffffffff8112df54>] ?
cpumask_next_and+0x2c/0x39
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125defb>] __down_common+0x90/0xe5
Jun 26 22:27:30 [368353.530119]  [<ffffffff810afc43>] ? signal_pending+0x12/0x1c
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125dfaf>] __down+0x18/0x1a
Jun 26 22:27:30 [368353.530119]  [<ffffffff81043ef9>] down+0x28/0x38
Jun 26 22:27:30 [368353.530119]  [<ffffffffa010399f>]
xfs_buf_lock+0x37/0x3b [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0103b1b>]
_xfs_buf_find+0x178/0x1d6 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0103d0d>]
xfs_buf_get+0x25/0x13b [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0104019>]
xfs_buf_read+0x13/0x80 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01478b9>]
xfs_trans_read_buf+0x181/0x248 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0134bd1>]
xfs_read_agi+0x67/0xe1 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0134c64>]
xfs_ialloc_read_agi+0x19/0x66 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0135564>]
xfs_ialloc_ag_select+0x16d/0x202 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa013563c>]
xfs_dialloc+0x43/0x75a [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff8104b47e>] ?
select_task_rq_fair+0x320/0x5ab
Jun 26 22:27:30 [368353.530119]  [<ffffffff810840d2>] ? unlock_page+0x25/0x2a
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125f132>] ?
_raw_read_unlock_bh+0x12/0x14
Jun 26 22:27:30 [368353.530119]  [<ffffffffa0137096>]
xfs_ialloc+0x53/0x4e2 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01427db>] ?
xlog_grant_head_check+0x4b/0xbc [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01119b8>]
xfs_dir_ialloc+0x6c/0x238 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa01136bb>]
xfs_create+0x2b6/0x4a6 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c5fe9>] ? __d_rehash+0x1e/0x54
Jun 26 22:27:30 [368353.530119]  [<ffffffffa010bf55>]
xfs_vn_mknod+0xd1/0x153 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffffa010bff8>]
xfs_vn_create+0xe/0x10 [xfs]
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c05a5>] vfs_create+0x52/0x72
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c0d82>] do_last+0x220/0x573
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c17c3>] path_openat+0xcb/0x319
Jun 26 22:27:30 [368353.530119]  [<ffffffff810c1aff>] do_filp_open+0x38/0x84
Jun 26 22:27:30 [368353.530119]  [<ffffffff810cb079>] ? alloc_fd+0x6f/0xfe
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b54bf>] do_sys_open+0x70/0x102
Jun 26 22:27:30 [368353.530119]  [<ffffffff810b556d>] sys_open+0x1c/0x1e
Jun 26 22:27:30 [368353.530119]  [<ffffffff8125fa22>]
system_call_fastpath+0x16/0x1b
