Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC5BC00140
	for <linux-raid@archiver.kernel.org>; Mon, 15 Aug 2022 06:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbiHOGTh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Aug 2022 02:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiHOGT2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 15 Aug 2022 02:19:28 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB78A1A3AD
        for <linux-raid@vger.kernel.org>; Sun, 14 Aug 2022 23:19:27 -0700 (PDT)
Subject: Re: [PATCH RFC] md: call md_cluster_stop() in __md_stop()
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660544366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AYlXTuPW6E9XJqByOHQ3ruEs3a63NvPXGxIqXzBRKWU=;
        b=cPo4qMI8bYEbIfQvQQQwVZPgnrr13Qoe9DU99R4c7PrvdUToNSqtKsZniR7gwrAgCXfqmq
        BuBT7Kb71dl2r/OoyQEBn2DhFDeujFIIDGMetugekdXSYHLO81NhV+lcnSdubc+ABZLZQw
        cqUWKpMLJV2hw3WyhJI/n/VszW53pd4=
To:     NeilBrown <neilb@suse.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
References: <166027061107.20931.13490156249149223084@noble.neil.brown.name>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <d45190a8-fffe-3a96-19ff-bdeccbc31945@linux.dev>
Date:   Mon, 15 Aug 2022 14:19:13 +0800
MIME-Version: 1.0
In-Reply-To: <166027061107.20931.13490156249149223084@noble.neil.brown.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Neil,

Sorry for later reply since I was on vacation last week.

On 8/12/22 10:16 AM, NeilBrown wrote:
> [[ I noticed the e151 patch recently which seems to admit that it broke
>     something.  So I looked into it and came up with this.

I just noticed it ...

>     It seems to make sense, but I'm not in a position to test it.
>     Guoqing: does it look OK to you?
>     - NeilBrown
> ]]
>
> As described in Commit: 48df498daf62 ("md: move bitmap_destroy to the
> beginning of __md_stop") md_cluster_stop() needs to run before the
> mdddev->thread is stopped.
> The change to make this happen was reverted in Commit: e151db8ecfb0
> ("md-raid: destroy the bitmap after destroying the thread") due to
> problems it caused.
>
> To restore correct behaviour, make md_cluster_stop() reentrant and
> explicitly call it at the start of __md_stop(), after first calling
> md_bitmap_wait_behind_writes().
>
> Fixes: e151db8ecfb0 ("md-raid: destroy the bitmap after destroying the thread")
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>   drivers/md/md-cluster.c | 1 +
>   drivers/md/md.c         | 3 +++
>   2 files changed, 4 insertions(+)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 742b2349fea3..37bf0aa4ed71 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1009,6 +1009,7 @@ static int leave(struct mddev *mddev)
>   	     test_bit(MD_CLOSING, &mddev->flags)))
>   		resync_bitmap(mddev);
>   
> +	mddev->cluster_info = NULL;

The above makes sense.

>   	set_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
>   	md_unregister_thread(&cinfo->recovery_thread);
>   	md_unregister_thread(&cinfo->recv_thread);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index afaf36b2f6ab..a57b2dff64dd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6238,6 +6238,9 @@ static void mddev_detach(struct mddev *mddev)
>   static void __md_stop(struct mddev *mddev)
>   {
>   	struct md_personality *pers = mddev->pers;
> +
> +	md_bitmap_wait_behind_writes(mddev);
> +	md_cluster_stop(mddev);
>   	mddev_detach(mddev);
>   	/* Ensure ->event_work is done */
>   	if (mddev->event_work.func)

The md_bitmap_destroy is called in __md_stop with or without e151db8ecfb0,
and it already invokes md_bitmap_wait_behind_writes and md_cluster_stop by
md_bitmap_free. So the above is sort of redundant to me.

For the issue described in e151db8ecfb, looks like raid1d was running after
__md_stop, I am wondering if dm-raid should stop write first just like 
normal
md-raid.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index afaf36b2f6ab..afc8d638eba0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6260,6 +6260,7 @@ void md_stop(struct mddev *mddev)
         /* stop the array and free an attached data structures.
          * This is called from dm-raid
          */
+       __md_stop_writes(mddev);
         __md_stop(mddev);
         bioset_exit(&mddev->bio_set);
         bioset_exit(&mddev->sync_set);

Thanks,
Guoqing
