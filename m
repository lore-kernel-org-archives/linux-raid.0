Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBCFEE49AF
	for <linux-raid@archiver.kernel.org>; Tue, 22 Aug 2023 19:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjHVT00 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjHVT0Z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Aug 2023 15:26:25 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E75DB
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 12:26:23 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-5008faf4456so1505345e87.3
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 12:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692732381; x=1693337181;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m/WmPGB09Nvl3Z+m4jVS2vWRRjCNj+LAFchYUCeV5Cs=;
        b=SrpbaKf9OKvfUyY0Y3BF7eagfjnYBP6m0s/F8NQd5smZAjqT5axK1SYsFSDea6qyJY
         Gwenk9uREjaNkjZNryDmbqzm0u/Ks8B/BDGUrjSdvqY5HGuDtNHUStM6VGhDg/Loij3l
         TwPZi7apuCyZbzLaiw59VebATFILY+uQDCfWkVEaMRRiK4RCgC5cJagh3ExE6TqlHyZp
         nGvyMsOx/k2C+Fx9LOoEsyAvOHv13V4iMsUPiNEcwIwTKu2WRRpfpNr/X5jl2DpbRtE1
         SdkM1Ut+Nn4YwcsCKvivKbpHCdD8qBk2vOnYWZOOHavKwb8v1oYY9yzBx3HElG6VxoeA
         Wv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692732381; x=1693337181;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m/WmPGB09Nvl3Z+m4jVS2vWRRjCNj+LAFchYUCeV5Cs=;
        b=fjWjsobA1wckS7esIvgXMREhqGLxrBohZEMXdODsgI9nz4qUDSkY9d5jYfQ6u8IaE1
         2655LkXKBY/7V/djuY7fYFKJbSkxYdfZrnlcCFiXZdsj8Bk+qIWhOmqyyUZxY7Ys6kAA
         7ZrcCkHT52iMRHgIeNEpyy95Dt8di7VcCq2MERHRPdvWXAEJutEGlUHGUG88FtRNAiS7
         IMCETjU8SgxyAcBwBHC20xcYYAbxOE0+4Pj9pukK6pyhaAhauu8ikQ11vBsa/1aRTTOQ
         Fuw/+h3cu7L3nU8WBCWtSK0i7IGsvT0cn/30oO/FJTyCoYgRzE8WoW1t6klXJO83BqjX
         jcow==
X-Gm-Message-State: AOJu0YzO9jTDOjdCaRKX1ZDeYdmlFq2X9CbWeI5sVty5rjZC7VGtJ+b8
        e16jx7VTuJ8biyDIsvXiZ3qX7MibDPWS9CTeNdI6PXVH2dxcqA==
X-Google-Smtp-Source: AGHT+IEJ3x53rp1SD1XbYmE+V7mHgUPv6iHyrQ4bGi9jaqGNipBSVKvNDey6BmWG66F5Xv4FjmCR/7rz4+e4OdJSz60=
X-Received: by 2002:a05:6512:12cb:b0:500:8443:744a with SMTP id
 p11-20020a05651212cb00b005008443744amr5773791lfg.7.1692732380851; Tue, 22 Aug
 2023 12:26:20 -0700 (PDT)
MIME-Version: 1.0
From:   Yiyi Hu <yiyihu@gmail.com>
Date:   Wed, 23 Aug 2023 03:26:09 +0800
Message-ID: <CA+-1TMPXUpxnpxixYHBbVYBGKjKQbW0XcAOQEiuZgWMGaxHP5g@mail.gmail.com>
Subject: Is this a kernel NULL pointer deferences bug in raid5 module?
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, when I upgrade to kernel 6.1.46 I'll meet this bug, running around
a day or within 2 days randomly.
Actually, I met this with 6.1.0, then I waited for 6.1.7, 6.1.15,
6.1.27, I waited so long and use the old 5.15.x series kernel and no
one seems to meet this. So I decided to report this bug after I tried
6.1.46.
kernel error log:

