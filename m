Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DB4C43334
	for <linux-raid@archiver.kernel.org>; Wed,  8 Jun 2022 17:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiFHR0m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 13:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiFHR0Z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 13:26:25 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D624A904
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 10:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=Ca4nKsGg4nF0jjkT4DhlnBaJ9rI/QYenNdEp1SJestg=; b=YQGX9E/BY1MiT1whB/30COZ5h+
        RbKLUtuVt7hnmfT1Rp26hCw013WaUqlVm41m07SSnqhlwO0hZu6HlazodU+CHSD+pmxJY+5sGfldk
        dX8Dhx9m7zUbhut98ifpnH/aQafu394c8yJo25JymgSkx/JM+jl7Go6KYIRwwqE3479wsSpCKpA04
        PORsYP6LSk/KgzM/d5SnR4iOZsbxC6SoF20cboYYlgtGiPjuFMr49U6GJc/xRUnNA7CS0HHbpgpne
        coKQ2AvhTyTt1oAuezbUY0CY7HBh11vRTD0Rm8I2g4LiCgcKVFmIl5P1RAdAJHA7wG2MuARrSiwO3
        +16GCmuQ==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nyzPV-0027vH-1L; Wed, 08 Jun 2022 11:24:02 -0600
Message-ID: <798f131b-fe4f-dcec-4903-22ab3a54d0ce@deltatee.com>
Date:   Wed, 8 Jun 2022 11:23:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org
Cc:     buczek@molgen.mpg.de, linux-raid@vger.kernel.org
References: <20220607020357.14831-1-guoqing.jiang@linux.dev>
 <20220607020357.14831-3-guoqing.jiang@linux.dev>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220607020357.14831-3-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: guoqing.jiang@linux.dev, song@kernel.org, buczek@molgen.mpg.de, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 2/2] md: unlock mddev before reap sync_thread in
 action_store
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hey,

On 2022-06-06 20:03, Guoqing Jiang wrote:
> Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
> with reconfig_mutex held") fixed is related with action_store path, other
> callers which reap sync_thread didn't need to be changed.
> 
> Let's pull md_unregister_thread from md_reap_sync_thread, then fix previous
> bug with belows.
> 
> 1. unlock mddev before md_reap_sync_thread in action_store.
> 2. save reshape_position before unlock, then restore it to ensure position
>    not changed accidentally by others.
> 
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>  drivers/md/dm-raid.c |  1 +
>  drivers/md/md.c      | 12 ++++++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 9526ccbedafb..d43b8075c055 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3725,6 +3725,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>  	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
>  		if (mddev->sync_thread) {
>  			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +			md_unregister_thread(&mddev->sync_thread);
>  			md_reap_sync_thread(mddev);
>  		}
>  	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2e83a19e3aba..4d70672f8ea8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4830,6 +4830,12 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>  			if (work_pending(&mddev->del_work))
>  				flush_workqueue(md_misc_wq);
>  			if (mddev->sync_thread) {
> +				sector_t save_rp = mddev->reshape_position;
> +
> +				mddev_unlock(mddev);
> +				md_unregister_thread(&mddev->sync_thread);
> +				mddev_lock_nointr(mddev);
> +				mddev->reshape_position = save_rp;
>  				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>  				md_reap_sync_thread(mddev);
>  			}

So with this patch, with 07revert-grow: I see the warning at the end of
this email. Seems there's a new bug in the hunk above: MD_RECOVERY_INTR
should be set before md_unregsiter_thread().

When I make that change, 07revert-grow fails in the same way it did with
the previous patch.

Logan

--



  177.804352] ------------[ cut here ]------------
