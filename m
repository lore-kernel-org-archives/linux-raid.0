From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: raid5 lockups post ca64cae96037de16e4af92678814f5d4bf0c1c65
Date: Mon, 04 Mar 2013 14:50:54 +0100
Message-ID: <wrfj1ubvi88x.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hi,

I have been hitting raid5 lockups with recent kernels. A bunch of
bisecting narrowed it down to be caused by this commit:

ca64cae96037de16e4af92678814f5d4bf0c1c65

So far I can only reproduce the problem when running a test script
creating raid5 arrays on top of loop devices and then running mkfs on
those. I haven't managed to reproduce it on real disk devices yet, but I
suspect it is possible too.

Basically it looks like a race condition where R5_LOCKED doesn't get
cleared for the device, however it is unclear to me how we get to that
point. Since I am not really deeply familiar with the discard related
changes, I figured someone might have a better idea what could go wrong.

Cheers,
Jes



[ 4799.312280] sector=97f8 i=1           (null)           (null)           (null) ffff88022f5963c0 0
[ 4799.322174] ------------[ cut here ]------------
[ 4799.327330] WARNING: at drivers/md/raid5.c:352 init_stripe+0x2d2/0x360 [raid456]()
[ 4799.335775] Hardware name: S1200BTL
[ 4799.339668] Modules linked in: raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx lockd sunrpc bnep bluetooth rfkill sg coretemp e1000e raid1 dm_mirror kvm_intel kvm crc32c_intel iTCO_wdt iTCO_vendor_support dm_region_hash ghash_clmulni_intel lpc_ich dm_log dm_mod mfd_core i2c_i801 video pcspkr microcode uinput xfs usb_storage mgag200 i2c_algo_bit drm_kms_helper ttm drm i2c_core mpt2sas raid_class scsi_transport_sas [last unloaded: raid456]
[ 4799.386633] Pid: 8204, comm: mkfs.ext4 Not tainted 3.7.0-rc1+ #17
[ 4799.393431] Call Trace:
[ 4799.396163]  [<ffffffff810602ff>] warn_slowpath_common+0x7f/0xc0
[ 4799.402868]  [<ffffffff8106035a>] warn_slowpath_null+0x1a/0x20
[ 4799.409375]  [<ffffffffa0423b92>] init_stripe+0x2d2/0x360 [raid456]
[ 4799.416368]  [<ffffffffa042400b>] get_active_stripe+0x3eb/0x480 [raid456]
[ 4799.423944]  [<ffffffffa0427beb>] make_request+0x3eb/0x6b0 [raid456]
[ 4799.431037]  [<ffffffff81084210>] ? wake_up_bit+0x40/0x40
[ 4799.437062]  [<ffffffff814a6633>] md_make_request+0xc3/0x200
[ 4799.443379]  [<ffffffff81134655>] ? mempool_alloc_slab+0x15/0x20
[ 4799.450082]  [<ffffffff812c70d2>] generic_make_request+0xc2/0x110
[ 4799.456881]  [<ffffffff812c7199>] submit_bio+0x79/0x160
[ 4799.462714]  [<ffffffff811ca625>] ? bio_alloc_bioset+0x65/0x120
[ 4799.469321]  [<ffffffff812ce234>] blkdev_issue_discard+0x184/0x240
[ 4799.476218]  [<ffffffff812cef76>] blkdev_ioctl+0x3b6/0x810
[ 4799.482338]  [<ffffffff811cb971>] block_ioctl+0x41/0x50
[ 4799.488170]  [<ffffffff811a6aa9>] do_vfs_ioctl+0x99/0x580
[ 4799.494185]  [<ffffffff8128a19a>] ? inode_has_perm.isra.30.constprop.60+0x2a/0x30
[ 4799.502535]  [<ffffffff8128b6d7>] ? file_has_perm+0x97/0xb0
[ 4799.508755]  [<ffffffff811a7021>] sys_ioctl+0x91/0xb0
[ 4799.514384]  [<ffffffff810de9dc>] ? __audit_syscall_exit+0x3ec/0x450
[ 4799.521475]  [<ffffffff8161e759>] system_call_fastpath+0x16/0x1b
[ 4799.528177] ---[ end trace 583fffce97b9ddd9 ]---
[ 4799.533327] sector=97f8 i=0           (null)           (null)           (null) ffff88022f5963c0 0
[ 4799.543227] ------------[ cut here ]------------