# tested on 2023-08-18, with 6.1.46, The bug still exists.
[ 3258.356331] BUG: kernel NULL pointer dereference, address: 0000000000000050
[ 3258.356340] #PF: supervisor read access in kernel mode
[ 3258.356343] #PF: error_code(0x0000) - not-present page
[ 3258.356345] PGD 0 P4D 0
[ 3258.356348] Oops: 0000 [#1] PREEMPT SMP
[ 3258.356351] CPU: 2 PID: 3956 Comm: md127_raid6 Tainted: G S
        6.1.46-gentoo #1
[ 3258.356355] Hardware name: To Be Filled By O.E.M. X370 Killer
SLI/X370 Killer SLI, BIOS P7.10 05/10/2022
[ 3258.356358] RIP: 0010:blk_cgroup_bio_start+0x46/0xa0
[ 3258.356364] Code: 00 00 0f 45 c2 89 c5 e8 98 26 b3 ff 48 c7 c7 e0
bf 36 82 e8 2c 65 4b 00 48 8b 43 48 0f b7 4b 14 65 8b 35 9d 88 aa 7e
48 63 d6 <48> 8b 40 50 48 03 04 d5 60 e8 38 82 48 63 d5 f6 c5 01 75 0e
80 cd
[ 3258.356368] RSP: 0018:ffffc90000c4fcd8 EFLAGS: 00010286
[ 3258.356371] RAX: 0000000000000000 RBX: ffff88810ec530b8 RCX: 0000000000000000
[ 3258.356373] RDX: 0000000000000002 RSI: 0000000000000002 RDI: ffffffff823354de
[ 3258.356375] RBP: 0000000000000001 R08: 0000000000040001 R09: ffff888108f2e8a8
[ 3258.356377] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888108f2e8a8
[ 3258.356379] R13: 8000000000000000 R14: 0000000000000003 R15: ffffc90000c4fd58
[ 3258.356382] FS:  0000000000000000(0000) GS:ffff889fbe880000(0000)
knlGS:0000000000000000
[ 3258.356384] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3258.356386] CR2: 0000000000000050 CR3: 00000009705ad000 CR4: 0000000000350ee0
[ 3258.356389] Call Trace:
[ 3258.356391]  <TASK>
[ 3258.356394]  ? __die_body.cold+0x1a/0x1f
[ 3258.356399]  ? page_fault_oops+0xae/0x280
[ 3258.356403]  ? do_user_addr_fault+0x61/0x4c0
[ 3258.356406]  ? exc_page_fault+0x5c/0x120
[ 3258.356409]  ? asm_exc_page_fault+0x22/0x30
[ 3258.356414]  ? blk_cgroup_bio_start+0x46/0xa0
[ 3258.356417]  ? blk_cgroup_bio_start+0x34/0xa0
[ 3258.356420]  submit_bio_noacct_nocheck+0x38/0x380
[ 3258.356424]  ? bio_init+0x6d/0xb0
[ 3258.356428]  ? submit_bio_noacct+0x52/0x300
[ 3258.356434]  handle_active_stripes.constprop.0+0x2cc/0x4b0 [raid456]
[ 3258.356447]  raid5d+0x359/0x5b0 [raid456]
[ 3258.356453]  ? common_interrupt+0xc6/0xd0
[ 3258.356457]  ? schedule_timeout+0x10a/0x140
[ 3258.356459]  ? preempt_count_add+0x62/0x90
[ 3258.356463]  ? md_free_disk+0x80/0x80
[ 3258.356467]  md_thread+0xa4/0x150
[ 3258.356470]  ? destroy_sched_domains_rcu+0x30/0x30
[ 3258.356475]  kthread+0xe6/0x110
[ 3258.356477]  ? kthread_complete_and_exit+0x20/0x20
[ 3258.356480]  ret_from_fork+0x1f/0x30
[ 3258.356484]  </TASK>
[ 3258.356485] Modules linked in: target_core_user uio
target_core_pscsi target_core_file target_core_iblock iscsi_target_mod
rpcsec_gss_krb5 nfsv4 nfs fscache netfs dm_cache_smq dm_cache
dm_persistent_data dm_bio_prison dm_bufio dm_queue_length macvtap
macvlan ipip dummy bridge stp llc nf_tables sch_fq_codel virtio_vdpa
vduse vdpa rdma_rxe ip6_udp_tunnel udp_tunnel nvme_rdma nvmet_rdma
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq raid1 raid0 linear bcache nvmet nvme_tcp nvme_fabrics
dm_writecache msr thermal rpcrdma rt2800usb rdma_ucm rt2x00usb ib_iser
rt2800lib rt2x00lib ib_umad rdma_cm ib_ipoib iw_cm mac80211
snd_hda_codec_realtek snd_hda_codec_generic ib_cm ledtrig_audio
snd_hda_intel snd_intel_dspcfg cfg80211 snd_hda_codec rfkill
nf_conntrack_tftp snd_hda_core nf_conntrack_netbios_ns
nf_conntrack_broadcast snd_hwdep nf_nat_ftp nf_conntrack_ftp wmi_bmof
mxm_wmi snd_pcm nf_nat evdev nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 snd_timer snd kvm_amd
[ 3258.356537]  nct6775 rapl soundcore nct6775_core pcspkr hwmon_vid
vhost_net mlx4_ib ocrdma rtc_cmos tun wmi vhost ib_uverbs vhost_iotlb
tap button ib_core acpi_cpufreq kvm irqbypass k10temp nfsd loop fuse
drm auth_rpcgss nfs_acl lockd grace dmi_sysfs mlx4_en crct10dif_pclmul
crc32_pclmul igb nvme crc32c_intel ghash_clmulni_intel sha512_ssse3
aesni_intel crypto_simd be2net mlx4_core i2c_algo_bit nvme_core sd_mod
hwmon xhci_pci t10_pi crc64_rocksoft_generic xhci_hcd crc64_rocksoft
crc64 sunrpc dm_mirror dm_region_hash dm_log be2iscsi iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi dm_multipath dm_mod dax
efivarfs
[ 3258.356597] CR2: 0000000000000050
[ 3258.356599] ---[ end trace 0000000000000000 ]---
[ 3258.356601] RIP: 0010:blk_cgroup_bio_start+0x46/0xa0
[ 3258.356604] Code: 00 00 0f 45 c2 89 c5 e8 98 26 b3 ff 48 c7 c7 e0
bf 36 82 e8 2c 65 4b 00 48 8b 43 48 0f b7 4b 14 65 8b 35 9d 88 aa 7e
48 63 d6 <48> 8b 40 50 48 03 04 d5 60 e8 38 82 48 63 d5 f6 c5 01 75 0e
80 cd
[ 3258.356608] RSP: 0018:ffffc90000c4fcd8 EFLAGS: 00010286
[ 3258.356610] RAX: 0000000000000000 RBX: ffff88810ec530b8 RCX: 0000000000000000
[ 3258.356613] RDX: 0000000000000002 RSI: 0000000000000002 RDI: ffffffff823354de
[ 3258.356614] RBP: 0000000000000001 R08: 0000000000040001 R09: ffff888108f2e8a8
[ 3258.356616] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888108f2e8a8
[ 3258.356618] R13: 8000000000000000 R14: 0000000000000003 R15: ffffc90000c4fd58
[ 3258.356621] FS:  0000000000000000(0000) GS:ffff889fbe880000(0000)
knlGS:0000000000000000
[ 3258.356626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3258.356630] CR2: 0000000000000050 CR3: 00000009705ad000 CR4: 0000000000350ee0
[ 3258.356633] note: md127_raid6[3956] exited with irqs disabled
[ 3258.356642] note: md127_raid6[3956] exited with preempt_count 1
[ 3258.356646] ------------[ cut here ]------------
[ 3258.356647] WARNING: CPU: 2 PID: 3956 at kernel/exit.c:814
do_exit+0x8b2/0xa50
[ 3258.356652] Modules linked in: target_core_user uio
target_core_pscsi target_core_file target_core_iblock iscsi_target_mod
rpcsec_gss_krb5 nfsv4 nfs fscache netfs dm_cache_smq dm_cache
dm_persistent_data dm_bio_prison dm_bufio dm_queue_length macvtap
macvlan ipip dummy bridge stp llc nf_tables sch_fq_codel virtio_vdpa
vduse vdpa rdma_rxe ip6_udp_tunnel udp_tunnel nvme_rdma nvmet_rdma
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq raid1 raid0 linear bcache nvmet nvme_tcp nvme_fabrics
dm_writecache msr thermal rpcrdma rt2800usb rdma_ucm rt2x00usb ib_iser
rt2800lib rt2x00lib ib_umad rdma_cm ib_ipoib iw_cm mac80211
snd_hda_codec_realtek snd_hda_codec_generic ib_cm ledtrig_audio
snd_hda_intel snd_intel_dspcfg cfg80211 snd_hda_codec rfkill
nf_conntrack_tftp snd_hda_core nf_conntrack_netbios_ns
nf_conntrack_broadcast snd_hwdep nf_nat_ftp nf_conntrack_ftp wmi_bmof
mxm_wmi snd_pcm nf_nat evdev nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 snd_timer snd kvm_amd
[ 3258.356693]  nct6775 rapl soundcore nct6775_core pcspkr hwmon_vid
vhost_net mlx4_ib ocrdma rtc_cmos tun wmi vhost ib_uverbs vhost_iotlb
tap button ib_core acpi_cpufreq kvm irqbypass k10temp nfsd loop fuse
drm auth_rpcgss nfs_acl lockd grace dmi_sysfs mlx4_en crct10dif_pclmul
crc32_pclmul igb nvme crc32c_intel ghash_clmulni_intel sha512_ssse3
aesni_intel crypto_simd be2net mlx4_core i2c_algo_bit nvme_core sd_mod
hwmon xhci_pci t10_pi crc64_rocksoft_generic xhci_hcd crc64_rocksoft
crc64 sunrpc dm_mirror dm_region_hash dm_log be2iscsi iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi dm_multipath dm_mod dax
efivarfs
[ 3258.356741] CPU: 2 PID: 3956 Comm: md127_raid6 Tainted: G S    D
        6.1.46-gentoo #1
