From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: xfs and raid5 - "Structure needs cleaning for directory open"
Date: Sun, 9 May 2010 20:48:00 +0200
Message-ID: <1816344475.20100509204800@kaneda.iguw.tuwien.ac.at>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


today in the morning some daemon processes terminated because of
errors in the xfs file system on top of a software raid5, consisting
of 4*1.5TB WD caviar green SATA disks.

current OS is centos 5.4, kernel is:
Linux alfred 2.6.18-164.15.1.el5xen #1 SMP Wed Mar 17 12:04:23 EDT 2010=
 x86_64 x86_64 x86_64 GNU/Linux

the history: this raid was originally created on an ASUS M2N-X plus
mainboard with all 4 drives connected to the on-board controller.
(centos 5.4, current i386 kernel). it
worked fine first, but after some months problems occured when copying
files via SMB, in these situations dmesg showed a stack trace,
starting with an interrupt problem deep in the kernel and reaching up
to the xfs filesystem code.

a few months ago the weekly raid check
(/etc/cron.weekly/99-raid-check) started a re-sync of the raid which
(on the M2N-X board) took about 2.5 to 3 days to complete.

to overcome the interrupt problems, I recently bought an intel D510
atom mainboard and a "Promise Technology, Inc. PDC40718 (SATA 300 TX4)
(rev 02))" sata controller, reinstalled centos 5.4 from scratch
(x86_64 version) and attached the 4 sata disks which worked fine until
this sunday night the 99-raid-check started again at 4:00 in the
morning and lasted until just now (19:00 o'clock).

around 12:00 noon (resync at about 50%) I noticed the first problems,
namely "Structure needs cleaning for directory open" messages. at this
time, a "du -sh *" revealed that around 50% of the data stored on the
xfs was lost (due to directories that couldn't be read because of the
"needs cleaning ..." error. a daring xfs_repair on the unmounted, but
still syncing filesystem revealed & fixed no errors (see output
below).

after painfully waiting 7 hours for the resync to complete, it looks
like the filesystem is OK and back to normal again: du shows the
expected 3.5TB usage, there are no more "needs cleaning ..." errors
and a quick check into the previously lost directories seems to show
that the files contained within seem to be OK.

I wonder what caused this behaviour (and how to prevent it in the
future):

1) damages done to the xfs filesystem on the old board? shouldn't
xfs_repair find & repair them?
2) does a re-syncing raid deliver bad/corrupt data to the filesystem
layer above?
3) may this be a hardware/memory problem since xfs reports "Corruption
of in-memory data detected". ?
4) is the Promise SATA controller to blame ?

here's some output that may help. please let me know if you need more:

*** this is where it started:

