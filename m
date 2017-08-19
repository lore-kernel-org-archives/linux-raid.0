From: Vasco Steinmetz <linux@kyberraum.net>
Subject: Warning in raid5-cache.c with NVME journal and DM_MQ_DEFAULT
Date: Sat, 19 Aug 2017 06:52:09 +0200
Message-ID: <d7042309-ab0c-9a7a-ecb6-d8988a38888e@kyberraum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

after adding an NVME (intel optane) as a journal device to an existing
raid5 under kernel 4.12.4, I'm experiencing the following warnings in
the kernel log:

[ 5430.188385] WARNING: CPU: 4 PID: 0 at drivers/md/raid5-cache.c:296
__r5l_stripe_write_finished+0x1a8/0x1b0
[ 5430.188385] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl
lockd grace af_packet tun bonding msr binfmt_misc dm_crypt loop rpcrdma
sunrpc ib_srp scsi_transport_srp ib_ipoib rdma_ucm rdma_cm iw_cm ib_cm
configfs ib_uverbs ib_umad mlx4_ib ib_core ipv6 input_leds led_class
hid_generic usbhid hid ipmi_ssif evdev x86_pkg_temp_thermal
crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc
nct6775 igb hwmon_vid aesni_intel aes_x86_64 crypto_simd xhci_pci
glue_helper xhci_hcd i2c_algo_bit ehci_pci cryptd ehci_hcd ptp i2c_i801
pps_core usbcore dca coretemp deadline_iosched mlx4_core hwmon i2c_core
pcspkr usb_common intel_pch_thermal 8250 thermal 8250_base ipmi_si fan
serial_core ipmi_devintf rtc_cmos ipmi_msghandler button unix
[ 5430.188428] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 4.12.4 #1
[ 5430.188429] Hardware name: Supermicro X10SL7-F/X10SL7-F, BIOS 3.0a
12/17/2015
[ 5430.188430] task: ffff8807fbfba640 task.stack: ffffc900031b0000
[ 5430.188433] RIP: 0010:__r5l_stripe_write_finished+0x1a8/0x1b0
[ 5430.188434] RSP: 0018:ffff88081fd03d20 EFLAGS: 00010002
[ 5430.188435] RAX: 0000000000000082 RBX: ffff8804268b0ee0 RCX:
0000000000000001
[ 5430.188436] RDX: 0000000000000101 RSI: 0000000000000001 RDI:
ffff880429884070
[ 5430.188437] RBP: ffff88081fd03d58 R08: 0000000000000101 R09:
0000000000000001
[ 5430.188438] R10: ffff88081fd03b10 R11: 0000000000000001 R12:
ffff880429884078
[ 5430.188438] R13: ffff880429884070 R14: ffff8807f767eb28 R15:
ffff880429884000
[ 5430.188440] FS:  0000000000000000(0000) GS:ffff88081fd00000(0000)
knlGS:0000000000000000
[ 5430.188440] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5430.188441] CR2: 0000000001d2a000 CR3: 0000000001809000 CR4:
00000000001406e0
[ 5430.188442] Call Trace:
[ 5430.188443]  <IRQ>
[ 5430.188446]  r5l_log_endio+0x17c/0x290
[ 5430.188449]  bio_endio+0x61/0x70
[ 5430.188453]  blk_update_request+0x7d/0x2b0
[ 5430.188455]  blk_mq_end_request+0x15/0x60
[ 5430.188459]  nvme_complete_rq+0x1e/0xe0
[ 5430.188461]  nvme_pci_complete_rq+0x10b/0x150
[ 5430.188463]  __blk_mq_complete_request+0x8c/0x140
[ 5430.188464]  blk_mq_complete_request+0x11/0x20
[ 5430.188466]  __nvme_process_cq+0x89/0x1c0
[ 5430.188468]  nvme_irq+0x1b/0x30
[ 5430.188471]  __handle_irq_event_percpu+0x65/0xd0
[ 5430.188472]  handle_irq_event_percpu+0x1e/0x50
[ 5430.188473]  handle_irq_event+0x27/0x50
[ 5430.188475]  handle_edge_irq+0x9a/0x120
[ 5430.188479]  handle_irq+0x15/0x20
[ 5430.188481]  do_IRQ+0x41/0xc0
[ 5430.188486]  common_interrupt+0x86/0x86
[ 5430.188489] RIP: 0010:cpuidle_enter_state+0x15f/0x1f0
[ 5430.188490] RSP: 0018:ffffc900031b3e90 EFLAGS: 00000286 ORIG_RAX:
ffffffffffffffdc
[ 5430.188491] RAX: ffff88081fd189c0 RBX: ffff88081fd1ff00 RCX:
000000000000001f
[ 5430.188492] RDX: 20c49ba5e353f7cf RSI: ffff88081fd161d8 RDI:
0000000000000000
[ 5430.188492] RBP: ffffc900031b3ec0 R08: ffff88081fd15b24 R09:
0000000000000018
[ 5430.188493] R10: ffffc900031b3e70 R11: 0000000000000190 R12:
000004f05070ffde
[ 5430.188494] R13: 0000000000000004 R14: ffffffff81850e18 R15:
0000000000000004
[ 5430.188494]  </IRQ>
[ 5430.188496]  cpuidle_enter+0x12/0x20
[ 5430.188500]  call_cpuidle+0x1e/0x30
[ 5430.188501]  do_idle+0x16f/0x1b0
[ 5430.188503]  cpu_startup_entry+0x18/0x20
[ 5430.188506]  start_secondary+0xe8/0xf0
[ 5430.188508]  secondary_startup_64+0x9f/0x9f
[ 5430.188509] Code: c8 48 8b 80 d0 02 00 00 a8 08 74 be eb ad 48 8b 75
d0 4c 89 ef e8 29 75 0e 00 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3
0f 0b <0f> ff e9 97 fe ff ff 90 55 48 89 e5 41 57 41 56 41 55 41 54 49
[ 5430.188533] ---[ end trace 6ecece6f3eb41632 ]---

The warnings appear only if blk-mq is compiled in and enabled as default
for dm per CONFIG_DM_MQ_DEFAULT.
When I disable this option the warning disappears.

I'm not sure whether I had writeback activated at that time.


Complete dmesg output and kernel config available upon request.


Kind regards,
Vasco

