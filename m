Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBE6C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 05:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 843D8610FB
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 05:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhDHFJo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 01:09:44 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37535 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229506AbhDHFJn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 8 Apr 2021 01:09:43 -0400
Received: from [192.168.0.2] (ip5f5aeede.dynamic.kabel-deutschland.de [95.90.238.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 007A8206473D2;
        Thu,  8 Apr 2021 07:09:30 +0200 (CEST)
Subject: Re: [PATCH] md-cluster: fix use-after-free issue when removing rdev
To:     Heming Zhao <heming.zhao@suse.com>
Cc:     guoqing.jiang@cloud.ionos.com, lidong.zhong@suse.com,
        xni@redhat.com, colyli@suse.com, ghe@suse.com,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>
References: <1617850862-26627-1-git-send-email-heming.zhao@suse.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <00bcd9d8-4199-7d4d-32b0-ece055f2186d@molgen.mpg.de>
Date:   Thu, 8 Apr 2021 07:09:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1617850862-26627-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Heming,


Thank you for the patch.

Am 08.04.21 um 05:01 schrieb Heming Zhao:
> md_kick_rdev_from_array will remove rdev, so we should
> use rdev_for_each_safe to search list.
> 
> How to trigger:
> 
> ```
> for i in {1..20}; do
>      echo ==== $i `date` ====;
> 
>      mdadm -Ss && ssh ${node2} "mdadm -Ss"
>      wipefs -a /dev/sda /dev/sdb
> 
>      mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l 1 /dev/sda \
>         /dev/sdb --assume-clean
>      ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
>      mdadm --wait /dev/md0
>      ssh ${node2} "mdadm --wait /dev/md0"
> 
>      mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
>      sleep 1
> done
> ```

In the test script, I do not understand, what node2 is used for, where 
you log in over SSH.

> Crash stack:
> 
> ```
> stack segment: 0000 [#1] SMP
> ... ...
> RIP: 0010:md_check_recovery+0x1e8/0x570 [md_mod]
> ... ...
> RSP: 0018:ffffb149807a7d68 EFLAGS: 00010207
> RAX: 0000000000000000 RBX: ffff9d494c180800 RCX: ffff9d490fc01e50
> RDX: fffff047c0ed8308 RSI: 0000000000000246 RDI: 0000000000000246
> RBP: 6b6b6b6b6b6b6b6b R08: ffff9d490fc01e40 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> R13: ffff9d494c180818 R14: ffff9d493399ef38 R15: ffff9d4933a1d800
> FS:  0000000000000000(0000) GS:ffff9d494f700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe68cab9010 CR3: 000000004c6be001 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   raid1d+0x5c/0xd40 [raid1]
>   ? finish_task_switch+0x75/0x2a0
>   ? lock_timer_base+0x67/0x80
>   ? try_to_del_timer_sync+0x4d/0x80
>   ? del_timer_sync+0x41/0x50
>   ? schedule_timeout+0x254/0x2d0
>   ? md_start_sync+0xe0/0xe0 [md_mod]
>   ? md_thread+0x127/0x160 [md_mod]
>   md_thread+0x127/0x160 [md_mod]
>   ? wait_woken+0x80/0x80
>   kthread+0x10d/0x130
>   ? kthread_park+0xa0/0xa0
>   ret_from_fork+0x1f/0x40
> ```
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reviewed-by: Gang He <ghe@suse.com>

If there is a commit, your patch is fixing, please add a Fixes: tag.

> ---
>   drivers/md/md.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 21da0c48f6c2..9892c13cdfc8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9251,11 +9251,11 @@ void md_check_recovery(struct mddev *mddev)
>   		}
>   
>   		if (mddev_is_clustered(mddev)) {
> -			struct md_rdev *rdev;
> +			struct md_rdev *rdev, *tmp;
>   			/* kick the device if another node issued a
>   			 * remove disk.
>   			 */
> -			rdev_for_each(rdev, mddev) {
> +			rdev_for_each_safe(rdev, tmp, mddev) {
>   				if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
>   						rdev->raid_disk < 0)
>   					md_kick_rdev_from_array(rdev);
> @@ -9569,7 +9569,7 @@ static int __init md_init(void)
>   static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
>   {
>   	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
> -	struct md_rdev *rdev2;
> +	struct md_rdev *rdev2, *tmp;
>   	int role, ret;
>   	char b[BDEVNAME_SIZE];
>   
> @@ -9586,7 +9586,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
>   	}
>   
>   	/* Check for change of roles in the active devices */
> -	rdev_for_each(rdev2, mddev) {
> +	rdev_for_each_safe(rdev2, tmp, mddev) {
>   		if (test_bit(Faulty, &rdev2->flags))
>   			continue;
>   


Kind regards,

Paul
