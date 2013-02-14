From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: raid5 slowpath warning?
Date: Thu, 14 Feb 2013 09:09:49 +0100
Message-ID: <wrfjliarjoz6.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am seeing a slowpath warning when running some raid5 tests over loop
devices. I haven't seen it yet when using physical disk, so it may be
related to the loop driver.

This is against Linus' tree at 211b0cdc7dc574e5e756bdf1cc2f4a16b7f6e07e

Anyone else who have seen this before I dig further at it?

Cheers,
Jes

[  325.819011] WARNING: at drivers/md/raid5.c:356 get_active_stripe+0x5af/0x6b0 [raid456]()
[  325.828042] Hardware name: S1200BTL
[  325.831926] Modules linked in: lockd bnep sunrpc bluetooth rfkill be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi raid456 async_raid6_recov async_memcpy async_pq dm_mirror dm_region_hash dm_log dm_mod raid6_pq async_xor xor async_tx coretemp kvm_intel kvm iTCO_wdt crc32c_intel ghash_clmulni_intel iTCO_vendor_support lpc_ich mfd_core video i2c_i801 raid1 e1000e microcode pcspkr uinput sd_mod crc_t10dif mgag200 i2c_algo_bit drm_kms_helper ttm drm ahci libahci i2c_core mpt2sas libata raid_class scsi_transport_sas
[  325.897176] Pid: 1427, comm: mkfs.ext4 Not tainted 3.8.0-rc7 #11
[  325.903879] Call Trace:
[  325.906611]  [<ffffffff8106223f>] warn_slowpath_common+0x7f/0xc0
[  325.913315]  [<ffffffff8106229a>] warn_slowpath_null+0x1a/0x20
[  325.919827]  [<ffffffffa022262f>] get_active_stripe+0x5af/0x6b0 [raid456]
[  325.927404]  [<ffffffff81086570>] ? wake_up_bit+0x40/0x40
[  325.933433]  [<ffffffffa0224877>] make_request+0x8c7/0xa90 [raid456]
[  325.940528]  [<ffffffff8109dc9c>] ? update_curr+0xec/0x170
[  325.946649]  [<ffffffff81086570>] ? wake_up_bit+0x40/0x40
[  325.952678]  [<ffffffff814a1a53>] md_make_request+0xc3/0x200
[  325.958998]  [<ffffffff81139595>] ? mempool_alloc_slab+0x15/0x20
[  325.965703]  [<ffffffff812d88d2>] generic_make_request+0xc2/0x110
[  325.972506]  [<ffffffff812d8c29>] submit_bio+0x79/0x160
[  325.978341]  [<ffffffff811d4555>] ? bio_alloc_bioset+0x65/0x120
[  325.984948]  [<ffffffff812dfda6>] blkdev_issue_discard+0x1f6/0x2b0
[  325.991840]  [<ffffffff812e0ae6>] blkdev_ioctl+0x3b6/0x810
[  325.997962]  [<ffffffff811d5801>] block_ioctl+0x41/0x50
[  326.003785]  [<ffffffff811b0669>] do_vfs_ioctl+0x99/0x580
[  326.009814]  [<ffffffff81299f7a>] ? inode_has_perm.isra.30.constprop.60+0x2a/0x30
[  326.018167]  [<ffffffff8129b337>] ? file_has_perm+0x97/0xb0
[  326.024379]  [<ffffffff811b0be1>] sys_ioctl+0x91/0xb0
[  326.030018]  [<ffffffff81618219>] system_call_fastpath+0x16/0x1b
[  326.036724] ---[ end trace 9e63e95270dde637 ]---
[  326.041878] sector=175a0 i=0           (null)           (null)           (null) ffff88023139e3c0 0
[root@noisybay linux-2.6]# cat /proc/mdstat 
Personalities : [raid1] [raid6] [raid5] [raid4] 
md64 : active raid5 loop2[3] loop1[1] loop0[0]
      523904 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/2] [UU_]
      [===>.................]  recovery = 18.5% (49128/261952) finish=80.3min speed=43K/sec
      

