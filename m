From: Daniel Walker <admin@ftwinc.net>
Subject: Re: Hard CPU Lockup when accessing MD RAID5
Date: Thu, 21 Apr 2016 22:47:40 +0000
Message-ID: <5719588D.2020704@ftwinc.net>
References: <570D6E79.1010201@ftwinc.net> <20160413170008.GA6186@kernel.org> <57172735.9030202@ftwinc.net> <22295.41020.927361.583034@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22295.41020.927361.583034@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Well, things have gone from bad to worse in my eyes..

We have had the following hardware replaced: Chassis, Motherboard, CPUs, 
RAM, SAS Cable, SAS Controller and the PSUs, basically we are down to 
just the harddrives and it is still crashing..

This is a rather long one :)

Apr 21 23:55:19  [  785.975018] NMI watchdog: Watchdog detected hard 
LOCKUP on cpu 1
Apr 21 23:55:19
Apr 21 23:55:19  [  785.975110] Modules linked in:
Apr 21 23:55:19   iptable_mangle
Apr 21 23:55:19   netconsole
Apr 21 23:55:19   configfs
Apr 21 23:55:19   tun
Apr 21 23:55:19   xt_multiport
Apr 21 23:55:19   ip6table_filter
Apr 21 23:55:19   ip6_tables
Apr 21 23:55:19   iptable_filter
Apr 21 23:55:19   ip_tables
Apr 21 23:55:19   x_tables
Apr 21 23:55:19   bridge
Apr 21 23:55:19   stp
Apr 21 23:55:19   llc
Apr 21 23:55:19   bonding
Apr 21 23:55:19   ext4
Apr 21 23:55:19   crc16
Apr 21 23:55:19   mbcache
Apr 21 23:55:19   jbd2
Apr 21 23:55:19   raid1
Apr 21 23:55:19   raid0
Apr 21 23:55:19   raid456
Apr 21 23:55:19   async_raid6_recov
Apr 21 23:55:19   async_memcpy
Apr 21 23:55:19   async_pq
Apr 21 23:55:19   async_xor
Apr 21 23:55:19   xor
Apr 21 23:55:19   async_tx
Apr 21 23:55:19   raid6_pq
Apr 21 23:55:19   md_mod
Apr 21 23:55:19   sg
Apr 21 23:55:19   sd_mod
Apr 21 23:55:19   hid_generic
Apr 21 23:55:19   usbhid
Apr 21 23:55:19   hid
Apr 21 23:55:19   iTCO_wdt
Apr 21 23:55:19   iTCO_vendor_support
Apr 21 23:55:19   x86_pkg_temp_thermal
Apr 21 23:55:19   intel_powerclamp
Apr 21 23:55:19   coretemp
Apr 21 23:55:19   crct10dif_pclmul
Apr 21 23:55:19   crc32_pclmul
Apr 21 23:55:19   crc32c_intel
Apr 21 23:55:19   ghash_clmulni_intel
Apr 21 23:55:19   cryptd
Apr 21 23:55:19   xhci_pci
Apr 21 23:55:19   ahci
Apr 21 23:55:19   igb
Apr 21 23:55:19   ehci_pci
Apr 21 23:55:19   i2c_algo_bit
Apr 21 23:55:19   xhci_hcd
Apr 21 23:55:19   ptp
Apr 21 23:55:19   ehci_hcd
Apr 21 23:55:19   libahci
Apr 21 23:55:19   mpt3sas
Apr 21 23:55:19   sb_edac
Apr 21 23:55:19   i2c_i801
Apr 21 23:55:19   pps_core
Apr 21 23:55:19   edac_core
Apr 21 23:55:19   mei_me
Apr 21 23:55:19   raid_class
Apr 21 23:55:19   lpc_ich
Apr 21 23:55:19   libata
Apr 21 23:55:19   scsi_transport_sas
Apr 21 23:55:19   usbcore
Apr 21 23:55:19   mfd_core
Apr 21 23:55:19   mei
Apr 21 23:55:19   usb_common
Apr 21 23:55:19   i2c_core
Apr 21 23:55:19   ioatdma
Apr 21 23:55:19   scsi_mod
Apr 21 23:55:19   dca
Apr 21 23:55:19   ipmi_si
Apr 21 23:55:19   ipmi_msghandler
Apr 21 23:55:19   acpi_power_meter
Apr 21 23:55:19   acpi_pad
Apr 21 23:55:19   tpm_tis
Apr 21 23:55:19   tpm
Apr 21 23:55:19   processor
Apr 21 23:55:19   button
Apr 21 23:55:19
Apr 21 23:55:19  [  785.980450] CPU: 1 PID: 14630 Comm: kworker/u65:2 
Not tainted 4.5.1 #1
Apr 21 23:55:19  [  785.980528] Hardware name: Supermicro Super 
Server/X10DRi-LN4+, BIOS 1.0b 01/29/2015
Apr 21 23:55:19  [  785.980616] Workqueue: writeback wb_workfn
Apr 21 23:55:19   (flush-9:11)
Apr 21 23:55:19
Apr 21 23:55:19  [  785.980818]  0000000000000000
Apr 21 23:55:19   ffff881fffc25bd0
Apr 21 23:55:19   ffffffff812e00b8
Apr 21 23:55:19   0000000000000000
Apr 21 23:55:19
Apr 21 23:55:19  [  785.981148]  0000000000000000
Apr 21 23:55:19   ffff881fffc25be8
Apr 21 23:55:19   ffffffff810dff1d
Apr 21 23:55:19   ffff881ff2cc0000
Apr 21 23:55:19
Apr 21 23:55:19  [  785.981479]  ffff881fffc25c20
Apr 21 23:55:19   ffffffff8110f8f8
Apr 21 23:55:19   0000000000000001
Apr 21 23:55:19   ffff881fffc2af00
Apr 21 23:55:19
Apr 21 23:55:19  [  785.981810] Call Trace:
Apr 21 23:55:19  [  785.981897]  <NMI>
Apr 21 23:55:19   [<ffffffff812e00b8>] dump_stack+0x4d/0x65
Apr 21 23:55:19  [  785.982065]  [<ffffffff810dff1d>] 
watchdog_overflow_callback+0xdd/0xf0
Apr 21 23:55:19  [  785.982165]  [<ffffffff8110f8f8>] 
__perf_event_overflow+0x88/0x1d0
Apr 21 23:55:19  [  785.982261]  [<ffffffff811103e4>] 
perf_event_overflow+0x14/0x20
Apr 21 23:55:19  [  785.982358]  [<ffffffff8101e320>] 
intel_pmu_handle_irq+0x1d0/0x4a0
Apr 21 23:55:19  [  785.982458]  [<ffffffff810162d8>] 
perf_event_nmi_handler+0x28/0x50
Apr 21 23:55:19  [  785.982554]  [<ffffffff81008121>] nmi_handle+0x61/0x110
Apr 21 23:55:19  [  785.982648]  [<ffffffff810082e7>] do_nmi+0x117/0x3e0
Apr 21 23:55:19  [  785.982746]  [<ffffffff814dae97>] 
end_repeat_nmi+0x1a/0x1e
Apr 21 23:55:19  [  785.982844]  [<ffffffffa01c4084>] ? 
__release_stripe+0x4/0x20 [raid456]
Apr 21 23:55:19  [  785.982941]  [<ffffffffa01c4084>] ? 
__release_stripe+0x4/0x20 [raid456]
Apr 21 23:55:19  [  785.983038]  [<ffffffffa01c4084>] ? 
__release_stripe+0x4/0x20 [raid456]
Apr 21 23:55:19  [  785.983134]  <<EOE>>
Apr 21 23:55:19   [<ffffffffa01c560b>] ? raid5_unplug+0x8b/0x130 [raid456]
Apr 21 23:55:19  [  785.983316]  [<ffffffff812b9b98>] 
blk_flush_plug_list+0xa8/0x210
Apr 21 23:55:19  [  785.983411]  [<ffffffff812ba0a4>] 
blk_finish_plug+0x24/0x40
Apr 21 23:55:19  [  785.983506]  [<ffffffff811b69a2>] 
wb_writeback+0x172/0x2d0
Apr 21 23:55:19  [  785.983600]  [<ffffffff811b716f>] wb_workfn+0x20f/0x3c0
Apr 21 23:55:19  [  785.983698]  [<ffffffff81067513>] 
process_one_work+0x143/0x400
Apr 21 23:55:19  [  785.983793]  [<ffffffff81067cc1>] 
worker_thread+0x61/0x490
Apr 21 23:55:19  [  785.983888]  [<ffffffff81067c60>] ? 
max_active_store+0x60/0x60
Apr 21 23:55:19  [  785.983983]  [<ffffffff81067c60>] ? 
max_active_store+0x60/0x60
Apr 21 23:55:19  [  785.984078]  [<ffffffff8106c926>] kthread+0xd6/0xf0
Apr 21 23:55:19  [  785.984171]  [<ffffffff810011f6>] ? 
exit_to_usermode_loop+0x76/0xb0
Apr 21 23:55:19  [  785.984266]  [<ffffffff8106c850>] ? 
kthread_park+0x50/0x50
Apr 21 23:55:19  [  785.984361]  [<ffffffff814d92af>] 
ret_from_fork+0x3f/0x70
Apr 21 23:55:19  [  785.984454]  [<ffffffff8106c850>] ? 
kthread_park+0x50/0x50
Apr 21 23:55:21  [  787.840894] NMI watchdog: Watchdog detected hard 
LOCKUP on cpu 13
Apr 21 23:55:21
Apr 21 23:55:21  [  787.840993] Modules linked in:
Apr 21 23:55:21   iptable_mangle
Apr 21 23:55:21   netconsole
Apr 21 23:55:21   configfs
Apr 21 23:55:21   tun
Apr 21 23:55:21   xt_multiport
Apr 21 23:55:21   ip6table_filter
Apr 21 23:55:21   ip6_tables
Apr 21 23:55:21   iptable_filter
Apr 21 23:55:21   ip_tables
Apr 21 23:55:21   x_tables
Apr 21 23:55:21   bridge
Apr 21 23:55:21   stp
Apr 21 23:55:21   llc
Apr 21 23:55:21   bonding
Apr 21 23:55:21   ext4
Apr 21 23:55:21   crc16
Apr 21 23:55:21   mbcache
Apr 21 23:55:21   jbd2
Apr 21 23:55:21   raid1
Apr 21 23:55:21   raid0
Apr 21 23:55:21   raid456
Apr 21 23:55:21   async_raid6_recov
Apr 21 23:55:21   async_memcpy
Apr 21 23:55:21   async_pq
Apr 21 23:55:21   async_xor
Apr 21 23:55:21   xor
Apr 21 23:55:21   async_tx
Apr 21 23:55:21   raid6_pq
Apr 21 23:55:21   md_mod
Apr 21 23:55:21   sg
Apr 21 23:55:21   sd_mod
Apr 21 23:55:21   hid_generic
Apr 21 23:55:21   usbhid
Apr 21 23:55:21   hid
Apr 21 23:55:21   iTCO_wdt
Apr 21 23:55:21   iTCO_vendor_support
Apr 21 23:55:21   x86_pkg_temp_thermal
Apr 21 23:55:21   intel_powerclamp
Apr 21 23:55:21   coretemp
Apr 21 23:55:21   crct10dif_pclmul
Apr 21 23:55:21   crc32_pclmul
Apr 21 23:55:21   crc32c_intel
Apr 21 23:55:21   ghash_clmulni_intel
Apr 21 23:55:21   cryptd
Apr 21 23:55:21   xhci_pci
Apr 21 23:55:21   ahci
Apr 21 23:55:21   igb
Apr 21 23:55:21   ehci_pci
Apr 21 23:55:21   i2c_algo_bit
Apr 21 23:55:21   xhci_hcd
Apr 21 23:55:21   ptp
Apr 21 23:55:21   ehci_hcd
Apr 21 23:55:21   libahci
Apr 21 23:55:21   mpt3sas
Apr 21 23:55:21   sb_edac
Apr 21 23:55:21   i2c_i801
Apr 21 23:55:21   pps_core
Apr 21 23:55:21   edac_core
Apr 21 23:55:21   mei_me
Apr 21 23:55:21   raid_class
Apr 21 23:55:21   lpc_ich
Apr 21 23:55:21   libata
Apr 21 23:55:21   scsi_transport_sas
Apr 21 23:55:21   usbcore
Apr 21 23:55:21   mfd_core
Apr 21 23:55:21   mei
Apr 21 23:55:21   usb_common
Apr 21 23:55:21   i2c_core
Apr 21 23:55:21   ioatdma
Apr 21 23:55:21   scsi_mod
Apr 21 23:55:21   dca
Apr 21 23:55:21   ipmi_si
Apr 21 23:55:21   ipmi_msghandler
Apr 21 23:55:21   acpi_power_meter
Apr 21 23:55:21   acpi_pad
Apr 21 23:55:21   tpm_tis
Apr 21 23:55:21   tpm
Apr 21 23:55:21   processor
Apr 21 23:55:21   button
Apr 21 23:55:21
Apr 21 23:55:21  [  787.848156] CPU: 13 PID: 16848 Comm: rtorrent main 
Not tainted 4.5.1 #1
Apr 21 23:55:21  [  787.848270] Hardware name: Supermicro Super 
Server/X10DRi-LN4+, BIOS 1.0b 01/29/2015
Apr 21 23:55:21  [  787.848403]  0000000000000000
Apr 21 23:55:21   ffff88407fca5bd0
Apr 21 23:55:21   ffffffff812e00b8
Apr 21 23:55:21   0000000000000000
Apr 21 23:55:21
Apr 21 23:55:21  [  787.848857]  0000000000000000
Apr 21 23:55:21   ffff88407fca5be8
Apr 21 23:55:21   ffffffff810dff1d
Apr 21 23:55:21   ffff883fea688000
Apr 21 23:55:21
Apr 21 23:55:21  [  787.849321]  ffff88407fca5c20
Apr 21 23:55:21   ffffffff8110f8f8
Apr 21 23:55:21   0000000000000001
Apr 21 23:55:21   ffff88407fcaaf00
Apr 21 23:55:21
Apr 21 23:55:21  [  787.849780] Call Trace:
Apr 21 23:55:21  [  787.849891]  <NMI>
Apr 21 23:55:21   [<ffffffff812e00b8>] dump_stack+0x4d/0x65
Apr 21 23:55:21  [  787.850091]  [<ffffffff810dff1d>] 
watchdog_overflow_callback+0xdd/0xf0
Apr 21 23:55:21  [  787.850211]  [<ffffffff8110f8f8>] 
__perf_event_overflow+0x88/0x1d0
Apr 21 23:55:21  [  787.850326]  [<ffffffff811103e4>] 
perf_event_overflow+0x14/0x20
Apr 21 23:55:21  [  787.850441]  [<ffffffff8101e320>] 
intel_pmu_handle_irq+0x1d0/0x4a0
Apr 21 23:55:21  [  787.850564]  [<ffffffff810162d8>] 
perf_event_nmi_handler+0x28/0x50
Apr 21 23:55:21  [  787.850677]  [<ffffffff81008121>] nmi_handle+0x61/0x110
Apr 21 23:55:21  [  787.850788]  [<ffffffff810083d1>] do_nmi+0x201/0x3e0
Apr 21 23:55:21  [  787.850910]  [<ffffffff814dae97>] 
end_repeat_nmi+0x1a/0x1e
Apr 21 23:55:21  [  787.851024]  [<ffffffff81090cc5>] ? 
queued_spin_lock_slowpath+0xf5/0x170
Apr 21 23:55:21  [  787.851142]  [<ffffffff81090cc5>] ? 
queued_spin_lock_slowpath+0xf5/0x170
Apr 21 23:55:21  [  787.851255]  [<ffffffff81090cc5>] ? 
queued_spin_lock_slowpath+0xf5/0x170
Apr 21 23:55:21  [  787.851367]  <<EOE>>
Apr 21 23:55:21   [<ffffffff814d8c6c>] _raw_spin_lock_irq+0x1c/0x20
Apr 21 23:55:21  [  787.851565]  [<ffffffffa01cd5d4>] 
raid5_make_request+0x6d4/0xce0 [raid456]
Apr 21 23:55:21  [  787.851680]  [<ffffffff812b824f>] ? 
generic_make_request+0x1f/0x1c0
Apr 21 23:55:21  [  787.851793]  [<ffffffff812bdc23>] ? 
blk_queue_split+0xb3/0x530
Apr 21 23:55:21  [  787.851907]  [<ffffffff8108bd90>] ? wait_woken+0x80/0x80
Apr 21 23:55:21  [  787.852021]  [<ffffffffa0110e43>] 
md_make_request+0xd3/0x210 [md_mod]
Apr 21 23:55:21  [  787.852135]  [<ffffffff81244923>] ? 
xfs_map_buffer.isra.15+0x33/0x60
Apr 21 23:55:21  [  787.852248]  [<ffffffff812b8319>] 
generic_make_request+0xe9/0x1c0
Apr 21 23:55:21  [  787.852365]  [<ffffffff812b8452>] submit_bio+0x62/0x150
Apr 21 23:55:21  [  787.852479]  [<ffffffff811c6f41>] 
do_mpage_readpage+0x2a1/0x6a0
Apr 21 23:55:21  [  787.852593]  [<ffffffff811286d9>] ? 
lru_cache_add+0x9/0x10
Apr 21 23:55:21  [  787.852704]  [<ffffffff811c7450>] 
mpage_readpages+0x110/0x170
Apr 21 23:55:21  [  787.852815]  [<ffffffff81246040>] ? 
__xfs_get_blocks+0x810/0x810
Apr 21 23:55:21  [  787.852927]  [<ffffffff81246040>] ? 
__xfs_get_blocks+0x810/0x810
Apr 21 23:55:21  [  787.853040]  [<ffffffff8116633d>] ? 
alloc_pages_current+0x8d/0x110
Apr 21 23:55:21  [  787.853152]  [<ffffffff812442f3>] 
xfs_vm_readpages+0x33/0x80
Apr 21 23:55:21  [  787.853265]  [<ffffffff81126585>] 
__do_page_cache_readahead+0x165/0x210
Apr 21 23:55:21  [  787.853381]  [<ffffffffa02cc397>] ? 
br_dev_xmit+0x137/0x1d0 [bridge]
Apr 21 23:55:21  [  787.853496]  [<ffffffff8111b1c7>] 
filemap_fault+0x427/0x4d0
Apr 21 23:55:21  [  787.853607]  [<ffffffff814d756d>] ? down_read+0xd/0x20
Apr 21 23:55:21  [  787.853719]  [<ffffffff8124fe20>] 
xfs_filemap_fault+0x40/0xa0
Apr 21 23:55:21  [  787.853833]  [<ffffffff81144fcd>] __do_fault+0x5d/0x110
Apr 21 23:55:21  [  787.853945]  [<ffffffff81148e34>] 
handle_mm_fault+0x1154/0x1b00
Apr 21 23:55:21  [  787.854058]  [<ffffffff81042ee1>] 
__do_page_fault+0x121/0x360
Apr 21 23:55:21  [  787.854170]  [<ffffffff8104315c>] do_page_fault+0xc/0x10
Apr 21 23:55:21  [  787.854282]  [<ffffffff814dab8f>] page_fault+0x1f/0x30
Apr 21 23:55:21  [  787.854395]  [<ffffffff812ec4f2>] ? 
copy_user_enhanced_fast_string+0x2/0x10
Apr 21 23:55:21  [  787.854510]  [<ffffffff812f25bc>] ? 
copy_from_iter+0x7c/0x260
Apr 21 23:55:21  [  787.854622]  [<ffffffff8143a448>] 
tcp_sendmsg+0xaa8/0xae0
Apr 21 23:55:21  [  787.854736]  [<ffffffff814631d0>] inet_sendmsg+0x60/0x90
Apr 21 23:55:21  [  787.854847]  [<ffffffff813d4da3>] sock_sendmsg+0x33/0x40
Apr 21 23:55:21  [  787.854959]  [<ffffffff813d51cf>] SYSC_sendto+0xef/0x170
Apr 21 23:55:21  [  787.855071]  [<ffffffff811363e8>] ? 
vm_mmap_pgoff+0x98/0xc0
Apr 21 23:55:21  [  787.855185]  [<ffffffff8114e075>] ? 
SyS_mmap_pgoff+0xe5/0x270
Apr 21 23:55:21  [  787.855297]  [<ffffffff813d5bc9>] SyS_sendto+0x9/0x10
Apr 21 23:55:21  [  787.855409]  [<ffffffff814d8f1b>] 
entry_SYSCALL_64_fastpath+0x16/0x6e
Apr 21 23:55:21  [  788.267238] NMI watchdog: Watchdog detected hard 
LOCKUP on cpu 6
Apr 21 23:55:21
Apr 21 23:55:21  [  788.267327] Modules linked in:
Apr 21 23:55:21   iptable_mangle
Apr 21 23:55:21   netconsole
Apr 21 23:55:21   configfs
Apr 21 23:55:21   tun
Apr 21 23:55:21   xt_multiport
Apr 21 23:55:21   ip6table_filter
Apr 21 23:55:21   ip6_tables
Apr 21 23:55:21   iptable_filter
Apr 21 23:55:21   ip_tables
Apr 21 23:55:21   x_tables
Apr 21 23:55:21   bridge
Apr 21 23:55:21   stp
Apr 21 23:55:21   llc
Apr 21 23:55:21   bonding
Apr 21 23:55:21   ext4
Apr 21 23:55:21   crc16
Apr 21 23:55:21   mbcache
Apr 21 23:55:21   jbd2
Apr 21 23:55:21   raid1
Apr 21 23:55:21   raid0
Apr 21 23:55:21   raid456
Apr 21 23:55:21   async_raid6_recov
Apr 21 23:55:21   async_memcpy
Apr 21 23:55:21   async_pq
Apr 21 23:55:21   async_xor
Apr 21 23:55:21   xor
Apr 21 23:55:21   async_tx
Apr 21 23:55:21   raid6_pq
Apr 21 23:55:21   md_mod
Apr 21 23:55:21   sg
Apr 21 23:55:21   sd_mod
Apr 21 23:55:21   hid_generic
Apr 21 23:55:21   usbhid
Apr 21 23:55:21   hid
Apr 21 23:55:21   iTCO_wdt
Apr 21 23:55:21   iTCO_vendor_support
Apr 21 23:55:21   x86_pkg_temp_thermal
Apr 21 23:55:21   intel_powerclamp
Apr 21 23:55:21   coretemp
Apr 21 23:55:21   crct10dif_pclmul
Apr 21 23:55:21   crc32_pclmul
Apr 21 23:55:21   crc32c_intel
Apr 21 23:55:21   ghash_clmulni_intel
Apr 21 23:55:21   cryptd
Apr 21 23:55:21   xhci_pci
Apr 21 23:55:21   ahci
Apr 21 23:55:21   igb
Apr 21 23:55:21   ehci_pci
Apr 21 23:55:21   i2c_algo_bit
Apr 21 23:55:21   xhci_hcd
Apr 21 23:55:21   ptp
Apr 21 23:55:21   ehci_hcd
Apr 21 23:55:21   libahci
Apr 21 23:55:21   mpt3sas
Apr 21 23:55:21   sb_edac
Apr 21 23:55:21   i2c_i801
Apr 21 23:55:21   pps_core
Apr 21 23:55:21   edac_core
Apr 21 23:55:21   mei_me
Apr 21 23:55:21   raid_class
Apr 21 23:55:21   lpc_ich
Apr 21 23:55:21   libata
Apr 21 23:55:21   scsi_transport_sas
Apr 21 23:55:21   usbcore
Apr 21 23:55:21   mfd_core
Apr 21 23:55:21   mei
Apr 21 23:55:21   usb_common
Apr 21 23:55:21   i2c_core
Apr 21 23:55:21   ioatdma
Apr 21 23:55:21   scsi_mod
Apr 21 23:55:21   dca
Apr 21 23:55:21   ipmi_si
Apr 21 23:55:21   ipmi_msghandler
Apr 21 23:55:21   acpi_power_meter
Apr 21 23:55:21   acpi_pad
Apr 21 23:55:21   tpm_tis
Apr 21 23:55:21   tpm
Apr 21 23:55:21   processor
Apr 21 23:55:21   button
Apr 21 23:55:21
Apr 21 23:55:21  [  788.273235] CPU: 6 PID: 12760 Comm: rtorrent main 
Not tainted 4.5.1 #1
Apr 21 23:55:21  [  788.273337] Hardware name: Supermicro Super 
Server/X10DRi-LN4+, BIOS 1.0b 01/29/2015
Apr 21 23:55:21  [  788.273454]  0000000000000000
Apr 21 23:55:21   ffff881fffcc5bd0
Apr 21 23:55:21   ffffffff812e00b8
Apr 21 23:55:21   0000000000000000
Apr 21 23:55:21
Apr 21 23:55:21  [  788.273827]  0000000000000000
Apr 21 23:55:21   ffff881fffcc5be8
Apr 21 23:55:21   ffffffff810dff1d
Apr 21 23:55:21   ffff881ff2fc8000
Apr 21 23:55:21
Apr 21 23:55:21  [  788.274193]  ffff881fffcc5c20
Apr 21 23:55:21   ffffffff8110f8f8
Apr 21 23:55:21   0000000000000001
Apr 21 23:55:21   ffff881fffccaf00
Apr 21 23:55:21
Apr 21 23:55:21  [  788.274564] Call Trace:
Apr 21 23:55:21  [  788.274650]  <NMI>
Apr 21 23:55:21   [<ffffffff812e00b8>] dump_stack+0x4d/0x65
Apr 21 23:55:21  [  788.274815]  [<ffffffff810dff1d>] 
watchdog_overflow_callback+0xdd/0xf0
Apr 21 23:55:21  [  788.274913]  [<ffffffff8110f8f8>] 
__perf_event_overflow+0x88/0x1d0
Apr 21 23:55:21  [  788.275010]  [<ffffffff811103e4>] 
perf_event_overflow+0x14/0x20
Apr 21 23:55:21  [  788.275106]  [<ffffffff8101e320>] 
intel_pmu_handle_irq+0x1d0/0x4a0
Apr 21 23:55:21  [  788.275203]  [<ffffffff810162d8>] 
perf_event_nmi_handler+0x28/0x50
Apr 21 23:55:21  [  788.275299]  [<ffffffff81008121>] nmi_handle+0x61/0x110
Apr 21 23:55:21  [  788.275392]  [<ffffffff810082e7>] do_nmi+0x117/0x3e0
Apr 21 23:55:21  [  788.275487]  [<ffffffff814dae97>] 
end_repeat_nmi+0x1a/0x1e
Apr 21 23:55:21  [  788.275582]  [<ffffffff81090cc5>] ? 
queued_spin_lock_slowpath+0xf5/0x170
Apr 21 23:55:21  [  788.275678]  [<ffffffff81090cc5>] ? 
queued_spin_lock_slowpath+0xf5/0x170
Apr 21 23:55:21  [  788.275773]  [<ffffffff81090cc5>] ? 
queued_spin_lock_slowpath+0xf5/0x170
Apr 21 23:55:21  [  788.275868]  <<EOE>>
Apr 21 23:55:21   [<ffffffff814d8c6c>] _raw_spin_lock_irq+0x1c/0x20
Apr 21 23:55:21  [  788.276030]  [<ffffffffa01cd5d4>] 
raid5_make_request+0x6d4/0xce0 [raid456]
Apr 21 23:55:21  [  788.276128]  [<ffffffff812b824f>] ? 
generic_make_request+0x1f/0x1c0
Apr 21 23:55:21  [  788.276225]  [<ffffffff812bdc23>] ? 
blk_queue_split+0xb3/0x530
Apr 21 23:55:21  [  788.276321]  [<ffffffff8108bd90>] ? wait_woken+0x80/0x80
Apr 21 23:55:21  [  788.276416]  [<ffffffffa0110e43>] 
md_make_request+0xd3/0x210 [md_mod]
Apr 21 23:55:21  [  788.276512]  [<ffffffff812b8319>] 
generic_make_request+0xe9/0x1c0
Apr 21 23:55:21  [  788.276607]  [<ffffffff812b8452>] submit_bio+0x62/0x150
Apr 21 23:55:21  [  788.276702]  [<ffffffff81127e05>] ? 
__pagevec_lru_add_fn+0x105/0x1e0
Apr 21 23:55:21  [  788.276798]  [<ffffffff811c6f90>] 
do_mpage_readpage+0x2f0/0x6a0
Apr 21 23:55:21  [  788.276893]  [<ffffffff811286d9>] ? 
lru_cache_add+0x9/0x10
Apr 21 23:55:21  [  788.276986]  [<ffffffff811c7450>] 
mpage_readpages+0x110/0x170
Apr 21 23:55:21  [  788.277081]  [<ffffffff81246040>] ? 
__xfs_get_blocks+0x810/0x810
Apr 21 23:55:21  [  788.277175]  [<ffffffff81246040>] ? 
__xfs_get_blocks+0x810/0x810
Apr 21 23:55:21  [  788.277271]  [<ffffffff8116633d>] ? 
alloc_pages_current+0x8d/0x110
Apr 21 23:55:21  [  788.277366]  [<ffffffff812442f3>] 
xfs_vm_readpages+0x33/0x80
Apr 21 23:55:21  [  788.277460]  [<ffffffff81126585>] 
__do_page_cache_readahead+0x165/0x210
Apr 21 23:55:21  [  788.277557]  [<ffffffff8111b1c7>] 
filemap_fault+0x427/0x4d0
Apr 21 23:55:21  [  788.277651]  [<ffffffff814d756d>] ? down_read+0xd/0x20
Apr 21 23:55:21  [  788.277744]  [<ffffffff8124fe20>] 
xfs_filemap_fault+0x40/0xa0
Apr 21 23:55:21  [  788.277840]  [<ffffffff81144fcd>] __do_fault+0x5d/0x110
Apr 21 23:55:21  [  788.277933]  [<ffffffff81148e34>] 
handle_mm_fault+0x1154/0x1b00
Apr 21 23:55:21  [  788.278029]  [<ffffffff81042ee1>] 
__do_page_fault+0x121/0x360
Apr 21 23:55:21  [  788.278123]  [<ffffffff8104315c>] do_page_fault+0xc/0x10
Apr 21 23:55:21  [  788.278216]  [<ffffffff814dab8f>] page_fault+0x1f/0x30
Apr 21 23:55:21  [  788.278311]  [<ffffffff812ec4f2>] ? 
copy_user_enhanced_fast_string+0x2/0x10
Apr 21 23:55:21  [  788.278410]  [<ffffffff812f25bc>] ? 
copy_from_iter+0x7c/0x260
Apr 21 23:55:21  [  788.278505]  [<ffffffff81439f78>] 
tcp_sendmsg+0x5d8/0xae0
Apr 21 23:55:21  [  788.278600]  [<ffffffff814631d0>] inet_sendmsg+0x60/0x90
Apr 21 23:55:21  [  788.278694]  [<ffffffff813d4da3>] sock_sendmsg+0x33/0x40
Apr 21 23:55:21  [  788.278787]  [<ffffffff813d51cf>] SYSC_sendto+0xef/0x170
Apr 21 23:55:21  [  788.278880]  [<ffffffff813d5bc9>] SyS_sendto+0x9/0x10
Apr 21 23:55:21  [  788.278973]  [<ffffffff814d8f1b>] 
entry_SYSCALL_64_fastpath+0x16/0x6e
Apr 21 23:55:23  [  790.117129] NMI watchdog: Watchdog detected hard 
LOCKUP on cpu 3
Apr 21 23:55:23
Apr 21 23:55:23  [  790.117222] Modules linked in:
Apr 21 23:55:23   iptable_mangle
Apr 21 23:55:23   netconsole
Apr 21 23:55:23   configfs
Apr 21 23:55:23   tun
Apr 21 23:55:23   xt_multiport
Apr 21 23:55:23   ip6table_filter
Apr 21 23:55:23   ip6_tables
Apr 21 23:55:23   iptable_filter
Apr 21 23:55:23   ip_tables
Apr 21 23:55:23   x_tables
Apr 21 23:55:23   bridge
Apr 21 23:55:23   stp
Apr 21 23:55:23   llc
Apr 21 23:55:23   bonding
Apr 21 23:55:23   ext4
Apr 21 23:55:23   crc16
Apr 21 23:55:23   mbcache
Apr 21 23:55:23   jbd2
Apr 21 23:55:23   raid1
Apr 21 23:55:23   raid0
Apr 21 23:55:23   raid456
Apr 21 23:55:23   async_raid6_recov
Apr 21 23:55:23   async_memcpy
Apr 21 23:55:23   async_pq
Apr 21 23:55:23   async_xor
Apr 21 23:55:23   xor
Apr 21 23:55:23   async_tx
Apr 21 23:55:23   raid6_pq
Apr 21 23:55:23   md_mod
Apr 21 23:55:23   sg
Apr 21 23:55:23   sd_mod
Apr 21 23:55:23   hid_generic
Apr 21 23:55:23   usbhid
Apr 21 23:55:23   hid
Apr 21 23:55:23   iTCO_wdt
Apr 21 23:55:23   iTCO_vendor_support
Apr 21 23:55:23   x86_pkg_temp_thermal
Apr 21 23:55:23   intel_powerclamp
Apr 21 23:55:23   coretemp
Apr 21 23:55:23   crct10dif_pclmul
Apr 21 23:55:23   crc32_pclmul
Apr 21 23:55:23   crc32c_intel
Apr 21 23:55:23   ghash_clmulni_intel
Apr 21 23:55:23   cryptd
Apr 21 23:55:23   xhci_pci
Apr 21 23:55:23   ahci
Apr 21 23:55:23   igb
Apr 21 23:55:23   ehci_pci
Apr 21 23:55:23   i2c_algo_bit
Apr 21 23:55:23   xhci_hcd
Apr 21 23:55:23   ptp
Apr 21 23:55:23   ehci_hcd
Apr 21 23:55:23   libahci
Apr 21 23:55:23   mpt3sas
Apr 21 23:55:23   sb_edac
Apr 21 23:55:23   i2c_i801
Apr 21 23:55:23   pps_core
Apr 21 23:55:23   edac_core
Apr 21 23:55:23   mei_me
Apr 21 23:55:23   raid_class
Apr 21 23:55:23   lpc_ich
Apr 21 23:55:23   libata
Apr 21 23:55:23   scsi_transport_sas
Apr 21 23:55:23   usbcore
Apr 21 23:55:23   mfd_core
Apr 21 23:55:23   mei
Apr 21 23:55:23   usb_common
Apr 21 23:55:23   i2c_core
Apr 21 23:55:23   ioatdma
Apr 21 23:55:23   scsi_mod
Apr 21 23:55:23   dca
Apr 21 23:55:23   ipmi_si
Apr 21 23:55:23   ipmi_msghandler
Apr 21 23:55:23   acpi_power_meter
Apr 21 23:55:23   acpi_pad
Apr 21 23:55:23   tpm_tis
Apr 21 23:55:23   tpm
Apr 21 23:55:23   processor
Apr 21 23:55:23   button
Apr 21 23:55:23
Apr 21 23:55:23  [  790.127050] CPU: 3 PID: 785 Comm: md11_raid5 Not 
tainted 4.5.1 #1
Apr 21 23:55:23  [  790.127145] Hardware name: Supermicro Super 
Server/X10DRi-LN4+, BIOS 1.0b 01/29/2015
Apr 21 23:55:23  [  790.127261]  0000000000000000
Apr 21 23:55:23   ffff881fffc65bd0
Apr 21 23:55:23   ffffffff812e00b8
Apr 21 23:55:23   0000000000000000
Apr 21 23:55:23
Apr 21 23:55:23  [  790.127630]  0000000000000000
Apr 21 23:55:23   ffff881fffc65be8
Apr 21 23:55:23   ffffffff810dff1d
Apr 21 23:55:23   ffff881ff2f10000
Apr 21 23:55:23
Apr 21 23:55:23  [  790.127999]  ffff881fffc65c20
Apr 21 23:55:23   ffffffff8110f8f8
Apr 21 23:55:23   0000000000000001
Apr 21 23:55:23   ffff881fffc6af00
Apr 21 23:55:23
Apr 21 23:55:23  [  790.128365] Call Trace:
Apr 21 23:55:23  [  790.128451]  <NMI>
Apr 21 23:55:23   [<ffffffff812e00b8>] dump_stack+0x4d/0x65
Apr 21 23:55:23  [  790.128620]  [<ffffffff810dff1d>] 
watchdog_overflow_callback+0xdd/0xf0
Apr 21 23:55:23  [  790.128720]  [<ffffffff8110f8f8>] 
__perf_event_overflow+0x88/0x1d0
Apr 21 23:55:23  [  790.128816]  [<ffffffff811103e4>] 
perf_event_overflow+0x14/0x20
Apr 21 23:55:23  [  790.128912]  [<ffffffff8101e320>] 
intel_pmu_handle_irq+0x1d0/0x4a0
Apr 21 23:55:23  [  790.129012]  [<ffffffff810162d8>] 
perf_event_nmi_handler+0x28/0x50
Apr 21 23:55:23  [  790.129111]  [<ffffffff81008121>] nmi_handle+0x61/0x110
Apr 21 23:55:23  [  790.129211]  [<ffffffff810083d1>] do_nmi+0x201/0x3e0
Apr 21 23:55:23  [  790.129308]  [<ffffffff814dae97>] 
end_repeat_nmi+0x1a/0x1e
Apr 21 23:55:23  [  790.129403]  [<ffffffff81090d23>] ? 
queued_spin_lock_slowpath+0x153/0x170
Apr 21 23:55:23  [  790.129499]  [<ffffffff81090d23>] ? 
queued_spin_lock_slowpath+0x153/0x170
Apr 21 23:55:23  [  790.129600]  [<ffffffff81090d23>] ? 
queued_spin_lock_slowpath+0x153/0x170
Apr 21 23:55:23  [  790.129696]  <<EOE>>
Apr 21 23:55:23   [<ffffffff814d8c6c>] _raw_spin_lock_irq+0x1c/0x20
Apr 21 23:55:23  [  790.129865]  [<ffffffffa01d031b>] 
handle_active_stripes.isra.55+0x1ab/0x4b0 [raid456]
Apr 21 23:55:23  [  790.129982]  [<ffffffffa01d0aa9>] raid5d+0x489/0x720 
[raid456]
Apr 21 23:55:23  [  790.130081]  [<ffffffff810a4830>] ? 
trace_event_raw_event_tick_stop+0x100/0x100
Apr 21 23:55:23  [  790.130200]  [<ffffffffa011074b>] 
md_thread+0x12b/0x130 [md_mod]
Apr 21 23:55:23  [  790.130299]  [<ffffffff8108bd90>] ? wait_woken+0x80/0x80
Apr 21 23:55:23  [  790.130398]  [<ffffffffa0110620>] ? 
find_pers+0x70/0x70 [md_mod]
Apr 21 23:55:23  [  790.130494]  [<ffffffff8106c926>] kthread+0xd6/0xf0
Apr 21 23:55:23  [  790.130586]  [<ffffffff8106c850>] ? 
kthread_park+0x50/0x50
Apr 21 23:55:23  [  790.130683]  [<ffffffff814d92af>] 
ret_from_fork+0x3f/0x70
Apr 21 23:55:23  [  790.130780]  [<ffffffff8106c850>] ? 
kthread_park+0x50/0x50
Apr 21 23:55:25  [  791.957594] NMI watchdog: Watchdog detected hard 
LOCKUP on cpu 17
Apr 21 23:55:25
Apr 21 23:55:25  [  791.958139] Modules linked in:
Apr 21 23:55:25   iptable_mangle
Apr 21 23:55:25   netconsole
Apr 21 23:55:25   configfs
Apr 21 23:55:25   tun
Apr 21 23:55:25   xt_multiport
Apr 21 23:55:25   ip6table_filter
Apr 21 23:55:25   ip6_tables
Apr 21 23:55:25   iptable_filter
Apr 21 23:55:25   ip_tables
Apr 21 23:55:25   x_tables
Apr 21 23:55:25   bridge
Apr 21 23:55:25   stp
Apr 21 23:55:25   llc
Apr 21 23:55:25   bonding
Apr 21 23:55:25   ext4
Apr 21 23:55:25   crc16
Apr 21 23:55:25   mbcache
Apr 21 23:55:25   jbd2
Apr 21 23:55:25   raid1
Apr 21 23:55:25   raid0
Apr 21 23:55:25   raid456
Apr 21 23:55:25   async_raid6_recov
Apr 21 23:55:25   async_memcpy
Apr 21 23:55:25   async_pq
Apr 21 23:55:25   async_xor
Apr 21 23:55:25   xor
Apr 21 23:55:25   async_tx
Apr 21 23:55:25   raid6_pq
Apr 21 23:55:25   md_mod
Apr 21 23:55:25   sg
Apr 21 23:55:25   sd_mod
Apr 21 23:55:25   hid_generic
Apr 21 23:55:25   usbhid
Apr 21 23:55:25   hid
Apr 21 23:55:25   iTCO_wdt
Apr 21 23:55:25   iTCO_vendor_support
Apr 21 23:55:25   x86_pkg_temp_thermal
Apr 21 23:55:25   intel_powerclamp
Apr 21 23:55:25   coretemp
Apr 21 23:55:25   crct10dif_pclmul
Apr 21 23:55:25   crc32_pclmul
Apr 21 23:55:25   crc32c_intel
Apr 21 23:55:25   ghash_clmulni_intel
Apr 21 23:55:25   cryptd
Apr 21 23:55:25   xhci_pci
Apr 21 23:55:25   ahci
Apr 21 23:55:25   igb
Apr 21 23:55:25   ehci_pci
Apr 21 23:55:25   i2c_algo_bit
Apr 21 23:55:25   xhci_hcd
Apr 21 23:55:25   ptp
Apr 21 23:55:25   ehci_hcd
Apr 21 23:55:25   libahci
Apr 21 23:55:25   mpt3sas
Apr 21 23:55:25   sb_edac
Apr 21 23:55:25   i2c_i801
Apr 21 23:55:25   pps_core
Apr 21 23:55:25   edac_core
Apr 21 23:55:25   mei_me
Apr 21 23:55:25   raid_class
Apr 21 23:55:25   lpc_ich
Apr 21 23:55:25   libata
Apr 21 23:55:25   scsi_transport_sas
Apr 21 23:55:25   usbcore
Apr 21 23:55:25   mfd_core
Apr 21 23:55:25   mei
Apr 21 23:55:25   usb_common
Apr 21 23:55:25   i2c_core
Apr 21 23:55:25   ioatdma
Apr 21 23:55:25   scsi_mod
Apr 21 23:55:25   dca
Apr 21 23:55:25   ipmi_si
Apr 21 23:55:25   ipmi_msghandler
Apr 21 23:55:25   acpi_power_meter
Apr 21 23:55:25   acpi_pad
Apr 21 23:55:25   tpm_tis
Apr 21 23:55:25   tpm
Apr 21 23:55:25   processor
Apr 21 23:55:25   button
Apr 21 23:55:25
Apr 21 23:55:25  [  791.964341] CPU: 17 PID: 18101 Comm: rtorrent main 
Not tainted 4.5.1 #1
Apr 21 23:55:25  [  791.964443] Hardware name: Supermicro Super 
Server/X10DRi-LN4+, BIOS 1.0b 01/29/2015
Apr 21 23:55:25  [  791.964567]  0000000000000000
Apr 21 23:55:25   ffff881fffd25bd0
Apr 21 23:55:25   ffffffff812e00b8
Apr 21 23:55:25   0000000000000000
Apr 21 23:55:25
Apr 21 23:55:25  [  791.964968]  0000000000000000
Apr 21 23:55:25   ffff881fffd25be8
Apr 21 23:55:25   ffffffff810dff1d
Apr 21 23:55:25   ffff881ff2890000
Apr 21 23:55:25
Apr 21 23:55:25  [  791.965369]  ffff881fffd25c20
Apr 21 23:55:25   ffffffff8110f8f8
Apr 21 23:55:25   0000000000000001
Apr 21 23:55:25   ffff881fffd2af00
Apr 21 23:55:25
Apr 21 23:55:25  [  791.965773] Call Trace:
Apr 21 23:55:25  [  791.965867]  <NMI>
Apr 21 23:55:25   [<ffffffff812e00b8>] dump_stack+0x4d/0x65
Apr 21 23:55:25  [  791.966053]  [<ffffffff810dff1d>] 
watchdog_overflow_callback+0xdd/0xf0
Apr 21 23:55:25  [  791.966161]  [<ffffffff8110f8f8>] 
__perf_event_overflow+0x88/0x1d0
Apr 21 23:55:25  [  791.966264]  [<ffffffff811103e4>] 
perf_event_overflow+0x14/0x20
Apr 21 23:55:25  [  791.966368]  [<ffffffff8101e320>] 
intel_pmu_handle_irq+0x1d0/0x4a0
Apr 21 23:55:25  [  791.966473]  [<ffffffff810162d8>] 
perf_event_nmi_handler+0x28/0x50
Apr 21 23:55:25  [  791.966577]  [<ffffffff81008121>] nmi_handle+0x61/0x110
Apr 21 23:55:25  [  791.966677]  [<ffffffff810083d1>] do_nmi+0x201/0x3e0
Apr 21 23:55:25  [  791.966778]  [<ffffffff814dae97>] 
end_repeat_nmi+0x1a/0x1e
Apr 21 23:55:25  [  791.966881]  [<ffffffff81090cd9>] ? 
queued_spin_lock_slowpath+0x109/0x170
Apr 21 23:55:25  [  791.966984]  [<ffffffff81090cd9>] ? 
queued_spin_lock_slowpath+0x109/0x170
Apr 21 23:55:25  [  791.967088]  [<ffffffff81090cd9>] ? 
queued_spin_lock_slowpath+0x109/0x170
Apr 21 23:55:25  [  791.967197]  <<EOE>>
Apr 21 23:55:25   [<ffffffff814d8c6c>] _raw_spin_lock_irq+0x1c/0x20
Apr 21 23:55:25  [  791.967376]  [<ffffffffa01cd5d4>] 
raid5_make_request+0x6d4/0xce0 [raid456]
Apr 21 23:55:25  [  791.967484]  [<ffffffff81217c3d>] ? 
xfs_bmap_search_extents+0x7d/0x100
Apr 21 23:55:25  [  791.967590]  [<ffffffff8108bd90>] ? wait_woken+0x80/0x80
Apr 21 23:55:25  [  791.967693]  [<ffffffffa0110e43>] 
md_make_request+0xd3/0x210 [md_mod]
Apr 21 23:55:25  [  791.967799]  [<ffffffff812b8319>] 
generic_make_request+0xe9/0x1c0
Apr 21 23:55:25  [  791.967903]  [<ffffffff812b8452>] submit_bio+0x62/0x150
Apr 21 23:55:25  [  791.968006]  [<ffffffff81127e05>] ? 
__pagevec_lru_add_fn+0x105/0x1e0
Apr 21 23:55:25  [  791.968110]  [<ffffffff811c6f90>] 
do_mpage_readpage+0x2f0/0x6a0
Apr 21 23:55:25  [  791.968213]  [<ffffffff811286d9>] ? 
lru_cache_add+0x9/0x10
Apr 21 23:55:25  [  791.968314]  [<ffffffff811c7450>] 
mpage_readpages+0x110/0x170
Apr 21 23:55:25  [  791.968420]  [<ffffffff81246040>] ? 
__xfs_get_blocks+0x810/0x810
Apr 21 23:55:25  [  791.968522]  [<ffffffff81246040>] ? 
__xfs_get_blocks+0x810/0x810
Apr 21 23:55:25  [  791.968626]  [<ffffffff8116633d>] ? 
alloc_pages_current+0x8d/0x110
Apr 21 23:55:25  [  791.968912]  [<ffffffff812442f3>] 
xfs_vm_readpages+0x33/0x80
Apr 21 23:55:25  [  791.969015]  [<ffffffff81126585>] 
__do_page_cache_readahead+0x165/0x210
Apr 21 23:55:25  [  791.969121]  [<ffffffff8111b1c7>] 
filemap_fault+0x427/0x4d0
Apr 21 23:55:25  [  791.969223]  [<ffffffff814d756d>] ? down_read+0xd/0x20
Apr 21 23:55:25  [  791.969325]  [<ffffffff8124fe20>] 
xfs_filemap_fault+0x40/0xa0
Apr 21 23:55:25  [  791.969429]  [<ffffffff81144fcd>] __do_fault+0x5d/0x110
Apr 21 23:55:25  [  791.969531]  [<ffffffff81148e34>] 
handle_mm_fault+0x1154/0x1b00
Apr 21 23:55:25  [  791.969635]  [<ffffffff810a49bf>] ? 
lock_timer_base.isra.34+0x4f/0x70
Apr 21 23:55:25  [  791.969741]  [<ffffffff81042ee1>] 
__do_page_fault+0x121/0x360
Apr 21 23:55:25  [  791.969842]  [<ffffffff8104315c>] do_page_fault+0xc/0x10
Apr 21 23:55:25  [  791.969944]  [<ffffffff814dab8f>] page_fault+0x1f/0x30
Apr 21 23:55:25  [  791.970047]  [<ffffffff812ec4f2>] ? 
copy_user_enhanced_fast_string+0x2/0x10
Apr 21 23:55:25  [  791.970152]  [<ffffffff812f25bc>] ? 
copy_from_iter+0x7c/0x260
Apr 21 23:55:25  [  791.970255]  [<ffffffff8143a448>] 
tcp_sendmsg+0xaa8/0xae0
Apr 21 23:55:25  [  791.970359]  [<ffffffff814631d0>] inet_sendmsg+0x60/0x90
Apr 21 23:55:25  [  791.970462]  [<ffffffff813d4da3>] sock_sendmsg+0x33/0x40
Apr 21 23:55:25  [  791.970562]  [<ffffffff813d51cf>] SYSC_sendto+0xef/0x170
Apr 21 23:55:25  [  791.970664]  [<ffffffff81042efe>] ? 
__do_page_fault+0x13e/0x360
Apr 21 23:55:25  [  791.970766]  [<ffffffff813d5bc9>] SyS_sendto+0x9/0x10
Apr 21 23:55:25  [  791.970868]  [<ffffffff814d8f1b>] 
entry_SYSCALL_64_fastpath+0x16/0x6e
Apr 21 23:55:26  [  793.219426] NMI watchdog: Watchdog detected hard 
LOCKUP on cpu 0
Apr 21 23:55:26
Apr 21 23:55:26  [  793.219517] Modules linked in:
Apr 21 23:55:26   iptable_mangle
Apr 21 23:55:26   netconsole
Apr 21 23:55:26   configfs
Apr 21 23:55:26   tun
Apr 21 23:55:26   xt_multiport
Apr 21 23:55:26   ip6table_filter
Apr 21 23:55:26   ip6_tables
Apr 21 23:55:26   iptable_filter
Apr 21 23:55:26   ip_tables
Apr 21 23:55:26   x_tables
Apr 21 23:55:26   bridge
Apr 21 23:55:26   stp
Apr 21 23:55:26   llc
Apr 21 23:55:26   bonding
Apr 21 23:55:26   ext4
Apr 21 23:55:26   crc16
Apr 21 23:55:26   mbcache
Apr 21 23:55:26   jbd2
Apr 21 23:55:26   raid1
Apr 21 23:55:26   raid0
Apr 21 23:55:26   raid456
Apr 21 23:55:26   async_raid6_recov
Apr 21 23:55:26   async_memcpy
Apr 21 23:55:26   async_pq
Apr 21 23:55:26   async_xor
Apr 21 23:55:26   xor
Apr 21 23:55:26   async_tx
Apr 21 23:55:26   raid6_pq
Apr 21 23:55:26   md_mod
Apr 21 23:55:26   sg
Apr 21 23:55:26   sd_mod
Apr 21 23:55:26   hid_generic
Apr 21 23:55:26   usbhid
Apr 21 23:55:26   hid
Apr 21 23:55:26   iTCO_wdt
Apr 21 23:55:26   iTCO_vendor_support
Apr 21 23:55:26   x86_pkg_temp_thermal
Apr 21 23:55:26   intel_powerclamp
Apr 21 23:55:26   coretemp
Apr 21 23:55:26   crct10dif_pclmul
Apr 21 23:55:26   crc32_pclmul
Apr 21 23:55:26   crc32c_intel
Apr 21 23:55:26   ghash_clmulni_intel
Apr 21 23:55:26   cryptd
Apr 21 23:55:26   xhci_pci
Apr 21 23:55:26   ahci
Apr 21 23:55:26   igb
Apr 21 23:55:26   ehci_pci
Apr 21 23:55:26   i2c_algo_bit
Apr 21 23:55:26   xhci_hcd
Apr 21 23:55:26   ptp
Apr 21 23:55:26   ehci_hcd
Apr 21 23:55:26   libahci
Apr 21 23:55:26   mpt3sas
Apr 21 23:55:26   sb_edac
Apr 21 23:55:26   i2c_i801
Apr 21 23:55:26   pps_core
Apr 21 23:55:26   edac_core
Apr 21 23:55:26   mei_me
Apr 21 23:55:26   raid_class
Apr 21 23:55:26   lpc_ich
Apr 21 23:55:26   libata
Apr 21 23:55:26   scsi_transport_sas
Apr 21 23:55:26   usbcore
Apr 21 23:55:26   mfd_core
Apr 21 23:55:26   mei
Apr 21 23:55:26   usb_common
Apr 21 23:55:26   i2c_core
Apr 21 23:55:26   ioatdma
Apr 21 23:55:26   scsi_mod
Apr 21 23:55:26   dca
Apr 21 23:55:26   ipmi_si
Apr 21 23:55:26   ipmi_msghandler
Apr 21 23:55:26   acpi_power_meter
Apr 21 23:55:26   acpi_pad
Apr 21 23:55:26   tpm_tis
Apr 21 23:55:26   tpm
Apr 21 23:55:26   processor
Apr 21 23:55:26   button
Apr 21 23:55:26
Apr 21 23:55:26  [  793.224979] CPU: 0 PID: 17378 Comm: rtorrent main 
Not tainted 4.5.1 #1
Apr 21 23:55:26  [  793.225075] Hardware name: Supermicro Super 
Server/X10DRi-LN4+, BIOS 1.0b 01/29/2015
Apr 21 23:55:26  [  793.225190]  0000000000000000
Apr 21 23:55:26   ffff881fffc05bd0
Apr 21 23:55:26   ffffffff812e00b8
Apr 21 23:55:26   0000000000000000
Apr 21 23:55:26
Apr 21 23:55:26  [  793.225552]  0000000000000000
Apr 21 23:55:26   ffff881fffc05be8
Apr 21 23:55:26   ffffffff810dff1d
Apr 21 23:55:26   ffff881fff832c00
Apr 21 23:55:26
Apr 21 23:55:26  [  793.225915]  ffff881fffc05c20
Apr 21 23:55:26   ffffffff8110f8f8
Apr 21 23:55:26   0000000000000001
Apr 21 23:55:26   ffff881fffc0af00
Apr 21 23:55:26
Apr 21 23:55:26  [  793.226277] Call Trace:
Apr 21 23:55:26  [  793.226363]  <NMI>
Apr 21 23:55:26   [<ffffffff812e00b8>] dump_stack+0x4d/0x65
Apr 21 23:55:26  [  793.226812]  [<ffffffff810dff1d>] 
watchdog_overflow_callback+0xdd/0xf0
Apr 21 23:55:26  [  793.226916]  [<ffffffff8110f8f8>] 
__perf_event_overflow+0x88/0x1d0
Apr 21 23:55:26  [  793.227014]  [<ffffffff811103e4>] 
perf_event_overflow+0x14/0x20
Apr 21 23:55:26  [  793.227112]  [<ffffffff8101e320>] 
intel_pmu_handle_irq+0x1d0/0x4a0
Apr 21 23:55:26  [  793.227210]  [<ffffffff810162d8>] 
perf_event_nmi_handler+0x28/0x50
Apr 21 23:55:26  [  793.227309]  [<ffffffff81008121>] nmi_handle+0x61/0x110
Apr 21 23:55:26  [  793.227405]  [<ffffffff810082e7>] do_nmi+0x117/0x3e0
Apr 21 23:55:26  [  793.227503]  [<ffffffff814dae97>] 
end_repeat_nmi+0x1a/0x1e
Apr 21 23:55:26  [  793.227600]  [<ffffffff81090cc1>] ? 
queued_spin_lock_slowpath+0xf1/0x170
Apr 21 23:55:26  [  793.227700]  [<ffffffff81090cc1>] ? 
queued_spin_lock_slowpath+0xf1/0x170
Apr 21 23:55:26  [  793.227797]  [<ffffffff81090cc1>] ? 
queued_spin_lock_slowpath+0xf1/0x170
Apr 21 23:55:26  [  793.227895]  <<EOE>>
Apr 21 23:55:26   [<ffffffff814d8c6c>] _raw_spin_lock_irq+0x1c/0x20
Apr 21 23:55:26  [  793.228071]  [<ffffffffa01cd5d4>] 
raid5_make_request+0x6d4/0xce0 [raid456]
Apr 21 23:55:26  [  793.228171]  [<ffffffff8111b520>] ? 
mempool_alloc_slab+0x10/0x20
Apr 21 23:55:26  [  793.228270]  [<ffffffff8108bd90>] ? wait_woken+0x80/0x80
Apr 21 23:55:26  [  793.228368]  [<ffffffffa0110e43>] 
md_make_request+0xd3/0x210 [md_mod]
Apr 21 23:55:26  [  793.228468]  [<ffffffff812b8319>] 
generic_make_request+0xe9/0x1c0
Apr 21 23:55:26  [  793.228564]  [<ffffffff812b8452>] submit_bio+0x62/0x150
Apr 21 23:55:26  [  793.228663]  [<ffffffff811c6425>] 
mpage_bio_submit+0x25/0x30
Apr 21 23:55:26  [  793.228759]  [<ffffffff811c7489>] 
mpage_readpages+0x149/0x170
Apr 21 23:55:26  [  793.228858]  [<ffffffff81246040>] ? 
__xfs_get_blocks+0x810/0x810
Apr 21 23:55:26  [  793.228953]  [<ffffffff81246040>] ? 
__xfs_get_blocks+0x810/0x810
Apr 21 23:55:26  [  793.229065]  [<ffffffff8116633d>] ? 
alloc_pages_current+0x8d/0x110
Apr 21 23:55:26  [  793.229168]  [<ffffffff812442f3>] 
xfs_vm_readpages+0x33/0x80
Apr 21 23:55:26  [  793.229265]  [<ffffffff81126585>] 
__do_page_cache_readahead+0x165/0x210
Apr 21 23:55:26  [  793.229368]  [<ffffffffa02cc397>] ? 
br_dev_xmit+0x137/0x1d0 [bridge]
Apr 21 23:55:26  [  793.229465]  [<ffffffff8111b1c7>] 
filemap_fault+0x427/0x4d0
Apr 21 23:55:26  [  793.229561]  [<ffffffff814d756d>] ? down_read+0xd/0x20
Apr 21 23:55:26  [  793.229656]  [<ffffffff8124fe20>] 
xfs_filemap_fault+0x40/0xa0
Apr 21 23:55:26  [  793.229754]  [<ffffffff81144fcd>] __do_fault+0x5d/0x110
Apr 21 23:55:26  [  793.229849]  [<ffffffff81148e34>] 
handle_mm_fault+0x1154/0x1b00
Apr 21 23:55:26  [  793.229947]  [<ffffffff81042ee1>] 
__do_page_fault+0x121/0x360
Apr 21 23:55:26  [  793.230042]  [<ffffffff8104315c>] do_page_fault+0xc/0x10
Apr 21 23:55:26  [  793.230137]  [<ffffffff814dab8f>] page_fault+0x1f/0x30
Apr 21 23:55:26  [  793.230233]  [<ffffffff812ec4f2>] ? 
copy_user_enhanced_fast_string+0x2/0x10
Apr 21 23:55:26  [  793.230332]  [<ffffffff812f25bc>] ? 
copy_from_iter+0x7c/0x260
Apr 21 23:55:26  [  793.230429]  [<ffffffff81439f78>] 
tcp_sendmsg+0x5d8/0xae0
Apr 21 23:55:26  [  793.230524]  [<ffffffff8114c8e1>] ? 
__vma_link_file+0x41/0x50
Apr 21 23:55:26  [  793.230622]  [<ffffffff814631d0>] inet_sendmsg+0x60/0x90
Apr 21 23:55:26  [  793.230717]  [<ffffffff813d4da3>] sock_sendmsg+0x33/0x40
Apr 21 23:55:26  [  793.230811]  [<ffffffff813d51cf>] SYSC_sendto+0xef/0x170
Apr 21 23:55:26  [  793.230907]  [<ffffffff811363e8>] ? 
vm_mmap_pgoff+0x98/0xc0
Apr 21 23:55:26  [  793.231003]  [<ffffffff8114e075>] ? 
SyS_mmap_pgoff+0xe5/0x270
Apr 21 23:55:26  [  793.231098]  [<ffffffff813d5bc9>] SyS_sendto+0x9/0x10
Apr 21 23:55:26  [  793.231192]  [<ffffffff814d8f1b>] 
entry_SYSCALL_64_fastpath+0x16/0x6e
Apr 21 23:55:27  [  793.895422] NMI watchdog: Watchdog detected hard 
LOCKUP on cpu 4

