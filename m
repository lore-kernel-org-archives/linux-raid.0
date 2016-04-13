From: Shaohua Li <shli@kernel.org>
Subject: Re: Hard CPU Lockup when accessing MD RAID5
Date: Wed, 13 Apr 2016 10:00:08 -0700
Message-ID: <20160413170008.GA6186@kernel.org>
References: <570D6E79.1010201@ftwinc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570D6E79.1010201@ftwinc.net>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Walker <admin@ftwinc.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Looks there is a deadlock trying to hold the device_lock or hash_lock. anything
abormal print out before the NMI watchdog? What is running in the machine?
Looks this is old kernel, is it possible you can try a latest kernel and report
back?

Thanks,
Shaohua

On Tue, Apr 12, 2016 at 09:54:08PM +0000, Daniel Walker wrote:
> Im having some issues on a brand new Supermicro server that we have running
> in production along side a few other machines which are identical to this
> server..
> 
> The output from the netconsole attached to the server is here:
> 
> Apr 12 21:34:45  [75704.964946] NMI watchdog: Watchdog detected hard LOCKUP
> on cpu 6
> Apr 12 21:34:45
> Apr 12 21:34:45  [75704.964973] Modules linked in:
> Apr 12 21:34:45   ipt_REJECT
> Apr 12 21:34:45   nf_reject_ipv4
> Apr 12 21:34:45   iptable_mangle
> Apr 12 21:34:45   tun
> Apr 12 21:34:45   netconsole
> Apr 12 21:34:45   configfs
> Apr 12 21:34:45   xt_multiport
> Apr 12 21:34:45   ip6table_filter
> Apr 12 21:34:45   ip6_tables
> Apr 12 21:34:45   iptable_filter
> Apr 12 21:34:45   ip_tables
> Apr 12 21:34:45   x_tables
> Apr 12 21:34:45   bridge
> Apr 12 21:34:45   stp
> Apr 12 21:34:45   llc
> Apr 12 21:34:45   bonding
> Apr 12 21:34:45   ext4
> Apr 12 21:34:45   crc16
> Apr 12 21:34:45   mbcache
> Apr 12 21:34:45   jbd2
> Apr 12 21:34:45   raid1
> Apr 12 21:34:45   raid0
> Apr 12 21:34:45   raid456
> Apr 12 21:34:45   async_raid6_recov
> Apr 12 21:34:45   async_memcpy
> Apr 12 21:34:45   async_pq
> Apr 12 21:34:45   async_xor
> Apr 12 21:34:45   xor
> Apr 12 21:34:45   async_tx
> Apr 12 21:34:45   raid6_pq
> Apr 12 21:34:45   md_mod
> Apr 12 21:34:45   sr_mod
> Apr 12 21:34:45   cdrom
> Apr 12 21:34:45   usb_storage
> Apr 12 21:34:45   hid_generic
> Apr 12 21:34:45   usbhid
> Apr 12 21:34:45   hid
> Apr 12 21:34:45   sg
> Apr 12 21:34:45   sd_mod
> Apr 12 21:34:45   x86_pkg_temp_thermal
> Apr 12 21:34:45   coretemp
> Apr 12 21:34:45   crct10dif_pclmul
> Apr 12 21:34:45   crc32_pclmul
> Apr 12 21:34:45   crc32c_intel
> Apr 12 21:34:45   jitterentropy_rng
> Apr 12 21:34:45   sha256_ssse3
> Apr 12 21:34:45   sha256_generic
> Apr 12 21:34:45   hmac
> Apr 12 21:34:45   iTCO_wdt
> Apr 12 21:34:45   iTCO_vendor_support
> Apr 12 21:34:45   drbg
> Apr 12 21:34:45   ansi_cprng
> Apr 12 21:34:45   aesni_intel
> Apr 12 21:34:45   aes_x86_64
> Apr 12 21:34:45   lrw
> Apr 12 21:34:45   gf128mul
> Apr 12 21:34:45   glue_helper
> Apr 12 21:34:45   ablk_helper
> Apr 12 21:34:45   cryptd
> Apr 12 21:34:45   ahci
> Apr 12 21:34:45   libahci
> Apr 12 21:34:45   sb_edac
> Apr 12 21:34:45   libata
> Apr 12 21:34:45   igb
> Apr 12 21:34:45   megaraid_sas
> Apr 12 21:34:45   xhci_pci
> Apr 12 21:34:45   ehci_pci
> Apr 12 21:34:45   i2c_algo_bit
> Apr 12 21:34:45   xhci_hcd
> Apr 12 21:34:45   ehci_hcd
> Apr 12 21:34:45   edac_core
> Apr 12 21:34:45   ptp
> Apr 12 21:34:45   mei_me
> Apr 12 21:34:45   lpc_ich
> Apr 12 21:34:45   i2c_i801
> Apr 12 21:34:45   usbcore
> Apr 12 21:34:45   pps_core
> Apr 12 21:34:45   mfd_core
> Apr 12 21:34:45   mei
> Apr 12 21:34:45   usb_common
> Apr 12 21:34:45   i2c_core
> Apr 12 21:34:45   ioatdma
> Apr 12 21:34:45   scsi_mod
> Apr 12 21:34:45   dca
> Apr 12 21:34:45   ipmi_si
> Apr 12 21:34:45   ipmi_msghandler
> Apr 12 21:34:45   acpi_power_meter
> Apr 12 21:34:45   tpm_tis
> Apr 12 21:34:45   tpm
> Apr 12 21:34:45   processor
> Apr 12 21:34:45   button
> Apr 12 21:34:45
> Apr 12 21:34:45  [75704.965874] CPU: 6 PID: 25339 Comm: main Not tainted
> 4.4.1 #2
> Apr 12 21:34:45  [75704.965916] Hardware name: Supermicro Super
> Server/X10DRi-LN4+, BIOS 2.0 12/17/2015
> Apr 12 21:34:45  [75704.965979]  0000000000000000
> Apr 12 21:34:45   ffffffff812abdf3
> Apr 12 21:34:45   0000000000000000
> Apr 12 21:34:45   ffffffff810cf5f5
> Apr 12 21:34:45
> Apr 12 21:34:45  [75704.966054]  ffff881ff2870000
> Apr 12 21:34:45   ffffffff810fcea2
> Apr 12 21:34:45   0000000000000001
> Apr 12 21:34:45   ffff881fffcc5e58
> Apr 12 21:34:45
> Apr 12 21:34:45  [75704.966134]  ffff881fffccaf00
> Apr 12 21:34:45   ffff881fffccb100
> Apr 12 21:34:45   ffff881ff2870000
> Apr 12 21:34:45   ffffffff8101bc63
> Apr 12 21:34:45
> Apr 12 21:34:45  [75704.966211] Call Trace:
> Apr 12 21:34:45  [75704.966246]  <NMI>
> Apr 12 21:34:45   [<ffffffff812abdf3>] ? dump_stack+0x40/0x5d
> Apr 12 21:34:45  [75704.966297]  [<ffffffff810cf5f5>] ?
> watchdog_overflow_callback+0xb5/0xd0
> Apr 12 21:34:45  [75704.966339]  [<ffffffff810fcea2>] ?
> __perf_event_overflow+0x82/0x1c0
> Apr 12 21:34:45  [75704.966384]  [<ffffffff8101bc63>] ?
> intel_pmu_handle_irq+0x1c3/0x3e0
> Apr 12 21:34:45  [75704.966431]  [<ffffffff8113b5cb>] ?
> vunmap_page_range+0x1bb/0x320
> Apr 12 21:34:45  [75704.966474]  [<ffffffff813213e0>] ?
> ghes_copy_tofrom_phys+0x110/0x1d0
> Apr 12 21:34:45  [75704.966519]  [<ffffffff81014f53>] ?
> perf_event_nmi_handler+0x23/0x40
> Apr 12 21:34:45  [75704.966560]  [<ffffffff81007b85>] ?
> nmi_handle+0x65/0x100
> Apr 12 21:34:45  [75704.966597]  [<ffffffff81007dfe>] ? do_nmi+0x1de/0x360
> Apr 12 21:34:45  [75704.970603]  [<ffffffff8148f957>] ?
> end_repeat_nmi+0x1a/0x1e
> Apr 12 21:34:45  [75704.970644]  [<ffffffff810862ca>] ?
> queued_spin_lock_slowpath+0xea/0x150
> Apr 12 21:34:45  [75704.970685]  [<ffffffff810862ca>] ?
> queued_spin_lock_slowpath+0xea/0x150
> Apr 12 21:34:45  [75704.970728]  [<ffffffff810862ca>] ?
> queued_spin_lock_slowpath+0xea/0x150
> Apr 12 21:34:45  [75704.970768]  <<EOE>>
> Apr 12 21:34:45   [<ffffffffa01b413b>] ? make_request+0x60b/0xbd0 [raid456]
> Apr 12 21:34:45  [75704.970838]  [<ffffffff810815c0>] ? wait_woken+0x80/0x80
> Apr 12 21:34:45  [75704.970878]  [<ffffffff81151ec4>] ?
> kmem_cache_alloc+0xf4/0x120
> Apr 12 21:34:45  [75704.970922]  [<ffffffffa017632d>] ?
> md_make_request+0xdd/0x220 [md_mod]
> Apr 12 21:34:45  [75704.970969]  [<ffffffff81219fde>] ?
> xfs_map_buffer.isra.12+0x2e/0x60
> Apr 12 21:34:45  [75704.971012]  [<ffffffff8128691d>] ?
> generic_make_request+0xed/0x1d0
> Apr 12 21:34:45  [75704.971052]  [<ffffffff81286a5a>] ?
> submit_bio+0x5a/0x140
> Apr 12 21:34:45  [75704.971098]  [<ffffffff81113379>] ?
> release_pages+0xc9/0x270
> Apr 12 21:34:45  [75704.971145]  [<ffffffff811a2c01>] ?
> do_mpage_readpage+0x2d1/0x640
> Apr 12 21:34:45  [75704.971187]  [<ffffffff811a304d>] ?
> mpage_readpages+0xdd/0x130
> Apr 12 21:34:45  [75704.971226]  [<ffffffff8121b510>] ?
> __xfs_get_blocks+0x750/0x750
> Apr 12 21:34:45  [75704.971267]  [<ffffffff8121b510>] ?
> __xfs_get_blocks+0x750/0x750
> Apr 12 21:34:45  [75704.971313]  [<ffffffff8114ad45>] ?
> alloc_pages_current+0x85/0x110
> Apr 12 21:34:45  [75704.971354]  [<ffffffff81111d25>] ?
> __do_page_cache_readahead+0x165/0x1f0
> Apr 12 21:34:45  [75704.971399]  [<ffffffff81105902>] ?
> pagecache_get_page+0x22/0x1a0
> Apr 12 21:34:45  [75704.971441]  [<ffffffff8110768c>] ?
> filemap_fault+0x37c/0x400
> Apr 12 21:34:45  [75704.971481]  [<ffffffff8122474b>] ?
> xfs_filemap_fault+0x3b/0x80
> Apr 12 21:34:45  [75704.971526]  [<ffffffff8112d2da>] ? __do_fault+0x3a/0xc0
> Apr 12 21:34:45  [75704.971564]  [<ffffffff81130883>] ?
> handle_mm_fault+0x1063/0x1650
> Apr 12 21:34:45  [75704.971614]  [<ffffffff8103bdae>] ?
> __do_page_fault+0x11e/0x370
> Apr 12 21:34:45  [75704.971653]  [<ffffffff811aa4ff>] ?
> SyS_epoll_wait+0x8f/0xd0
> Apr 12 21:34:45  [75704.971694]  [<ffffffff8148f64f>] ? page_fault+0x1f/0x30
> Apr 12 21:34:45  [75705.493640] NMI watchdog: Watchdog detected hard LOCKUP
> on cpu 12
> Apr 12 21:34:45
> Apr 12 21:34:45  [75705.493668] Modules linked in:
> Apr 12 21:34:45   ipt_REJECT
> Apr 12 21:34:45   nf_reject_ipv4
> Apr 12 21:34:45   iptable_mangle
> Apr 12 21:34:45   tun
> Apr 12 21:34:45   netconsole
> Apr 12 21:34:45   configfs
> Apr 12 21:34:45   xt_multiport
> Apr 12 21:34:45   ip6table_filter
> Apr 12 21:34:45   ip6_tables
> Apr 12 21:34:45   iptable_filter
> Apr 12 21:34:45   ip_tables
> Apr 12 21:34:45   x_tables
> Apr 12 21:34:45   bridge
> Apr 12 21:34:45   stp
> Apr 12 21:34:45   llc
> Apr 12 21:34:45   bonding
> Apr 12 21:34:45   ext4
> Apr 12 21:34:45   crc16
> Apr 12 21:34:45   mbcache
> Apr 12 21:34:45   jbd2
> Apr 12 21:34:45   raid1
> Apr 12 21:34:45   raid0
> Apr 12 21:34:45   raid456
> Apr 12 21:34:45   async_raid6_recov
> Apr 12 21:34:45   async_memcpy
> Apr 12 21:34:45   async_pq
> Apr 12 21:34:45   async_xor
> Apr 12 21:34:45   xor
> Apr 12 21:34:45   async_tx
> Apr 12 21:34:45   raid6_pq
> Apr 12 21:34:45   md_mod
> Apr 12 21:34:45   sr_mod
> Apr 12 21:34:45   cdrom
> Apr 12 21:34:45   usb_storage
> Apr 12 21:34:45   hid_generic
> Apr 12 21:34:45   usbhid
> Apr 12 21:34:45   hid
> Apr 12 21:34:45   sg
> Apr 12 21:34:45   sd_mod
> Apr 12 21:34:45   x86_pkg_temp_thermal
> Apr 12 21:34:45   coretemp
> Apr 12 21:34:45   crct10dif_pclmul
> Apr 12 21:34:45   crc32_pclmul
> Apr 12 21:34:45   crc32c_intel
> Apr 12 21:34:45   jitterentropy_rng
> Apr 12 21:34:45   sha256_ssse3
> Apr 12 21:34:45   sha256_generic
> Apr 12 21:34:45   hmac
> Apr 12 21:34:45   iTCO_wdt
> Apr 12 21:34:45   iTCO_vendor_support
> Apr 12 21:34:45   drbg
> Apr 12 21:34:45   ansi_cprng
> Apr 12 21:34:45   aesni_intel
> Apr 12 21:34:45   aes_x86_64
> Apr 12 21:34:45   lrw
> Apr 12 21:34:45   gf128mul
> Apr 12 21:34:45   glue_helper
> Apr 12 21:34:45   ablk_helper
> Apr 12 21:34:45   cryptd
> Apr 12 21:34:45   ahci
> Apr 12 21:34:45   libahci
> Apr 12 21:34:45   sb_edac
> Apr 12 21:34:45   libata
> Apr 12 21:34:45   igb
> Apr 12 21:34:45   megaraid_sas
> Apr 12 21:34:45   xhci_pci
> Apr 12 21:34:45   ehci_pci
> Apr 12 21:34:45   i2c_algo_bit
> Apr 12 21:34:45   xhci_hcd
> Apr 12 21:34:45   ehci_hcd
> Apr 12 21:34:45   edac_core
> Apr 12 21:34:45   ptp
> Apr 12 21:34:45   mei_me
> Apr 12 21:34:45   lpc_ich
> Apr 12 21:34:45   i2c_i801
> Apr 12 21:34:45   usbcore
> Apr 12 21:34:45   pps_core
> Apr 12 21:34:45   mfd_core
> Apr 12 21:34:45   mei
> Apr 12 21:34:45   usb_common
> Apr 12 21:34:45   i2c_core
> Apr 12 21:34:45   ioatdma
> Apr 12 21:34:45   scsi_mod
> Apr 12 21:34:45   dca
> Apr 12 21:34:45   ipmi_si
> Apr 12 21:34:45   ipmi_msghandler
> Apr 12 21:34:45   acpi_power_meter
> Apr 12 21:34:45   tpm_tis
> Apr 12 21:34:45   tpm
> Apr 12 21:34:45   processor
> Apr 12 21:34:45   button
> Apr 12 21:34:45
> Apr 12 21:34:45  [75705.494688] CPU: 12 PID: 32350 Comm: main Not tainted
> 4.4.1 #2
> Apr 12 21:34:45  [75705.494728] Hardware name: Supermicro Super
> Server/X10DRi-LN4+, BIOS 2.0 12/17/2015
> Apr 12 21:34:45  [75705.494790]  0000000000000000
> Apr 12 21:34:45   ffffffff812abdf3
> Apr 12 21:34:45   0000000000000000
> Apr 12 21:34:45   ffffffff810cf5f5
> Apr 12 21:34:45
> Apr 12 21:34:45  [75705.494886]  ffff883ff29a0000
> Apr 12 21:34:45   ffffffff810fcea2
> Apr 12 21:34:45   0000000000000001
> Apr 12 21:34:45   ffff88407fc85e58
> Apr 12 21:34:45
> Apr 12 21:34:45  [75705.494976]  ffff88407fc8af00
> Apr 12 21:34:45   ffff88407fc8b100
> Apr 12 21:34:45   ffff883ff29a0000
> Apr 12 21:34:45   ffffffff8101bc63
> Apr 12 21:34:45
> Apr 12 21:34:45  [75705.495064] Call Trace:
> Apr 12 21:34:45  [75705.495094]  <NMI>
> Apr 12 21:34:45   [<ffffffff812abdf3>] ? dump_stack+0x40/0x5d
> Apr 12 21:34:45  [75705.495150]  [<ffffffff810cf5f5>] ?
> watchdog_overflow_callback+0xb5/0xd0
> Apr 12 21:34:45  [75705.495193]  [<ffffffff810fcea2>] ?
> __perf_event_overflow+0x82/0x1c0
> Apr 12 21:34:45  [75705.495237]  [<ffffffff8101bc63>] ?
> intel_pmu_handle_irq+0x1c3/0x3e0
> Apr 12 21:34:45  [75705.495284]  [<ffffffff8113b5cb>] ?
> vunmap_page_range+0x1bb/0x320
> Apr 12 21:34:45  [75705.495330]  [<ffffffff813213e0>] ?
> ghes_copy_tofrom_phys+0x110/0x1d0
> Apr 12 21:34:45  [75705.495373]  [<ffffffff81014f53>] ?
> perf_event_nmi_handler+0x23/0x40
> Apr 12 21:34:45  [75705.495418]  [<ffffffff81007b85>] ?
> nmi_handle+0x65/0x100
> Apr 12 21:34:45  [75705.495458]  [<ffffffff81007d2e>] ? do_nmi+0x10e/0x360
> Apr 12 21:34:45  [75705.495497]  [<ffffffff8148f957>] ?
> end_repeat_nmi+0x1a/0x1e
> Apr 12 21:34:45  [75705.495540]  [<ffffffff810862ca>] ?
> queued_spin_lock_slowpath+0xea/0x150
> Apr 12 21:34:45  [75705.495581]  [<ffffffff810862ca>] ?
> queued_spin_lock_slowpath+0xea/0x150
> Apr 12 21:34:45  [75705.495621]  [<ffffffff810862ca>] ?
> queued_spin_lock_slowpath+0xea/0x150
> Apr 12 21:34:45  [75705.495661]  <<EOE>>
> Apr 12 21:34:45   [<ffffffffa01b413b>] ? make_request+0x60b/0xbd0 [raid456]
> Apr 12 21:34:45  [75705.495733]  [<ffffffff81282d87>] ?
> blk_rq_init+0x87/0xa0
> Apr 12 21:34:45  [75705.495771]  [<ffffffff81283e3c>] ?
> get_request+0x29c/0x6e0
> Apr 12 21:34:45  [75705.495812]  [<ffffffff810815c0>] ? wait_woken+0x80/0x80
> Apr 12 21:34:45  [75705.495853]  [<ffffffffa017632d>] ?
> md_make_request+0xdd/0x220 [md_mod]
> Apr 12 21:34:45  [75705.495898]  [<ffffffff8128829e>] ?
> blk_queue_bio+0x15e/0x350
> Apr 12 21:34:45  [75705.495937]  [<ffffffff8128691d>] ?
> generic_make_request+0xed/0x1d0
> Apr 12 21:34:45  [75705.495978]  [<ffffffff81286a5a>] ?
> submit_bio+0x5a/0x140
> Apr 12 21:34:45  [75705.496018]  [<ffffffff811a215e>] ?
> mpage_bio_submit+0x1e/0x30
> Apr 12 21:34:45  [75705.496057]  [<ffffffff811a3076>] ?
> mpage_readpages+0x106/0x130
> Apr 12 21:34:45  [75705.496102]  [<ffffffff8121b510>] ?
> __xfs_get_blocks+0x750/0x750
> Apr 12 21:34:45  [75705.496144]  [<ffffffff8121b510>] ?
> __xfs_get_blocks+0x750/0x750
> Apr 12 21:34:45  [75705.496185]  [<ffffffff8114ad45>] ?
> alloc_pages_current+0x85/0x110
> Apr 12 21:34:45  [75705.496227]  [<ffffffff81111d25>] ?
> __do_page_cache_readahead+0x165/0x1f0
> Apr 12 21:34:45  [75705.496268]  [<ffffffff811344f5>] ? vma_link+0x75/0xb0
> Apr 12 21:34:45  [75705.496307]  [<ffffffff811120eb>] ?
> force_page_cache_readahead+0x9b/0xe0
> Apr 12 21:34:45  [75705.496352]  [<ffffffff8113f876>] ?
> madvise_willneed+0x76/0x140
> Apr 12 21:34:45  [75705.496395]  [<ffffffff811301ce>] ?
> handle_mm_fault+0x9ae/0x1650
> Apr 12 21:34:45  [75705.496437]  [<ffffffff81133dcb>] ? find_vma+0x5b/0x70
> Apr 12 21:34:45  [75705.496476]  [<ffffffff8113fc52>] ?
> SyS_madvise+0x312/0x6f0
> Apr 12 21:34:45  [75705.496515]  [<ffffffff8148d9db>] ?
> entry_SYSCALL_64_fastpath+0x16/0x6e
> Apr 12 21:34:47  [75707.118049] NMI watchdog: Watchdog detected hard LOCKUP
> on cpu 15
> Apr 12 21:34:47
> Apr 12 21:34:47  [75707.118078] Modules linked in:
> Apr 12 21:34:47   ipt_REJECT
> Apr 12 21:34:47   nf_reject_ipv4
> Apr 12 21:34:47   iptable_mangle
> Apr 12 21:34:47   tun
> Apr 12 21:34:47   netconsole
> Apr 12 21:34:47   configfs
> Apr 12 21:34:47   xt_multiport
> Apr 12 21:34:47   ip6table_filter
> Apr 12 21:34:47   ip6_tables
> Apr 12 21:34:47   iptable_filter
> Apr 12 21:34:47   ip_tables
> Apr 12 21:34:47   x_tables
> Apr 12 21:34:47   bridge
> Apr 12 21:34:47   stp
> Apr 12 21:34:47   llc
> Apr 12 21:34:47   bonding
> Apr 12 21:34:47   ext4
> Apr 12 21:34:47   crc16
> Apr 12 21:34:47   mbcache
> Apr 12 21:34:47   jbd2
> Apr 12 21:34:47   raid1
> Apr 12 21:34:47   raid0
> Apr 12 21:34:47   raid456
> Apr 12 21:34:47   async_raid6_recov
> Apr 12 21:34:47   async_memcpy
> Apr 12 21:34:47   async_pq
> Apr 12 21:34:47   async_xor
> Apr 12 21:34:47   xor
> Apr 12 21:34:47   async_tx
> Apr 12 21:34:47   raid6_pq
> Apr 12 21:34:47   md_mod
> Apr 12 21:34:47   sr_mod
> Apr 12 21:34:47   cdrom
> Apr 12 21:34:47   usb_storage
> Apr 12 21:34:47   hid_generic
> Apr 12 21:34:47   usbhid
> Apr 12 21:34:47   hid
> Apr 12 21:34:47   sg
> Apr 12 21:34:47   sd_mod
> Apr 12 21:34:47   x86_pkg_temp_thermal
> Apr 12 21:34:47   coretemp
> Apr 12 21:34:47   crct10dif_pclmul
> Apr 12 21:34:47   crc32_pclmul
> Apr 12 21:34:47   crc32c_intel
> Apr 12 21:34:47   jitterentropy_rng
> Apr 12 21:34:47   sha256_ssse3
> Apr 12 21:34:47   sha256_generic
> Apr 12 21:34:47   hmac
> Apr 12 21:34:47   iTCO_wdt
> Apr 12 21:34:47   iTCO_vendor_support
> Apr 12 21:34:47   drbg
> Apr 12 21:34:47   ansi_cprng
> Apr 12 21:34:47   aesni_intel
> Apr 12 21:34:47   aes_x86_64
> Apr 12 21:34:47   lrw
> Apr 12 21:34:47   gf128mul
> Apr 12 21:34:47   glue_helper
> Apr 12 21:34:47   ablk_helper
> Apr 12 21:34:47   cryptd
> Apr 12 21:34:47   ahci
> Apr 12 21:34:47   libahci
> Apr 12 21:34:47   sb_edac
> Apr 12 21:34:47   libata
> Apr 12 21:34:47   igb
> Apr 12 21:34:47   megaraid_sas
> Apr 12 21:34:47   xhci_pci
> Apr 12 21:34:47   ehci_pci
> Apr 12 21:34:47   i2c_algo_bit
> Apr 12 21:34:47   xhci_hcd
> Apr 12 21:34:47   ehci_hcd
> Apr 12 21:34:47   edac_core
> Apr 12 21:34:47   ptp
> Apr 12 21:34:47   mei_me
> Apr 12 21:34:47   lpc_ich
> Apr 12 21:34:47   i2c_i801
> Apr 12 21:34:47   usbcore
> Apr 12 21:34:47   pps_core
> Apr 12 21:34:47   mfd_core
> Apr 12 21:34:47   mei
> Apr 12 21:34:47   usb_common
> Apr 12 21:34:47   i2c_core
> Apr 12 21:34:47   ioatdma
> Apr 12 21:34:47   scsi_mod
> Apr 12 21:34:47   dca
> Apr 12 21:34:47   ipmi_si
> Apr 12 21:34:47   ipmi_msghandler
> Apr 12 21:34:47   acpi_power_meter
> Apr 12 21:34:47   tpm_tis
> Apr 12 21:34:47   tpm
> Apr 12 21:34:47   processor
> Apr 12 21:34:47   button
> Apr 12 21:34:47
> Apr 12 21:34:47  [75707.119088] CPU: 15 PID: 31940 Comm: main Not tainted
> 4.4.1 #2
> Apr 12 21:34:47  [75707.119134] Hardware name: Supermicro Super
> Server/X10DRi-LN4+, BIOS 2.0 12/17/2015
> Apr 12 21:34:47  [75707.119196]  0000000000000000
> Apr 12 21:34:47   ffffffff812abdf3
> Apr 12 21:34:47   0000000000000000
> Apr 12 21:34:47   ffffffff810cf5f5
> Apr 12 21:34:47
> Apr 12 21:34:47  [75707.119277]  ffff883ff2a20000
> Apr 12 21:34:47   ffffffff810fcea2
> Apr 12 21:34:47   0000000000000001
> Apr 12 21:34:47   ffff88407fce5e58
> Apr 12 21:34:47
> Apr 12 21:34:47  [75707.119360]  ffff88407fceaf00
> Apr 12 21:34:47   ffff88407fceb100
> Apr 12 21:34:47   ffff883ff2a20000
> Apr 12 21:34:47   ffffffff8101bc63
> Apr 12 21:34:47
> Apr 12 21:34:47  [75707.119439] Call Trace:
> Apr 12 21:34:47  [75707.119471]  <NMI>
> Apr 12 21:34:47   [<ffffffff812abdf3>] ? dump_stack+0x40/0x5d
> Apr 12 21:34:47  [75707.119527]  [<ffffffff810cf5f5>] ?
> watchdog_overflow_callback+0xb5/0xd0
> Apr 12 21:34:47  [75707.119571]  [<ffffffff810fcea2>] ?
> __perf_event_overflow+0x82/0x1c0
> Apr 12 21:34:47  [75707.119614]  [<ffffffff8101bc63>] ?
> intel_pmu_handle_irq+0x1c3/0x3e0
> Apr 12 21:34:47  [75707.119657]  [<ffffffff8113b5cb>] ?
> vunmap_page_range+0x1bb/0x320
> Apr 12 21:34:47  [75707.119703]  [<ffffffff813213e0>] ?
> ghes_copy_tofrom_phys+0x110/0x1d0
> Apr 12 21:34:47  [75707.119758]  [<ffffffff81014f53>] ?
> perf_event_nmi_handler+0x23/0x40
> Apr 12 21:34:47  [75707.119800]  [<ffffffff81007b85>] ?
> nmi_handle+0x65/0x100
> Apr 12 21:34:47  [75707.119838]  [<ffffffff81007d2e>] ? do_nmi+0x10e/0x360
> Apr 12 21:34:47  [75707.119878]  [<ffffffff8148f957>] ?
> end_repeat_nmi+0x1a/0x1e
> Apr 12 21:34:47  [75707.119920]  [<ffffffff810862ca>] ?
> queued_spin_lock_slowpath+0xea/0x150
> Apr 12 21:34:47  [75707.119962]  [<ffffffff810862ca>] ?
> queued_spin_lock_slowpath+0xea/0x150
> Apr 12 21:34:47  [75707.120002]  [<ffffffff810862ca>] ?
> queued_spin_lock_slowpath+0xea/0x150
> Apr 12 21:34:47  [75707.120042]  <<EOE>>
> Apr 12 21:34:47   [<ffffffffa01b413b>] ? make_request+0x60b/0xbd0 [raid456]
> Apr 12 21:34:47  [75707.120113]  [<ffffffff810815c0>] ? wait_woken+0x80/0x80
> Apr 12 21:34:47  [75707.120152]  [<ffffffffa017632d>] ?
> md_make_request+0xdd/0x220 [md_mod]
> Apr 12 21:34:47  [75707.120195]  [<ffffffff8128691d>] ?
> generic_make_request+0xed/0x1d0
> Apr 12 21:34:47  [75707.120236]  [<ffffffff81286a5a>] ?
> submit_bio+0x5a/0x140
> Apr 12 21:34:47  [75707.120277]  [<ffffffff8112afaf>] ?
> workingset_refault+0x4f/0xa0
> Apr 12 21:34:47  [75707.120320]  [<ffffffff811a215e>] ?
> mpage_bio_submit+0x1e/0x30
> Apr 12 21:34:47  [75707.120359]  [<ffffffff811a3076>] ?
> mpage_readpages+0x106/0x130
> Apr 12 21:34:47  [75707.120401]  [<ffffffff8121b510>] ?
> __xfs_get_blocks+0x750/0x750
> Apr 12 21:34:47  [75707.120439]  [<ffffffff8121b510>] ?
> __xfs_get_blocks+0x750/0x750
> Apr 12 21:34:47  [75707.120481]  [<ffffffff8114ad45>] ?
> alloc_pages_current+0x85/0x110
> Apr 12 21:34:47  [75707.120523]  [<ffffffff81111d25>] ?
> __do_page_cache_readahead+0x165/0x1f0
> Apr 12 21:34:47  [75707.120564]  [<ffffffff811344f5>] ? vma_link+0x75/0xb0
> Apr 12 21:34:47  [75707.120602]  [<ffffffff811120c7>] ?
> force_page_cache_readahead+0x77/0xe0
> Apr 12 21:34:47  [75707.120644]  [<ffffffff8113f876>] ?
> madvise_willneed+0x76/0x140
> Apr 12 21:34:47  [75707.120683]  [<ffffffff811301ce>] ?
> handle_mm_fault+0x9ae/0x1650
> Apr 12 21:34:47  [75707.120722]  [<ffffffff81133dcb>] ? find_vma+0x5b/0x70
> Apr 12 21:34:47  [75707.120760]  [<ffffffff8113fc52>] ?
> SyS_madvise+0x312/0x6f0
> Apr 12 21:34:47  [75707.120799]  [<ffffffff8148d9db>] ?
> entry_SYSCALL_64_fastpath+0x16/0x6e
> 
> Once this starts, a couple of minutes goes by and the machine locks up
> completely.
> 
> I have been unable to locate the problem here, anyone that can point me in
> the right direction?
> 
> Best regards
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
