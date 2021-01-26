Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C848BC433E6
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 15:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D4C223109
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 15:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406073AbhAZPPO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jan 2021 10:15:14 -0500
Received: from mga06.intel.com ([134.134.136.31]:55876 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391664AbhAZPBN (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 26 Jan 2021 10:01:13 -0500
IronPort-SDR: D3IcOXaZ81zxTk87gOs5WofPbbg0iNjKWOgTA/dYH+Vf16dcphV3pnAuVOhi/2QajM7bgmU6DN
 I7M1wPXX7Q0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="241441356"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="241441356"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 06:59:17 -0800
IronPort-SDR: er0ofxajgvawSOeV9f9vcIUU2mypWvlnHtdTZP9nvSakQrOfTsCtiOV4YaR0zyLAqKBqNOJLdB
 MNo6cyoL6ULA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="356744488"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 26 Jan 2021 06:59:17 -0800
Received: from [10.213.22.225] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.22.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 97ED95807C8;
        Tue, 26 Jan 2021 06:59:16 -0800 (PST)
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     "Shchirskyi, Oleksandr" <oleksandr.shchirskyi@intel.com>
Subject: Kernel bug during chunk size migration
Message-ID: <6bef1a9b-4fd0-633d-8589-8e486cac60ab@linux.intel.com>
Date:   Tue, 26 Jan 2021 15:59:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,
We recently discovered a problem with the md driver on the upstream
kernel. During chunk size migration (tested with different combinations
of the chunk size, e.g. 4->128, 128->4), a kernel bug appears.
We were able to reproduce this issue on imsm only metadata, as with native, 
mdadm create doesn't take into account size param, and on the whole drives
size test lasts too long.
Retesting on previous kernel versions showed that the problem is present
in older versions of the kernel, including 5.0 (4.x versions were not
checked yet)

Steps to reproduce (run in the loop with different chunk size
combinations):

mdadm --create /dev/md/imsm0 --metadata=imsm --raid-devices=3 /dev/nvme1n1 
/dev/nvme0n1 /dev/nvme2n1 --run
mdadm --create /dev/md/raidVolume --level=0 --chunk ${chunk_size_1} 
--size=524288 --raid-devices=2 /dev/nvme0n1 /dev/nvme2n1 --run
parted -s /dev/md/raidVolume mklabel msdos
parted -s /dev/md/raidVolume mkpart primary ext4 0% 30%
partprobe /dev/md/raidVolume
udevadm settle
mkfs.ext4 /dev/md/raidVolume1 -F
mount /dev/md/raidVolume1 /mnt/raidVolume1
openssl rand -base64 216583372 > /mnt/raidVolume1/testfile.bin
mdadm --grow /dev/md/raidVolume --chunk=${chunk_size_2}
grep -m 1 "reshape done" <(dmesg -w)
umount  /mnt/raidVolume1
mdadm --stop --scan
wipefs -a /dev/nvme{0,2}n1
sleep 60

Reproducibility rate:
Sporadic, we have to run the script from above usually 10-15 times in a
loop to hit the issue.

End of test log:

+ mount /dev/md/raidVolume1 /mnt/raidVolume1
+ openssl rand -base64 216583372
+ mdadm --grow /dev/md/raidVolume --chunk=128
mdadm: level of /dev/md/raidVolume changed to raid4
[mdadm command hangs here]

Kernel log:

[34497.995168] md/raid:md126: device nvme2n1 operational as raid disk 1
[34498.002910] md/raid:md126: device nvme0n1 operational as raid disk 0
[34498.020207] md/raid:md126: raid level 4 active with 2 out of 3 devices, 
algorithm 5
[34498.029537] BUG: kernel NULL pointer dereference, address: 000000000000000c
[34498.038049] #PF: supervisor read access in kernel mode
[34498.044799] #PF: error_code(0x0000) - not-present page
[34498.051588] PGD 0 P4D 0
[34498.055790] Oops: 0000 [#1] SMP PTI
[34498.060989] CPU: 4 PID: 2185199 Comm: md126_raid4 Tainted: G S 
5.11.0-rc1 #1
[34498.071200] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS 
SE5C620.86B.02.01.0008.031920191559 03/19/2019
[34498.083661] RIP: 0010:async_copy_data+0x168/0x290 [raid456]
[34498.091323] Code: e1 fb 00 00 00 83 f9 03 75 73 45 89 f8 85 ed 0f 84 cb 00 00 
00 44 8b 64 24 04 49 8b 72 58 b9 00 10 00 00 49 c1 e4 04 4c 01 e6 <8b> 7e 0c 8b 
5e 08 44 01 ef 44 29 eb 89 fa 81 e2 ff 0f 00 00 39 eb
[34498.115178] RSP: 0018:ffffc90023cd7ad0 EFLAGS: 00010246
[34498.122859] RAX: 0000000000000000 RBX: ffff88810daf0210 RCX: 0000000000001000
[34498.132559] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000001
[34498.142286] RBP: 0000000000001000 R08: 00000000fffffc00 R09: 0000000000000000
[34498.152034] R10: ffff88810a819240 R11: ffff88810daf0000 R12: 0000000000000000
[34498.161827] R13: 0000000000000000 R14: ffff88810daf0213 R15: ffff88810a819240
[34498.171673] FS:  0000000000000000(0000) GS:ffff888c10900000(0000) 
knlGS:0000000000000000
[34498.182561] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[34498.191159] CR2: 000000000000000c CR3: 000000000260a004 CR4: 00000000007706e0
[34498.201235] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[34498.211340] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[34498.221466] PKRU: 55555554
[34498.227185] Call Trace:
[34498.232670]  raid_run_ops+0x50a/0x1620 [raid456]
[34498.240396]  ? handle_stripe_dirtying+0x6f6/0x800 [raid456]
[34498.249139]  handle_stripe+0xcfa/0x23c0 [raid456]
[34498.257066]  ? load_balance+0x121/0xc00
[34498.264159]  handle_active_stripes.isra.51+0x384/0x550 [raid456]
[34498.273527]  raid5d+0x346/0x520 [raid456]
[34498.280925]  ? schedule+0x3c/0xa0
[34498.287656]  ? schedule_timeout+0x20b/0x2a0
[34498.295285]  ? md_start_sync+0x60/0x60 [md_mod]
[34498.303313]  md_thread+0x131/0x160 [md_mod]
[34498.311027]  ? do_wait_intr_irq+0x90/0x90
[34498.319216]  kthread+0x114/0x130
[34498.326039]  ? kthread_unpark+0x60/0x60
[34498.333473]  ret_from_fork+0x1f/0x30
[34498.340622] Modules linked in: raid0 raid1 raid456 async_raid6_recov 
async_memcpy async_pq async_xor xor async_tx raid6_pq raid10 md_mod nvme 
nvme_core vmd
[34498.362066] CR2: 000000000000000c
[34498.369214] ---[ end trace 58332a66527ae7b9 ]---

GDB trace:

(gdb) li *async_copy_data+0x168
0x11f8 is in async_copy_data (drivers/md/raid5.c:1326).
1321
1322            if (frombio)
1323                    flags |= ASYNC_TX_FENCE;
1324            init_async_submit(&submit, flags, tx, NULL, NULL, NULL);
1325
1326            bio_for_each_segment(bvl, bio, iter) {
1327                    int len = bvl.bv_len;
1328                    int clen;
1329                    int b_offset = 0;
1330
(gdb)

Any advice will be helpful.
Currently we are working to find the root cause.

Regards,
Mariusz