May  9 04:22:01 alfred kernel: md: syncing RAID array md0
May  9 04:22:01 alfred kernel: md: minimum _guaranteed_ reconstruction =
speed: 1000 KB/sec/disc.
May  9 04:22:01 alfred kernel: md: using maximum available idle IO band=
width (but not more than 200000 KB/sec) for reconstructio
n.
May  9 04:22:01 alfred kernel: md: using 128k window, over a total of 1=
465135936 blocks.
May  9 04:24:06 alfred kernel: XFS internal error XFS_WANT_CORRUPTED_GO=
TO at line 4565 of file fs/xfs/xfs_bmap.c.  Caller 0xffff
ffff8835dba8
May  9 04:24:06 alfred kernel:
May  9 04:24:06 alfred kernel: Call Trace:
May  9 04:24:06 alfred kernel:  [<ffffffff8833f15e>] :xfs:xfs_bmap_read=
_extents+0x361/0x384
May  9 04:24:06 alfred kernel:  [<ffffffff8835dba8>] :xfs:xfs_iread_ext=
ents+0xac/0xc8
May  9 04:24:06 alfred kernel:  [<ffffffff883448c3>] :xfs:xfs_bmapi+0x2=
26/0xe79
May  9 04:24:06 alfred kernel:  [<ffffffff8021c4c6>] generic_make_reque=
st+0x211/0x228
May  9 04:24:06 alfred kernel:  [<ffffffff882edd2e>] :raid456:handle_st=
ripe+0x20a6/0x21ff
May  9 04:24:06 alfred kernel:  [<ffffffff88361a2b>] :xfs:xfs_iomap+0x1=
44/0x2a5
May  9 04:24:06 alfred kernel:  [<ffffffff88376c38>] :xfs:__xfs_get_blo=
cks+0x7a/0x1bf
May  9 04:24:06 alfred kernel:  [<ffffffff882eebdb>] :raid456:make_requ=
est+0x4ba/0x4f4
May  9 04:24:06 alfred kernel:  [<ffffffff8029bfc3>] autoremove_wake_fu=
nction+0x0/0x2e
May  9 04:24:06 alfred kernel:  [<ffffffff80228a95>] do_mpage_readpage+=
0x167/0x474
May  9 04:24:06 alfred kernel:  [<ffffffff88376d8e>] :xfs:xfs_get_block=
s+0x0/0xe
May  9 04:24:06 alfred kernel:  [<ffffffff88376d8e>] :xfs:xfs_get_block=
s+0x0/0xe
May  9 04:24:06 alfred kernel:  [<ffffffff8020cc70>] add_to_page_cache+=
0xb9/0xc5
May  9 04:24:06 alfred kernel:  [<ffffffff88376d8e>] :xfs:xfs_get_block=
s+0x0/0xe
May  9 04:24:06 alfred kernel:  [<ffffffff8023a3d8>] mpage_readpages+0x=
91/0xd9
May  9 04:24:06 alfred kernel:  [<ffffffff88376d8e>] :xfs:xfs_get_block=
s+0x0/0xe
May  9 04:24:06 alfred kernel:  [<ffffffff8020f66f>] __alloc_pages+0x65=
/0x2ce
May  9 04:24:06 alfred kernel:  [<ffffffff802137d1>] __do_page_cache_re=
adahead+0x130/0x1ab
May  9 04:24:06 alfred kernel:  [<ffffffff802336c8>] blockable_page_cac=
he_readahead+0x53/0xb2
May  9 04:24:06 alfred kernel:  [<ffffffff802147a4>] page_cache_readahe=
ad+0xd6/0x1af
May  9 04:24:06 alfred kernel:  [<ffffffff8020c6d7>] do_generic_mapping=
_read+0xc6/0x38a
May  9 04:24:06 alfred kernel:  [<ffffffff8020d693>] file_read_actor+0x=
0/0x101
May  9 04:24:06 alfred kernel:  [<ffffffff8020cae7>] __generic_file_aio=
_read+0x14c/0x198
May  9 04:24:06 alfred kernel:  [<ffffffff8837d7de>] :xfs:xfs_read+0x18=
7/0x209
May  9 04:24:06 alfred kernel:  [<ffffffff8837a4d8>] :xfs:xfs_file_aio_=
read+0x63/0x6b
May  9 04:24:06 alfred kernel:  [<ffffffff8020d3d2>] do_sync_read+0xc7/=
0x104
May  9 04:24:06 alfred kernel:  [<ffffffff8021ecec>] __dentry_open+0x10=
1/0x1dc
May  9 04:24:06 alfred kernel:  [<ffffffff8029bfc3>] autoremove_wake_fu=
nction+0x0/0x2e
May  9 04:24:06 alfred kernel:  [<ffffffff80227a40>] do_filp_open+0x2a/=
0x38
May  9 04:24:06 alfred kernel:  [<ffffffff8020bbaf>] vfs_read+0xcb/0x17=
1
May  9 04:24:06 alfred kernel:  [<ffffffff80212495>] sys_read+0x45/0x6e
May  9 04:24:06 alfred kernel:  [<ffffffff8026168d>] ia32_sysret+0x0/0x=
5
May  9 04:24:06 alfred kernel:
May  9 04:24:06 alfred kernel: XFS internal error XFS_WANT_CORRUPTED_GO=
TO at line 4565 of file fs/xfs/xfs_bmap.c.  Caller 0xffff
ffff8835dba8
*** (many, many more)