[ 3258.356744] Hardware name: To Be Filled By O.E.M. X370 Killer
SLI/X370 Killer SLI, BIOS P7.10 05/10/2022
[ 3258.356747] RIP: 0010:do_exit+0x8b2/0xa50
[ 3258.356749] Code: 1c ff ff ff 48 89 df e8 ac 96 0c 00 e9 8e f9 ff
ff 0f 0b e9 9a f7 ff ff 4c 89 e6 bf 05 06 00 00 e8 43 ea 00 00 e9 6a
f8 ff ff <0f> 0b e9 bd f7 ff ff 48 8b bb f8 06 00 00 e8 cb dc ff ff 48
85 c0
[ 3258.356753] RSP: 0018:ffffc90000c4fed8 EFLAGS: 00010286
[ 3258.356756] RAX: 0000000080000000 RBX: ffff88811121be00 RCX: 0000000000000000
[ 3258.356758] RDX: 0000000000000001 RSI: 0000000000002710 RDI: 00000000ffffffff
[ 3258.356760] RBP: ffff88810fcb5100 R08: 0000000000009ffb R09: 00000000ffffdfff
[ 3258.356762] R10: ffff88a03f23f240 R11: ffff88a03f23f240 R12: 0000000000000009
[ 3258.356764] R13: ffff8881101e7380 R14: 0000000000000000 R15: 0000000000000000
[ 3258.356766] FS:  0000000000000000(0000) GS:ffff889fbe880000(0000)
knlGS:0000000000000000
[ 3258.356768] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3258.356770] CR2: 0000000000000050 CR3: 00000009705ad000 CR4: 0000000000350ee0
[ 3258.356772] Call Trace:
[ 3258.356774]  <TASK>
[ 3258.356775]  ? __warn+0x7d/0xc0
[ 3258.356779]  ? do_exit+0x8b2/0xa50
[ 3258.356782]  ? report_bug+0xe2/0x170
[ 3258.356785]  ? handle_bug+0x3c/0x60
[ 3258.356788]  ? exc_invalid_op+0x13/0x60
[ 3258.356790]  ? asm_exc_invalid_op+0x16/0x20
[ 3258.356794]  ? do_exit+0x8b2/0xa50
[ 3258.356796]  ? do_exit+0x68/0xa50
[ 3258.356798]  make_task_dead+0x89/0x90
[ 3258.356800]  rewind_stack_and_make_dead+0x17/0x20
[ 3258.356803] RIP: 0000:0x0
[ 3258.356807] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[ 3258.356809] RSP: 0000:0000000000000000 EFLAGS: 00000000 ORIG_RAX:
0000000000000000
[ 3258.356811] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 3258.356813] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 3258.356815] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 3258.356817] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 3258.356818] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 3258.356821]  </TASK>
[ 3258.356823] ---[ end trace 0000000000000000 ]---

