Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF29C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 07:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbiFIHVA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 03:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239865AbiFIHU6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 03:20:58 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B616C244164
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 00:20:54 -0700 (PDT)
Subject: Re: [PATCH 2/2] md: unlock mddev before reap sync_thread in
 action_store
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654759252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mi3wzeThjHWe6DZx2CmJbNAOASyKgQPFCmCv00jW84k=;
        b=Mm/YMBnfEAtbSU5xYKWy//AZNVn/xSp8syLUNk1z8QqfScHzICFFaetfcld1r/OuqqqTum
        h04eRXriYoN/F7MtwjhUCJBUDP9MtULCsBnBxOKsvvTJarU815w+0ApeUbRzaHq/gFXqCH
        jiZobAcWN+kNSb+02wgA08NQ8rKN+Rc=
To:     Logan Gunthorpe <logang@deltatee.com>, song@kernel.org
Cc:     buczek@molgen.mpg.de, linux-raid@vger.kernel.org
References: <20220607020357.14831-1-guoqing.jiang@linux.dev>
 <20220607020357.14831-3-guoqing.jiang@linux.dev>
 <798f131b-fe4f-dcec-4903-22ab3a54d0ce@deltatee.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <28b5f07e-aabc-d68f-ba0f-1d357e1b30e3@linux.dev>
Date:   Thu, 9 Jun 2022 15:20:45 +0800
MIME-Version: 1.0
In-Reply-To: <798f131b-fe4f-dcec-4903-22ab3a54d0ce@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/9/22 1:23 AM, Logan Gunthorpe wrote:
> Hey,
>
> On 2022-06-06 20:03, Guoqing Jiang wrote:
>> Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
>> with reconfig_mutex held") fixed is related with action_store path, other
>> callers which reap sync_thread didn't need to be changed.
>>
>> Let's pull md_unregister_thread from md_reap_sync_thread, then fix previous
>> bug with belows.
>>
>> 1. unlock mddev before md_reap_sync_thread in action_store.
>> 2. save reshape_position before unlock, then restore it to ensure position
>>     not changed accidentally by others.
>>
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>> ---
>>   drivers/md/dm-raid.c |  1 +
>>   drivers/md/md.c      | 12 ++++++++++--
>>   2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>> index 9526ccbedafb..d43b8075c055 100644
>> --- a/drivers/md/dm-raid.c
>> +++ b/drivers/md/dm-raid.c
>> @@ -3725,6 +3725,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>>   	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
>>   		if (mddev->sync_thread) {
>>   			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> +			md_unregister_thread(&mddev->sync_thread);
>>   			md_reap_sync_thread(mddev);
>>   		}
>>   	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 2e83a19e3aba..4d70672f8ea8 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -4830,6 +4830,12 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>>   			if (work_pending(&mddev->del_work))
>>   				flush_workqueue(md_misc_wq);
>>   			if (mddev->sync_thread) {
>> +				sector_t save_rp = mddev->reshape_position;
>> +
>> +				mddev_unlock(mddev);
>> +				md_unregister_thread(&mddev->sync_thread);
>> +				mddev_lock_nointr(mddev);
>> +				mddev->reshape_position = save_rp;
>>   				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>   				md_reap_sync_thread(mddev);
>>   			}
> So with this patch, with 07revert-grow: I see the warning at the end of
> this email. Seems there's a new bug in the hunk above: MD_RECOVERY_INTR
> should be set before md_unregsiter_thread().

Yes, it was missed by mistake, the below incremental change is needed.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e4d9a8b0efac..c29ef9505e03 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4833,6 +4833,7 @@ action_store(struct mddev *mddev, const char 
*page, size_t len)
                                 sector_t save_rp = mddev->reshape_position;

                                 mddev_unlock(mddev);
+                               set_bit(MD_RECOVERY_INTR, &mddev->recovery);
md_unregister_thread(&mddev->sync_thread);
                                 mddev_lock_nointr(mddev);
                                 mddev->reshape_position = save_rp;

And we may not save/restore reshape_position, I will run more tests
before send new version. And Xiao's suggestion might be safer if it
fixes the original issue.

> When I make that change, 07revert-grow fails in the same way it did with
> the previous patch.
>
> Logan
>
> --
>
>
>
>    177.804352] ------------[ cut here ]------------
> [  177.805200] WARNING: CPU: 2 PID: 1382 at drivers/md/md.c:490
> mddev_suspend+0x26c/0x330
> [  177.806541] Modules linked in:
> [  177.807078] CPU: 2 PID: 1382 Comm: md0_raid5 Not tainted
> 5.18.0-rc3-eid-vmlocalyes-dbg-00035-gd1d91cae9ac1 #2237
> [  177.809122] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.14.0-2 04/01/2014
> [  177.810649] RIP: 0010:mddev_suspend+0x26c/0x330
> [  177.811654] Code: ab 5c 13 00 00 e9 a3 fe ff ff 48 8d bb d8 02 00 00
> be ff ff ff ff e8 d3 97 5f 00 85 c0 0f 85 74 fe ff ff 0f 0b e9 6d fe ff
> ff <0f> 0b e9 4c fe ff ff 4c 8d bd 68 ff ff ff 31 f6 4c 89 ff e8 1c f7
> [  177.815028] RSP: 0018:ffff88828656faa8 EFLAGS: 00010246
> [  177.815995] RAX: 0000000000000000 RBX: ffff8881765e8000 RCX:
> ffffffff9b3b1ed4
> [  177.817306] RDX: dffffc0000000000 RSI: ffff88817333e478 RDI:
> ffff88816e861670
> [  177.818555] RBP: ffff88828656fb78 R08: ffffffff9b38e442 R09:
> ffffffff9e94db07
> [  177.819757] R10: fffffbfff3d29b60 R11: 0000000000000001 R12:
> ffff88816e861600
> [  177.821043] R13: ffff88829c34cf00 R14: ffff8881765e8000 R15:
> ffff88817333e248
> [  177.822307] FS:  0000000000000000(0000) GS:ffff888472e00000(0000)
> knlGS:0000000000000000
> [  177.823699] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  177.824701] CR2: 00007faa60ada843 CR3: 000000028e9ca002 CR4:
> 0000000000370ee0
> [  177.825889] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  177.827111] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [  177.828346] Call Trace:
> [  177.828785]  <TASK>
> [  177.829275]  ? rdev_read_only+0x150/0x150
> [  177.830180]  ? lock_is_held_type+0xf3/0x150
> [  177.830888]  ? raid5_calc_degraded+0x1f9/0x650
> [  177.831665]  check_reshape+0x289/0x500
> [  177.832360]  raid5_check_reshape+0x93/0x150
> [  177.833060]  md_check_recovery+0x864/0xa80
> [  177.833757]  raid5d+0xc6/0x930

I saw exactly the same trace when I replied with "held on" 😁.

Thanks,
Guoqing

