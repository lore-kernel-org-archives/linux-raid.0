Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3625DC61DA4
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 09:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjCOJjl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 05:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjCOJjj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 05:39:39 -0400
Received: from out-8.mta0.migadu.com (out-8.mta0.migadu.com [IPv6:2001:41d0:1004:224b::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3852846A8
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 02:39:36 -0700 (PDT)
Message-ID: <16613534-5482-23c5-fa97-cfaedecab3d7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678873175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IJQpaLrSEutmV4KWPVUPTFEg5KqW6z8bi/taME87jzA=;
        b=WLxR4tmD7spuddY0C1rdTQ7+xpV7ABWic2YHTubAIQSDjRCrHIk73ooyRoPwUF/I41Um9V
        QOpU32alPXisrWLNUUHlW6QHf/6AsIlD8tUmKvyEne9/+lGKpF88xspl+Rk/VyiznSbp6G
        lsj1Zdfqfkq1MHjxLefW9vyVSSL2LkQ=
Date:   Wed, 15 Mar 2023 17:39:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/5] md: protect md_thread with a new disk level spin
 lock
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, agk@redhat.com,
        snitzer@kernel.org, song@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20230315061810.653263-1-yukuai1@huaweicloud.com>
 <20230315061810.653263-6-yukuai1@huaweicloud.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <20230315061810.653263-6-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/15/23 14:18, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
>
> Our test reports a uaf for 'mddev->sync_thread':
>
> T1                      T2
> md_start_sync
>   md_register_thread
> 			raid1d
> 			 md_check_recovery
> 			  md_reap_sync_thread
> 			   md_unregister_thread
> 			    kfree
>
>   md_wakeup_thread
>    wake_up
>    ->sync_thread was freed

Better to provide the relevant uaf (user after free perhaps you mean)
log from the test.

> Currently, a global spinlock 'pers_lock' is borrowed to protect
> 'mddev->thread', this problem can be fixed likewise, however, there might
> be similar problem for other md_thread, and I really don't like the idea to
> borrow a global lock.
>
> This patch use a disk level spinlock to protect md_thread in relevant apis.

It is array level I think, and you probably want to remove the comment.

* pers_lockdoes extra service to protect accesses to
* mddev->thread when the mutex cannot be held.

Thanks,
Guoqing
