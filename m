Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DD3C43381
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7128A64F39
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhCDAAC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:00:02 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17272 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448132AbhCCPYF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Mar 2021 10:24:05 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1614781838; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=N7gH4RruEQj1zBe7IxepIVA2pzTw3HuX+p291V6HOx4iS1kc5EYalnmK3rfHmmF6ror8wq5qnEtjmqhkNJl54A0Yrb0PVGXv57TTddzBT2cAujnyEiwdH/m+HGRZn2PLlNApm9ExEJwHpk5H6bW3Q8iGqkjOdYQP3coHWgSKYCA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1614781838; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gSE+RlqDwwiqetN0fU22f6c7vkmzm9X89Vtf5Fc/jg0=; 
        b=YLqHG5TskkYuGKgnUCkZKtfe47T5kXi4yvlrG6usN3fHn36CLDjLZnltsRnZcT41+6w5y3L4Bcio1+BEW113SqkZIOvOheCNgU5DdSd3O8DgSoSsyYqXKBcN76WfunilUwFMejGitdLEafKWBpXDqv6ttP+gGnGG1hrq07Ij8z8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1614781835456893.4019857629609; Wed, 3 Mar 2021 15:30:35 +0100 (CET)
Subject: Re: [PATCH v2] super1.c: avoid useless sync when bitmap switches from
 clustered to none
To:     Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org
Cc:     xni@redhat.com, lidong.zhong@suse.com
References: <1612311771-17411-1-git-send-email-heming.zhao@suse.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <89c46715-bc0d-d4de-9da5-1da44d4d3428@trained-monkey.org>
Date:   Wed, 3 Mar 2021 09:30:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1612311771-17411-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/2/21 7:22 PM, Zhao Heming wrote:
> With kernel commit 480523feae58 ("md: only call set_in_sync() when it
> is expected to succeed."), mddev->in_sync in clustered array is always
> zero. It makes metadata resync_offset to always zero.
> When assembling a clusterd array with "-U no-bitmap" option, kernel
> md layer "mddev->resync_offset == 0" and "mddev->bitmap == NULL" will
> trigger raid1 do sync on every bitmap chunk. the sync action is useless,
> we should avoid it.
> 
> Related kernel flow:
> ```
> md_do_sync
>  mddev->pers->sync_request
>   raid1_sync_request
>    md_bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1)
>     __bitmap_start_sync(bitmap, offset,&blocks1, degraded)
>       if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
>         *blocks = 1024;
>         return 1; /* always resync if no bitmap */
>       }
> ```
> 
> Reprodusible steps:
> ```
> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sd{a,b}
> node1 # mdadm -Ss
> (in another shell, executing & watching: watch -n 1 'cat /proc/mdstat')
> node1 # mdadm -A -U no-bitmap /dev/md0 /dev/sd{a,b}
> ```
> 
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
> v2: only set MaxSector on bitmap clean device

Applied!

Thanks,
Jes

