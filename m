From: Nate Clark <nate@neworld.us>
Subject: NULL pointer dereference at 0000000000000038 IP: [<ffffffff815f514f>] bitmap_load+0x45f/0x610
Date: Fri, 19 Jun 2015 17:18:45 -0400
Message-ID: <CAG2YfWODJEAV2i=WhzvJQw2AicKL0-c-EvAMA+Y-UVQRo+jgrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I encountered a null pointer in md on kernel 4.0.4 and 4.0.5. I was running
Fedora so I filed this bug with redhat,
https://bugzilla.redhat.com/show_bug.cgi?id=1232492.

It seems pretty easy to encounter.
1) Add PROGRAM line in mdadm.conf, which points to a script that just
sleeps for 5 or 10 seconds
2) Create md device (I used raid 1 but I don't think that matters)
3) Stop that md device
4) Before the monitor program finishes execution assemble that md device.

On my system this always cause an Oops.

The full stack trace is:
[ 644.787990] md/raid1:md12: not clean -- starting background reconstruction
[ 644.787995] md/raid1:md12: active with 0 out of 2 mirrors
[ 644.788490] created bitmap (30 pages) for device md12
[ 644.799090] md12: bitmap initialized from disk: read 2 pages, set 59169
of 59615 bits
[ 644.799113] BUG: unable to handle kernel NULL pointer dereference at
0000000000000038
[ 644.807917] IP: [<ffffffff815f514f>] bitmap_load+0x45f/0x610
[ 644.807919] PGD 85974f067 PUD 85ba37067 PMD 0
[ 644.807921] Oops: 0002 [#1] SMP
[ 644.807960] Modules linked in: ip6t_REJECT nf_reject_ipv6 ip6table_filter
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_raw ip6_tables xt_conntrack iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_mangle xt_CT nf_conntrack
iptable_raw bonding intel_rapl iosf_mbi x86_pkg_temp_thermal coretemp
kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel iTCO_wdt
ghash_clmulni_intel iTCO_vendor_support ipmi_devintf i2c_algo_bit ttm
drm_kms_helper drm sb_edac lpc_ich tpm_tis mei_me i2c_i801 mfd_core
edac_core ipmi_si mei shpchp tpm wmi ipmi_msghandler nfsd auth_rpcgss
nfs_acl lockd grace sunrpc uas usb_storage raid1 ixgbe e1000e isci mpt2sas
mdio vxlan libsas ip6_udp_tunnel udp_tunnel dca raid_class ptp
scsi_transport_sas pps_core [last unloaded: amifldrv_mod]
[ 644.807960]
[ 644.807963] CPU: 2 PID: 17466 Comm: mdadm Tainted: P OE
4.0.5-300.fc22.x86_64 #1
[ 644.807964] Hardware name: Newisys NDS-SB1EA/NDS-SB1EA, BIOS HDS 9.00
11/13/2014
[ 644.807965] task: ffff880848ffa7c0 ti: ffff880848998000 task.ti:
ffff880848998000
[ 644.807967] RIP: 0010:[<ffffffff815f514f>] [<ffffffff815f514f>]
bitmap_load+0x45f/0x610
[ 644.807968] RSP: 0018:ffff88084899bc88 EFLAGS: 00010202
[ 644.807969] RAX: 0000000000000000 RBX: 00000000ffffffff RCX:
0000000000000049
[ 644.807970] RDX: 0000000000001388 RSI: ffff88087fc4e698 RDI:
ffff880856bbf800
[ 644.807971] RBP: ffff88084899bd18 R08: 000000000000000a R09:
0000000000000824
[ 644.807972] R10: ffffffff81f01fed R11: 0000000000000824 R12:
ffffea002160ac00
[ 644.807973] R13: 0000000000000001 R14: 000000000000e8df R15:
ffff8808577a7e00
[ 644.807974] FS: 00007fc328773700(0000) GS:ffff88087fc40000(0000)
knlGS:0000000000000000
[ 644.807975] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 644.807976] CR2: 0000000000000038 CR3: 00000008562c4000 CR4:
00000000000407e0
[ 644.807977] Stack:
[ 644.807978] 000000004899bca8 ffff880856bbfb50 ffff880856bbf800
000000000000e721
[ 644.807980] 0000000000000000 0000000000000000 0000000000000000
000000000000e8de
[ 644.807981] 000000000000e8df 0000000000000000 0000000008000000
00000000f2a8eda4
[ 644.807982] Call Trace:
[ 644.807988] [<ffffffff815ef950>] do_md_run+0x30/0xa0
[ 644.807989] [<ffffffff815f177e>] md_ioctl+0xe9e/0x1bc0
[ 644.807993] [<ffffffff810fed2d>] ? call_rcu_sched+0x1d/0x20
[ 644.807997] [<ffffffff811b8ff1>] ? shmem_destroy_inode+0x31/0x50
[ 644.808001] [<ffffffff8123a267>] ? evict+0x107/0x190
[ 644.808005] [<ffffffff8137cd5f>] blkdev_ioctl+0x1bf/0x7d0
[ 644.808007] [<ffffffff81236075>] ? dput+0xc5/0x230
[ 644.808010] [<ffffffff81258a0d>] block_ioctl+0x3d/0x50
[ 644.808013] [<ffffffff81232036>] do_vfs_ioctl+0x2c6/0x4d0
[ 644.808016] [<ffffffff8121f13e>] ? ____fput+0xe/0x10
[ 644.808018] [<ffffffff812322c1>] SyS_ioctl+0x81/0xa0
[ 644.808022] [<ffffffff81789b09>] system_call_fastpath+0x12/0x17
[ 644.808037] Code: ff ff e8 a5 28 19 00 f0 41 80 67 78 fd 49 8b 47 30 f0
80 88 b8 01 00 00 20 48 8b 7d 80 48 8b 87 48 01 00 00 48 8b 97 80 03 00 00
<48> 89 50 38 48 8b bf 48 01 00 00 e8 b1 06 ff ff 4c 89 ff e8 59
[ 644.808039] RIP [<ffffffff815f514f>] bitmap_load+0x45f/0x610
[ 644.808039] RSP <ffff88084899bc88>
[ 644.808040] CR2: 0000000000000038

I do have full vmcores and dmesg if that information is needed.

Thanks,
-nate
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