We are not using any additional modules for monitoring the servers other 
than plain ping warnings in case a server is not responding..

We have tried loading the optimized defaults in bios, the current 
motherboard is on an older bios just for testing and the problem is 
identical..

I just cannot find the problem here, it appears to die constantly.

Right now, i have taken it out of production, and im moving data over 
from that raids, it currently consists of 6 raid5's, i will move data 
between them one at the time and re-create the mdadm raid and the 
filesystem on them to see if there's a problem there.

Any other ideas?

Best regards
Daniel

Den 20-04-2016 kl. 17:29 skrev John Stoffel:
> Daniel,
>
> This is one of those hard problems to diagnose.  Can you take the
> system out of production and run some stress tests on it to see how it
> does?
>
> Have you updated all the firmware on the board?  Have you disabled
> hyperthreading as well?  Is there any overclocking or stuff like that
> happening?  If so, go back to the BIOS "safe" defaults.
>
> Do you have another system with the same hardware that's working fine
> in the same type of setup?  Then that does point to hardware.
>
> Is your power supply maxed out or near the limits?  Maybe you're
> getting a slight under-voltage?  Not likely... but you never know.
>
> And why is the kernel tainted?  Are you adding in third party modules?
> If so, remove them completely from the system.  SuperMicros don't
> generally require anything like that in my experience.
>
> Is it some of the extra monitoring modules you have installed?
>
> Good luck!
> John
>
>
>
>>>>>> "Daniel" == Daniel Walker <admin@ftwinc.net> writes:
> Daniel> Hi,
>
> Daniel> I upgraded the kernel to the latest stable with debugging enabled
> Daniel> (4.5.1) without any luck, this is what is outputted in dmesg:
>
>
> Daniel>     [262448.558983] INFO: task php:13376 blocked for more than 120 seconds.
> Daniel>     [262448.559057]       Tainted: G        W       4.5.1 #1
> Daniel>     [262448.559092] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> Daniel> disables this message.
> Daniel>     [262448.559246] php             D
> Daniel>      ffff88001c297a18
> Daniel>         0 13376  12277 0x00000000
> Daniel>     [262448.559519]  ffff88001c297a18
> Daniel>      ffff881ff248c100
> Daniel>      ffff880013e9b400
> Daniel>      ffff881fea472000
>
> Daniel>     [262448.559603]  ffff88001c297ae8
> Daniel>      ffff88001c298000
> Daniel>      ffff881c5cac1b30
> Daniel>      ffff880013e9b400
>
> Daniel>     [262448.560046]  0000000000020001
> Daniel>      0000000545ea7820
> Daniel>      ffff88001c297a30
> Daniel>      ffffffff814d5690
>
> Daniel>     [262448.560485] Call Trace:
> Daniel>     [262448.560541]  [<ffffffff814d5690>] schedule+0x30/0x80
> Daniel>     [262448.560761]  [<ffffffff814d823e>] schedule_timeout+0x21e/0x2a0
> Daniel>     [262448.560828]  [<ffffffff81217c3d>] ?
> Daniel> xfs_bmap_search_extents+0x7d/0x100
> Daniel>     [262448.561000]  [<ffffffff810902d9>] ? down_trylock+0x29/0x40
> Daniel>     [262448.561135]  [<ffffffff814d726f>] __down+0x5f/0xa0
> Daniel>     [262448.561268]  [<ffffffff8124bdd6>] ? _xfs_buf_find+0x156/0x350
> Daniel>     [262448.561347]  [<ffffffff8109032c>] down+0x3c/0x50
> Daniel>     [262448.561390]  [<ffffffff8124bbc7>] xfs_buf_lock+0x37/0xf0
> Daniel>     [262448.561435]  [<ffffffff8124bdd6>] _xfs_buf_find+0x156/0x350
> Daniel>     [262448.561557]  [<ffffffff8124bff5>] xfs_buf_get_map+0x25/0x280
> Daniel>     [262448.561603]  [<ffffffff81268f4b>] ? kmem_zone_alloc+0x7b/0x120
> Daniel>     [262448.561666]  [<ffffffff8124cbe8>] xfs_buf_read_map+0x28/0x180
> Daniel>     [262448.561768]  [<ffffffff8127830b>] xfs_trans_read_buf_map+0xeb/0x300
> Daniel>     [262448.561809]  [<ffffffff8123f7da>] xfs_imap_to_bp+0x5a/0xc0
> Daniel>     [262448.561881]  [<ffffffff8125b7a5>] xfs_iunlink_remove+0x275/0x3a0
> Daniel>     [262448.561943]  [<ffffffff81268f4b>] ? kmem_zone_alloc+0x7b/0x120
> Daniel>     [262448.561988]  [<ffffffff8125ec33>] xfs_ifree+0x33/0xd0
> Daniel>     [262448.562033]  [<ffffffff8125ed85>] xfs_inactive_ifree+0xb5/0x200
> Daniel>     [262448.562109]  [<ffffffff8125ef58>] xfs_inactive+0x88/0x110
> Daniel>     [262448.562296]  [<ffffffff81263f31>] xfs_fs_evict_inode+0xc1/0x110
> Daniel>     [262448.562344]  [<ffffffff811a42fb>] evict+0xbb/0x180
> Daniel>     [262448.562405]  [<ffffffff811a4bb3>] iput+0x193/0x200
> Daniel>     [262448.562483]  [<ffffffff811a08d2>] d_delete+0x122/0x160
> Daniel>     [262448.562520]  [<ffffffff81195b99>] vfs_rmdir+0xf9/0x120
> Daniel>     [262448.562559]  [<ffffffff81199d17>] do_rmdir+0x1b7/0x1d0
> Daniel>     [262448.562607]  [<ffffffff81001210>] ? exit_to_usermode_loop+0x90/0xb0
> Daniel>     [262448.562665]  [<ffffffff8119a921>] SyS_rmdir+0x11/0x20
> Daniel>     [262448.562891]  [<ffffffff814d8f1b>]
> Daniel> entry_SYSCALL_64_fastpath+0x16/0x6e
> Daniel>     [262489.707201] NMI watchdog: Watchdog detected hard LOCKUP on cpu 15
>
> Daniel>     [262489.707227] Modules linked in:
> Daniel>      ipt_MASQUERADE
> Daniel>      nf_nat_masquerade_ipv4
> Daniel>      iptable_nat
> Daniel>      nf_conntrack_ipv4
> Daniel>      nf_defrag_ipv4
> Daniel>      nf_nat_ipv4
> Daniel>      nf_nat
> Daniel>      nf_conntrack
> Daniel>      ipt_REJECT
> Daniel>      nf_reject_ipv4
> Daniel>      iptable_mangle
> Daniel>      netconsole
> Daniel>      configfs
> Daniel>      tun
> Daniel>      xt_multiport
> Daniel>      ip6table_filter
> Daniel>      ip6_tables
> Daniel>      iptable_filter
> Daniel>      ip_tables
> Daniel>      x_tables
> Daniel>      bridge
> Daniel>      stp
> Daniel>      llc
> Daniel>      bonding
> Daniel>      ext4
> Daniel>      crc16
> Daniel>      mbcache
> Daniel>      jbd2
> Daniel>      raid1
> Daniel>      raid0
> Daniel>      raid456
> Daniel>      async_raid6_recov
> Daniel>      async_memcpy
> Daniel>      async_pq
> Daniel>      async_xor
> Daniel>      xor
> Daniel>      async_tx
> Daniel>      raid6_pq
> Daniel>      md_mod
> Daniel>      sg
> Daniel>      sd_mod
> Daniel>      hid_generic
> Daniel>      usbhid
> Daniel>      hid
> Daniel>      x86_pkg_temp_thermal
> Daniel>      coretemp
> Daniel>      crct10dif_pclmul
> Daniel>      crc32_pclmul
> Daniel>      crc32c_intel
> Daniel>      ghash_clmulni_intel
> Daniel>      jitterentropy_rng
> Daniel>      sha256_ssse3
> Daniel>      iTCO_wdt
> Daniel>      sha256_generic
> Daniel>      iTCO_vendor_support
> Daniel>      hmac
> Daniel>      drbg
> Daniel>      xhci_pci
> Daniel>      ahci
> Daniel>      sb_edac
> Daniel>      ehci_pci
> Daniel>      ansi_cprng
> Daniel>      xhci_hcd
> Daniel>      ehci_hcd
> Daniel>      libahci
> Daniel>      i2c_i801
> Daniel>      edac_core
> Daniel>      lpc_ich
> Daniel>      mei_me
> Daniel>      mfd_core
> Daniel>      libata
> Daniel>      usbcore
> Daniel>      igb
> Daniel>      mei
> Daniel>      megaraid_sas
> Daniel>      i2c_algo_bit
> Daniel>      usb_common
> Daniel>      ptp
> Daniel>      aesni_intel
> Daniel>      pps_core
> Daniel>      aes_x86_64
> Daniel>      ioatdma
> Daniel>      lrw
> Daniel>      gf128mul
> Daniel>      glue_helper
> Daniel>      ablk_helper
> Daniel>      i2c_core
> Daniel>      scsi_mod
> Daniel>      dca
> Daniel>      cryptd
> Daniel>      ipmi_si
> Daniel>      ipmi_msghandler
> Daniel>      acpi_power_meter
> Daniel>      tpm_tis
> Daniel>      tpm
> Daniel>      processor
> Daniel>      button
>
> Daniel>     [262489.708066] CPU: 15 PID: 17535 Comm: kworker/u32:6 Tainted:
> Daniel> G        W       4.5.1 #1
> Daniel>     [262489.708124] Hardware name: Supermicro Super Server/X10DRi-LN4+,
> Daniel> BIOS 2.0 12/17/2015
> Daniel>     [262489.708187] Workqueue: writeback wb_workfn
> Daniel>      (flush-9:7)
>
> Daniel>     [262489.708228]  0000000000000000
> Daniel>      ffff88207fde5bd0
> Daniel>      ffffffff812e00b8
> Daniel>      0000000000000000
>
> Daniel>     [262489.708298]  0000000000000000
> Daniel>      ffff88207fde5be8
> Daniel>      ffffffff810dff1d
> Daniel>      ffff881ff2270000
>
> Daniel>     [262489.708368]  ffff88207fde5c20
> Daniel>      ffffffff8110f8f8
> Daniel>      0000000000000001
> Daniel>      ffff88207fdeaf00
>
> Daniel>     [262489.708438] Call Trace:
> Daniel>     [262489.708467]  <NMI>
> Daniel>      [<ffffffff812e00b8>] dump_stack+0x4d/0x65
> Daniel>     [262489.708512]  [<ffffffff810dff1d>]
> Daniel> watchdog_overflow_callback+0xdd/0xf0
> Daniel>     [262489.708552]  [<ffffffff8110f8f8>] __perf_event_overflow+0x88/0x1d0
> Daniel>     [262489.708589]  [<ffffffff811103e4>] perf_event_overflow+0x14/0x20
> Daniel>     [262489.708627]  [<ffffffff8101e320>] intel_pmu_handle_irq+0x1d0/0x4a0
> Daniel>     [262489.708666]  [<ffffffff81155481>] ? vunmap_page_range+0x1a1/0x310
> Daniel>     [262489.708703]  [<ffffffff811555fc>] ?
> Daniel> unmap_kernel_range_noflush+0xc/0x10
> Daniel>     [262489.708748]  [<ffffffff8135a543>] ?
> Daniel> ghes_copy_tofrom_phys+0x113/0x1e0
> Daniel>     [262489.708788]  [<ffffffff810359da>] ?
> Daniel> native_apic_wait_icr_idle+0x1a/0x30
> Daniel>     [262489.708827]  [<ffffffff810096e0>] ? arch_irq_work_raise+0x30/0x40
> Daniel>     [262489.708865]  [<ffffffff810162d8>] perf_event_nmi_handler+0x28/0x50
> Daniel>     [262489.708902]  [<ffffffff81008121>] nmi_handle+0x61/0x110
> Daniel>     [262489.708939]  [<ffffffff810082e7>] do_nmi+0x117/0x3e0
> Daniel>     [262489.708975]  [<ffffffff814dae97>] end_repeat_nmi+0x1a/0x1e
> Daniel>     [262489.709013]  [<ffffffffa01d05f0>] ? raid5_unplug+0x70/0x130
> Daniel> [raid456]
> Daniel>     [262489.709051]  [<ffffffffa01d05f0>] ? raid5_unplug+0x70/0x130
> Daniel> [raid456]
> Daniel>     [262489.709089]  [<ffffffffa01d05f0>] ? raid5_unplug+0x70/0x130
> Daniel> [raid456]
> Daniel>     [262489.709125]  <<EOE>>
> Daniel>      [<ffffffff812b9b98>] blk_flush_plug_list+0xa8/0x210
> Daniel>     [262489.709169]  [<ffffffff814d5de0>] ? bit_wait_timeout+0x70/0x70
> Daniel>     [262489.709206]  [<ffffffff814d4c04>] io_schedule_timeout+0x54/0x130
> Daniel>     [262489.709242]  [<ffffffff814d5df6>] bit_wait_io+0x16/0x60
> Daniel>     [262489.709277]  [<ffffffff814d5b59>] __wait_on_bit_lock+0x49/0xa0
> Daniel>     [262489.709314]  [<ffffffff81117fd0>] __lock_page+0xb0/0xc0
> Daniel>     [262489.709352]  [<ffffffff8108bdc0>] ?
> Daniel> autoremove_wake_function+0x30/0x30
> Daniel>     [262489.709391]  [<ffffffff811250f0>] write_cache_pages+0x2f0/0x4d0
> Daniel>     [262489.709427]  [<ffffffff81122df0>] ? wb_position_ratio+0x1f0/0x1f0
> Daniel>     [262489.709465]  [<ffffffff8112530e>] generic_writepages+0x3e/0x60
> Daniel>     [262489.709502]  [<ffffffff81244c18>] xfs_vm_writepages+0x38/0x40
> Daniel>     [262489.709539]  [<ffffffff81125e29>] do_writepages+0x19/0x30
> Daniel>     [262489.709574]  [<ffffffff811b5c50>]
> Daniel> __writeback_single_inode+0x40/0x310
> Daniel>     [262489.709612]  [<ffffffff811b6402>] writeback_sb_inodes+0x242/0x520
> Daniel>     [262489.709649]  [<ffffffff811b676a>] __writeback_inodes_wb+0x8a/0xc0
> Daniel>     [262489.709686]  [<ffffffff811b6a77>] wb_writeback+0x247/0x2d0
> Daniel>     [262489.709721]  [<ffffffff811b716f>] wb_workfn+0x20f/0x3c0
> Daniel>     [262489.709758]  [<ffffffff81067513>] process_one_work+0x143/0x400
> Daniel>     [262489.709795]  [<ffffffff81067cc1>] worker_thread+0x61/0x490
> Daniel>     [262489.709831]  [<ffffffff81067c60>] ? max_active_store+0x60/0x60
> Daniel>     [262489.709867]  [<ffffffff8106c926>] kthread+0xd6/0xf0
> Daniel>     [262489.709901]  [<ffffffff8106c850>] ? kthread_park+0x50/0x50
> Daniel>     [262489.709937]  [<ffffffff814d92af>] ret_from_fork+0x3f/0x70
> Daniel>     [262489.709972]  [<ffffffff8106c850>] ? kthread_park+0x50/0x50
> Daniel>     [262491.022971] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
>
> Daniel>     [262491.023470] Modules linked in:
> Daniel>      ipt_MASQUERADE
> Daniel>      nf_nat_masquerade_ipv4
> Daniel>      iptable_nat
> Daniel>      nf_conntrack_ipv4
> Daniel>      nf_defrag_ipv4
> Daniel>      nf_nat_ipv4
> Daniel>      nf_nat
> Daniel>      nf_conntrack
> Daniel>      ipt_REJECT
> Daniel>      nf_reject_ipv4
> Daniel>      iptable_mangle
> Daniel>      netconsole
> Daniel>      configfs
> Daniel>      tun
> Daniel>      xt_multiport
> Daniel>      ip6table_filter
> Daniel>      ip6_tables
> Daniel>      iptable_filter
> Daniel>      ip_tables
> Daniel>      x_tables
> Daniel>      bridge
> Daniel>      stp
> Daniel>      llc
> Daniel>      bonding
> Daniel>      ext4
> Daniel>      crc16
> Daniel>      mbcache
> Daniel>      jbd2
> Daniel>      raid1
> Daniel>      raid0
> Daniel>      raid456
> Daniel>      async_raid6_recov
> Daniel>      async_memcpy
> Daniel>      async_pq
> Daniel>      async_xor
> Daniel>      xor
> Daniel>      async_tx
> Daniel>      raid6_pq
> Daniel>      md_mod
> Daniel>      sg
> Daniel>      sd_mod
> Daniel>      hid_generic
> Daniel>      usbhid
> Daniel>      hid
> Daniel>      x86_pkg_temp_thermal
> Daniel>      coretemp
> Daniel>      crct10dif_pclmul
> Daniel>      crc32_pclmul
> Daniel>      crc32c_intel
> Daniel>      ghash_clmulni_intel
> Daniel>      jitterentropy_rng
> Daniel>      sha256_ssse3
> Daniel>      iTCO_wdt
> Daniel>      sha256_generic
> Daniel>      iTCO_vendor_support
> Daniel>      hmac
> Daniel>      drbg
> Daniel>      xhci_pci
> Daniel>      ahci
> Daniel>      sb_edac
> Daniel>      ehci_pci
> Daniel>      ansi_cprng
> Daniel>      xhci_hcd
> Daniel>      ehci_hcd
> Daniel>      libahci
> Daniel>      i2c_i801
> Daniel>      edac_core
> Daniel>      lpc_ich
> Daniel>      mei_me
> Daniel>      mfd_core
> Daniel>      libata
> Daniel>      usbcore
> Daniel>      igb
> Daniel>      mei
> Daniel>      megaraid_sas
> Daniel>      i2c_algo_bit
> Daniel>      usb_common
> Daniel>      ptp
> Daniel>      aesni_intel
> Daniel>      pps_core
> Daniel>      aes_x86_64
> Daniel>      ioatdma
> Daniel>      lrw
> Daniel>      gf128mul
> Daniel>      glue_helper
> Daniel>      ablk_helper
> Daniel>      i2c_core
> Daniel>      scsi_mod
> Daniel>      dca
> Daniel>      cryptd
> Daniel>      ipmi_si
> Daniel>      ipmi_msghandler
> Daniel>      acpi_power_meter
> Daniel>      tpm_tis
> Daniel>      tpm
> Daniel>      processor
> Daniel>      button
>
> Daniel>     [262491.029705] CPU: 0 PID: 1178 Comm: md7_raid5 Tainted: G
> Daniel> W       4.5.1 #1
> Daniel>     [262491.029776] Hardware name: Supermicro Super Server/X10DRi-LN4+,
> Daniel> BIOS 2.0 12/17/2015
> Daniel>     [262491.029849]  0000000000000000
> Daniel>      ffff88207fc05bd0
> Daniel>      ffffffff812e00b8
> Daniel>      0000000000000000
>
> Daniel>     [262491.029988]  0000000000000000
> Daniel>      ffff88207fc05be8
> Daniel>      ffffffff810dff1d
> Daniel>      ffff881fff032000
>
> Daniel>     [262491.030124]  ffff88207fc05c20
> Daniel>      ffffffff8110f8f8
> Daniel>      0000000000000001
> Daniel>      ffff88207fc0af00
>
> Daniel>     [262491.030260] Call Trace:
> Daniel>     [262491.030302]  <NMI>
> Daniel>      [<ffffffff812e00b8>] dump_stack+0x4d/0x65
> Daniel>     [262491.030377]  [<ffffffff810dff1d>]
> Daniel> watchdog_overflow_callback+0xdd/0xf0
> Daniel>     [262491.030432]  [<ffffffff8110f8f8>] __perf_event_overflow+0x88/0x1d0
> Daniel>     [262491.030484]  [<ffffffff811103e4>] perf_event_overflow+0x14/0x20
> Daniel>     [262491.030536]  [<ffffffff8101e320>] intel_pmu_handle_irq+0x1d0/0x4a0
> Daniel>     [262491.030589]  [<ffffffff81155481>] ? vunmap_page_range+0x1a1/0x310
> Daniel>     [262491.030640]  [<ffffffff811555fc>] ?
> Daniel> unmap_kernel_range_noflush+0xc/0x10
> Daniel>     [262491.030693]  [<ffffffff8135a543>] ?
> Daniel> ghes_copy_tofrom_phys+0x113/0x1e0
> Daniel>     [262491.030745]  [<ffffffff8135a681>] ? ghes_read_estatus+0x71/0x140
> Daniel>     [262491.030797]  [<ffffffff810162d8>] perf_event_nmi_handler+0x28/0x50
> Daniel>     [262491.030849]  [<ffffffff81008121>] nmi_handle+0x61/0x110
> Daniel>     [262491.030898]  [<ffffffff810083d1>] do_nmi+0x201/0x3e0
> Daniel>     [262491.030949]  [<ffffffff814dae97>] end_repeat_nmi+0x1a/0x1e
> Daniel>     [262491.030998]  [<ffffffff81090d23>] ?
> Daniel> queued_spin_lock_slowpath+0x153/0x170
> Daniel>     [262491.031050]  [<ffffffff81090d23>] ?
> Daniel> queued_spin_lock_slowpath+0x153/0x170
> Daniel>     [262491.031102]  [<ffffffff81090d23>] ?
> Daniel> queued_spin_lock_slowpath+0x153/0x170
> Daniel>     [262491.031153]  <<EOE>>
> Daniel>      [<ffffffff814d8c6c>] _raw_spin_lock_irq+0x1c/0x20
> Daniel>     [262491.031225]  [<ffffffffa01db6b1>] raid5d+0x91/0x720 [raid456]
> Daniel>     [262491.031276]  [<ffffffff810a4a8a>] ? try_to_del_timer_sync+0x4a/0x60
> Daniel>     [262491.031328]  [<ffffffff810a4ae3>] ? del_timer_sync+0x43/0x50
> Daniel>     [262491.031377]  [<ffffffff814d816e>] ? schedule_timeout+0x14e/0x2a0
> Daniel>     [262491.031428]  [<ffffffff810a4830>] ?
> Daniel> trace_event_raw_event_tick_stop+0x100/0x100
> Daniel>     [262491.031502]  [<ffffffffa017874b>] md_thread+0x12b/0x130 [md_mod]
> Daniel>     [262491.031555]  [<ffffffff8108bd90>] ? wait_woken+0x80/0x80
> Daniel>     [262491.031605]  [<ffffffffa0178620>] ? find_pers+0x70/0x70 [md_mod]
> Daniel>     [262491.031656]  [<ffffffff8106c926>] kthread+0xd6/0xf0
> Daniel>     [262491.031704]  [<ffffffff8106c850>] ? kthread_park+0x50/0x50
> Daniel>     [262491.031753]  [<ffffffff814d92af>] ret_from_fork+0x3f/0x70
> Daniel>     [262491.031802]  [<ffffffff8106c850>] ? kthread_park+0x50/0x50
> Daniel>     [262491.031753]  [<ffffffff814d92af>] ret_from_fork+0x3f/0x70
> Daniel>     [262491.031802]  [<ffffffff8106c850>] ? kthread_park+0x50/0x50
>
> Daniel> The server is hosting plain VPS's, there's a few that use it for
> Daniel> rtorrent which is quite disk extenssive, but from what I can see that
> Daniel> iowait is quite low.
>
> Daniel> There's absolutely nothing logged at all before the lockups, everythings
> Daniel> running fine and then suddenly it just crashes, im beginning to think we
> Daniel> might have a hardware problem, but im having a hard time finding the
> Daniel> actual issue.
>
> Daniel> Any ideas?
>
> Daniel> Best regards
>
>
> Daniel> Den 13-04-2016 kl. 19:00 skrev Shaohua Li:
>>> Looks there is a deadlock trying to hold the device_lock or hash_lock. anything
>>> abormal print out before the NMI watchdog? What is running in the machine?
>>> Looks this is old kernel, is it possible you can try a latest kernel and report
>>> back?
>>>
>>> Thanks,
>>> Shaohua
>>>
>>> On Tue, Apr 12, 2016 at 09:54:08PM +0000, Daniel Walker wrote:
>>>> Im having some issues on a brand new Supermicro server that we have running
>>>> in production along side a few other machines which are identical to this
>>>> server..
>>>>
>>>> The output from the netconsole attached to the server is here:
>>>>
>>>> Apr 12 21:34:45  [75704.964946] NMI watchdog: Watchdog detected hard LOCKUP
>>>> on cpu 6
>>>> Apr 12 21:34:45
>>>> Apr 12 21:34:45  [75704.964973] Modules linked in:
>>>> Apr 12 21:34:45   ipt_REJECT
>>>> Apr 12 21:34:45   nf_reject_ipv4
>>>> Apr 12 21:34:45   iptable_mangle
>>>> Apr 12 21:34:45   tun
>>>> Apr 12 21:34:45   netconsole
>>>> Apr 12 21:34:45   configfs
>>>> Apr 12 21:34:45   xt_multiport
>>>> Apr 12 21:34:45   ip6table_filter
>>>> Apr 12 21:34:45   ip6_tables
>>>> Apr 12 21:34:45   iptable_filter
>>>> Apr 12 21:34:45   ip_tables
>>>> Apr 12 21:34:45   x_tables
>>>> Apr 12 21:34:45   bridge
>>>> Apr 12 21:34:45   stp
>>>> Apr 12 21:34:45   llc
>>>> Apr 12 21:34:45   bonding
>>>> Apr 12 21:34:45   ext4
>>>> Apr 12 21:34:45   crc16
>>>> Apr 12 21:34:45   mbcache
>>>> Apr 12 21:34:45   jbd2
>>>> Apr 12 21:34:45   raid1
>>>> Apr 12 21:34:45   raid0
>>>> Apr 12 21:34:45   raid456
>>>> Apr 12 21:34:45   async_raid6_recov
>>>> Apr 12 21:34:45   async_memcpy
>>>> Apr 12 21:34:45   async_pq
>>>> Apr 12 21:34:45   async_xor
>>>> Apr 12 21:34:45   xor
>>>> Apr 12 21:34:45   async_tx
>>>> Apr 12 21:34:45   raid6_pq
>>>> Apr 12 21:34:45   md_mod
>>>> Apr 12 21:34:45   sr_mod
>>>> Apr 12 21:34:45   cdrom
>>>> Apr 12 21:34:45   usb_storage
>>>> Apr 12 21:34:45   hid_generic
>>>> Apr 12 21:34:45   usbhid
>>>> Apr 12 21:34:45   hid
>>>> Apr 12 21:34:45   sg
>>>> Apr 12 21:34:45   sd_mod
>>>> Apr 12 21:34:45   x86_pkg_temp_thermal
>>>> Apr 12 21:34:45   coretemp
>>>> Apr 12 21:34:45   crct10dif_pclmul
>>>> Apr 12 21:34:45   crc32_pclmul
>>>> Apr 12 21:34:45   crc32c_intel
>>>> Apr 12 21:34:45   jitterentropy_rng
>>>> Apr 12 21:34:45   sha256_ssse3
>>>> Apr 12 21:34:45   sha256_generic
>>>> Apr 12 21:34:45   hmac
>>>> Apr 12 21:34:45   iTCO_wdt
>>>> Apr 12 21:34:45   iTCO_vendor_support
>>>> Apr 12 21:34:45   drbg
>>>> Apr 12 21:34:45   ansi_cprng
>>>> Apr 12 21:34:45   aesni_intel
>>>> Apr 12 21:34:45   aes_x86_64
>>>> Apr 12 21:34:45   lrw
>>>> Apr 12 21:34:45   gf128mul
>>>> Apr 12 21:34:45   glue_helper
>>>> Apr 12 21:34:45   ablk_helper
>>>> Apr 12 21:34:45   cryptd
>>>> Apr 12 21:34:45   ahci
>>>> Apr 12 21:34:45   libahci
>>>> Apr 12 21:34:45   sb_edac
>>>> Apr 12 21:34:45   libata
>>>> Apr 12 21:34:45   igb
>>>> Apr 12 21:34:45   megaraid_sas
>>>> Apr 12 21:34:45   xhci_pci
>>>> Apr 12 21:34:45   ehci_pci
>>>> Apr 12 21:34:45   i2c_algo_bit
>>>> Apr 12 21:34:45   xhci_hcd
>>>> Apr 12 21:34:45   ehci_hcd
>>>> Apr 12 21:34:45   edac_core
>>>> Apr 12 21:34:45   ptp
>>>> Apr 12 21:34:45   mei_me
>>>> Apr 12 21:34:45   lpc_ich
>>>> Apr 12 21:34:45   i2c_i801
>>>> Apr 12 21:34:45   usbcore
>>>> Apr 12 21:34:45   pps_core
>>>> Apr 12 21:34:45   mfd_core
>>>> Apr 12 21:34:45   mei
>>>> Apr 12 21:34:45   usb_common
>>>> Apr 12 21:34:45   i2c_core
>>>> Apr 12 21:34:45   ioatdma
>>>> Apr 12 21:34:45   scsi_mod
>>>> Apr 12 21:34:45   dca
>>>> Apr 12 21:34:45   ipmi_si
>>>> Apr 12 21:34:45   ipmi_msghandler
>>>> Apr 12 21:34:45   acpi_power_meter
>>>> Apr 12 21:34:45   tpm_tis
>>>> Apr 12 21:34:45   tpm
>>>> Apr 12 21:34:45   processor
>>>> Apr 12 21:34:45   button
>>>> Apr 12 21:34:45
>>>> Apr 12 21:34:45  [75704.965874] CPU: 6 PID: 25339 Comm: main Not tainted
>>>> 4.4.1 #2
>>>> Apr 12 21:34:45  [75704.965916] Hardware name: Supermicro Super
>>>> Server/X10DRi-LN4+, BIOS 2.0 12/17/2015
>>>> Apr 12 21:34:45  [75704.965979]  0000000000000000
>>>> Apr 12 21:34:45   ffffffff812abdf3
>>>> Apr 12 21:34:45   0000000000000000
>>>> Apr 12 21:34:45   ffffffff810cf5f5
>>>> Apr 12 21:34:45
>>>> Apr 12 21:34:45  [75704.966054]  ffff881ff2870000
>>>> Apr 12 21:34:45   ffffffff810fcea2
>>>> Apr 12 21:34:45   0000000000000001
>>>> Apr 12 21:34:45   ffff881fffcc5e58
>>>> Apr 12 21:34:45
>>>> Apr 12 21:34:45  [75704.966134]  ffff881fffccaf00
>>>> Apr 12 21:34:45   ffff881fffccb100
>>>> Apr 12 21:34:45   ffff881ff2870000
>>>> Apr 12 21:34:45   ffffffff8101bc63
>>>> Apr 12 21:34:45
>>>> Apr 12 21:34:45  [75704.966211] Call Trace:
>>>> Apr 12 21:34:45  [75704.966246]  <NMI>
>>>> Apr 12 21:34:45   [<ffffffff812abdf3>] ? dump_stack+0x40/0x5d
>>>> Apr 12 21:34:45  [75704.966297]  [<ffffffff810cf5f5>] ?
>>>> watchdog_overflow_callback+0xb5/0xd0
>>>> Apr 12 21:34:45  [75704.966339]  [<ffffffff810fcea2>] ?
>>>> __perf_event_overflow+0x82/0x1c0
>>>> Apr 12 21:34:45  [75704.966384]  [<ffffffff8101bc63>] ?
>>>> intel_pmu_handle_irq+0x1c3/0x3e0
>>>> Apr 12 21:34:45  [75704.966431]  [<ffffffff8113b5cb>] ?
>>>> vunmap_page_range+0x1bb/0x320
>>>> Apr 12 21:34:45  [75704.966474]  [<ffffffff813213e0>] ?
>>>> ghes_copy_tofrom_phys+0x110/0x1d0
>>>> Apr 12 21:34:45  [75704.966519]  [<ffffffff81014f53>] ?
>>>> perf_event_nmi_handler+0x23/0x40
>>>> Apr 12 21:34:45  [75704.966560]  [<ffffffff81007b85>] ?
>>>> nmi_handle+0x65/0x100
>>>> Apr 12 21:34:45  [75704.966597]  [<ffffffff81007dfe>] ? do_nmi+0x1de/0x360
>>>> Apr 12 21:34:45  [75704.970603]  [<ffffffff8148f957>] ?
>>>> end_repeat_nmi+0x1a/0x1e
>>>> Apr 12 21:34:45  [75704.970644]  [<ffffffff810862ca>] ?
>>>> queued_spin_lock_slowpath+0xea/0x150
>>>> Apr 12 21:34:45  [75704.970685]  [<ffffffff810862ca>] ?
>>>> queued_spin_lock_slowpath+0xea/0x150
>>>> Apr 12 21:34:45  [75704.970728]  [<ffffffff810862ca>] ?
>>>> queued_spin_lock_slowpath+0xea/0x150
>>>> Apr 12 21:34:45  [75704.970768]  <<EOE>>
>>>> Apr 12 21:34:45   [<ffffffffa01b413b>] ? make_request+0x60b/0xbd0 [raid456]
>>>> Apr 12 21:34:45  [75704.970838]  [<ffffffff810815c0>] ? wait_woken+0x80/0x80
>>>> Apr 12 21:34:45  [75704.970878]  [<ffffffff81151ec4>] ?
>>>> kmem_cache_alloc+0xf4/0x120
>>>> Apr 12 21:34:45  [75704.970922]  [<ffffffffa017632d>] ?
>>>> md_make_request+0xdd/0x220 [md_mod]
>>>> Apr 12 21:34:45  [75704.970969]  [<ffffffff81219fde>] ?
>>>> xfs_map_buffer.isra.12+0x2e/0x60
>>>> Apr 12 21:34:45  [75704.971012]  [<ffffffff8128691d>] ?
>>>> generic_make_request+0xed/0x1d0
>>>> Apr 12 21:34:45  [75704.971052]  [<ffffffff81286a5a>] ?
>>>> submit_bio+0x5a/0x140
>>>> Apr 12 21:34:45  [75704.971098]  [<ffffffff81113379>] ?
>>>> release_pages+0xc9/0x270
>>>> Apr 12 21:34:45  [75704.971145]  [<ffffffff811a2c01>] ?
>>>> do_mpage_readpage+0x2d1/0x640
>>>> Apr 12 21:34:45  [75704.971187]  [<ffffffff811a304d>] ?
>>>> mpage_readpages+0xdd/0x130
>>>> Apr 12 21:34:45  [75704.971226]  [<ffffffff8121b510>] ?
>>>> __xfs_get_blocks+0x750/0x750
>>>> Apr 12 21:34:45  [75704.971267]  [<ffffffff8121b510>] ?
>>>> __xfs_get_blocks+0x750/0x750
>>>> Apr 12 21:34:45  [75704.971313]  [<ffffffff8114ad45>] ?
>>>> alloc_pages_current+0x85/0x110
>>>> Apr 12 21:34:45  [75704.971354]  [<ffffffff81111d25>] ?
>>>> __do_page_cache_readahead+0x165/0x1f0
>>>> Apr 12 21:34:45  [75704.971399]  [<ffffffff81105902>] ?
>>>> pagecache_get_page+0x22/0x1a0
>>>> Apr 12 21:34:45  [75704.971441]  [<ffffffff8110768c>] ?
>>>> filemap_fault+0x37c/0x400
>>>> Apr 12 21:34:45  [75704.971481]  [<ffffffff8122474b>] ?
>>>> xfs_filemap_fault+0x3b/0x80
>>>> Apr 12 21:34:45  [75704.971526]  [<ffffffff8112d2da>] ? __do_fault+0x3a/0xc0
>>>> Apr 12 21:34:45  [75704.971564]  [<ffffffff81130883>] ?
>>>> handle_mm_fault+0x1063/0x1650
>>>> Apr 12 21:34:45  [75704.971614]  [<ffffffff8103bdae>] ?
>>>> __do_page_fault+0x11e/0x370
>>>> Apr 12 21:34:45  [75704.971653]  [<ffffffff811aa4ff>] ?
>>>> SyS_epoll_wait+0x8f/0xd0
>>>> Apr 12 21:34:45  [75704.971694]  [<ffffffff8148f64f>] ? page_fault+0x1f/0x30
>>>> Apr 12 21:34:45  [75705.493640] NMI watchdog: Watchdog detected hard LOCKUP
>>>> on cpu 12
>>>> Apr 12 21:34:45
>>>> Apr 12 21:34:45  [75705.493668] Modules linked in:
>>>> Apr 12 21:34:45   ipt_REJECT
>>>> Apr 12 21:34:45   nf_reject_ipv4
>>>> Apr 12 21:34:45   iptable_mangle
>>>> Apr 12 21:34:45   tun
>>>> Apr 12 21:34:45   netconsole
>>>> Apr 12 21:34:45   configfs
>>>> Apr 12 21:34:45   xt_multiport
>>>> Apr 12 21:34:45   ip6table_filter
>>>> Apr 12 21:34:45   ip6_tables
>>>> Apr 12 21:34:45   iptable_filter
>>>> Apr 12 21:34:45   ip_tables
>>>> Apr 12 21:34:45   x_tables
>>>> Apr 12 21:34:45   bridge
>>>> Apr 12 21:34:45   stp
>>>> Apr 12 21:34:45   llc
>>>> Apr 12 21:34:45   bonding
>>>> Apr 12 21:34:45   ext4
>>>> Apr 12 21:34:45   crc16
>>>> Apr 12 21:34:45   mbcache
>>>> Apr 12 21:34:45   jbd2
>>>> Apr 12 21:34:45   raid1
>>>> Apr 12 21:34:45   raid0
>>>> Apr 12 21:34:45   raid456
>>>> Apr 12 21:34:45   async_raid6_recov
>>>> Apr 12 21:34:45   async_memcpy
>>>> Apr 12 21:34:45   async_pq
>>>> Apr 12 21:34:45   async_xor
>>>> Apr 12 21:34:45   xor
>>>> Apr 12 21:34:45   async_tx
>>>> Apr 12 21:34:45   raid6_pq
>>>> Apr 12 21:34:45   md_mod
>>>> Apr 12 21:34:45   sr_mod
>>>> Apr 12 21:34:45   cdrom
>>>> Apr 12 21:34:45   usb_storage
>>>> Apr 12 21:34:45   hid_generic
>>>> Apr 12 21:34:45   usbhid
>>>> Apr 12 21:34:45   hid
>>>> Apr 12 21:34:45   sg
>>>> Apr 12 21:34:45   sd_mod
>>>> Apr 12 21:34:45   x86_pkg_temp_thermal
>>>> Apr 12 21:34:45   coretemp
>>>> Apr 12 21:34:45   crct10dif_pclmul
>>>> Apr 12 21:34:45   crc32_pclmul
>>>> Apr 12 21:34:45   crc32c_intel
>>>> Apr 12 21:34:45   jitterentropy_rng
>>>> Apr 12 21:34:45   sha256_ssse3
>>>> Apr 12 21:34:45   sha256_generic
>>>> Apr 12 21:34:45   hmac
>>>> Apr 12 21:34:45   iTCO_wdt
>>>> Apr 12 21:34:45   iTCO_vendor_support
>>>> Apr 12 21:34:45   drbg
>>>> Apr 12 21:34:45   ansi_cprng
>>>> Apr 12 21:34:45   aesni_intel
>>>> Apr 12 21:34:45   aes_x86_64
>>>> Apr 12 21:34:45   lrw
>>>> Apr 12 21:34:45   gf128mul
>>>> Apr 12 21:34:45   glue_helper
>>>> Apr 12 21:34:45   ablk_helper
>>>> Apr 12 21:34:45   cryptd
>>>> Apr 12 21:34:45   ahci
>>>> Apr 12 21:34:45   libahci
>>>> Apr 12 21:34:45   sb_edac
>>>> Apr 12 21:34:45   libata
>>>> Apr 12 21:34:45   igb
>>>> Apr 12 21:34:45   megaraid_sas
>>>> Apr 12 21:34:45   xhci_pci
>>>> Apr 12 21:34:45   ehci_pci
>>>> Apr 12 21:34:45   i2c_algo_bit
>>>> Apr 12 21:34:45   xhci_hcd
>>>> Apr 12 21:34:45   ehci_hcd
>>>> Apr 12 21:34:45   edac_core
>>>> Apr 12 21:34:45   ptp
>>>> Apr 12 21:34:45   mei_me
>>>> Apr 12 21:34:45   lpc_ich
>>>> Apr 12 21:34:45   i2c_i801
>>>> Apr 12 21:34:45   usbcore
>>>> Apr 12 21:34:45   pps_core
>>>> Apr 12 21:34:45   mfd_core
>>>> Apr 12 21:34:45   mei
>>>> Apr 12 21:34:45   usb_common
>>>> Apr 12 21:34:45   i2c_core
>>>> Apr 12 21:34:45   ioatdma
>>>> Apr 12 21:34:45   scsi_mod
>>>> Apr 12 21:34:45   dca
>>>> Apr 12 21:34:45   ipmi_si
>>>> Apr 12 21:34:45   ipmi_msghandler
>>>> Apr 12 21:34:45   acpi_power_meter
>>>> Apr 12 21:34:45   tpm_tis
>>>> Apr 12 21:34:45   tpm
>>>> Apr 12 21:34:45   processor
>>>> Apr 12 21:34:45   button
>>>> Apr 12 21:34:45
>>>> Apr 12 21:34:45  [75705.494688] CPU: 12 PID: 32350 Comm: main Not tainted
>>>> 4.4.1 #2
>>>> Apr 12 21:34:45  [75705.494728] Hardware name: Supermicro Super
>>>> Server/X10DRi-LN4+, BIOS 2.0 12/17/2015
>>>> Apr 12 21:34:45  [75705.494790]  0000000000000000
>>>> Apr 12 21:34:45   ffffffff812abdf3
>>>> Apr 12 21:34:45   0000000000000000
>>>> Apr 12 21:34:45   ffffffff810cf5f5
>>>> Apr 12 21:34:45
>>>> Apr 12 21:34:45  [75705.494886]  ffff883ff29a0000
>>>> Apr 12 21:34:45   ffffffff810fcea2
>>>> Apr 12 21:34:45   0000000000000001
>>>> Apr 12 21:34:45   ffff88407fc85e58
>>>> Apr 12 21:34:45
>>>> Apr 12 21:34:45  [75705.494976]  ffff88407fc8af00
>>>> Apr 12 21:34:45   ffff88407fc8b100
>>>> Apr 12 21:34:45   ffff883ff29a0000
>>>> Apr 12 21:34:45   ffffffff8101bc63
>>>> Apr 12 21:34:45
>>>> Apr 12 21:34:45  [75705.495064] Call Trace:
>>>> Apr 12 21:34:45  [75705.495094]  <NMI>
>>>> Apr 12 21:34:45   [<ffffffff812abdf3>] ? dump_stack+0x40/0x5d
>>>> Apr 12 21:34:45  [75705.495150]  [<ffffffff810cf5f5>] ?
>>>> watchdog_overflow_callback+0xb5/0xd0
>>>> Apr 12 21:34:45  [75705.495193]  [<ffffffff810fcea2>] ?
>>>> __perf_event_overflow+0x82/0x1c0
>>>> Apr 12 21:34:45  [75705.495237]  [<ffffffff8101bc63>] ?
>>>> intel_pmu_handle_irq+0x1c3/0x3e0
>>>> Apr 12 21:34:45  [75705.495284]  [<ffffffff8113b5cb>] ?
>>>> vunmap_page_range+0x1bb/0x320
>>>> Apr 12 21:34:45  [75705.495330]  [<ffffffff813213e0>] ?
>>>> ghes_copy_tofrom_phys+0x110/0x1d0
>>>> Apr 12 21:34:45  [75705.495373]  [<ffffffff81014f53>] ?
>>>> perf_event_nmi_handler+0x23/0x40
>>>> Apr 12 21:34:45  [75705.495418]  [<ffffffff81007b85>] ?
>>>> nmi_handle+0x65/0x100
>>>> Apr 12 21:34:45  [75705.495458]  [<ffffffff81007d2e>] ? do_nmi+0x10e/0x360
>>>> Apr 12 21:34:45  [75705.495497]  [<ffffffff8148f957>] ?
>>>> end_repeat_nmi+0x1a/0x1e
>>>> Apr 12 21:34:45  [75705.495540]  [<ffffffff810862ca>] ?
>>>> queued_spin_lock_slowpath+0xea/0x150
>>>> Apr 12 21:34:45  [75705.495581]  [<ffffffff810862ca>] ?
>>>> queued_spin_lock_slowpath+0xea/0x150
>>>> Apr 12 21:34:45  [75705.495621]  [<ffffffff810862ca>] ?
>>>> queued_spin_lock_slowpath+0xea/0x150
>>>> Apr 12 21:34:45  [75705.495661]  <<EOE>>
>>>> Apr 12 21:34:45   [<ffffffffa01b413b>] ? make_request+0x60b/0xbd0 [raid456]
>>>> Apr 12 21:34:45  [75705.495733]  [<ffffffff81282d87>] ?
>>>> blk_rq_init+0x87/0xa0
>>>> Apr 12 21:34:45  [75705.495771]  [<ffffffff81283e3c>] ?
>>>> get_request+0x29c/0x6e0
>>>> Apr 12 21:34:45  [75705.495812]  [<ffffffff810815c0>] ? wait_woken+0x80/0x80
>>>> Apr 12 21:34:45  [75705.495853]  [<ffffffffa017632d>] ?
>>>> md_make_request+0xdd/0x220 [md_mod]
>>>> Apr 12 21:34:45  [75705.495898]  [<ffffffff8128829e>] ?
>>>> blk_queue_bio+0x15e/0x350
>>>> Apr 12 21:34:45  [75705.495937]  [<ffffffff8128691d>] ?
>>>> generic_make_request+0xed/0x1d0
>>>> Apr 12 21:34:45  [75705.495978]  [<ffffffff81286a5a>] ?
>>>> submit_bio+0x5a/0x140
>>>> Apr 12 21:34:45  [75705.496018]  [<ffffffff811a215e>] ?
>>>> mpage_bio_submit+0x1e/0x30
>>>> Apr 12 21:34:45  [75705.496057]  [<ffffffff811a3076>] ?
>>>> mpage_readpages+0x106/0x130
>>>> Apr 12 21:34:45  [75705.496102]  [<ffffffff8121b510>] ?
>>>> __xfs_get_blocks+0x750/0x750
>>>> Apr 12 21:34:45  [75705.496144]  [<ffffffff8121b510>] ?
>>>> __xfs_get_blocks+0x750/0x750
>>>> Apr 12 21:34:45  [75705.496185]  [<ffffffff8114ad45>] ?
>>>> alloc_pages_current+0x85/0x110
>>>> Apr 12 21:34:45  [75705.496227]  [<ffffffff81111d25>] ?
>>>> __do_page_cache_readahead+0x165/0x1f0
>>>> Apr 12 21:34:45  [75705.496268]  [<ffffffff811344f5>] ? vma_link+0x75/0xb0
>>>> Apr 12 21:34:45  [75705.496307]  [<ffffffff811120eb>] ?
>>>> force_page_cache_readahead+0x9b/0xe0
>>>> Apr 12 21:34:45  [75705.496352]  [<ffffffff8113f876>] ?
>>>> madvise_willneed+0x76/0x140
>>>> Apr 12 21:34:45  [75705.496395]  [<ffffffff811301ce>] ?
>>>> handle_mm_fault+0x9ae/0x1650
>>>> Apr 12 21:34:45  [75705.496437]  [<ffffffff81133dcb>] ? find_vma+0x5b/0x70
>>>> Apr 12 21:34:45  [75705.496476]  [<ffffffff8113fc52>] ?
>>>> SyS_madvise+0x312/0x6f0
>>>> Apr 12 21:34:45  [75705.496515]  [<ffffffff8148d9db>] ?
>>>> entry_SYSCALL_64_fastpath+0x16/0x6e
>>>> Apr 12 21:34:47  [75707.118049] NMI watchdog: Watchdog detected hard LOCKUP
>>>> on cpu 15
>>>> Apr 12 21:34:47
>>>> Apr 12 21:34:47  [75707.118078] Modules linked in:
>>>> Apr 12 21:34:47   ipt_REJECT
>>>> Apr 12 21:34:47   nf_reject_ipv4
>>>> Apr 12 21:34:47   iptable_mangle
>>>> Apr 12 21:34:47   tun
>>>> Apr 12 21:34:47   netconsole
>>>> Apr 12 21:34:47   configfs
>>>> Apr 12 21:34:47   xt_multiport
>>>> Apr 12 21:34:47   ip6table_filter
>>>> Apr 12 21:34:47   ip6_tables
>>>> Apr 12 21:34:47   iptable_filter
>>>> Apr 12 21:34:47   ip_tables
>>>> Apr 12 21:34:47   x_tables
>>>> Apr 12 21:34:47   bridge
>>>> Apr 12 21:34:47   stp
>>>> Apr 12 21:34:47   llc
>>>> Apr 12 21:34:47   bonding
>>>> Apr 12 21:34:47   ext4
>>>> Apr 12 21:34:47   crc16
>>>> Apr 12 21:34:47   mbcache
>>>> Apr 12 21:34:47   jbd2
>>>> Apr 12 21:34:47   raid1
>>>> Apr 12 21:34:47   raid0
>>>> Apr 12 21:34:47   raid456
>>>> Apr 12 21:34:47   async_raid6_recov
>>>> Apr 12 21:34:47   async_memcpy
>>>> Apr 12 21:34:47   async_pq
>>>> Apr 12 21:34:47   async_xor
>>>> Apr 12 21:34:47   xor
>>>> Apr 12 21:34:47   async_tx
>>>> Apr 12 21:34:47   raid6_pq
>>>> Apr 12 21:34:47   md_mod
>>>> Apr 12 21:34:47   sr_mod
>>>> Apr 12 21:34:47   cdrom
>>>> Apr 12 21:34:47   usb_storage
>>>> Apr 12 21:34:47   hid_generic
>>>> Apr 12 21:34:47   usbhid
>>>> Apr 12 21:34:47   hid
>>>> Apr 12 21:34:47   sg
>>>> Apr 12 21:34:47   sd_mod
>>>> Apr 12 21:34:47   x86_pkg_temp_thermal
>>>> Apr 12 21:34:47   coretemp
>>>> Apr 12 21:34:47   crct10dif_pclmul
>>>> Apr 12 21:34:47   crc32_pclmul
>>>> Apr 12 21:34:47   crc32c_intel
>>>> Apr 12 21:34:47   jitterentropy_rng
>>>> Apr 12 21:34:47   sha256_ssse3
>>>> Apr 12 21:34:47   sha256_generic
>>>> Apr 12 21:34:47   hmac
>>>> Apr 12 21:34:47   iTCO_wdt
>>>> Apr 12 21:34:47   iTCO_vendor_support
>>>> Apr 12 21:34:47   drbg
>>>> Apr 12 21:34:47   ansi_cprng
>>>> Apr 12 21:34:47   aesni_intel
>>>> Apr 12 21:34:47   aes_x86_64
>>>> Apr 12 21:34:47   lrw
>>>> Apr 12 21:34:47   gf128mul
>>>> Apr 12 21:34:47   glue_helper
>>>> Apr 12 21:34:47   ablk_helper
>>>> Apr 12 21:34:47   cryptd
>>>> Apr 12 21:34:47   ahci
>>>> Apr 12 21:34:47   libahci
>>>> Apr 12 21:34:47   sb_edac
>>>> Apr 12 21:34:47   libata
>>>> Apr 12 21:34:47   igb
>>>> Apr 12 21:34:47   megaraid_sas
>>>> Apr 12 21:34:47   xhci_pci
>>>> Apr 12 21:34:47   ehci_pci
>>>> Apr 12 21:34:47   i2c_algo_bit
>>>> Apr 12 21:34:47   xhci_hcd
>>>> Apr 12 21:34:47   ehci_hcd
>>>> Apr 12 21:34:47   edac_core
>>>> Apr 12 21:34:47   ptp
>>>> Apr 12 21:34:47   mei_me
>>>> Apr 12 21:34:47   lpc_ich
>>>> Apr 12 21:34:47   i2c_i801
>>>> Apr 12 21:34:47   usbcore
>>>> Apr 12 21:34:47   pps_core
>>>> Apr 12 21:34:47   mfd_core
>>>> Apr 12 21:34:47   mei
>>>> Apr 12 21:34:47   usb_common
>>>> Apr 12 21:34:47   i2c_core
>>>> Apr 12 21:34:47   ioatdma
>>>> Apr 12 21:34:47   scsi_mod
>>>> Apr 12 21:34:47   dca
>>>> Apr 12 21:34:47   ipmi_si
>>>> Apr 12 21:34:47   ipmi_msghandler
>>>> Apr 12 21:34:47   acpi_power_meter
>>>> Apr 12 21:34:47   tpm_tis
>>>> Apr 12 21:34:47   tpm
>>>> Apr 12 21:34:47   processor
>>>> Apr 12 21:34:47   button
>>>> Apr 12 21:34:47
>>>> Apr 12 21:34:47  [75707.119088] CPU: 15 PID: 31940 Comm: main Not tainted
>>>> 4.4.1 #2
>>>> Apr 12 21:34:47  [75707.119134] Hardware name: Supermicro Super
>>>> Server/X10DRi-LN4+, BIOS 2.0 12/17/2015
>>>> Apr 12 21:34:47  [75707.119196]  0000000000000000
>>>> Apr 12 21:34:47   ffffffff812abdf3
>>>> Apr 12 21:34:47   0000000000000000
>>>> Apr 12 21:34:47   ffffffff810cf5f5
>>>> Apr 12 21:34:47
>>>> Apr 12 21:34:47  [75707.119277]  ffff883ff2a20000
>>>> Apr 12 21:34:47   ffffffff810fcea2
>>>> Apr 12 21:34:47   0000000000000001
>>>> Apr 12 21:34:47   ffff88407fce5e58
>>>> Apr 12 21:34:47
>>>> Apr 12 21:34:47  [75707.119360]  ffff88407fceaf00
>>>> Apr 12 21:34:47   ffff88407fceb100
>>>> Apr 12 21:34:47   ffff883ff2a20000
>>>> Apr 12 21:34:47   ffffffff8101bc63
>>>> Apr 12 21:34:47
>>>> Apr 12 21:34:47  [75707.119439] Call Trace:
>>>> Apr 12 21:34:47  [75707.119471]  <NMI>
>>>> Apr 12 21:34:47   [<ffffffff812abdf3>] ? dump_stack+0x40/0x5d
>>>> Apr 12 21:34:47  [75707.119527]  [<ffffffff810cf5f5>] ?
>>>> watchdog_overflow_callback+0xb5/0xd0
>>>> Apr 12 21:34:47  [75707.119571]  [<ffffffff810fcea2>] ?
>>>> __perf_event_overflow+0x82/0x1c0
>>>> Apr 12 21:34:47  [75707.119614]  [<ffffffff8101bc63>] ?
>>>> intel_pmu_handle_irq+0x1c3/0x3e0
>>>> Apr 12 21:34:47  [75707.119657]  [<ffffffff8113b5cb>] ?
>>>> vunmap_page_range+0x1bb/0x320
>>>> Apr 12 21:34:47  [75707.119703]  [<ffffffff813213e0>] ?
>>>> ghes_copy_tofrom_phys+0x110/0x1d0
>>>> Apr 12 21:34:47  [75707.119758]  [<ffffffff81014f53>] ?
>>>> perf_event_nmi_handler+0x23/0x40
>>>> Apr 12 21:34:47  [75707.119800]  [<ffffffff81007b85>] ?
>>>> nmi_handle+0x65/0x100
>>>> Apr 12 21:34:47  [75707.119838]  [<ffffffff81007d2e>] ? do_nmi+0x10e/0x360
>>>> Apr 12 21:34:47  [75707.119878]  [<ffffffff8148f957>] ?
>>>> end_repeat_nmi+0x1a/0x1e
>>>> Apr 12 21:34:47  [75707.119920]  [<ffffffff810862ca>] ?
>>>> queued_spin_lock_slowpath+0xea/0x150
>>>> Apr 12 21:34:47  [75707.119962]  [<ffffffff810862ca>] ?
>>>> queued_spin_lock_slowpath+0xea/0x150
>>>> Apr 12 21:34:47  [75707.120002]  [<ffffffff810862ca>] ?
>>>> queued_spin_lock_slowpath+0xea/0x150
>>>> Apr 12 21:34:47  [75707.120042]  <<EOE>>
>>>> Apr 12 21:34:47   [<ffffffffa01b413b>] ? make_request+0x60b/0xbd0 [raid456]
>>>> Apr 12 21:34:47  [75707.120113]  [<ffffffff810815c0>] ? wait_woken+0x80/0x80
>>>> Apr 12 21:34:47  [75707.120152]  [<ffffffffa017632d>] ?
>>>> md_make_request+0xdd/0x220 [md_mod]
>>>> Apr 12 21:34:47  [75707.120195]  [<ffffffff8128691d>] ?
>>>> generic_make_request+0xed/0x1d0
>>>> Apr 12 21:34:47  [75707.120236]  [<ffffffff81286a5a>] ?
>>>> submit_bio+0x5a/0x140
>>>> Apr 12 21:34:47  [75707.120277]  [<ffffffff8112afaf>] ?
>>>> workingset_refault+0x4f/0xa0
>>>> Apr 12 21:34:47  [75707.120320]  [<ffffffff811a215e>] ?
>>>> mpage_bio_submit+0x1e/0x30
>>>> Apr 12 21:34:47  [75707.120359]  [<ffffffff811a3076>] ?
>>>> mpage_readpages+0x106/0x130
>>>> Apr 12 21:34:47  [75707.120401]  [<ffffffff8121b510>] ?
>>>> __xfs_get_blocks+0x750/0x750
>>>> Apr 12 21:34:47  [75707.120439]  [<ffffffff8121b510>] ?
>>>> __xfs_get_blocks+0x750/0x750
>>>> Apr 12 21:34:47  [75707.120481]  [<ffffffff8114ad45>] ?
>>>> alloc_pages_current+0x85/0x110
>>>> Apr 12 21:34:47  [75707.120523]  [<ffffffff81111d25>] ?
>>>> __do_page_cache_readahead+0x165/0x1f0
>>>> Apr 12 21:34:47  [75707.120564]  [<ffffffff811344f5>] ? vma_link+0x75/0xb0
>>>> Apr 12 21:34:47  [75707.120602]  [<ffffffff811120c7>] ?
>>>> force_page_cache_readahead+0x77/0xe0
>>>> Apr 12 21:34:47  [75707.120644]  [<ffffffff8113f876>] ?
>>>> madvise_willneed+0x76/0x140
>>>> Apr 12 21:34:47  [75707.120683]  [<ffffffff811301ce>] ?
>>>> handle_mm_fault+0x9ae/0x1650
>>>> Apr 12 21:34:47  [75707.120722]  [<ffffffff81133dcb>] ? find_vma+0x5b/0x70
>>>> Apr 12 21:34:47  [75707.120760]  [<ffffffff8113fc52>] ?
>>>> SyS_madvise+0x312/0x6f0
>>>> Apr 12 21:34:47  [75707.120799]  [<ffffffff8148d9db>] ?
>>>> entry_SYSCALL_64_fastpath+0x16/0x6e
>>>>
>>>> Once this starts, a couple of minutes goes by and the machine locks up
>>>> completely.
>>>>
>>>> I have been unable to locate the problem here, anyone that can point me in
>>>> the right direction?
>>>>
>>>> Best regards
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Daniel> --
> Daniel> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> Daniel> the body of a message to majordomo@vger.kernel.org
> Daniel> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
