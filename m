From: "Janos Haar" <djani22@netcenter.hu>
Subject: kernel BUG at drivers/md/md.c:5145!
Date: Sat, 9 Feb 2008 09:46:01 +0100
Message-ID: <05cc01c86af8$357f54b0$9900a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list,

I found the issue when i do this:

1. some raid action (replace and resync 2 drives)
2. switch the md2 to readonly
3. xfsrepair -n the md2 (loop0) (everything is OK)
4. mount the md2 (loop0) with -o ro

Feb  7 03:49:34 Albohacen-global kernel: Filesystem "loop0": Disabling
barriers, not supported by the underlying device
Feb  7 03:49:34 Albohacen-global kernel: XFS mounting filesystem loop0
Feb  7 03:49:35 Albohacen-global kernel: ------------[ cut
here ]------------
Feb  7 03:49:35 Albohacen-global kernel: kernel BUG at drivers/md/md.c:5145!
Feb  7 03:49:35 Albohacen-global kernel: invalid opcode: 0000 [1] SMP
Feb  7 03:49:35 Albohacen-global kernel: CPU 0
Feb  7 03:49:35 Albohacen-global kernel: Modules linked in: usb_storage
autofs4 hidp rfcomm l2cap bluetooth sunrpc ip6t_REJECT ip6table_filter
ip6_tables ipv6
 video sbs dock button battery ac parport_pc lp parport snd_hda_intel
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_pcm_oss snd_mixe
r_oss snd_pcm snd_timer snd soundcore snd_page_alloc shpchp ehci_hcd
i2c_i801 uhci_hcd i2c_core serio_raw
Feb  7 03:49:35 Albohacen-global kernel: Pid: 257, comm: pdflush Not tainted
2.6.22.15 #1
Feb  7 03:49:35 Albohacen-global kernel: RIP: 0010:[<ffffffff806a6cdf>]
[<ffffffff806a6cdf>] md_write_start+0x22/0x108
Feb  7 03:49:35 Albohacen-global kernel: RSP: 0018:ffff81003f5b1920  EFLAGS:
00010246
Feb  7 03:49:35 Albohacen-global kernel: RAX: 0000000000000001 RBX:
ffff81003efeee20 RCX: 000000005bf57f78
Feb  7 03:49:35 Albohacen-global kernel: RDX: ffff81003dac2488 RSI:
ffff810027fe2ab0 RDI: ffff81003efeee20
Feb  7 03:49:35 Albohacen-global kernel: RBP: ffff81003f5b1970 R08:
0000000000900002 R09: 0000000000000000
Feb  7 03:49:35 Albohacen-global kernel: R10: ffff810022607d38 R11:
0000000000000010 R12: ffff810027fe2ab0
Feb  7 03:49:35 Albohacen-global kernel: R13: ffff81003ef00cc8 R14:
ffff810027fe2ab0 R15: 000000005bf57f78
Feb  7 03:49:35 Albohacen-global kernel: FS:  0000000000000000(0000)
GS:ffffffff80a74000(0000) knlGS:0000000000000000
Feb  7 03:49:35 Albohacen-global kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Feb  7 03:49:35 Albohacen-global kernel: CR2: 000000000060b9a0 CR3:
00000000339e3000 CR4: 00000000000006e0
Feb  7 03:49:35 Albohacen-global kernel: Process pdflush (pid: 257,
threadinfo ffff81003f5b0000, task ffff81003f40d840)
Feb  7 03:49:35 Albohacen-global kernel: Stack:  ffff81003e988938
0000000000000001 ffff81003f5b1940 ffffffff807609db
Feb  7 03:49:35 Albohacen-global kernel:  ffff81003f5b19f0 ffffffff8069ef1a
ffff81003e928938 ffff81003ef00cc8
Feb  7 03:49:35 Albohacen-global kernel:  ffff810027fe2ab0 ffff81003ef00cc8
ffff81003f5b1a20 ffffffff8069ea1b
Feb  7 03:49:36 Albohacen-global kernel: Call Trace:
Feb  7 03:49:36 Albohacen-global kernel: Call Trace:
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff807609db>]
_spin_unlock_irq+0x9/0xc
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff8069ef1a>]
make_request+0x55d/0x5df
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff8069ea1b>]
make_request+0x5e/0x5df
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80264eec>]
mempool_alloc_slab+0x11/0x13
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff8027e712>]
poison_obj+0x27/0x32
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80264eec>]
mempool_alloc_slab+0x11/0x13
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff8027e837>]
cache_alloc_debugcheck_after+0x11a/0x19b
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80417588>]
generic_make_request+0x293/0x2d2
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80419963>]
submit_bio+0xbc/0xc5
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff802a386d>]
submit_bh+0xed/0x111
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff802a4cc1>]
__block_write_full_page+0x1dd/0x2e3
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff802a8b19>]
blkdev_get_block+0x0/0x4d
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff802a4e79>]
block_write_full_page+0xb2/0xb6
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff8026c374>]
__dec_zone_page_state+0x1e/0x20
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff802a7c8e>]
blkdev_writepage+0x13/0x15
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80267525>]
__writepage+0x15/0x36
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80267a5a>]
write_cache_pages+0x1b9/0x30b
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80267510>]
__writepage+0x0/0x36
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80267bce>]
generic_writepages+0x22/0x28
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80267bff>]
do_writepages+0x2b/0x3a
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff8029feaf>]
__writeback_single_inode+0x1d1/0x35f
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80261151>]
delayacct_end+0x81/0x8c
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff802a0401>]
sync_sb_inodes+0x1ac/0x268
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff802a087d>]
writeback_inodes+0x99/0xf8
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80268172>]
wb_kupdate+0x9d/0x110
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff802684c1>]
pdflush+0x0/0x1f8
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff8026860b>]
pdflush+0x14a/0x1f8
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80229552>]
__wake_up_common+0x3e/0x68
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff802680d5>]
wb_kupdate+0x0/0x110
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80244c21>]
kthread+0x49/0x78
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff8020a398>]
child_rip+0xa/0x12
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff80244bd8>]
kthread+0x0/0x78
Feb  7 03:49:36 Albohacen-global kernel:  [<ffffffff8020a38e>]
child_rip+0x0/0x12
Feb  7 03:49:36 Albohacen-global kernel:
Feb  7 03:49:36 Albohacen-global kernel:
Feb  7 03:49:36 Albohacen-global kernel: Code: 0f 0b eb fe 83 f8 02 75 1c c7
47 30 00 00 00 00 90 0f ba af
Feb  7 03:49:36 Albohacen-global kernel: RIP  [<ffffffff806a6cdf>]
md_write_start+0x22/0x108
Feb  7 03:49:36 Albohacen-global kernel:  RSP <ffff81003f5b1920>

