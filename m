From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [BUG]NULL Pointer dereference in rdev_set_badblocks
Date: Mon, 23 Sep 2013 10:10:03 +0200
Message-ID: <523FF75B.4000208@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020807010403060402090404"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020807010403060402090404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Neil and all,

I saw below NULL Pointer dereference in rdev_set_badblocks once:

when this happened, both devices in raid1 almost failed at same time, a
lot of io errors, after several minutes, super_written error and disable
on device and then run into NULL pointer dereference.

Could you comment on this?

 cat badblock_null.log
Sep  3 14:31:19 pserver102 kernel: [534312.102156] Modules linked in:
bridge stp llc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_t
ables raid1 md_mod dm_round_robin sd_mod crc_t10dif ib_srp
scsi_transport_srp scsi_tgt xt_ETHOIP6(O) x_tables vhost_net(O) macvtap
macvlan
tun(O) nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 rdma_ucm rdma_cm
iw_cm ib_addr ib_ipoib ib_cm ib_sa ib_uverbs ib_umad ib_qib mlx4_ib i
b_mthca ib_mad ib_core dm_multipath scsi_dh kvm_amd kvm sg powernow_k8
mperf crc32c_intel microcode tpm_tis tpm tpm_bios psmouse serio_raw
evdev usb_storage scsi_mod amd64_edac_mod edac_core edac_mce_amd
i2c_piix4 button processor thermal_sys mlx4_core
Sep  3 14:31:19 pserver102 kernel: [534312.103339]
Sep  3 14:31:19 pserver102 kernel: [534312.103432] Pid: 46599, comm:
md2_raid1 Tainted: G           O 3.4.51-4-pserver #1 Supermicro H8QG6/
H8QG6
Sep  3 14:31:19 pserver102 kernel: [534312.103658] RIP:
0010:[<ffffffffa02b3978>]  [<ffffffffa02b3978>]
rdev_set_badblocks+0x8/0x70 [md_mod
]
Sep  3 14:31:19 pserver102 kernel: [534312.103870] RSP:
0018:ffff881fbc197c10  EFLAGS: 00010282
Sep  3 14:31:19 pserver102 kernel: [534312.103976] RAX: 0000000000000000
RBX: 0000000000000000 RCX: 0000000000000000
Sep  3 14:31:19 pserver102 kernel: [534312.104171] RDX: 0000000000000008
RSI: 00000000001ad300 RDI: 0000000000000000
Sep  3 14:31:19 pserver102 kernel: [534312.104358] RBP: ffff881803fa55c0
R08: ffffea0100092418 R09: 0000000000000001
Sep  3 14:31:19 pserver102 kernel: [534312.104550] R10: 0000000000000000
R11: dead000000100100 R12: 0000000000000000
Sep  3 14:31:19 pserver102 kernel: [534312.104762] R13: 00000000001ad300
R14: 0000000000000010 R15: 0000000000000008
Sep  3 14:31:19 pserver102 kernel: [534312.104960] FS:
00007f3722277700(0000) GS:ffff880807d00000(0000) knlGS:0000000000000000
Sep  3 14:31:19 pserver102 kernel: [534312.105158] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Sep  3 14:31:19 pserver102 kernel: [534312.105263] CR2: 0000000000000058
CR3: 0000002003c15000 CR4: 00000000000407e0
Sep  3 14:31:19 pserver102 kernel: [534312.105456] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Sep  3 14:31:19 pserver102 kernel: [534312.105654] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Sep  3 14:31:19 pserver102 kernel: [534312.105854] Process md2_raid1
(pid: 46599, threadinfo ffff881fbc196000, task ffff881fc44ccaf0)
Sep  3 14:31:19 pserver102 kernel: [534312.106050] Stack:
Sep  3 14:31:19 pserver102 kernel: [534312.106148]  00000000001ad300
0000000000000001 ffff880800f11800 ffffffffa02c8df3
Sep  3 14:31:19 pserver102 kernel: [534312.106351]  ffff881fe461ef90
ffff881f00000020 0000100000000009 ffff880800f11800
Sep  3 14:31:19 pserver102 kernel: [534312.106558]  ffff88180324e000
ffff88180324e000 ffff8818ffffffff ffff883ffa7c5b50
Sep  3 14:31:19 pserver102 kernel: [534312.106774] Call Trace:
Sep  3 14:31:19 pserver102 kernel: [534312.106876]  [<ffffffffa02c8df3>]
? md_raid1_congested+0x1ab3/0x5560 [raid1]
Sep  3 14:31:19 pserver102 kernel: [534312.106989]  [<ffffffff813814af>]
? generic_make_request+0xaf/0xe0
Sep  3 14:31:19 pserver102 kernel: [534312.107101]  [<ffffffffa02c943c>]
? md_raid1_congested+0x20fc/0x5560 [raid1]
Sep  3 14:31:19 pserver102 kernel: [534312.107213]  [<ffffffff8167686b>]
? __schedule+0x2eb/0x750
Sep  3 14:31:19 pserver102 kernel: [534312.107320]  [<ffffffff81046e23>]
? lock_timer_base+0x33/0x70
Sep  3 14:31:19 pserver102 kernel: [534312.107429]  [<ffffffff810478bc>]
? try_to_del_timer_sync+0x7c/0xd0
Sep  3 14:31:19 pserver102 kernel: [534312.107538]  [<ffffffff81046e60>]
? lock_timer_base+0x70/0x70
Sep  3 14:31:19 pserver102 kernel: [534312.107652]  [<ffffffffa02b17ff>]
? md_rdev_init+0x23f/0x290 [md_mod]
Sep  3 14:31:19 pserver102 kernel: [534312.107765]  [<ffffffff81059db0>]
? wake_up_bit+0x40/0x40
Sep  3 14:31:19 pserver102 kernel: [534312.107876]  [<ffffffffa02b16e0>]
? md_rdev_init+0x120/0x290 [md_mod]
Sep  3 14:31:19 pserver102 kernel: [534312.107986]  [<ffffffffa02b16e0>]
? md_rdev_init+0x120/0x290 [md_mod]
Sep  3 14:31:19 pserver102 kernel: [534312.108096]  [<ffffffff8105988e>]
? kthread+0x9e/0xb0
Sep  3 14:31:19 pserver102 kernel: [534312.108203]  [<ffffffff816804a4>]
? kernel_thread_helper+0x4/0x10
Sep  3 14:31:19 pserver102 kernel: [534312.108310]  [<ffffffff810597f0>]
? kthread_freezable_should_stop+0x60/0x60
Sep  3 14:31:19 pserver102 kernel: [534312.108424]  [<ffffffff816804a0>]
? gs_change+0x13/0x13
Sep  3 14:31:19 pserver102 kernel: [534312.108530] Code: 01 00 00 e8 5b
95 ff ff 48 8b 7b 18 48 89 de e8 bf 97 ff ff e9 88 fe ff ff 66 2e 0
f 1f 84 00 00 00 00 00 53 48 89 fb 48 83 ec 10 <48> 03 77 58 48 8d bf 30
01 00 00 e8 28 9d ff ff 85 c0 75 0c 48


