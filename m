From: Xiao Ni <xni@redhat.com>
Subject: After reshaping raid1 to raid0 with bitmap, then stop md panic
Date: Tue, 5 Aug 2014 03:03:06 -0400 (EDT)
Message-ID: <11051344.17913061.1407222186494.JavaMail.zimbra@redhat.com>
References: <324320204.17911195.1407221719669.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <324320204.17911195.1407221719669.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

Dear all


   I faced one problem that the system panic after reshaping raid1 to raid0 with bitmap.
The dmesg and calltrace information is like this:

   You can easily reproduce this by those steps:
   1. mdadm -CR /dev/md0 -l1 -n2 /dev/loop[0-1] --bitmap=internal
   2. mdadm --wait /dev/md0
   3. mdadm --grow -l0 /dev/md0
   4. mdadm -S /dev/md0

[ 1485.254389] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 231810 256
[ 1485.265275] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 232322 256
[ 1485.276154] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 232834 256
[ 1485.287025] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 233346 256
[ 1485.297894] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 233858 256
[ 1485.308768] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 234370 256
[ 1485.319639] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 234882 256
[ 1485.330505] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 235394 256
[ 1485.341383] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 235906 256
[ 1485.352256] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 236418 256
[ 1485.363126] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 236930 256
[ 1485.373995] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 237442 256
[ 1485.384865] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 237954 256
[ 1485.395732] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 238466 256
[ 1485.406651] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 238978 256
[ 1485.417543] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 239490 256
[ 1485.428412] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 240002 256
[ 1485.439283] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 240514 256
[ 1485.450156] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 241026 256
[ 1485.461056] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 241538 256
[ 1485.471959] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 242050 256
[ 1485.482832] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 242562 256
[ 1485.493697] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 243074 256
[ 1485.504561] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 243586 256
[ 1485.515438] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 244098 256
[ 1485.526307] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 244610 256
[ 1485.537180] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 245122 256
[ 1485.548027] md/raid0:md0: make_request bug: can't convert block across chunks or bigger than 64k 245634 64

[ 1485.646746] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[ 1485.654724] IP: [<ffffffff8148db2e>] bitmap_daemon_work+0x24e/0x450
[ 1485.661134] PGD 924a35067 PUD 922a4d067 PMD 0 
[ 1485.665735] Oops: 0002 [#1] SMP  
[ 1485.668992] Modules linked in: raid1 raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx ext4 mbcache jbd2 raid0 loop sg iTCO_wdt iTCO_vendor_support nfsd coretemp kvm_intel kvm igb ptp auth_rpcgss crc32c_intel serio_raw pcspkr pps_core nfs_acl i7core_edac lockd shpchp ioatdma lpc_ich dm_multipath acpi_cpufreq mperf edac_core sunrpc mfd_core ipmi_si ipmi_msghandler i2c_i801 dca xfs libcrc32c sd_mod crc_t10dif crct10dif_common sr_mod cdrom mgag200 syscopyarea ata_generic sysfillrect pata_acpi sysimgblt i2c_algo_bit mptsas drm_kms_helper ahci ttm firewire_ohci scsi_transport_sas libahci pata_jmicron mptscsih drm firewire_core mptbase libata i2c_core crc_itu_t dm_mirror dm_region_hash dm_log dm_mod
[ 1485.734595] CPU: 13 PID: 2613 Comm: mdadm Tainted: G          I --------------   3.10.0-142.el7.x86_64 #1
[ 1485.744260] Hardware name: SGI.COM AltixXE500/X8DAH, BIOS 1.0b    12/10/2009
[ 1485.751398] task: ffff8809247038e0 ti: ffff88091b614000 task.ti: ffff88091b614000
[ 1485.758908] RIP: 0010:[<ffffffff8148db2e>]  [<ffffffff8148db2e>] bitmap_daemon_work+0x24e/0x450
[ 1485.767727] RSP: 0018:ffff88091b615c70  EFLAGS: 00010246
[ 1485.773071] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[ 1485.780279] RDX: 0000000000001388 RSI: 0000000000000000 RDI: 0000000000020000
[ 1485.787539] RBP: ffff88091b615cc0 R08: 0000000000000003 R09: 0000000000000000
[ 1485.794754] R10: fffffffffffffb34 R11: 0000000000000000 R12: 0000000000000800
[ 1485.801961] R13: ffff88091f5e7800 R14: 0000000000000008 R15: ffff88048c367e00
[ 1485.809221] FS:  00007f0269b4d740(0000) GS:ffff88093fd40000(0000) knlGS:0000000000000000
[ 1485.817424] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1485.823239] CR2: 0000000000000038 CR3: 000000091b595000 CR4: 00000000000007e0
[ 1485.830462] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1485.837669] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1485.844927] Stack:
[ 1485.846937]  ffff88091b615fd8 ffff88091b615fd8 ffff88091f5e7b50 0000000000020000
[ 1485.854481]  0000000084b198ea ffff88048c367e00 ffff88091f5e7800 0000000000002710
[ 1485.861949]  0000000000000000 ffff88091f5e7800 ffff88091b615ce8 ffffffff8148ddd4
[ 1485.869451] Call Trace:
[ 1485.871914]  [<ffffffff8148ddd4>] bitmap_flush+0x34/0x70
[ 1485.877292]  [<ffffffff814872d0>] __md_stop_writes+0x40/0x80
[ 1485.882983]  [<ffffffff814882b9>] do_md_stop+0x99/0x4b0
[ 1485.888279]  [<ffffffff811504f5>] ? filemap_write_and_wait+0x55/0x60
[ 1485.894626]  [<ffffffff8148997e>] md_ioctl+0xace/0x1940
[ 1485.899853]  [<ffffffff811ce742>] ? path_openat+0xc2/0x4c0
[ 1485.905335]  [<ffffffff812af3f4>] blkdev_ioctl+0x224/0x7e0
[ 1485.910818]  [<ffffffff811f7861>] block_ioctl+0x41/0x50
[ 1485.916040]  [<ffffffff811d1345>] do_vfs_ioctl+0x2e5/0x4c0
[ 1485.921525]  [<ffffffff81265ebe>] ? file_has_perm+0xae/0xc0
[ 1485.927093]  [<ffffffff811d15c1>] SyS_ioctl+0xa1/0xc0
[ 1485.932145]  [<ffffffff815f9519>] system_call_fastpath+0x16/0x1b
[ 1485.938144] Code: 20 02 00 00 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 2e 0f 1f 84 00 00 00 00 00 49 8b 85 48 01 00 00 49 8b 95 80 03 00 00 <48> 89 50 38 eb b7 0f 1f 40 00 49 8b 85 48 01 00 00 48 bf ff ff
[ 1485.958086] RIP  [<ffffffff8148db2e>] bitmap_daemon_work+0x24e/0x450
[ 1485.964445]  RSP <ffff88091b615c70>
[ 1485.967926] CR2: 0000000000000038
