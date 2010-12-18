From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: Kernel panic with mdadm 3.1.4 on Ubuntu Lucid 64-bit
Date: Sat, 18 Dec 2010 15:14:25 -0700
Message-ID: <AANLkTi=oUmkbxfziccDGqe=ErgUSsXM-AG_WAbVWcO5W@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I am seeing an occassional kernel panic when running "mdadm -S
/dev/md0" to stop a RAID 5 array that is syncing. The
/var/log/messages snip-it is below. My system is a VMware Ubuntu 10.04
(Lucid) 64-bit VM, with mdadm 3.1.4 instead of the stock version in
Ubuntu. I have no additional mdadm nor kernel patches.

I have 11 virtual hard drives in my VM, and I am using 9 as active
drives and 2 as spares. Chunk size is 64K.

The issue is tough to duplicate but if I create the md array, and then
mdadm -S it, and then recreate it again, and do this sequence in rapid
succession, I can sometimes make this kernel panic happen.

Dec 18 14:08:33 localhost kernel: [ 1077.948456] mdadm         D
0000000000000000     0 12873  12872 0x00000000
Dec 18 14:08:33 localhost kernel: [ 1077.948463]  ffff880052201a68
0000000000000082 0000000000015bc0 0000000000015bc0
Dec 18 14:08:33 localhost kernel: [ 1077.948469]  ffff8800418a1a98
ffff880052201fd8 0000000000015bc0 ffff8800418a16e0
Dec 18 14:08:33 localhost kernel: [ 1077.948473]  0000000000015bc0
ffff880052201fd8 0000000000015bc0 ffff8800418a1a98
Dec 18 14:08:33 localhost kernel: [ 1077.948478] Call Trace:
Dec 18 14:08:33 localhost kernel: [ 1077.948504]  [<ffffffff81558a7d>]
schedule_timeout+0x22d/0x300
Dec 18 14:08:33 localhost kernel: [ 1077.948510]  [<ffffffff81557d26>]
wait_for_common+0xd6/0x180
Dec 18 14:08:33 localhost kernel: [ 1077.948518]  [<ffffffff8115c3c8>]
? ifind_fast+0x58/0xb0
Dec 18 14:08:33 localhost kernel: [ 1077.948529]  [<ffffffff81059a60>]
? default_wake_function+0x0/0x20
Dec 18 14:08:33 localhost kernel: [ 1077.948542]  [<ffffffff811ae899>]
? sysfs_drop_dentry+0x139/0x160
Dec 18 14:08:33 localhost kernel: [ 1077.948548]  [<ffffffff81557e8d>]
wait_for_completion+0x1d/0x20
Dec 18 14:08:33 localhost kernel: [ 1077.948553]  [<ffffffff811af3b8>]
sysfs_addrm_finish+0x118/0x150
Dec 18 14:08:33 localhost kernel: [ 1077.948578]  [<ffffffff811accbb>]
sysfs_hash_and_remove+0x5b/0x80
Dec 18 14:08:33 localhost kernel: [ 1077.948583]  [<ffffffff811b0c8f>]
sysfs_remove_group+0x5f/0x100
Dec 18 14:08:33 localhost kernel: [ 1077.948596]  [<ffffffffa0425c31>]
stop+0x61/0x80 [raid456]
Dec 18 14:08:33 localhost kernel: [ 1077.948607]  [<ffffffff8142cabd>]
do_md_stop+0xdd/0x560
Dec 18 14:08:33 localhost kernel: [ 1077.948620]  [<ffffffff81284b51>]
? apparmor_capable+0x31/0xa0
Dec 18 14:08:33 localhost kernel: [ 1077.948626]  [<ffffffff8142f694>]
md_ioctl+0x514/0x7f0
Dec 18 14:08:33 localhost kernel: [ 1077.948630]  [<ffffffff81059a72>]
? default_wake_function+0x12/0x20
Dec 18 14:08:33 localhost kernel: [ 1077.948636]  [<ffffffff810f34be>]
? find_get_page+0x1e/0xa0
Dec 18 14:08:33 localhost kernel: [ 1077.948640]  [<ffffffff810f4ecb>]
? filemap_fault+0x8b/0x450
Dec 18 14:08:33 localhost kernel: [ 1077.948646]  [<ffffffff8113cb5d>]
? mem_cgroup_update_mapped_file_stat+0x2d/0x90
Dec 18 14:08:33 localhost kernel: [ 1077.948652]  [<ffffffff812a56b7>]
__blkdev_driver_ioctl+0x27/0x80
Dec 18 14:08:33 localhost kernel: [ 1077.948656]  [<ffffffff812a5b8d>]
blkdev_ioctl+0x1ed/0x6f0
Dec 18 14:08:33 localhost kernel: [ 1077.948661]  [<ffffffff81172ffc>]
block_ioctl+0x3c/0x40
Dec 18 14:08:33 localhost kernel: [ 1077.948667]  [<ffffffff81153d42>]
vfs_ioctl+0x22/0xa0
Dec 18 14:08:33 localhost kernel: [ 1077.948671]  [<ffffffff81153ee1>]
do_vfs_ioctl+0x81/0x410
Dec 18 14:08:33 localhost kernel: [ 1077.948676]  [<ffffffff8155d273>]
? do_page_fault+0x153/0x3b0
Dec 18 14:08:33 localhost kernel: [ 1077.948680]  [<ffffffff811542f1>]
sys_ioctl+0x81/0xa0
Dec 18 14:08:33 localhost kernel: [ 1077.948687]  [<ffffffff810121b2>]
system_call_fastpath+0x16/0x1b


Thank you in advance for any guidance!
-Tommy