--------------020807010403060402090404
Content-Type: text/x-log;
 name="badblock_null.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="badblock_null.log"

Sep  3 14:30:58 pserver102 kernel: [534290.949370] sd 14:0:0:2: [sdbl]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:30:58 pserver102 kernel: [534290.949579] sd 14:0:0:2: [sdbl]  Sense Key : Illegal Request [current] 
Sep  3 14:30:58 pserver102 kernel: [534290.949703] sd 14:0:0:2: [sdbl]  Add. Sense: Logical unit not supported
Sep  3 14:30:58 pserver102 kernel: [534290.949821] sd 14:0:0:2: [sdbl] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:30:58 pserver102 kernel: [534290.950008] end_request: I/O error, dev sdbl, sector 0
Sep  3 14:31:07 pserver102 kernel: [534299.935235] sd 1:0:0:2: [sdbe]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:07 pserver102 kernel: [534299.935463] sd 1:0:0:2: [sdbe]  Sense Key : Illegal Request [current] 
Sep  3 14:31:07 pserver102 kernel: [534299.935585] sd 1:0:0:2: [sdbe]  Add. Sense: Logical unit not supported
Sep  3 14:31:07 pserver102 kernel: [534299.935714] sd 1:0:0:2: [sdbe] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:07 pserver102 kernel: [534299.935910] end_request: I/O error, dev sdbe, sector 0
Sep  3 14:31:07 pserver102 kernel: [534299.936158] sd 13:0:0:2: [sdbi]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:07 pserver102 kernel: [534299.936363] sd 13:0:0:2: [sdbi]  Sense Key : Illegal Request [current] 
Sep  3 14:31:07 pserver102 kernel: [534299.936482] sd 13:0:0:2: [sdbi]  Add. Sense: Logical unit not supported
Sep  3 14:31:07 pserver102 kernel: [534299.936601] sd 13:0:0:2: [sdbi] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:07 pserver102 kernel: [534299.936788] end_request: I/O error, dev sdbi, sector 0
Sep  3 14:31:08 pserver102 kernel: [534300.935144] sd 2:0:0:2: [sdbf]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:08 pserver102 kernel: [534300.935356] sd 2:0:0:2: [sdbf]  Sense Key : Illegal Request [current] 
Sep  3 14:31:08 pserver102 kernel: [534300.935485] sd 2:0:0:2: [sdbf]  Add. Sense: Logical unit not supported
Sep  3 14:31:08 pserver102 kernel: [534300.935610] sd 2:0:0:2: [sdbf] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:08 pserver102 kernel: [534300.935804] end_request: I/O error, dev sdbf, sector 0
Sep  3 14:31:08 pserver102 kernel: [534300.936059] sd 14:0:0:2: [sdbl]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:08 pserver102 kernel: [534300.936263] sd 14:0:0:2: [sdbl]  Sense Key : Illegal Request [current] 
Sep  3 14:31:08 pserver102 kernel: [534300.936406] sd 14:0:0:2: [sdbl]  Add. Sense: Logical unit not supported
Sep  3 14:31:08 pserver102 kernel: [534300.936527] sd 14:0:0:2: [sdbl] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:08 pserver102 kernel: [534300.936723] end_request: I/O error, dev sdbl, sector 0
Sep  3 14:31:17 pserver102 kernel: [534309.922663] sd 1:0:0:2: [sdbe]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:17 pserver102 kernel: [534309.922879] sd 1:0:0:2: [sdbe]  Sense Key : Illegal Request [current] 
Sep  3 14:31:17 pserver102 kernel: [534309.922999] sd 1:0:0:2: [sdbe]  Add. Sense: Logical unit not supported
Sep  3 14:31:17 pserver102 kernel: [534309.923118] sd 1:0:0:2: [sdbe] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:17 pserver102 kernel: [534309.925093] end_request: I/O error, dev sdbe, sector 0
Sep  3 14:31:17 pserver102 kernel: [534309.925357] sd 13:0:0:2: [sdbi]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:17 pserver102 kernel: [534309.925567] sd 13:0:0:2: [sdbi]  Sense Key : Illegal Request [current] 
Sep  3 14:31:17 pserver102 kernel: [534309.925689] sd 13:0:0:2: [sdbi]  Add. Sense: Logical unit not supported
Sep  3 14:31:17 pserver102 kernel: [534309.925803] sd 13:0:0:2: [sdbi] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:17 pserver102 kernel: [534309.926010] end_request: I/O error, dev sdbi, sector 0
Sep  3 14:31:18 pserver102 kernel: [534310.924583] sd 2:0:0:2: [sdbf]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:18 pserver102 kernel: [534310.924792] sd 2:0:0:2: [sdbf]  Sense Key : Illegal Request [current] 
Sep  3 14:31:18 pserver102 kernel: [534310.924914] sd 2:0:0:2: [sdbf]  Add. Sense: Logical unit not supported
Sep  3 14:31:18 pserver102 kernel: [534310.925040] sd 2:0:0:2: [sdbf] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:18 pserver102 kernel: [534310.925251] end_request: I/O error, dev sdbf, sector 0
Sep  3 14:31:18 pserver102 kernel: [534310.925488] sd 14:0:0:2: [sdbl]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:18 pserver102 kernel: [534310.925695] sd 14:0:0:2: [sdbl]  Sense Key : Illegal Request [current] 
Sep  3 14:31:18 pserver102 kernel: [534310.925816] sd 14:0:0:2: [sdbl]  Add. Sense: Logical unit not supported
Sep  3 14:31:18 pserver102 kernel: [534310.925943] sd 14:0:0:2: [sdbl] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:18 pserver102 kernel: [534310.926135] end_request: I/O error, dev sdbl, sector 0
Sep  3 14:31:19 pserver102 kernel: [534311.924892] end_request: I/O error, dev dm-13, sector 16
Sep  3 14:31:19 pserver102 kernel: [534311.925015] end_request: I/O error, dev dm-13, sector 16
Sep  3 14:31:19 pserver102 kernel: [534311.925130] md: super_written gets error=-5, uptodate=0
Sep  3 14:31:19 pserver102 kernel: [534311.925247] md/raid1:md2: Disk failure on dm-13, disabling device.
Sep  3 14:31:19 pserver102 kernel: [534311.925248] md/raid1:md2: Operation continuing on 1 devices.
Sep  3 14:31:19 pserver102 kernel: [534311.925487] end_request: I/O error, dev dm-13, sector 1766144
Sep  3 14:31:19 pserver102 kernel: [534311.925597] md/raid1:md2: dm-13: rescheduling sector 1757952
Sep  3 14:31:19 pserver102 kernel: [534311.925710] end_request: I/O error, dev dm-13, sector 428328
Sep  3 14:31:19 pserver102 kernel: [534311.925831] md/raid1:md2: dm-13: rescheduling sector 420136
Sep  3 14:31:19 pserver102 kernel: [534311.925949] end_request: I/O error, dev dm-13, sector 434952
Sep  3 14:31:19 pserver102 kernel: [534311.926064] md/raid1:md2: dm-13: rescheduling sector 426760
Sep  3 14:31:19 pserver102 kernel: [534311.926178] end_request: I/O error, dev dm-14, sector 16
Sep  3 14:31:19 pserver102 kernel: [534311.926296] md: super_written gets error=-5, uptodate=0
Sep  3 14:31:19 pserver102 kernel: [534311.926458] md: super_written gets error=-5, uptodate=0
Sep  3 14:31:19 pserver102 kernel: [534311.926690] md: super_written gets error=-5, uptodate=0
Sep  3 14:31:19 pserver102 kernel: [534311.926923] RAID1 conf printout:
Sep  3 14:31:19 pserver102 kernel: [534311.926929]  --- wd:1 rd:2
Sep  3 14:31:19 pserver102 kernel: [534311.926935]  disk 0, wo:0, o:1, dev:dm-14
Sep  3 14:31:19 pserver102 kernel: [534311.926939]  disk 1, wo:1, o:0, dev:dm-13
Sep  3 14:31:19 pserver102 kernel: [534312.101337] RAID1 conf printout:
Sep  3 14:31:19 pserver102 kernel: [534312.101343]  --- wd:1 rd:2
Sep  3 14:31:19 pserver102 kernel: [534312.101348]  disk 0, wo:0, o:1, dev:dm-14
Sep  3 14:31:19 pserver102 kernel: [534312.101393] md: super_written gets error=-5, uptodate=0
Sep  3 14:31:19 pserver102 kernel: [534312.101611] BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
Sep  3 14:31:19 pserver102 kernel: [534312.101813] IP: [<ffffffffa02b3978>] rdev_set_badblocks+0x8/0x70 [md_mod]
Sep  3 14:31:19 pserver102 kernel: [534312.101937] PGD 0 
Sep  3 14:31:19 pserver102 kernel: [534312.102037] Oops: 0000 [#1] SMP 
Sep  3 14:31:19 pserver102 kernel: [534312.102149] CPU 4 
Sep  3 14:31:19 pserver102 kernel: [534312.102156] Modules linked in: bridge stp llc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables raid1 md_mod dm_round_robin sd_mod crc_t10dif ib_srp scsi_transport_srp scsi_tgt xt_ETHOIP6(O) x_tables vhost_net(O) macvtap macvlan tun(O) nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 rdma_ucm rdma_cm iw_cm ib_addr ib_ipoib ib_cm ib_sa ib_uverbs ib_umad ib_qib mlx4_ib ib_mthca ib_mad ib_core dm_multipath scsi_dh kvm_amd kvm sg powernow_k8 mperf crc32c_intel microcode tpm_tis tpm tpm_bios psmouse serio_raw evdev usb_storage scsi_mod amd64_edac_mod edac_core edac_mce_amd i2c_piix4 button processor thermal_sys mlx4_core
Sep  3 14:31:19 pserver102 kernel: [534312.103339] 
Sep  3 14:31:19 pserver102 kernel: [534312.103432] Pid: 46599, comm: md2_raid1 Tainted: G           O 3.4.51-4-pserver #1 Supermicro H8QG6/H8QG6
Sep  3 14:31:19 pserver102 kernel: [534312.103658] RIP: 0010:[<ffffffffa02b3978>]  [<ffffffffa02b3978>] rdev_set_badblocks+0x8/0x70 [md_mod]
Sep  3 14:31:19 pserver102 kernel: [534312.103870] RSP: 0018:ffff881fbc197c10  EFLAGS: 00010282
Sep  3 14:31:19 pserver102 kernel: [534312.103976] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
Sep  3 14:31:19 pserver102 kernel: [534312.104171] RDX: 0000000000000008 RSI: 00000000001ad300 RDI: 0000000000000000
Sep  3 14:31:19 pserver102 kernel: [534312.104358] RBP: ffff881803fa55c0 R08: ffffea0100092418 R09: 0000000000000001
Sep  3 14:31:19 pserver102 kernel: [534312.104550] R10: 0000000000000000 R11: dead000000100100 R12: 0000000000000000
Sep  3 14:31:19 pserver102 kernel: [534312.104762] R13: 00000000001ad300 R14: 0000000000000010 R15: 0000000000000008
Sep  3 14:31:19 pserver102 kernel: [534312.104960] FS:  00007f3722277700(0000) GS:ffff880807d00000(0000) knlGS:0000000000000000
Sep  3 14:31:19 pserver102 kernel: [534312.105158] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep  3 14:31:19 pserver102 kernel: [534312.105263] CR2: 0000000000000058 CR3: 0000002003c15000 CR4: 00000000000407e0
Sep  3 14:31:19 pserver102 kernel: [534312.105456] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Sep  3 14:31:19 pserver102 kernel: [534312.105654] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Sep  3 14:31:19 pserver102 kernel: [534312.105854] Process md2_raid1 (pid: 46599, threadinfo ffff881fbc196000, task ffff881fc44ccaf0)
Sep  3 14:31:19 pserver102 kernel: [534312.106050] Stack:
Sep  3 14:31:19 pserver102 kernel: [534312.106148]  00000000001ad300 0000000000000001 ffff880800f11800 ffffffffa02c8df3
Sep  3 14:31:19 pserver102 kernel: [534312.106351]  ffff881fe461ef90 ffff881f00000020 0000100000000009 ffff880800f11800
Sep  3 14:31:19 pserver102 kernel: [534312.106558]  ffff88180324e000 ffff88180324e000 ffff8818ffffffff ffff883ffa7c5b50
Sep  3 14:31:19 pserver102 kernel: [534312.106774] Call Trace:
Sep  3 14:31:19 pserver102 kernel: [534312.106876]  [<ffffffffa02c8df3>] ? md_raid1_congested+0x1ab3/0x5560 [raid1]
Sep  3 14:31:19 pserver102 kernel: [534312.106989]  [<ffffffff813814af>] ? generic_make_request+0xaf/0xe0
Sep  3 14:31:19 pserver102 kernel: [534312.107101]  [<ffffffffa02c943c>] ? md_raid1_congested+0x20fc/0x5560 [raid1]
Sep  3 14:31:19 pserver102 kernel: [534312.107213]  [<ffffffff8167686b>] ? __schedule+0x2eb/0x750
Sep  3 14:31:19 pserver102 kernel: [534312.107320]  [<ffffffff81046e23>] ? lock_timer_base+0x33/0x70
Sep  3 14:31:19 pserver102 kernel: [534312.107429]  [<ffffffff810478bc>] ? try_to_del_timer_sync+0x7c/0xd0
Sep  3 14:31:19 pserver102 kernel: [534312.107538]  [<ffffffff81046e60>] ? lock_timer_base+0x70/0x70
Sep  3 14:31:19 pserver102 kernel: [534312.107652]  [<ffffffffa02b17ff>] ? md_rdev_init+0x23f/0x290 [md_mod]
Sep  3 14:31:19 pserver102 kernel: [534312.107765]  [<ffffffff81059db0>] ? wake_up_bit+0x40/0x40
Sep  3 14:31:19 pserver102 kernel: [534312.107876]  [<ffffffffa02b16e0>] ? md_rdev_init+0x120/0x290 [md_mod]
Sep  3 14:31:19 pserver102 kernel: [534312.107986]  [<ffffffffa02b16e0>] ? md_rdev_init+0x120/0x290 [md_mod]
Sep  3 14:31:19 pserver102 kernel: [534312.108096]  [<ffffffff8105988e>] ? kthread+0x9e/0xb0
Sep  3 14:31:19 pserver102 kernel: [534312.108203]  [<ffffffff816804a4>] ? kernel_thread_helper+0x4/0x10
Sep  3 14:31:19 pserver102 kernel: [534312.108310]  [<ffffffff810597f0>] ? kthread_freezable_should_stop+0x60/0x60
Sep  3 14:31:19 pserver102 kernel: [534312.108424]  [<ffffffff816804a0>] ? gs_change+0x13/0x13
Sep  3 14:31:19 pserver102 kernel: [534312.108530] Code: 01 00 00 e8 5b 95 ff ff 48 8b 7b 18 48 89 de e8 bf 97 ff ff e9 88 fe ff ff 66 2e 0f 1f 84 00 00 00 00 00 53 48 89 fb 48 83 ec 10 <48> 03 77 58 48 8d bf 30 01 00 00 e8 28 9d ff ff 85 c0 75 0c 48 
Sep  3 14:31:19 pserver102 kernel: [534312.109159] RIP  [<ffffffffa02b3978>] rdev_set_badblocks+0x8/0x70 [md_mod]
Sep  3 14:31:19 pserver102 kernel: [534312.109270]  RSP <ffff881fbc197c10>
Sep  3 14:31:19 pserver102 kernel: [534312.109368] CR2: 0000000000000058
Sep  3 14:31:19 pserver102 kernel: [534312.109865] ---[ end trace b195a0cfb8232033 ]---
Sep  3 14:31:27 pserver102 kernel: [534319.926023] sd 1:0:0:2: [sdbe]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:27 pserver102 kernel: [534319.926385] sd 1:0:0:2: [sdbe]  Sense Key : Illegal Request [current] 
Sep  3 14:31:27 pserver102 kernel: [534319.926738] sd 1:0:0:2: [sdbe]  Add. Sense: Logical unit not supported
Sep  3 14:31:27 pserver102 kernel: [534319.927032] sd 1:0:0:2: [sdbe] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:27 pserver102 kernel: [534319.928016] blk_update_request: 15 callbacks suppressed
Sep  3 14:31:27 pserver102 kernel: [534319.928187] end_request: I/O error, dev sdbe, sector 0
Sep  3 14:31:27 pserver102 kernel: [534319.928498] sd 13:0:0:2: [sdbi]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:27 pserver102 kernel: [534319.928814] sd 13:0:0:2: [sdbi]  Sense Key : Illegal Request [current] 
Sep  3 14:31:27 pserver102 kernel: [534319.929186] sd 13:0:0:2: [sdbi]  Add. Sense: Logical unit not supported
Sep  3 14:31:27 pserver102 kernel: [534319.929494] sd 13:0:0:2: [sdbi] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:27 pserver102 kernel: [534319.930502] end_request: I/O error, dev sdbi, sector 0
Sep  3 14:31:28 pserver102 kernel: [534320.929556] sd 2:0:0:2: [sdbf]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:28 pserver102 kernel: [534320.929887] sd 2:0:0:2: [sdbf]  Sense Key : Illegal Request [current] 
Sep  3 14:31:28 pserver102 kernel: [534320.930245] sd 2:0:0:2: [sdbf]  Add. Sense: Logical unit not supported
Sep  3 14:31:28 pserver102 kernel: [534320.930536] sd 2:0:0:2: [sdbf] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:28 pserver102 kernel: [534320.931540] end_request: I/O error, dev sdbf, sector 0
Sep  3 14:31:28 pserver102 kernel: [534320.931848] sd 14:0:0:2: [sdbl]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:28 pserver102 kernel: [534320.932165] sd 14:0:0:2: [sdbl]  Sense Key : Illegal Request [current] 
Sep  3 14:31:28 pserver102 kernel: [534320.932526] sd 14:0:0:2: [sdbl]  Add. Sense: Logical unit not supported
Sep  3 14:31:28 pserver102 kernel: [534320.932828] sd 14:0:0:2: [sdbl] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Sep  3 14:31:28 pserver102 kernel: [534320.933825] end_request: I/O error, dev sdbl, sector 0
Sep  3 14:31:37 pserver102 kernel: [534329.928044] sd 1:0:0:2: [sdbe]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Sep  3 14:31:37 pserver102 kernel: [534329.928376] sd 1:0:0:2: [sdbe]  Sense Key : Illegal Request [current] 
Sep  3 14:31:37 pserver102 kernel: [534329.928731] sd 1:0:0:2: [sdbe]  Add. Sense: Logical unit not supported

--------------020807010403060402090404--
