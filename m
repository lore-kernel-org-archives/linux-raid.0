From: Martin Michlmayr <tbm@cyrius.com>
Subject: drivers/ata/libata-core.c:4732 ata_qc_issue+0x4c/0x2e0
Date: Tue, 9 Sep 2008 14:16:43 +0300
Message-ID: <20080909111643.GB6239@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Pietro Abate <Pietro.Abate@pps.jussieu.fr>
List-Id: linux-raid.ids

A Debian user reported the following oops (2.6.26, RAID1 + LVM,
running on an ARM platform, sata_mv):

> [42952301.700000] ------------[ cut here ]------------
> [42952301.700000] WARNING: at drivers/ata/libata-core.c:4732 ata_qc_issue+0x4c/0x2e0 [libata]()
> [42952301.700000] Modules linked in: dm_mod raid1 md_mod reiserfs ext3 jbd vfat fat nls_base usb_storage ext2 mbcache sd_mod sata_mv libata ehci_hcd evdev scsi_mod usbcore mv643xx_eth mii gpio_keys
> [42952301.700000] [<c002a0ec>] (dump_stack+0x0/0x14) from [<c0042c8c>] (warn_on_slowpath+0x4c/0x84)
> [42952301.700000] [<c0042c40>] (warn_on_slowpath+0x0/0x84) from [<bf0661c8>] (ata_qc_issue+0x4c/0x2e0 [libata])
> [42952301.700000]  r6:d7c66000 r5:d7c66108 r4:00000003
> [42952301.700000] [<bf06617c>] (ata_qc_issue+0x0/0x2e0 [libata]) from [<bf06bb4c>] (ata_scsi_translate+0x118/0x170 [libata])
> [42952301.700000] [<bf06ba34>] (ata_scsi_translate+0x0/0x170 [libata]) from [<bf06eadc>] (ata_scsi_queuecmd+0x1d8/0x1fc [libata])
> [42952301.700000] [<bf06e904>] (ata_scsi_queuecmd+0x0/0x1fc [libata]) from [<bf031eac>] (scsi_dispatch_cmd+0x1fc/0x2c8 [scsi_mod])
> [42952301.700000]  r6:d73a4078 r5:d6d16220 r4:80000013
> [42952301.700000] [<bf031cb0>] (scsi_dispatch_cmd+0x0/0x2c8 [scsi_mod]) from [<bf038ac8>] (scsi_request_fn+0x2a4/0x394 [scsi_mod])
> [42952301.700000]  r7:d73f1790 r6:d73a4078 r5:d6c75400 r4:d6c42c00
> [42952301.700000] [<bf038824>] (scsi_request_fn+0x0/0x394 [scsi_mod]) from [<c0110434>] (__generic_unplug_device+0x38/0x3c)
> [42952301.700000]  r8:0cc0ed00 r7:d6c0dc60 r6:d73a4078 r5:02000000 r4:d73a4078
> [42952301.700000] [<c01103fc>] (__generic_unplug_device+0x0/0x3c) from [<c0110ba8>] (generic_unplug_device+0x28/0x38)
> [42952301.700000]  r4:00000000
> [42952301.700000] [<c0110b80>] (generic_unplug_device+0x0/0x38) from [<c010f948>] (blk_unplug+0xb0/0xbc)
> [42952301.700000] [<c010f898>] (blk_unplug+0x0/0xbc) from [<bf1563c0>] (unplug_slaves+0x70/0xd4 [raid1])
> [42952301.700000]  r6:00000000 r5:d735f800 r4:d7ebda60
> [42952301.700000] [<bf156350>] (unplug_slaves+0x0/0xd4 [raid1]) from [<bf156440>] (raid1_unplug+0x1c/0x28 [raid1])
> [42952301.700000]  r7:00000001 r6:d532b9e8 r5:00000000 r4:d735f800
> [42952301.700000] [<bf156424>] (raid1_unplug+0x0/0x28 [raid1]) from [<c010f948>] (blk_unplug+0xb0/0xbc)
> [42952301.700000]  r4:00000000
> [42952301.700000] [<c010f898>] (blk_unplug+0x0/0xbc) from [<bf1482d0>] (md_do_sync+0x710/0xad8 [md_mod])
> [42952301.700000]  r6:d735f800 r5:00004c5f r4:c02a6458
> [42952301.700000] [<bf147bc0>] (md_do_sync+0x0/0xad8 [md_mod]) from [<bf149b68>] (md_thread+0x10c/0x128 [md_mod])
> [42952301.700000] [<bf149a5c>] (md_thread+0x0/0x128 [md_mod]) from [<c0056ac0>] (kthread+0x5c/0x94)
> [42952301.700000]  r7:00000000 r6:bf149a5c r5:d5336ec0 r4:d5a14000
> [42952301.700000] [<c0056a64>] (kthread+0x0/0x94) from [<c0045f68>] (do_exit+0x0/0x6a0)
> [42952301.700000]  r6:00000000 r5:00000000 r4:00000000
> [42952301.700000] ---[ end trace eace704192d009e7 ]---

-- 
Martin Michlmayr
http://www.cyrius.com/