[here: mdadm --readwrite /dev/md2]

Feb  7 03:51:21 Albohacen-global kernel: md: md2 switched to read-write
mode.

[here: mount .... -o remount,rw]

Feb  7 03:52:50 Albohacen-global kernel: Filesystem "loop0": Disabling
barriers, not supported by the underlying device

The files in mount point is unacessible.

(system reboot)

No data lost. :-)

some more info:

[root@Albohacen-global log]# uname -a
Linux Albohacen-global 2.6.22.15 #1 SMP Mon Dec 24 10:15:03 CET 2007 x86_64
x86_64 x86_64 GNU/Linux

[root@Albohacen-global log]# losetup /dev/loop0
/dev/loop0: [0010]:7011 (/dev/md2), encryption blowfish (type 18)

[root@Albohacen-global log]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
[multipath] [faulty]
md1 : active raid4 sdf2[1] sde2[0] sdd2[5] sdc2[4] sdb2[3] sda2[2]
      19558720 blocks level 4, 64k chunk, algorithm 0 [6/6] [UUUUUU]
      bitmap: 2/239 pages [8KB], 8KB chunk

md2 : active raid4 sdf3[1] sde3[0] sdd3[5] sdc3[4] sdb3[3] sda3[2]
      1542761600 blocks level 4, 64k chunk, algorithm 0 [6/6] [UUUUUU]
      bitmap: 5/148 pages [20KB], 1024KB chunk

md0 : active raid1 sdb1[1] sda1[0]
      104320 blocks [2/2] [UU]

unused devices: <none>


Thanks,
Janos Haar