I'm using gentoo on raid6,
 # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
md126 : active raid1 dm-18[2] dm-10[0]
      8379392 blocks super 1.2 [2/2] [UU]

md127 : active raid6 md126[0](J) sdb2[1] sda2[6] sdd2[2] sde2[3] sdc2[5] sdf2[4]
      23441016832 blocks super 1.2 level 6, 512k chunk, algorithm 2
[6/6] [UUUUUU]

# mdadm --detail /dev/md126
/dev/md126:
           Version : 1.2
     Creation Time : Mon Nov 28 23:35:53 2022
        Raid Level : raid1
        Array Size : 8379392 (7.99 GiB 8.58 GB)
     Used Dev Size : 8379392 (7.99 GiB 8.58 GB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Wed Aug 23 03:12:09 2023
             State : clean
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : resync

              Name : m:r6_wjournal  (local to host m)
              UUID : b26db5f9:4632ad63:ad25132e:6fbac76a
            Events : 21830666

    Number   Major   Minor   RaidDevice State
       0     253       10        0      active sync   /dev/dm-10
       2     253       18        1      active sync   /dev/dm-18

 # mdadm --detail /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Tue Nov 29 00:24:51 2022
        Raid Level : raid6
        Array Size : 23441016832 (21.83 TiB 24.00 TB)
     Used Dev Size : 5860254208 (5.46 TiB 6.00 TB)
      Raid Devices : 6
     Total Devices : 7
       Persistence : Superblock is persistent

       Update Time : Wed Aug 23 03:12:39 2023
             State : clean
    Active Devices : 6
   Working Devices : 7
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : journal

              Name : m:m_r6_pv  (local to host m)
              UUID : 14a8576e:8050f86a:e7e29ac7:07d1ddf1
            Events : 19741955

    Number   Major   Minor   RaidDevice State
       1       8       18        0      active sync   /dev/sdb2
       2       8       50        1      active sync   /dev/sdd2
       3       8       66        2      active sync   /dev/sde2
       4       8       82        3      active sync   /dev/sdf2
       5       8       34        4      active sync   /dev/sdc2
       6       8        2        5      active sync   /dev/sda2

       0       9      126        -      journal   /dev/md/m:r6_wjournal


Is this a raid module bug? or should I report the bug to other mailing list?
