From: Pietro Abate <Pietro.Abate@pps.jussieu.fr>
Subject: Re: drivers/ata/libata-core.c:4732 ata_qc_issue+0x4c/0x2e0
Date: Tue, 9 Sep 2008 14:12:08 +0200
Message-ID: <20080909121207.GB31147@uranium.pps.jussieu.fr>
References: <20080909111643.GB6239@deprecation.cyrius.com> <48C661F8.5000709@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48C661F8.5000709@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Martin Michlmayr <tbm@cyrius.com>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 09, 2008 at 01:46:00PM +0200, Tejun Heo wrote:
> Martin Michlmayr wrote:
> > A Debian user reported the following oops (2.6.26, RAID1 + LVM,
> > running on an ARM platform, sata_mv):
> 
> Can you please attach full log?

Well, there you go :) and please don't tell me my disk are just gone banana...
as I basically never used them ...

[...]

Sep  9 12:04:08 kernel: [42950667.430000] ata1: failed to read log page 10h (errno=-5)
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: exception Emask 0x1 SAct 0x1ffff SErr 0x0 action 0x6
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: edma_err_cause=02000084 pp_flags=00000003, dev error, EDMA self-disable
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: cmd 60/80:00:3f:fb:eb/00:00:08:00:00/40 tag 0 ncq 65536 in
Sep  9 12:04:08 kernel: [42950667.430000]          res 41/40:84:3f:02:ec/40:00:08:00:00/40 Emask 0x9 (media error)
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: error: { UNC }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: cmd 60/80:08:bf:f8:eb/00:00:08:00:00/40 tag 1 ncq 65536 in
Sep  9 12:04:08 kernel: [42950667.430000]          res 41/40:84:3f:02:ec/40:00:08:00:00/40 Emask 0x9 (media error)
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: error: { UNC }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: cmd 60/00:10:3f:fe:eb/04:00:08:00:00/40 tag 2 ncq 524288 in
Sep  9 12:04:08 kernel: [42950667.430000]          res 41/40:84:3f:02:ec/40:00:08:00:00/40 Emask 0x9 (media error)
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: error: { UNC }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: cmd 60/80:18:3f:f6:eb/00:00:08:00:00/40 tag 3 ncq 65536 in
Sep  9 12:04:08 kernel: [42950667.430000]          res 41/40:84:3f:02:ec/40:00:08:00:00/40 Emask 0x9 (media error)
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: error: { UNC }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: cmd 60/80:20:bf:f6:eb/00:00:08:00:00/40 tag 4 ncq 65536 in
Sep  9 12:04:08 kernel: [42950667.430000]          res 41/40:84:3f:02:ec/40:00:08:00:00/40 Emask 0x9 (media error)
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: error: { UNC }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: cmd 60/00:28:3f:f7:eb/01:00:08:00:00/40 tag 5 ncq 131072 in
Sep  9 12:04:08 kernel: [42950667.430000]          res 41/40:84:3f:02:ec/40:00:08:00:00/40 Emask 0x9 (media error)
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: error: { UNC }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: cmd 60/80:30:3f:f8:eb/00:00:08:00:00/40 tag 6 ncq 65536 in
Sep  9 12:04:08 kernel: [42950667.430000]          res 41/40:84:3f:02:ec/40:00:08:00:00/40 Emask 0x9 (media error)

