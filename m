From: Ivan Vasilyev <ivan.vasilyev@gmail.com>
Subject: md raid10 Oops on recent kernels
Date: Mon, 13 Aug 2012 16:49:26 +0400
Message-ID: <CANZ+j8dDLqe=30AFd7oJ9WjhTSTRfbkXPBfBdG3GH=7eHkUqeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm using md raid over LVM on some servers (since EVMS project has
proven to be dead), but on kernel versions 3.4 and 3.5 there is a
problem with raid10.
It can be reproduced on current Debian Wheezy (set up from scratch with
7.0beta1 installer) with kernel package v3.5 taken
from experimental repository.

Array create, initial sync (after "dd ... of=/dev/md/rtest_a") and
--assemble give no errors,
but then any directIO on md device causes oops (dd without
iflag=direct does not).
Seems strange, but V4L capture by uvcvideo driver also freezes after first oops
(and resumes only after mdadm --stop on problematic array)

Recent LVM2 has built-in RAID (implemented with md driver), but
unfortunately raid10 is not supported, so it can't replace current
setup.

Is this a bug in MD driver or in some other part of the kernel? Will it affect
other raid setups in future? (like old one with raid0 layered over raid1)


------------------------------------------------------------

Tested on a KVM guest, so hardware seems to be irrelevant.
Config: 1.5Gb memory, 2 vCPUs, 5 virtio disks


*** Short summary of commands:
vgcreate gurion_vg_jnt /dev/vdb6 /dev/vdc6 /dev/vdd6 /dev/vde6
lvcreate -n rtest_a_c1r -l 129 gurion_vg_jnt /dev/vdb6
...
lvcreate -n rtest_a_c4r -l 129 guiron_vg_jnt /dev/vde6
mdadm --create /dev/md/rtest_a --verbose --metadata=1.2 \
  --level=raid10 --raid-devices=4 --name=rtest_a \
  --chunk=1024 --bitmap=internal \
  /dev/gurion_vg_jnt/rtest_a_c1r /dev/gurion_vg_jnt/rtest_a_c2r \
  /dev/gurion_vg_jnt/rtest_a_c3r /dev/gurion_vg_jnt/rtest_a_c4r


Linux version 3.5-trunk-amd64 (Debian 3.5-1~experimental.1)
(debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-1) )
#1 SMP Thu Aug 2 17:16:27 UTC 2012

ii  linux-image-3.5-trunk-amd64                  3.5-1~experimental.1
ii  mdadm                                        3.2.5-1

(oops is captured after "mdadm --assemble /dev/md/rtest_a" and then "lvs")
----------
 BUG: unable to handle kernel paging request at ffffffff00000001
 IP: [<ffffffff00000001>] 0xffffffff00000000
 PGD 160d067 PUD 0
 Oops: 0010 [#1] SMP
 CPU 0
 Modules linked in: appletalk ipx p8023 p8022 psnap llc rose netrom
ax25 iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables nfsd nfs
nfs_acl auth_rpcgss fscache lockd sunrpc loop crc32c_intel
ghash_clmulni_intel processor aesni_intel aes_x86_64 i2c_piix4
aes_generic cryptd thermal_sys button snd_pcm i2c_core snd_page_alloc
snd_timer snd soundcore psmouse pcspkr serio_raw evdev microcode
virtio_balloon ext4 crc16 jbd2 mbcache dm_mod raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor xor async_tx
raid6_pq raid1 raid0 multipath linear md_mod sr_mod cdrom ata_generic
virtio_net floppy virtio_blk ata_piix uhci_hcd ehci_hcd libata
scsi_mod virtio_pci virtio_ring virtio usbcore usb_common [last
unloaded: scsi_wait_scan]

 Pid: 11591, comm: lvs Not tainted 3.5-trunk-amd64 #1 Bochs Bochs
 RIP: 0010:[<ffffffff00000001>]  [<ffffffff00000001>] 0xffffffff00000000
 RSP: 0018:ffff88005a601a58  EFLAGS: 00010292
 RAX: 0000000000100000 RBX: ffff88005cc34c80 RCX: ffff88005d334440
 RDX: 0000000000000000 RSI: ffff88005a601a68 RDI: ffff88005b3d1c00
 RBP: 0000000000000000 R08: ffffffffa017e99c R09: 0000000000000001
 R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
 R13: ffff88005cc34d00 R14: ffffea00010d7d60 R15: 0000000000000000
 FS:  00007fd8fcef77a0(0000) GS:ffff88005f200000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffffffff00000001 CR3: 000000005f836000 CR4: 00000000000407f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process lvs (pid: 11591, threadinfo ffff88005a600000, task ffff88005f8ae040)
 Stack:
  ffff880054ad0c80 ffffffff81126dec ffff880057065900 0000000000000400
  ffffea0000000000 0000000000000000 ffff88005a601b80 ffff8800575ded40
  ffff88005a601c20 0000000000000000 0000000000000000 ffffffff811299b5
 Call Trace:
  [<ffffffff81126dec>] ? bio_alloc+0xe/0x1e
  [<ffffffff811299b5>] ? dio_bio_add_page+0x16/0x4c
  [<ffffffff81129a51>] ? dio_send_cur_page+0x66/0xa4
  [<ffffffff8112a4dc>] ? do_blockdev_direct_IO+0x8cb/0xa81
  [<ffffffff8125ed7e>] ? kobj_lookup+0xf6/0x12e
  [<ffffffff811a13c7>] ? disk_map_sector_rcu+0x5d/0x5d
  [<ffffffff811a2d9f>] ? disk_clear_events+0x3f/0xe4
  [<ffffffff8112873a>] ? blkdev_max_block+0x2b/0x2b
  [<ffffffff81128000>] ? blkdev_direct_IO+0x4e/0x53
  [<ffffffff8112873a>] ? blkdev_max_block+0x2b/0x2b
  [<ffffffff810bbf07>] ? generic_file_aio_read+0xeb/0x5b5
  [<ffffffff811103fd>] ? dput+0x26/0xf4
  [<ffffffff81115b87>] ? mntput_no_expire+0x2a/0x134
  [<ffffffff8110b3fc>] ? do_last+0x67d/0x717
  [<ffffffff810ffe44>] ? do_sync_read+0xb4/0xec
  [<ffffffff8110051e>] ? vfs_read+0x9f/0xe6
  [<ffffffff811005aa>] ? sys_read+0x45/0x6b
  [<ffffffff81364779>] ? system_call_fastpath+0x16/0x1b
 Code:  Bad RIP value.
 RIP  [<ffffffff00000001>] 0xffffffff00000000
  RSP <ffff88005a601a58>
 CR2: ffffffff00000001
 ---[ end trace b86c49ca25a6cdb2 ]---
----------
