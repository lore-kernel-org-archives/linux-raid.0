Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD9BEE49A5
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 01:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjHWBJk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Aug 2023 21:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjHWBJk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Aug 2023 21:09:40 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95050CFE
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 18:09:37 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RVp5n4jKHz4f3lCp
        for <linux-raid@vger.kernel.org>; Wed, 23 Aug 2023 09:09:33 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgDHoqVKXOVkvyZwBQ--.55554S3;
        Wed, 23 Aug 2023 09:09:32 +0800 (CST)
Subject: Re: Is this a kernel NULL pointer deferences bug in raid5 module?
To:     Yiyi Hu <yiyihu@gmail.com>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>,
        "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <CA+-1TMPXUpxnpxixYHBbVYBGKjKQbW0XcAOQEiuZgWMGaxHP5g@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e68077c0-598a-cc19-21c9-7855a96db695@huaweicloud.com>
Date:   Wed, 23 Aug 2023 09:09:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+-1TMPXUpxnpxixYHBbVYBGKjKQbW0XcAOQEiuZgWMGaxHP5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgDHoqVKXOVkvyZwBQ--.55554S3
X-Coremail-Antispam: 1UD129KBjvAXoWfJFWxGF43Kw4DuryDJryUAwb_yoW8JFy5Go
        W8Ar1UJw48W34UtF18KF1DJw47Jr4fJFnxAFyUCr45CrnrGrZrXr1kCr4rJw13Kr1xGrW5
        Aa4ktr17K345Xws7n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUU5E7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK
        8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/08/23 3:26, Yiyi Hu 写道:
> Hi, when I upgrade to kernel 6.1.46 I'll meet this bug, running around
> a day or within 2 days randomly.
> Actually, I met this with 6.1.0, then I waited for 6.1.7, 6.1.15,
> 6.1.27, I waited so long and use the old 5.15.x series kernel and no
> one seems to meet this. So I decided to report this bug after I tried
> 6.1.46.
> kernel error log:
> 
> # tested on 2023-08-18, with 6.1.46, The bug still exists.
> [ 3258.356331] BUG: kernel NULL pointer dereference, address: 0000000000000050
> [ 3258.356340] #PF: supervisor read access in kernel mode
> [ 3258.356343] #PF: error_code(0x0000) - not-present page
> [ 3258.356345] PGD 0 P4D 0
> [ 3258.356348] Oops: 0000 [#1] PREEMPT SMP
> [ 3258.356351] CPU: 2 PID: 3956 Comm: md127_raid6 Tainted: G S
>          6.1.46-gentoo #1
> [ 3258.356355] Hardware name: To Be Filled By O.E.M. X370 Killer
> SLI/X370 Killer SLI, BIOS P7.10 05/10/2022
> [ 3258.356358] RIP: 0010:blk_cgroup_bio_start+0x46/0xa0
> [ 3258.356364] Code: 00 00 0f 45 c2 89 c5 e8 98 26 b3 ff 48 c7 c7 e0
> bf 36 82 e8 2c 65 4b 00 48 8b 43 48 0f b7 4b 14 65 8b 35 9d 88 aa 7e
> 48 63 d6 <48> 8b 40 50 48 03 04 d5 60 e8 38 82 48 63 d5 f6 c5 01 75 0e
> 80 cd
> [ 3258.356368] RSP: 0018:ffffc90000c4fcd8 EFLAGS: 00010286
> [ 3258.356371] RAX: 0000000000000000 RBX: ffff88810ec530b8 RCX: 0000000000000000
> [ 3258.356373] RDX: 0000000000000002 RSI: 0000000000000002 RDI: ffffffff823354de
> [ 3258.356375] RBP: 0000000000000001 R08: 0000000000040001 R09: ffff888108f2e8a8
> [ 3258.356377] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888108f2e8a8
> [ 3258.356379] R13: 8000000000000000 R14: 0000000000000003 R15: ffffc90000c4fd58
> [ 3258.356382] FS:  0000000000000000(0000) GS:ffff889fbe880000(0000)
> knlGS:0000000000000000
> [ 3258.356384] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3258.356386] CR2: 0000000000000050 CR3: 00000009705ad000 CR4: 0000000000350ee0
> [ 3258.356389] Call Trace:
> [ 3258.356391]  <TASK>
> [ 3258.356394]  ? __die_body.cold+0x1a/0x1f
> [ 3258.356399]  ? page_fault_oops+0xae/0x280
> [ 3258.356403]  ? do_user_addr_fault+0x61/0x4c0
> [ 3258.356406]  ? exc_page_fault+0x5c/0x120
> [ 3258.356409]  ? asm_exc_page_fault+0x22/0x30
> [ 3258.356414]  ? blk_cgroup_bio_start+0x46/0xa0
> [ 3258.356417]  ? blk_cgroup_bio_start+0x34/0xa0
> [ 3258.356420]  submit_bio_noacct_nocheck+0x38/0x380
> [ 3258.356424]  ? bio_init+0x6d/0xb0
> [ 3258.356428]  ? submit_bio_noacct+0x52/0x300
> [ 3258.356434]  handle_active_stripes.constprop.0+0x2cc/0x4b0 [raid456]
> [ 3258.356447]  raid5d+0x359/0x5b0 [raid456]