May  9 06:19:16 alfred kernel: Filesystem "md0": corrupt dinode 1610637=
790, (btree extents).  Unmount and run xfs_repair.
May  9 06:19:16 alfred kernel: Filesystem "md0": XFS internal error xfs=
_bmap_read_extents(1) at line 4560 of file fs/xfs/xfs_bma
p.c.  Caller 0xffffffff8835dba8
May  9 06:19:16 alfred kernel:
May  9 06:19:16 alfred kernel: Call Trace:
May  9 06:19:16 alfred kernel:  [<ffffffff8833f15e>] :xfs:xfs_bmap_read=
_extents+0x361/0x384
May  9 06:19:16 alfred kernel:  [<ffffffff8835dba8>] :xfs:xfs_iread_ext=
ents+0xac/0xc8
May  9 06:19:16 alfred kernel:  [<ffffffff883448c3>] :xfs:xfs_bmapi+0x2=
26/0xe79
May  9 06:19:16 alfred kernel:  [<ffffffff8866ac47>] :ip_conntrack:tcp_=
pkt_to_tuple+0x0/0x61
May  9 06:19:16 alfred kernel:  [<ffffffff8866883d>] :ip_conntrack:__ip=
_conntrack_find+0xd/0xb7
May  9 06:19:16 alfred kernel:  [<ffffffff8023f750>] lock_timer_base+0x=
1b/0x3c
May  9 06:19:16 alfred kernel:  [<ffffffff8021ce99>] __mod_timer+0xb0/0=
xbe
May  9 06:19:16 alfred kernel:  [<ffffffff88668e71>] :ip_conntrack:__ip=
_ct_refresh_acct+0x10f/0x152
May  9 06:19:16 alfred kernel:  [<ffffffff8866b8a8>] :ip_conntrack:tcp_=
packet+0xa5f/0xa9f
May  9 06:19:16 alfred kernel:  [<ffffffff88361a2b>] :xfs:xfs_iomap+0x1=
44/0x2a5
May  9 06:19:16 alfred kernel:  [<ffffffff88376c38>] :xfs:__xfs_get_blo=
cks+0x7a/0x1bf
May  9 06:19:16 alfred kernel:  [<ffffffff802235ae>] alloc_buffer_head+=
0x31/0x36
May  9 06:19:16 alfred kernel:  [<ffffffff8022fa7a>] alloc_page_buffers=
+0x81/0xd3
May  9 06:19:16 alfred kernel:  [<ffffffff8020ea95>] __block_prepare_wr=
ite+0x1ad/0x375
May  9 06:19:16 alfred kernel:  [<ffffffff88376d8e>] :xfs:xfs_get_block=
s+0x0/0xe
May  9 06:19:16 alfred kernel:  [<ffffffff802bda81>] add_to_page_cache_=
lru+0x1c/0x22
May  9 06:19:16 alfred kernel:  [<ffffffff802d3456>] block_write_begin+=
0x80/0xcf
May  9 06:19:16 alfred kernel:  [<ffffffff8837637d>] :xfs:xfs_vm_write_=
begin+0x19/0x1e
May  9 06:19:16 alfred kernel:  [<ffffffff88376d8e>] :xfs:xfs_get_block=
s+0x0/0xe
May  9 06:19:16 alfred kernel:  [<ffffffff8021072e>] generic_file_buffe=
red_write+0x14b/0x60c
May  9 06:19:16 alfred kernel:  [<ffffffff80209e60>] __d_lookup+0xb0/0x=
ff
May  9 06:19:16 alfred kernel:  [<ffffffff80264931>] _spin_lock_irqsave=
+0x9/0x14
May  9 06:19:16 alfred kernel:  [<ffffffff8837dcfe>] :xfs:xfs_write+0x4=
9e/0x69e
May  9 06:19:16 alfred kernel:  [<ffffffff8022d090>] mntput_no_expire+0=
x19/0x89
May  9 06:19:16 alfred kernel:  [<ffffffff8020edf0>] link_path_walk+0xa=
6/0xb2
May  9 06:19:16 alfred kernel:  [<ffffffff8837a470>] :xfs:xfs_file_aio_=
write+0x65/0x6a
May  9 06:19:16 alfred kernel:  [<ffffffff802185e8>] do_sync_write+0xc7=
/0x104
May  9 06:19:16 alfred kernel:  [<ffffffff8021ecec>] __dentry_open+0x10=
1/0x1dc
May  9 06:19:16 alfred kernel:  [<ffffffff8029bfc3>] autoremove_wake_fu=
nction+0x0/0x2e
May  9 06:19:16 alfred kernel:  [<ffffffff80227a40>] do_filp_open+0x2a/=
0x38
May  9 06:19:16 alfred kernel:  [<ffffffff802171aa>] vfs_write+0xce/0x1=
74
May  9 06:19:16 alfred kernel:  [<ffffffff802179e2>] sys_write+0x45/0x6=
e
May  9 06:19:16 alfred kernel:  [<ffffffff8026168d>] ia32_sysret+0x0/0x=
5
*** also many, many more, always the same dinode

