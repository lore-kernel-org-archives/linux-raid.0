Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D12CCCA481
	for <linux-raid@archiver.kernel.org>; Wed,  8 Jun 2022 06:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbiFHGCO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242272AbiFHFxx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 01:53:53 -0400
Received: from forward103j.mail.yandex.net (forward103j.mail.yandex.net [5.45.198.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E1F6171
        for <linux-raid@vger.kernel.org>; Tue,  7 Jun 2022 20:47:15 -0700 (PDT)
Received: from sas2-599c596a5fe6.qloud-c.yandex.net (sas2-599c596a5fe6.qloud-c.yandex.net [IPv6:2a02:6b8:c08:b999:0:640:599c:596a])
        by forward103j.mail.yandex.net (Yandex) with ESMTP id 20E75103170
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 06:47:14 +0300 (MSK)
Received: from sas8-c6148047b62a.qloud-c.yandex.net (sas8-c6148047b62a.qloud-c.yandex.net [2a02:6b8:c1b:2a11:0:640:c614:8047])
        by sas2-599c596a5fe6.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 3nJINfXeZs-lEf0rFpk;
        Wed, 08 Jun 2022 06:47:14 +0300
X-Yandex-Fwd: 2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ngs.ru; s=mail; t=1654660034;
        bh=YLlj6mZ7owEx/p+KsifQoorXE2wOvINMw1MXhrUl3dU=;
        h=From:To:Subject:Date:Message-ID;
        b=pvyWkaXUG9CI19zq1SKRVAjm4+UiFe8HSbI9QPqItaQf8j5XDjLfgXyuwwp0vJWPu
         YnPFe8eAr1xSGNvz9mtn4Npdy1b5N9DnGZ8q9vWszwPWISBrXhPYCQG622cnZ/f5f0
         5ZmPEONAfGaIruKKhFafTM4H4JIAWlYZfHopoZUQ=
Authentication-Results: sas2-599c596a5fe6.qloud-c.yandex.net; dkim=pass header.i=@ngs.ru
Received: by sas8-c6148047b62a.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id opvDykKCTf-lDNmKeG2;
        Wed, 08 Jun 2022 06:47:13 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Message-ID: <984f2ca5-2565-025d-62a2-2425b518a01f@ngs.ru>
Date:   Wed, 8 Jun 2022 10:48:09 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To:     linux-raid@vger.kernel.org
Content-Language: ru
From:   Pavel <pavel2000@ngs.ru>
Subject: Misbehavior of md-raid RAID on failed NVMe.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, linux-raid community.

Today we found a strange and even scaring behavior of md-raid RAID based 
on NVMe devices.

We ordered new server, and started data transfer (using dd, filesystems 
was unmounted on source, etc - no errors here).

While data in transfer, kernel started IO errors reporting on one of 
NVMe devices. (dmesg output below)
But md-raid not reacted on them in any way. RAID array not went into any 
failed state, and "clean" state reported all the time.

Based on earlier practice, we trusted md-raid and thought things goes ok.
After data transfer finished, server was turned off and cables was 
replaced on suspicion.

After OS started on this new server, we found MySQL crashes.
Thorough checksum check showed us mismatches on files content.
(Of course, we did checksumming of untouched files, not MySQL database 
files)

So, there is data-loss possible when NVMe device behaves wrong.
We think, md-raid has to remove failed device from raid in a such case.
That it didn't happen is wrong behaviour, so want to inform community 
about finding.

Hope, this will help to make kernel ever better.
Thanks for your work.

---

Full dmesg available on https://areainter.net/nvme-fail-dmesg.txt .

Linux version 5.16.5 (root@build.fsn1-hwlab.hetzner.company) (gcc 
(Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 
2.35.2) #1 SMP Mon Feb 7 07:50:07 UTC 2022
...
[Tue Jun  7 09:53:50 2022] I/O error, dev nvme0n1, sector 692601496 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:53:51 2022] nvme nvme0: request 0x20 genctr mismatch (got 
0x2 expected 0x0)
[Tue Jun  7 09:53:51 2022] nvme nvme0: invalid id 8224 completed on 
queue 32
[Tue Jun  7 09:53:51 2022] I/O error, dev nvme0n1, sector 694551976 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:53:51 2022] I/O error, dev nvme0n1, sector 694897016 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:53:53 2022] nvme nvme0: request 0x3e0 genctr mismatch 
(got 0xd expected 0xe)
[Tue Jun  7 09:53:53 2022] nvme nvme0: invalid id 54240 completed on 
queue 16
[Tue Jun  7 09:53:53 2022] could not locate request for tag 0x8d4
[Tue Jun  7 09:53:53 2022] nvme nvme0: invalid id 18644 completed on 
queue 16
[Tue Jun  7 09:53:53 2022] I/O error, dev nvme0n1, sector 699600520 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
.. similar messages cut ..
[Tue Jun  7 09:54:20 2022] I/O error, dev nvme0n1, sector 59150536 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:54:21 2022] nvme nvme0: I/O 12 QID 32 timeout, aborting
[Tue Jun  7 09:54:21 2022] nvme nvme0: Abort status: 0x0
[Tue Jun  7 09:54:21 2022] I/O error, dev nvme0n1, sector 60858552 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:54:23 2022] nvme nvme0: I/O 207 QID 16 timeout, aborting
[Tue Jun  7 09:54:23 2022] nvme nvme0: I/O 208 QID 16 timeout, aborting
[Tue Jun  7 09:54:23 2022] nvme nvme0: Abort status: 0x0
[Tue Jun  7 09:54:23 2022] nvme nvme0: Abort status: 0x0
[Tue Jun  7 09:54:24 2022] I/O error, dev nvme0n1, sector 370882864 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:54:35 2022] nvme nvme0: request 0x0 genctr mismatch (got 
0x0 expected 0xe)
[Tue Jun  7 09:54:35 2022] nvme nvme0: invalid id 0 completed on queue 12
...
[Tue Jun  7 09:58:45 2022] I/O error, dev nvme0n1, sector 537397400 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:58:45 2022] ------------[ cut here ]------------
[Tue Jun  7 09:58:45 2022] WARNING: CPU: 0 PID: 79690 at 
drivers/iommu/dma-iommu.c:848 iommu_dma_unmap_page+0x33/0x84
[Tue Jun  7 09:58:45 2022] Modules linked in: dm_mod sctp ip6_udp_tunnel 
udp_tunnel libcrc32c dell_rbu ipmi_devintf ipmi_msghandler dcdbas 
intel_rapl_msr intel_rapl_common amd64_edac kvm_amd kvm irqbypass nvme 
crc32_pclmul sp5100_tco crc32c_intel nvme_core wmi_bmof 
ghash_clmulni_intel ahci ccp aesni_intel t10_pi libahci i2c_piix4 
sha1_generic k10temp crypto_simd serio_raw cryptd acpi_cpufreq button 
jc42 ftsteutates nct6775 wmi hwmon_vid fuse configfs ip_tables x_tables 
autofs4 igb i2c_algo_bit dca evdev
[Tue Jun  7 09:58:45 2022] CPU: 0 PID: 79690 Comm: md0_raid1 Not tainted 
5.16.5 #1
[Tue Jun  7 09:58:45 2022] Hardware name: ASUS System Product Name/Pro 
WS 565-ACE, BIOS 2424 09/29/2021
[Tue Jun  7 09:58:45 2022] RIP: 0010:iommu_dma_unmap_page+0x33/0x84
[Tue Jun  7 09:58:45 2022] Code: cf 41 56 49 89 f6 41 55 49 89 d5 41 54 
55 48 89 fd 53 4c 89 c3 e8 51 e1 ff ff 4c 89 f6 48 89 c7 e8 92 c4 ff ff 
48 85 c0 75 04 <0f> 0b eb 42 4c 89 f6 48 89 ef 4c 89 ea 49 89 c4 e8 b7 
fe ff ff 48
[Tue Jun  7 09:58:45 2022] RSP: 0018:ffff889fae805e78 EFLAGS: 00010046
[Tue Jun  7 09:58:45 2022] RAX: 0000000000000000 RBX: 0000000000000000 
RCX: 000000000000000c
[Tue Jun  7 09:58:45 2022] RDX: ffff88810b0f35f0 RSI: 0000000000000000 
RDI: 0000000000000000
[Tue Jun  7 09:58:45 2022] RBP: ffff8881019e60d0 R08: ffff88810b0f35f0 
R09: 0000000000000000
[Tue Jun  7 09:58:45 2022] R10: 0000000000000000 R11: ffff889fae805ff8 
R12: ffff88810854e000
[Tue Jun  7 09:58:45 2022] R13: 0000000000001000 R14: 00000000cf4be000 
R15: 0000000000000001
[Tue Jun  7 09:58:45 2022] FS:  0000000000000000(0000) 
GS:ffff889fae800000(0000) knlGS:0000000000000000
[Tue Jun  7 09:58:45 2022] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Tue Jun  7 09:58:45 2022] CR2: 00007f4a97564c98 CR3: 000000011bb28000 
CR4: 0000000000350ef0
[Tue Jun  7 09:58:45 2022] Call Trace:
[Tue Jun  7 09:58:45 2022]  <IRQ>
[Tue Jun  7 09:58:45 2022]  nvme_pci_complete_rq+0x5b/0x67 [nvme]
[Tue Jun  7 09:58:45 2022]  nvme_poll_cq+0x1e4/0x265 [nvme]
[Tue Jun  7 09:58:45 2022]  nvme_irq+0x36/0x6e [nvme]
[Tue Jun  7 09:58:45 2022]  __handle_irq_event_percpu+0x73/0x13e
[Tue Jun  7 09:58:45 2022]  handle_irq_event_percpu+0x31/0x77
[Tue Jun  7 09:58:45 2022]  handle_irq_event+0x2e/0x51
[Tue Jun  7 09:58:45 2022]  handle_edge_irq+0xc9/0xee
[Tue Jun  7 09:58:45 2022]  __common_interrupt+0x41/0x9e
[Tue Jun  7 09:58:45 2022]  common_interrupt+0x6e/0x8b
[Tue Jun  7 09:58:45 2022]  </IRQ>
[Tue Jun  7 09:58:45 2022]  <TASK>
[Tue Jun  7 09:58:45 2022]  asm_common_interrupt+0x1e/0x40
[Tue Jun  7 09:58:45 2022] RIP: 0010:__blk_mq_try_issue_directly+0x12/0x136
[Tue Jun  7 09:58:45 2022] Code: fe ff ff 48 8b 97 78 01 00 00 48 8b 92 
80 00 00 00 48 89 34 c2 b0 01 c3 0f 1f 44 00 00 41 57 41 56 41 55 41 54 
55 48 89 f5 53 <89> d3 48 83 ec 18 65 48 8b 04 25 28 00 00 00 48 89 44 
24 10 31 c0
[Tue Jun  7 09:58:45 2022] RSP: 0018:ffff88810bbf7ad8 EFLAGS: 00000246
[Tue Jun  7 09:58:45 2022] RAX: 0000000000000000 RBX: 0000000000000001 
RCX: 0000000000000001
[Tue Jun  7 09:58:45 2022] RDX: 0000000000000001 RSI: ffff8881137e6e40 
RDI: ffff88810dfdf400
[Tue Jun  7 09:58:45 2022] RBP: ffff8881137e6e40 R08: 0000000000000001 
R09: 0000000000000a20
[Tue Jun  7 09:58:45 2022] R10: 0000000000000000 R11: 0000000000000000 
R12: 0000000000000000
[Tue Jun  7 09:58:45 2022] R13: ffff88810dfdf400 R14: ffff8881137e6e40 
R15: ffff88810bbf7df0
[Tue Jun  7 09:58:45 2022] blk_mq_request_issue_directly+0x46/0x78
[Tue Jun  7 09:58:45 2022] blk_mq_try_issue_list_directly+0x41/0xba
[Tue Jun  7 09:58:45 2022]  blk_mq_sched_insert_requests+0x86/0xd0
[Tue Jun  7 09:58:45 2022]  blk_mq_flush_plug_list+0x1b5/0x214
[Tue Jun  7 09:58:45 2022]  ? __blk_mq_alloc_requests+0x1c7/0x21d
[Tue Jun  7 09:58:45 2022]  blk_mq_submit_bio+0x437/0x518
[Tue Jun  7 09:58:45 2022]  submit_bio_noacct+0x93/0x1e6
[Tue Jun  7 09:58:45 2022]  ? bio_associate_blkg_from_css+0x137/0x15c
[Tue Jun  7 09:58:45 2022]  flush_bio_list+0x96/0xa5
[Tue Jun  7 09:58:45 2022]  flush_pending_writes+0x7a/0xbf
[Tue Jun  7 09:58:45 2022]  ? md_check_recovery+0x8a/0x4bd
[Tue Jun  7 09:58:45 2022]  raid1d+0x194/0x10e8
[Tue Jun  7 09:58:45 2022]  ? common_interrupt+0xf/0x8b
[Tue Jun  7 09:58:45 2022]  md_thread+0x12c/0x155
[Tue Jun  7 09:58:45 2022]  ? init_wait_entry+0x29/0x29
[Tue Jun  7 09:58:45 2022]  ? signal_pending+0x19/0x19
[Tue Jun  7 09:58:45 2022]  kthread+0x104/0x10c
[Tue Jun  7 09:58:45 2022]  ? set_kthread_struct+0x32/0x32
[Tue Jun  7 09:58:45 2022]  ret_from_fork+0x22/0x30
[Tue Jun  7 09:58:45 2022]  </TASK>
[Tue Jun  7 09:58:45 2022] ---[ end trace 15dc74ae2e04f737 ]---
[Tue Jun  7 09:58:45 2022] ------------[ cut here ]------------
[Tue Jun  7 09:58:45 2022] refcount_t: underflow; use-after-free.
[Tue Jun  7 09:58:45 2022] WARNING: CPU: 0 PID: 79690 at 
lib/refcount.c:28 refcount_warn_saturate+0xa7/0xe8
[Tue Jun  7 09:58:45 2022] Modules linked in: dm_mod sctp ip6_udp_tunnel 
udp_tunnel libcrc32c dell_rbu ipmi_devintf ipmi_msghandler dcdbas 
intel_rapl_msr intel_rapl_common amd64_edac kvm_amd kvm irqbypass nvme 
crc32_pclmul sp5100_tco crc32c_intel nvme_core wmi_bmof 
ghash_clmulni_intel ahci ccp aesni_intel t10_pi libahci i2c_piix4 
sha1_generic k10temp crypto_simd serio_raw cryptd acpi_cpufreq button 
jc42 ftsteutates nct6775 wmi hwmon_vid fuse configfs ip_tables x_tables 
autofs4 igb i2c_algo_bit dca evdev
[Tue Jun  7 09:58:45 2022] CPU: 0 PID: 79690 Comm: md0_raid1 Tainted: 
G        W         5.16.5 #1
[Tue Jun  7 09:58:45 2022] Hardware name: ASUS System Product Name/Pro 
WS 565-ACE, BIOS 2424 09/29/2021
[Tue Jun  7 09:58:45 2022] RIP: 0010:refcount_warn_saturate+0xa7/0xe8
[Tue Jun  7 09:58:45 2022] Code: 05 8b be ec 00 01 e8 e6 69 3c 00 0f 0b 
c3 80 3d 7b be ec 00 00 75 53 48 c7 c7 7b f1 dd 81 c6 05 6b be ec 00 01 
e8 c7 69 3c 00 <0f> 0b c3 80 3d 5b be ec 00 00 75 34 48 c7 c7 a3 f1 dd 
81 c6 05 4b
[Tue Jun  7 09:58:45 2022] RSP: 0018:ffff889fae805e98 EFLAGS: 00010082
[Tue Jun  7 09:58:45 2022] RAX: 0000000000000000 RBX: ffff88810c978000 
RCX: 0000000000000027
[Tue Jun  7 09:58:45 2022] RDX: 0000000000000003 RSI: 0000000000000001 
RDI: ffff889fae820540
[Tue Jun  7 09:58:45 2022] RBP: ffff88811c0a9300 R08: 0000000000000003 
R09: fffffffffffd5e28
[Tue Jun  7 09:58:45 2022] R10: ffffffff820597a8 R11: ffff889fae805ff8 
R12: 0000000000000000
[Tue Jun  7 09:58:45 2022] R13: ffff889fae805f08 R14: ffff889fae80332e 
R15: 0000000000000001
[Tue Jun  7 09:58:45 2022] FS:  0000000000000000(0000) 
GS:ffff889fae800000(0000) knlGS:0000000000000000
[Tue Jun  7 09:58:45 2022] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Tue Jun  7 09:58:45 2022] CR2: 00007f4a97564c98 CR3: 000000011bb28000 
CR4: 0000000000350ef0
[Tue Jun  7 09:58:45 2022] Call Trace:
[Tue Jun  7 09:58:45 2022]  <IRQ>
[Tue Jun  7 09:58:45 2022]  refcount_dec_and_test+0x24/0x2a
[Tue Jun  7 09:58:45 2022]  blk_mq_free_request+0xad/0xc2
[Tue Jun  7 09:58:45 2022]  nvme_poll_cq+0x1e4/0x265 [nvme]
[Tue Jun  7 09:58:45 2022]  nvme_irq+0x36/0x6e [nvme]
[Tue Jun  7 09:58:45 2022]  __handle_irq_event_percpu+0x73/0x13e
[Tue Jun  7 09:58:45 2022]  handle_irq_event_percpu+0x31/0x77
[Tue Jun  7 09:58:45 2022]  handle_irq_event+0x2e/0x51
[Tue Jun  7 09:58:45 2022]  handle_edge_irq+0xc9/0xee
[Tue Jun  7 09:58:45 2022]  __common_interrupt+0x41/0x9e
[Tue Jun  7 09:58:45 2022]  common_interrupt+0x6e/0x8b
[Tue Jun  7 09:58:45 2022]  </IRQ>
[Tue Jun  7 09:58:45 2022]  <TASK>
[Tue Jun  7 09:58:45 2022]  asm_common_interrupt+0x1e/0x40
[Tue Jun  7 09:58:45 2022] RIP: 0010:__blk_mq_try_issue_directly+0x12/0x136
[Tue Jun  7 09:58:45 2022] Code: fe ff ff 48 8b 97 78 01 00 00 48 8b 92 
80 00 00 00 48 89 34 c2 b0 01 c3 0f 1f 44 00 00 41 57 41 56 41 55 41 54 
55 48 89 f5 53 <89> d3 48 83 ec 18 65 48 8b 04 25 28 00 00 00 48 89 44 
24 10 31 c0
[Tue Jun  7 09:58:45 2022] RSP: 0018:ffff88810bbf7ad8 EFLAGS: 00000246
[Tue Jun  7 09:58:45 2022] RAX: 0000000000000000 RBX: 0000000000000001 
RCX: 0000000000000001
[Tue Jun  7 09:58:45 2022] RDX: 0000000000000001 RSI: ffff8881137e6e40 
RDI: ffff88810dfdf400
[Tue Jun  7 09:58:45 2022] RBP: ffff8881137e6e40 R08: 0000000000000001 
R09: 0000000000000a20
[Tue Jun  7 09:58:45 2022] R10: 0000000000000000 R11: 0000000000000000 
R12: 0000000000000000
[Tue Jun  7 09:58:45 2022] R13: ffff88810dfdf400 R14: ffff8881137e6e40 
R15: ffff88810bbf7df0
[Tue Jun  7 09:58:45 2022] blk_mq_request_issue_directly+0x46/0x78
[Tue Jun  7 09:58:45 2022] blk_mq_try_issue_list_directly+0x41/0xba
[Tue Jun  7 09:58:45 2022]  blk_mq_sched_insert_requests+0x86/0xd0
[Tue Jun  7 09:58:45 2022]  blk_mq_flush_plug_list+0x1b5/0x214
[Tue Jun  7 09:58:45 2022]  ? __blk_mq_alloc_requests+0x1c7/0x21d
[Tue Jun  7 09:58:45 2022]  blk_mq_submit_bio+0x437/0x518
[Tue Jun  7 09:58:45 2022]  submit_bio_noacct+0x93/0x1e6
[Tue Jun  7 09:58:45 2022]  ? bio_associate_blkg_from_css+0x137/0x15c
[Tue Jun  7 09:58:45 2022]  flush_bio_list+0x96/0xa5
[Tue Jun  7 09:58:45 2022]  flush_pending_writes+0x7a/0xbf
[Tue Jun  7 09:58:45 2022]  ? md_check_recovery+0x8a/0x4bd
[Tue Jun  7 09:58:45 2022]  raid1d+0x194/0x10e8
[Tue Jun  7 09:58:45 2022]  ? common_interrupt+0xf/0x8b
[Tue Jun  7 09:58:45 2022]  md_thread+0x12c/0x155
[Tue Jun  7 09:58:45 2022]  ? init_wait_entry+0x29/0x29
[Tue Jun  7 09:58:45 2022]  ? signal_pending+0x19/0x19
[Tue Jun  7 09:58:45 2022]  kthread+0x104/0x10c
[Tue Jun  7 09:58:45 2022]  ? set_kthread_struct+0x32/0x32
[Tue Jun  7 09:58:45 2022]  ret_from_fork+0x22/0x30
[Tue Jun  7 09:58:45 2022]  </TASK>
[Tue Jun  7 09:58:45 2022] ---[ end trace 15dc74ae2e04f738 ]---
[Tue Jun  7 09:58:45 2022] I/O error, dev nvme0n1, sector 538918912 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:58:45 2022] I/O error, dev nvme0n1, sector 538988816 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:58:48 2022] I/O error, dev nvme0n1, sector 126839568 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:58:48 2022] I/O error, dev nvme0n1, sector 126888224 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:58:48 2022] I/O error, dev nvme0n1, sector 126894288 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:58:48 2022] could not locate request for tag 0xa30
[Tue Jun  7 09:58:48 2022] nvme nvme0: invalid id 27184 completed on 
queue 25
...
[Tue Jun  7 10:09:30 2022] I/O error, dev nvme0n1, sector 1177659304 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 10:09:37 2022] could not locate request for tag 0xe3f
[Tue Jun  7 10:09:37 2022] nvme nvme0: invalid id 56895 completed on 
queue 29
[Tue Jun  7 10:09:37 2022] I/O error, dev nvme0n1, sector 1182557168 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 10:09:38 2022] I/O error, dev nvme0n1, sector 1183614776 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 10:09:38 2022] nvme nvme0: I/O 788 QID 29 timeout, reset 
controller
[Tue Jun  7 10:09:38 2022] nvme nvme0: 32/0/0 default/read/poll queues
[Tue Jun  7 10:09:43 2022] I/O error, dev nvme0n1, sector 1184632520 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
...
[Tue Jun  7 10:13:08 2022] I/O error, dev nvme0n1, sector 1307072128 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 10:13:45 2022] nvme nvme0: controller is down; will reset: 
CSTS=0x3, PCI_STATUS=0x10
[Tue Jun  7 10:13:45 2022] nvme nvme0: 32/0/0 default/read/poll queues
[Tue Jun  7 10:13:46 2022] I/O error, dev nvme0n1, sector 1312589488 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
...
[Tue Jun  7 10:19:28 2022] I/O error, dev nvme0n1, sector 1530577624 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 10:19:34 2022] nvme nvme0: I/O 861 QID 25 timeout, reset 
controller
[Tue Jun  7 10:19:34 2022] nvme nvme0: 32/0/0 default/read/poll queues
[Tue Jun  7 10:19:36 2022] I/O error, dev nvme0n1, sector 1538154616 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0


---