Looks like this is the same as following:

https://lore.kernel.org/all/7c57f3a8-36e9-4805-b1ea-a4fd3406f7bb@fatooh.org/

And this is fixed by:

https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=0d0bd28c500173bfca78aa840f8f36d261ef1765

Thanks,
Kuai

> [ 3258.356453]  ? common_interrupt+0xc6/0xd0
> [ 3258.356457]  ? schedule_timeout+0x10a/0x140
> [ 3258.356459]  ? preempt_count_add+0x62/0x90
> [ 3258.356463]  ? md_free_disk+0x80/0x80
> [ 3258.356467]  md_thread+0xa4/0x150
> [ 3258.356470]  ? destroy_sched_domains_rcu+0x30/0x30
> [ 3258.356475]  kthread+0xe6/0x110
> [ 3258.356477]  ? kthread_complete_and_exit+0x20/0x20
> [ 3258.356480]  ret_from_fork+0x1f/0x30
> [ 3258.356484]  </TASK>
> [ 3258.356485] Modules linked in: target_core_user uio
> target_core_pscsi target_core_file target_core_iblock iscsi_target_mod
> rpcsec_gss_krb5 nfsv4 nfs fscache netfs dm_cache_smq dm_cache
> dm_persistent_data dm_bio_prison dm_bufio dm_queue_length macvtap
> macvlan ipip dummy bridge stp llc nf_tables sch_fq_codel virtio_vdpa
> vduse vdpa rdma_rxe ip6_udp_tunnel udp_tunnel nvme_rdma nvmet_rdma
> raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> raid6_pq raid1 raid0 linear bcache nvmet nvme_tcp nvme_fabrics
> dm_writecache msr thermal rpcrdma rt2800usb rdma_ucm rt2x00usb ib_iser
> rt2800lib rt2x00lib ib_umad rdma_cm ib_ipoib iw_cm mac80211
> snd_hda_codec_realtek snd_hda_codec_generic ib_cm ledtrig_audio
> snd_hda_intel snd_intel_dspcfg cfg80211 snd_hda_codec rfkill
> nf_conntrack_tftp snd_hda_core nf_conntrack_netbios_ns
> nf_conntrack_broadcast snd_hwdep nf_nat_ftp nf_conntrack_ftp wmi_bmof
> mxm_wmi snd_pcm nf_nat evdev nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 snd_timer snd kvm_amd
> [ 3258.356537]  nct6775 rapl soundcore nct6775_core pcspkr hwmon_vid
> vhost_net mlx4_ib ocrdma rtc_cmos tun wmi vhost ib_uverbs vhost_iotlb
> tap button ib_core acpi_cpufreq kvm irqbypass k10temp nfsd loop fuse
> drm auth_rpcgss nfs_acl lockd grace dmi_sysfs mlx4_en crct10dif_pclmul
> crc32_pclmul igb nvme crc32c_intel ghash_clmulni_intel sha512_ssse3
> aesni_intel crypto_simd be2net mlx4_core i2c_algo_bit nvme_core sd_mod
> hwmon xhci_pci t10_pi crc64_rocksoft_generic xhci_hcd crc64_rocksoft
> crc64 sunrpc dm_mirror dm_region_hash dm_log be2iscsi iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi dm_multipath dm_mod dax
> efivarfs
> [ 3258.356597] CR2: 0000000000000050
> [ 3258.356599] ---[ end trace 0000000000000000 ]---
> [ 3258.356601] RIP: 0010:blk_cgroup_bio_start+0x46/0xa0
> [ 3258.356604] Code: 00 00 0f 45 c2 89 c5 e8 98 26 b3 ff 48 c7 c7 e0
> bf 36 82 e8 2c 65 4b 00 48 8b 43 48 0f b7 4b 14 65 8b 35 9d 88 aa 7e
> 48 63 d6 <48> 8b 40 50 48 03 04 d5 60 e8 38 82 48 63 d5 f6 c5 01 75 0e
> 80 cd
> [ 3258.356608] RSP: 0018:ffffc90000c4fcd8 EFLAGS: 00010286
> [ 3258.356610] RAX: 0000000000000000 RBX: ffff88810ec530b8 RCX: 0000000000000000
> [ 3258.356613] RDX: 0000000000000002 RSI: 0000000000000002 RDI: ffffffff823354de
> [ 3258.356614] RBP: 0000000000000001 R08: 0000000000040001 R09: ffff888108f2e8a8
> [ 3258.356616] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888108f2e8a8
> [ 3258.356618] R13: 8000000000000000 R14: 0000000000000003 R15: ffffc90000c4fd58
> [ 3258.356621] FS:  0000000000000000(0000) GS:ffff889fbe880000(0000)
> knlGS:0000000000000000
> [ 3258.356626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3258.356630] CR2: 0000000000000050 CR3: 00000009705ad000 CR4: 0000000000350ee0
> [ 3258.356633] note: md127_raid6[3956] exited with irqs disabled
> [ 3258.356642] note: md127_raid6[3956] exited with preempt_count 1
> [ 3258.356646] ------------[ cut here ]------------
> [ 3258.356647] WARNING: CPU: 2 PID: 3956 at kernel/exit.c:814
> do_exit+0x8b2/0xa50
> [ 3258.356652] Modules linked in: target_core_user uio
> target_core_pscsi target_core_file target_core_iblock iscsi_target_mod
> rpcsec_gss_krb5 nfsv4 nfs fscache netfs dm_cache_smq dm_cache
> dm_persistent_data dm_bio_prison dm_bufio dm_queue_length macvtap
> macvlan ipip dummy bridge stp llc nf_tables sch_fq_codel virtio_vdpa
> vduse vdpa rdma_rxe ip6_udp_tunnel udp_tunnel nvme_rdma nvmet_rdma
> raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> raid6_pq raid1 raid0 linear bcache nvmet nvme_tcp nvme_fabrics
> dm_writecache msr thermal rpcrdma rt2800usb rdma_ucm rt2x00usb ib_iser
> rt2800lib rt2x00lib ib_umad rdma_cm ib_ipoib iw_cm mac80211
> snd_hda_codec_realtek snd_hda_codec_generic ib_cm ledtrig_audio
> snd_hda_intel snd_intel_dspcfg cfg80211 snd_hda_codec rfkill
> nf_conntrack_tftp snd_hda_core nf_conntrack_netbios_ns
> nf_conntrack_broadcast snd_hwdep nf_nat_ftp nf_conntrack_ftp wmi_bmof
> mxm_wmi snd_pcm nf_nat evdev nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 snd_timer snd kvm_amd
> [ 3258.356693]  nct6775 rapl soundcore nct6775_core pcspkr hwmon_vid
> vhost_net mlx4_ib ocrdma rtc_cmos tun wmi vhost ib_uverbs vhost_iotlb
> tap button ib_core acpi_cpufreq kvm irqbypass k10temp nfsd loop fuse
> drm auth_rpcgss nfs_acl lockd grace dmi_sysfs mlx4_en crct10dif_pclmul
> crc32_pclmul igb nvme crc32c_intel ghash_clmulni_intel sha512_ssse3
> aesni_intel crypto_simd be2net mlx4_core i2c_algo_bit nvme_core sd_mod
> hwmon xhci_pci t10_pi crc64_rocksoft_generic xhci_hcd crc64_rocksoft
> crc64 sunrpc dm_mirror dm_region_hash dm_log be2iscsi iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi dm_multipath dm_mod dax
> efivarfs
> [ 3258.356741] CPU: 2 PID: 3956 Comm: md127_raid6 Tainted: G S    D
>          6.1.46-gentoo #1
> [ 3258.356744] Hardware name: To Be Filled By O.E.M. X370 Killer
> SLI/X370 Killer SLI, BIOS P7.10 05/10/2022
> [ 3258.356747] RIP: 0010:do_exit+0x8b2/0xa50
> [ 3258.356749] Code: 1c ff ff ff 48 89 df e8 ac 96 0c 00 e9 8e f9 ff
> ff 0f 0b e9 9a f7 ff ff 4c 89 e6 bf 05 06 00 00 e8 43 ea 00 00 e9 6a
> f8 ff ff <0f> 0b e9 bd f7 ff ff 48 8b bb f8 06 00 00 e8 cb dc ff ff 48
> 85 c0
> [ 3258.356753] RSP: 0018:ffffc90000c4fed8 EFLAGS: 00010286
> [ 3258.356756] RAX: 0000000080000000 RBX: ffff88811121be00 RCX: 0000000000000000
> [ 3258.356758] RDX: 0000000000000001 RSI: 0000000000002710 RDI: 00000000ffffffff
> [ 3258.356760] RBP: ffff88810fcb5100 R08: 0000000000009ffb R09: 00000000ffffdfff
> [ 3258.356762] R10: ffff88a03f23f240 R11: ffff88a03f23f240 R12: 0000000000000009
> [ 3258.356764] R13: ffff8881101e7380 R14: 0000000000000000 R15: 0000000000000000
> [ 3258.356766] FS:  0000000000000000(0000) GS:ffff889fbe880000(0000)
> knlGS:0000000000000000
> [ 3258.356768] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3258.356770] CR2: 0000000000000050 CR3: 00000009705ad000 CR4: 0000000000350ee0
> [ 3258.356772] Call Trace:
> [ 3258.356774]  <TASK>
> [ 3258.356775]  ? __warn+0x7d/0xc0
> [ 3258.356779]  ? do_exit+0x8b2/0xa50
> [ 3258.356782]  ? report_bug+0xe2/0x170
> [ 3258.356785]  ? handle_bug+0x3c/0x60
> [ 3258.356788]  ? exc_invalid_op+0x13/0x60
> [ 3258.356790]  ? asm_exc_invalid_op+0x16/0x20
> [ 3258.356794]  ? do_exit+0x8b2/0xa50
> [ 3258.356796]  ? do_exit+0x68/0xa50
> [ 3258.356798]  make_task_dead+0x89/0x90
> [ 3258.356800]  rewind_stack_and_make_dead+0x17/0x20
> [ 3258.356803] RIP: 0000:0x0
> [ 3258.356807] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> [ 3258.356809] RSP: 0000:0000000000000000 EFLAGS: 00000000 ORIG_RAX:
> 0000000000000000
> [ 3258.356811] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [ 3258.356813] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [ 3258.356815] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> [ 3258.356817] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [ 3258.356818] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [ 3258.356821]  </TASK>
> [ 3258.356823] ---[ end trace 0000000000000000 ]---
> 
> I'm using gentoo on raid6,
>   # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> md126 : active raid1 dm-18[2] dm-10[0]
>        8379392 blocks super 1.2 [2/2] [UU]
> 
> md127 : active raid6 md126[0](J) sdb2[1] sda2[6] sdd2[2] sde2[3] sdc2[5] sdf2[4]
>        23441016832 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [6/6] [UUUUUU]
> 
> # mdadm --detail /dev/md126
> /dev/md126:
>             Version : 1.2
>       Creation Time : Mon Nov 28 23:35:53 2022
>          Raid Level : raid1
>          Array Size : 8379392 (7.99 GiB 8.58 GB)
>       Used Dev Size : 8379392 (7.99 GiB 8.58 GB)
>        Raid Devices : 2
>       Total Devices : 2
>         Persistence : Superblock is persistent
> 
>         Update Time : Wed Aug 23 03:12:09 2023
>               State : clean
>      Active Devices : 2
>     Working Devices : 2
>      Failed Devices : 0
>       Spare Devices : 0
> 
> Consistency Policy : resync
> 
>                Name : m:r6_wjournal  (local to host m)
>                UUID : b26db5f9:4632ad63:ad25132e:6fbac76a
>              Events : 21830666
> 
>      Number   Major   Minor   RaidDevice State
>         0     253       10        0      active sync   /dev/dm-10
>         2     253       18        1      active sync   /dev/dm-18
> 
>   # mdadm --detail /dev/md127
> /dev/md127:
>             Version : 1.2
>       Creation Time : Tue Nov 29 00:24:51 2022
>          Raid Level : raid6
>          Array Size : 23441016832 (21.83 TiB 24.00 TB)
>       Used Dev Size : 5860254208 (5.46 TiB 6.00 TB)
>        Raid Devices : 6
>       Total Devices : 7
>         Persistence : Superblock is persistent
> 
>         Update Time : Wed Aug 23 03:12:39 2023
>               State : clean
>      Active Devices : 6
>     Working Devices : 7
>      Failed Devices : 0
>       Spare Devices : 0
> 
>              Layout : left-symmetric
>          Chunk Size : 512K
> 
> Consistency Policy : journal
> 
>                Name : m:m_r6_pv  (local to host m)
>                UUID : 14a8576e:8050f86a:e7e29ac7:07d1ddf1
>              Events : 19741955
> 
>      Number   Major   Minor   RaidDevice State
>         1       8       18        0      active sync   /dev/sdb2
>         2       8       50        1      active sync   /dev/sdd2
>         3       8       66        2      active sync   /dev/sde2
>         4       8       82        3      active sync   /dev/sdf2
>         5       8       34        4      active sync   /dev/sdc2
>         6       8        2        5      active sync   /dev/sda2
> 
>         0       9      126        -      journal   /dev/md/m:r6_wjournal
> 
> 
> Is this a raid module bug? or should I report the bug to other mailing list?
> .
> 