May  9 12:53:32 alfred kernel: Filesystem "md0": XFS internal error xfs=
_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.
c.  Caller 0xffffffff88358eb7
May  9 12:53:32 alfred kernel:
May  9 12:53:32 alfred kernel: Call Trace:
May  9 12:53:32 alfred kernel:  [<ffffffff88349bee>] :xfs:xfs_btree_che=
ck_sblock+0xaf/0xbe
May  9 12:53:32 alfred kernel:  [<ffffffff88358eb7>] :xfs:xfs_inobt_inc=
rement+0x156/0x17e
May  9 12:53:32 alfred kernel:  [<ffffffff88358920>] :xfs:xfs_dialloc+0=
x4d0/0x80c
May  9 12:53:32 alfred kernel:  [<ffffffff802260ff>] find_or_create_pag=
e+0x3f/0xab
May  9 12:53:32 alfred kernel:  [<ffffffff8835eafc>] :xfs:xfs_ialloc+0x=
5f/0x57f
May  9 12:53:32 alfred kernel:  [<ffffffff8805c02a>] :ext3:ext3_get_acl=
+0x63/0x310
May  9 12:53:32 alfred kernel:  [<ffffffff8020b242>] kmem_cache_alloc+0=
x62/0x6d
May  9 12:53:32 alfred kernel:  [<ffffffff88370b23>] :xfs:xfs_dir_iallo=
c+0x86/0x2b7
May  9 12:53:32 alfred kernel:  [<ffffffff883654c0>] :xfs:xlog_grant_lo=
g_space+0x204/0x25c
May  9 12:53:32 alfred kernel:  [<ffffffff883735f8>] :xfs:xfs_create+0x=
237/0x45c
May  9 12:53:32 alfred kernel:  [<ffffffff88338d47>] :xfs:xfs_attr_get+=
0x8e/0x9f
May  9 12:53:32 alfred kernel:  [<ffffffff8837cd38>] :xfs:xfs_vn_mknod+=
0x144/0x215
May  9 12:53:32 alfred kernel:  [<ffffffff8023bdcb>] vfs_create+0xe6/0x=
158
May  9 12:53:32 alfred kernel:  [<ffffffff8021b38f>] open_namei+0x1a1/0=
x6ed
May  9 12:53:32 alfred kernel:  [<ffffffff80227a32>] do_filp_open+0x1c/=
0x38
May  9 12:53:32 alfred kernel:  [<ffffffff8021a1a0>] do_sys_open+0x44/0=
xbe
May  9 12:53:32 alfred kernel:  [<ffffffff8026168d>] ia32_sysret+0x0/0x=
5
May  9 12:53:32 alfred kernel:
*** also many, many more