[  177.805200] WARNING: CPU: 2 PID: 1382 at drivers/md/md.c:490
mddev_suspend+0x26c/0x330
[  177.806541] Modules linked in:
[  177.807078] CPU: 2 PID: 1382 Comm: md0_raid5 Not tainted
5.18.0-rc3-eid-vmlocalyes-dbg-00035-gd1d91cae9ac1 #2237
[  177.809122] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.14.0-2 04/01/2014
[  177.810649] RIP: 0010:mddev_suspend+0x26c/0x330
[  177.811654] Code: ab 5c 13 00 00 e9 a3 fe ff ff 48 8d bb d8 02 00 00
be ff ff ff ff e8 d3 97 5f 00 85 c0 0f 85 74 fe ff ff 0f 0b e9 6d fe ff
ff <0f> 0b e9 4c fe ff ff 4c 8d bd 68 ff ff ff 31 f6 4c 89 ff e8 1c f7
[  177.815028] RSP: 0018:ffff88828656faa8 EFLAGS: 00010246
[  177.815995] RAX: 0000000000000000 RBX: ffff8881765e8000 RCX:
ffffffff9b3b1ed4
[  177.817306] RDX: dffffc0000000000 RSI: ffff88817333e478 RDI:
ffff88816e861670
[  177.818555] RBP: ffff88828656fb78 R08: ffffffff9b38e442 R09:
ffffffff9e94db07
[  177.819757] R10: fffffbfff3d29b60 R11: 0000000000000001 R12:
ffff88816e861600
[  177.821043] R13: ffff88829c34cf00 R14: ffff8881765e8000 R15:
ffff88817333e248
[  177.822307] FS:  0000000000000000(0000) GS:ffff888472e00000(0000)
knlGS:0000000000000000
[  177.823699] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  177.824701] CR2: 00007faa60ada843 CR3: 000000028e9ca002 CR4:
0000000000370ee0
[  177.825889] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  177.827111] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[  177.828346] Call Trace:
[  177.828785]  <TASK>
[  177.829275]  ? rdev_read_only+0x150/0x150
[  177.830180]  ? lock_is_held_type+0xf3/0x150
[  177.830888]  ? raid5_calc_degraded+0x1f9/0x650
[  177.831665]  check_reshape+0x289/0x500
[  177.832360]  raid5_check_reshape+0x93/0x150
[  177.833060]  md_check_recovery+0x864/0xa80
[  177.833757]  raid5d+0xc6/0x930
[  177.834272]  ? __this_cpu_preempt_check+0x13/0x20
[  177.835060]  ? lock_downgrade+0x3f0/0x3f0
[  177.835727]  ? raid5_do_work+0x330/0x330
[  177.836392]  ? __this_cpu_preempt_check+0x13/0x20
[  177.837313]  ? lockdep_hardirqs_on+0x82/0x110
[  177.838156]  ? _raw_spin_unlock_irqrestore+0x31/0x60
[  177.838977]  ? trace_hardirqs_on+0x2b/0x110
[  177.839678]  ? preempt_count_sub+0x18/0xc0
[  177.840383]  ? _raw_spin_unlock_irqrestore+0x41/0x60
[  177.841241]  md_thread+0x1a2/0x2c0
[  177.841836]  ? suspend_lo_store+0x140/0x140
[  177.842515]  ? __this_cpu_preempt_check+0x13/0x20
[  177.843290]  ? lockdep_hardirqs_on+0x82/0x110
[  177.844111]  ? destroy_sched_domains_rcu+0x40/0x40
[  177.844979]  ? preempt_count_sub+0x18/0xc0
[  177.845769]  ? __kasan_check_read+0x11/0x20
[  177.846514]  ? suspend_lo_store+0x140/0x140
[  177.847210]  kthread+0x177/0x1b0
[  177.847756]  ? kthread_complete_and_exit+0x30/0x30
[  177.848570]  ret_from_fork+0x22/0x30
[  177.849204]  </TASK>
[  177.849584] irq event stamp: 609927
[  177.850163] hardirqs last  enabled at (609935): [<ffffffff9a216ea4>]
__up_console_sem+0x64/0x70
[  177.851601] hardirqs last disabled at (609942): [<ffffffff9a216e89>]
__up_console_sem+0x49/0x70
[  177.853048] softirqs last  enabled at (609546): [<ffffffff9a14751e>]
__irq_exit_rcu+0xfe/0x150
[  177.854706] softirqs last disabled at (609499): [<ffffffff9a14751e>]
__irq_exit_rcu+0xfe/0x150
[  177.856240] ---[ end trace 0000000000000000 ]---
