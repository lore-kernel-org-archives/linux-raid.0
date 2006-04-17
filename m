From: "Yogesh Pahilwan" <pahilwan.yogesh@spsoftindia.com>
Subject: RAID0 with bitmap support in 2.6.15 kernel
Date: Mon, 17 Apr 2006 14:30:11 +0530
Message-ID: <200604170859.k3H8xkD1004413@mailserver.spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: 'Neil Brown' <neilb@suse.de>
List-Id: linux-raid.ids

Hi Folks,

I am creating RAID0 with bitmap support in 2.6.15 kernel.

For that I have created 10GB partition each on 4 sata disks and try to
created RAID0 over these 4 10 GB partitions and use one of the partitions on
one of the disks for keeping the bitmap file. I have use following command
for creating RAID0.

# mdadm -Cv /dev/md0 -bitmap=/root/mntbitmap/RAID0.bitmap -bitmap-chunk=2048
-l0 -n4 /dev/sd{a1,b1,c1,d1}

But after this I am getting Segmentation fault and kernel oops as shown in
dmesg.

# dmesg

[ 2419.835895] md: raid0 personality registered as nr 2
[ 2419.836176] md0: bitmap file is out of date (0 < 1) -- forcing full
recovery
[ 2419.836191] ----------- [cut here ] --------- [please bite here ]
---------
[ 2419.881887] Kernel BUG at drivers/md/bitmap.c:1592
[ 2419.913287] invalid operand: 0000 [1] SMP
[ 2419.940119] CPU 1
[ 2419.953249] Modules linked in: raid0 ipv6 parport_pc lp parport autofs4
dm_mirror button battery ac uhci_hcd ehci_hcd i2c_i801 i2c_core floppy
sd_mod ata_piix libata scsi_mod e1000 nfs lockd nfs_acl sunrpc
[ 2420.073140] Pid: 3400, comm: mdadm Not tainted 2.6.15 #2
[ 2420.107964] RIP: 0010:[<ffffffff802c4d51>]
<ffffffff802c4d51>{bitmap_create+1340}
[ 2420.155921] RSP: 0018:ffff810114e73a48  EFLAGS: 00010247
[ 2420.191887] RAX: 0000000000000000 RBX: ffff810117402c00 RCX:
0000000000000000
[ 2420.238702] RDX: 0000000000000fff RSI: 0000000000001000 RDI:
ffffffff804263a0
[ 2420.285516] RBP: ffff810114e73b28 R08: ffffffff804263b8 R09:
0000000000000000
[ 2420.332330] R10: 0000000100000000 R11: 0000000000000000 R12:
ffff810115110200
[ 2420.379143] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000200000
[ 2420.425958] FS:  00002aaaaaab4b00(0000) GS:ffffffff80528880(0000)
knlGS:0000000000000000
[ 2420.479051] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2420.516732] CR2: 0000003eb298f070 CR3: 0000000114060000 CR4:
00000000000006e0
[ 2420.563546] Process mdadm (pid: 3400, threadinfo ffff810114e72000, task
ffff81011516a880)
[ 2420.617208] Stack: 0000000000000000 0000000000000000 0000000000000000
00000000000000fc
[ 2420.668591]        0000000000000000 0000000000000000 ffff810117402c00
0000000000000000
[ 2420.721113]        0000000000000000 0000000000000005
[ 2420.754226] Call Trace:<ffffffff802bea60>{md_probe+177}
<ffffffff802bef70>{do_md_run+1035}
[ 2420.808462]        <ffffffff802be037>{bind_rdev_to_array+402}
<ffffffff802c109a>{md_ioctl+5242}
[ 2420.865551]        <ffffffff801594c6>{__pagevec_free+46}
<ffffffff80160533>{release_pages+376}
[ 2420.922072]        <ffffffff801558a7>{find_get_pages+90}
<ffffffff801eec8f>{blkdev_driver_ioctl+91}
[ 2420.981445]        <ffffffff801ef375>{blkdev_ioctl+1745}
<ffffffff801f887b>{kobject_put+25}
[ 2421.036252]        <ffffffff8017f3bf>{bdev_destroy_inode+31}
<ffffffff80190920>{destroy_inode+79}
[ 2421.094484]        <ffffffff8019206b>{generic_delete_inode+329}
<ffffffff80190f4e>{iput+124}
[ 2421.149862]        <ffffffff8017f721>{bdput+13}
<ffffffff8017fc12>{blkdev_put+411}
[ 2421.199530]        <ffffffff8018018f>{block_ioctl+27}
<ffffffff8018a65a>{do_ioctl+46}
[ 2421.250912]        <ffffffff8018a913>{vfs_ioctl+623}
<ffffffff8018a982>{sys_ioctl+93}
[ 2421.302294]        <ffffffff8010d976>{system_call+126}
[ 2421.337689]
[ 2421.337690] Code: 0f 0b 68 4c d2 37 80 c2 38 06 49 89 4c 24 38 48 8b 55
80 be
[ 2421.394779] RIP <ffffffff802c4d51>{bitmap_create+1340} RSP
<ffff810114e73a48>
[ 2421.441946]


If I have to create RAID0 with bitmap support, what kind of mdadm
configuration I will have to use?

Thanks,
Yogesh

