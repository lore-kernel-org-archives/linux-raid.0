Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712C6C433ED
	for <linux-raid@archiver.kernel.org>; Fri, 30 Apr 2021 20:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B1846144B
	for <linux-raid@archiver.kernel.org>; Fri, 30 Apr 2021 20:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbhD3URD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Apr 2021 16:17:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:8027 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235709AbhD3URC (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 30 Apr 2021 16:17:02 -0400
IronPort-SDR: /sj2SW8wh7tlvM192gKL175a9XQHUsVTz4dJPfuvCZh1ZK1PAGyR5KiYRpeojwfDxwhvqLLcIV
 QG0bzef1T4ag==
X-IronPort-AV: E=McAfee;i="6200,9189,9970"; a="261306992"
X-IronPort-AV: E=Sophos;i="5.82,263,1613462400"; 
   d="scan'208";a="261306992"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2021 13:16:11 -0700
IronPort-SDR: P0bqXFH3uOjodzXbrSk9W8rYD2Jch1JQbC2rXXnx9e6ZxEH5Nb7EndUsQhn2yrce5P5Lo+RwoN
 YZg5D4fuN+lQ==
X-IronPort-AV: E=Sophos;i="5.82,263,1613462400"; 
   d="scan'208";a="425166937"
Received: from oshchirs-mobl.ger.corp.intel.com (HELO [10.213.23.61]) ([10.213.23.61])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2021 13:16:09 -0700
To:     linux-raid@vger.kernel.org
Cc:     Xiao Ni <xni@redhat.com>
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Subject: Kernel bug in async_xor_offs during RAID5 recovery
Message-ID: <d58a9209-b2a2-6f2a-73ea-a90c0970daf3@linux.intel.com>
Date:   Fri, 30 Apr 2021 22:16:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

We recently discovered a regression in the md-next kernel. During PPL 
recovery on RAID5 with IMSM metadata, a kernel bug appears. The issue is 
caused by patch ceaf2966ab08. W/o this patch the issue is not reproducible.

Steps to reproduce:

mdadm --create /dev/md/imsm0 --metadata=imsm --raid-devices=3 /dev/nvme0n1 
/dev/nvme1n1 /dev/nvme2n1 --run
mdadm --create /dev/md/md1 /dev/md/imsm0 --level=5 --chunk 64 
--size=2621440 --raid-devices=3  --run --consistency-policy=ppl --assume-clean
# here we write previously prepared data to md1 device
mdadm --set-faulty /dev/md/md1 /dev/nvme1n1
mdadm --stop --scan
echo 1 > /sys/block/nvme1n1/device/device/remove
# here using our debug tool we set dirty flag and corrupt data on /dev/nvme1n1
mdadm --assemble --scan

Reproducibility rate:

100%

End of test log:

# mdadm --assemble --scan
mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
Killed

Kernel log:

[  818.308417] md: md127 stopped.
[  818.468051] md: md126 stopped.
[  818.474506] md/raid:md126: not clean -- starting background reconstruction
[  818.481419] md/raid:md126: device nvme0n1 operational as raid disk 1
[  818.487789] md/raid:md126: device nvme2n1 operational as raid disk 2
[  818.494572] md/raid:md126: starting dirty degraded array with PPL.
[  818.500781] md/raid:md126: raid level 5 active with 2 out of 3 devices, 
algorithm 0
[  818.510417] BUG: kernel NULL pointer dereference, address: 0000000000000004
[  818.517401] #PF: supervisor read access in kernel mode
[  818.522562] #PF: error_code(0x0000) - not-present page
[  818.527709] PGD 800000048b276067 P4D 800000048b276067 PUD 48d42b067 PMD 0
[  818.534595] Oops: 0000 [#1] SMP PTI
[  818.538107] CPU: 45 PID: 8989 Comm: mdadm Tainted: G S 
5.12.0-rc3-20210428.intel.6363061+ #1
[  818.547862] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS 
SE5C620.86B.00.01.0016.020120190930 02/01/2019
[  818.558312] RIP: 0010:async_xor_offs+0x3be/0x5c0 [async_xor]
[  818.563989] Code: 7d ff 31 d2 31 ed eb 03 48 89 c2 49 8b 04 d7 48 85 c0 
74 27 48 01 f0 4d 89 c1 48 c1 f8 06 48 c1 e0 0c 48 01 c8 4d 85 e4 74 04 
<45> 8b 0c 94 4c 63 d5 4c 01 c8 83 c5 01 4b 89 04 d6 48 8d 42 01 48
[  818.582780] RSP: 0018:ffffc900041ab800 EFLAGS: 00010202
[  818.588019] RAX: ffff888484baf000 RBX: ffff88848ddd8000 RCX: 
ffff888000000000
[  818.595165] RDX: 0000000000000000 RSI: 0000160000000000 RDI: 
0000000000000000
[  818.602315] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000000
[  818.609462] R10: 0000000000000000 R11: ffff88886fd68984 R12: 
0000000000000004
[  818.616612] R13: ffffc900041ab8a8 R14: ffffc900041ab8d8 R15: 
ffffc900041ab8d8
[  818.623774] FS:  00007f00978c08c0(0000) GS:ffff88886fd40000(0000) 
knlGS:0000000000000000
[  818.631885] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  818.637654] CR2: 0000000000000004 CR3: 0000000483766005 CR4: 
00000000007706e0
[  818.644804] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  818.651957] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  818.659643] PKRU: 55555554
[  818.662904] Call Trace:
[  818.665905]  ? sync_page_io+0x11a/0x190 [md_mod]
[  818.671077]  async_xor+0x1c/0x20 [async_xor]
[  818.675882]  ppl_xor+0x6e/0xa0 [raid456]
[  818.680338]  ppl_recover_entry.isra.14+0x2a3/0x750 [raid456]
[  818.686541]  ? lock_timer_base+0x67/0x80
[  818.691006]  ? try_to_del_timer_sync+0x4d/0x80
[  818.695986]  ? del_timer_sync+0x25/0x40
[  818.700366]  ? schedule_timeout+0x195/0x2a0
[  818.705095]  ? chksum_update+0x13/0x20
[  818.709394]  ? crc32c+0x31/0x60
[  818.713068]  ? io_schedule_timeout+0x19/0x40
[  818.717866]  ? wait_for_completion_io_timeout+0xa4/0xf0
[  818.723617]  ? submit_bio_wait+0x80/0xb0
[  818.728065]  ? sync_page_io+0x11a/0x190 [md_mod]
[  818.733201]  ? submit_bio_wait+0xb0/0xb0
[  818.737652]  ? ppl_init_log+0xa17/0xb10 [raid456]
[  818.742890]  ppl_init_log+0xa17/0xb10 [raid456]
[  818.747958]  raid5_run.cold.60+0x4d1/0x5c2 [raid456]
[  818.753456]  md_run+0x488/0xa60 [md_mod]
[  818.757909]  ? blkdev_direct_IO+0x30c/0x4c0
[  818.762614]  do_md_run+0x14/0xf0 [md_mod]
[  818.767148]  array_state_store+0x2ce/0x320 [md_mod]
[  818.772553]  md_attr_store+0x6c/0xb0 [md_mod]
[  818.777447]  kernfs_fop_write_iter+0x11c/0x1b0
[  818.782416]  new_sync_write+0x119/0x1a0
[  818.786768]  vfs_write+0x181/0x250
[  818.790678]  ksys_write+0x59/0xd0
[  818.794501]  do_syscall_64+0x2d/0x40
[  818.798573]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  818.804118] RIP: 0033:0x7f0096f408a8
[  818.808182] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 
f3 0f 1e fa 48 8d 05 b5 4c 2d 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 
<48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
[  818.827933] RSP: 002b:00007fff08dae3d8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[  818.835994] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 
00007f0096f408a8
[  818.843606] RDX: 0000000000000008 RSI: 0000000000466722 RDI: 
0000000000000007
[  818.851210] RBP: 0000000000466722 R08: 0000000000467670 R09: 
00007f0096fd0d40
[  818.858811] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000001d5bf00
[  818.866400] R13: 0000000000000000 R14: 0000000000000002 R15: 
0000000000000002
[  818.873992] Modules linked in: raid456 async_raid6_recov async_memcpy 
async_pq async_xor xor async_tx raid6_pq md_mod nvme nvme_core
[  818.886871] CR2: 0000000000000004

Regards,
Oleksandr Shchirskyi