[...]

Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: error: { UNC }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: cmd 60/80:80:3f:02:ec/01:00:08:00:00/40 tag 16 ncq 196608 in
Sep  9 12:04:08 kernel: [42950667.430000]          res 41/40:84:3f:02:ec/40:00:08:00:00/40 Emask 0x9 (media error)
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:08 kernel: [42950667.430000] ata1.00: error: { UNC }
Sep  9 12:04:08 kernel: [42950667.440000] ata1: hard resetting link
Sep  9 12:04:09 kernel: [42950667.950000] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Sep  9 12:04:09 kernel: [42950667.990000] ata1.00: configured for UDMA/133
Sep  9 12:04:09 kernel: [42950667.990000] ata1: EH complete
Sep  9 12:04:09 kernel: [42950667.990000] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
Sep  9 12:04:09 kernel: [42950667.990000] sd 0:0:0:0: [sda] Write Protect is off
Sep  9 12:04:09 kernel: [42950667.990000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Sep  9 12:04:09 kernel: [42950667.990000] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep  9 12:04:11 kernel: [42950669.980000] ata1.00: exception Emask 0x0 SAct 0x1fffe SErr 0x0 action 0x6
Sep  9 12:04:11 kernel: [42950669.980000] ata1.00: edma_err_cause=00000084 pp_flags=00000003, dev error, EDMA self-disable
Sep  9 12:04:11 kernel: [42950669.980000] ata1.00: cmd 60/00:08:3f:fd:eb/01:00:08:00:00/40 tag 1 ncq 131072 in
Sep  9 12:04:11 kernel: [42950669.980000]          res 41/40:84:3f:fb:eb/40:00:08:00:00/40 Emask 0x9 (media error)
Sep  9 12:04:11 kernel: [42950669.980000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:11 kernel: [42950669.980000] ata1.00: error: { UNC }
Sep  9 12:04:11 kernel: [42950669.980000] ata1.00: cmd 60/80:10:bf:f5:eb/00:00:08:00:00/40 tag 2 ncq 65536 in
Sep  9 12:04:11 kernel: [42950669.980000]          res 41/40:84:3f:fb:eb/40:00:08:00:00/40 Emask 0x9 (media error)
Sep  9 12:04:11 kernel: [42950669.980000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:11 kernel: [42950669.980000] ata1.00: error: { UNC }
Sep  9 12:04:11 kernel: [42950669.980000] ata1.00: cmd 60/00:18:3f:f4:eb/01:00:08:00:00/40 tag 3 ncq 131072 in


[...]

Sep  9 12:04:22 kernel: [42950681.140000]          res 51/40:00:37:59:ec/d2:00:08:00:00/40 Emask 0x409 (media error) <F>
Sep  9 12:04:22 kernel: [42950681.140000] ata1.00: status: { DRDY ERR }
Sep  9 12:04:22 kernel: [42950681.140000] ata1.00: error: { UNC }
Sep  9 12:04:22 kernel: [42950681.140000] ata1.00: cmd 60/80:78:3f:fb:eb/00:00:08:00:00/40 tag 15 ncq 65536 in
Sep  9 12:04:22 kernel: [42950681.140000]          res c0/40:4c:3f:61:ec/40:00:08:00:00/40 Emask 0x2 (HSM violation)
Sep  9 12:04:22 kernel: [42950681.140000] ata1.00: status: { Busy }
Sep  9 12:04:22 kernel: [42950681.140000] ata1.00: error: { UNC }
Sep  9 12:04:22 kernel: [42950681.140000] ata1: hard resetting link
Sep  9 12:04:22 kernel: [42950681.650000] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Sep  9 12:04:22 kernel: [42950681.690000] ata1.00: configured for UDMA/133
Sep  9 12:04:22 kernel: [42950681.690000] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Sep  9 12:04:22 kernel: [42950681.690000] sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
Sep  9 12:04:22 kernel: [42950681.690000] Descriptor sense data with sense descriptors (in hex):
Sep  9 12:04:22 kernel: [42950681.690000]         72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
Sep  9 12:04:22 kernel: [42950681.690000]         08 ec 61 3f
Sep  9 12:04:22 kernel: [42950681.690000] sd 0:0:0:0: [sda] Add. Sense: Scsi parity error
Sep  9 12:04:22 kernel: [42950681.690000] end_request: I/O error, dev sda, sector 149683775
Sep  9 12:04:22 kernel: [42950681.690000] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Sep  9 12:04:22 kernel: [42950681.690000] sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
Sep  9 12:04:22 kernel: [42950681.690000] Descriptor sense data with sense descriptors (in hex):
Sep  9 12:04:22 kernel: [42950681.690000]         72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
Sep  9 12:04:22 kernel: [42950681.690000]         08 ec 61 3f
Sep  9 12:04:22 kernel: [42950681.690000] sd 0:0:0:0: [sda] Add. Sense: Scsi parity error
Sep  9 12:04:22 kernel: [42950681.690000] end_request: I/O error, dev sda, sector 149683007
Sep  9 12:04:22 kernel: [42950681.690000] ata1: EH complete
Sep  9 12:04:22 kernel: [42950681.690000] ------------[ cut here ]------------
Sep  9 12:04:22 kernel: [42950681.690000] WARNING: at drivers/ata/libata-core.c:4732 ata_qc_issue+0x4c/0x2e0 [libata]()
Sep  9 12:04:22 kernel: [42950681.690000] Modules linked in: dm_mod raid1 md_mod reiserfs ext3 jbd vfat fat nls_base usb_storage ext2 mbcache sd_mod sata_mv libata ehci_hcd evdev scsi_mod usbcore mv643xx_eth mii gpio_keys
Sep  9 12:04:22 kernel: [42950681.690000] [<c002a0ec>] (dump_stack+0x0/0x14) from [<c0042c8c>] (warn_on_slowpath+0x4c/0x84)
Sep  9 12:04:22 kernel: [42950681.690000] [<c0042c40>] (warn_on_slowpath+0x0/0x84) from [<bf0661c8>] (ata_qc_issue+0x4c/0x2e0 [libata])
Sep  9 12:04:22 kernel: [42950681.690000]  r6:d7c66000 r5:d7c66108 r4:00000003
Sep  9 12:04:22 kernel: [42950681.690000] [<bf06617c>] (ata_qc_issue+0x0/0x2e0 [libata]) from [<bf06bb4c>] (ata_scsi_translate+0x118/0x170 [libata])
Sep  9 12:04:22 kernel: [42950681.690000] [<bf06ba34>] (ata_scsi_translate+0x0/0x170 [libata]) from [<bf06eadc>] (ata_scsi_queuecmd+0x1d8/0x1fc [libata])
Sep  9 12:04:22 kernel: [42950681.690000] [<bf06e904>] (ata_scsi_queuecmd+0x0/0x1fc [libata]) from [<bf031eac>] (scsi_dispatch_cmd+0x1fc/0x2c8 [scsi_mod])
Sep  9 12:04:22 kernel: [42950681.690000]  r6:d73a4078 r5:d6d16300 r4:80000013
Sep  9 12:04:22 kernel: [42950681.690000] [<bf031cb0>] (scsi_dispatch_cmd+0x0/0x2c8 [scsi_mod]) from [<bf038ac8>] (scsi_request_fn+0x2a4/0x394 [scsi_mod])
Sep  9 12:04:22 kernel: [42950681.690000]  r7:d73f16c8 r6:d73a4078 r5:d6c75400 r4:d6c42c00
Sep  9 12:04:22 kernel: [42950681.690000] [<bf038824>] (scsi_request_fn+0x0/0x394 [scsi_mod]) from [<c01105e4>] (__blk_run_queue+0x4c/0x6c)
Sep  9 12:04:22 kernel: [42950681.690000]  r8:d7356600 r7:d6c75400 r6:60000013 r5:d6c75400 r4:d73a4078
Sep  9 12:04:22 kernel: [42950681.690000] [<c0110598>] (__blk_run_queue+0x0/0x6c) from [<c0110624>] (blk_run_queue+0x20/0x28)
Sep  9 12:04:22 kernel: [42950681.690000]  r4:60000013
Sep  9 12:04:22 kernel: [42950681.690000] [<c0110604>] (blk_run_queue+0x0/0x28) from [<bf036c68>] (scsi_run_queue+0x198/0x1a8 [scsi_mod])
Sep  9 12:04:22 kernel: [42950681.690000]  r4:d6c42c00
Sep  9 12:04:22 kernel: [42950681.690000] [<bf036ad0>] (scsi_run_queue+0x0/0x1a8 [scsi_mod]) from [<bf037ac8>] (scsi_run_host_queues+0x20/0x3c [scsi_mod])
Sep  9 12:04:22 kernel: [42950681.690000] [<bf037aa8>] (scsi_run_host_queues+0x0/0x3c [scsi_mod]) from [<bf0365ac>] (scsi_error_handler+0x478/0x50c [scsi_mod])
Sep  9 12:04:22 kernel: [42950681.690000]  r5:d6c75400 r4:80000013
Sep  9 12:04:22 kernel: [42950681.690000] [<bf036134>] (scsi_error_handler+0x0/0x50c [scsi_mod]) from [<c0056ac0>] (kthread+0x5c/0x94)
Sep  9 12:04:22 kernel: [42950681.690000] [<c0056a64>] (kthread+0x0/0x94) from [<c0045f68>] (do_exit+0x0/0x6a0)
Sep  9 12:04:22 kernel: [42950681.690000]  r6:00000000 r5:00000000 r4:00000000
Sep  9 12:04:22 kernel: [42950681.690000] ---[ end trace eace704192d009e7 ]---
Sep  9 12:04:22 kernel: [42950681.690000] ------------[ cut here ]------------