May  9 13:44:35 alfred kernel: 00000000: ff ff ff ff ff ff ff ff 00 00 =
00 00 00 00 00 00  =FF=FF=FF=FF=FF=FF=FF=FF........
May  9 13:44:35 alfred kernel: Filesystem "md0": XFS internal error xfs=
_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c.
  Caller 0xffffffff8834b82e
May  9 13:44:35 alfred kernel:
May  9 13:44:35 alfred kernel: Call Trace:
May  9 13:44:35 alfred kernel:  [<ffffffff8834b72d>] :xfs:xfs_da_do_buf=
+0x503/0x5b1
May  9 13:44:35 alfred kernel:  [<ffffffff8834b82e>] :xfs:xfs_da_read_b=
uf+0x16/0x1b
May  9 13:44:35 alfred kernel:  [<ffffffff8020cb6c>] _atomic_dec_and_lo=
ck+0x39/0x57
May  9 13:44:35 alfred kernel:  [<ffffffff8834b82e>] :xfs:xfs_da_read_b=
uf+0x16/0x1b
May  9 13:44:35 alfred kernel:  [<ffffffff88350b0c>] :xfs:xfs_dir2_leaf=
_getdents+0x354/0x5ec
May  9 13:44:35 alfred kernel:  [<ffffffff88350b0c>] :xfs:xfs_dir2_leaf=
_getdents+0x354/0x5ec
May  9 13:44:35 alfred kernel:  [<ffffffff88379c6c>] :xfs:xfs_hack_fill=
dir+0x0/0x5b
May  9 13:44:35 alfred kernel:  [<ffffffff88379c6c>] :xfs:xfs_hack_fill=
dir+0x0/0x5b
May  9 13:44:35 alfred kernel:  [<ffffffff8834d868>] :xfs:xfs_readdir+0=
xa7/0xb6
May  9 13:44:35 alfred kernel:  [<ffffffff8837a301>] :xfs:xfs_file_read=
dir+0xff/0x14c
May  9 13:44:35 alfred kernel:  [<ffffffff80225d93>] filldir+0x0/0xb7
May  9 13:44:35 alfred kernel:  [<ffffffff80225d93>] filldir+0x0/0xb7
May  9 13:44:35 alfred kernel:  [<ffffffff802366f7>] vfs_readdir+0x77/0=
xa9
May  9 13:44:35 alfred kernel:  [<ffffffff80239f2a>] sys_getdents+0x75/=
0xbd
May  9 13:44:35 alfred kernel:  [<ffffffff80260295>] tracesys+0x47/0xb6
May  9 13:44:35 alfred kernel:  [<ffffffff802602f9>] tracesys+0xab/0xb6
May  9 13:44:35 alfred kernel:
May  9 13:51:24 alfred kernel: Filesystem "md0": Disabling barriers, tr=
ial barrier write failed
May  9 13:51:24 alfred kernel: XFS mounting filesystem md0

*** these xfs_da_do_buf errors appear at a rate of about 5 per second
until 14:40 o'clock, then stop.  file system was still mounted, maybe
one daemon was still accessing it.

*** xfs_repair performed when raid was at 50% resync and filesystem was
corrupted:

[root@alfred ~]# xfs_repair /dev/md0
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
[...]
        - agno =3D 62
        - agno =3D 63
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
[...]
        - agno =3D 61
        - agno =3D 62
        - agno =3D 63
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

raid output after sync was finished:

[root@alfred md]# cat /sys/block/md0/md/array_state
clean
[root@alfred md]# cat /sys/block/md0/md/mismatch_cnt
0

tnx & cu

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
