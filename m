Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2CCEB64D9
	for <linux-raid@archiver.kernel.org>; Wed, 14 Jun 2023 07:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbjFNH0v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243694AbjFNHZk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Jun 2023 03:25:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B0419B7
        for <linux-raid@vger.kernel.org>; Wed, 14 Jun 2023 00:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686727476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCVjUpCiaki4fcM43NzRGyadlOcYPcJBZy9bfHP7iJM=;
        b=EB4iFy1KiXnd+FEMKcOIrqr9EJjz9oMDkJKFmxJrSaOvQjcuTia93CYYj0Kk5aRfe/a937
        0cAzJ3fCaetvsskAT+ttRo+vUrRs1lnn24TnF9YsIhGg6LzAeVLkJNWQ6DUObykvbj7wh4
        MfooZNwA06C69xiTWY0Hz67TFPluusY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-hoDWzBPnPJmsg9yKLMeN5Q-1; Wed, 14 Jun 2023 03:24:34 -0400
X-MC-Unique: hoDWzBPnPJmsg9yKLMeN5Q-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-25deb8603a5so238548a91.3
        for <linux-raid@vger.kernel.org>; Wed, 14 Jun 2023 00:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686727473; x=1689319473;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pCVjUpCiaki4fcM43NzRGyadlOcYPcJBZy9bfHP7iJM=;
        b=lINdyyV2zOnZ+0qR8isdeFAB8hbsnxlYMdsmOZIEyvI136PPMexVCzF6/OzYMxZTOX
         InGcmC0zxOXot0E/Hu/sjJgtViFWMw3O3zJQIWeTmxthMPWSPG4VsnD110IB/e+noIIp
         1nDhk3/QiInCtfqjGGFD4gGXjuQHVdAFLPvjwECP+60uRQWnFhlO7t3sM/ZtxDn9NYXc
         fbLZOJ4z/44nvPhJaCFJXyBy+LckpcLIKnLBkgrHcz8sMAd9TL9ig/kUKv1h9T2HnAvb
         x4dfMn65YesELFNM2l0hHwY52BMWLIm3KR42MjbCaeHKQ6o20wNIwrI+c4sJ+8FDO4wq
         mIog==
X-Gm-Message-State: AC+VfDyMqUmw1XMgS7p3mcm+31K3tfT/5d+dTZphz9UMRyCy+2/58re+
        URtNTTFO6F2L13+2zX0dwvmWmfQUou8kExiaZIxYiVIEP/9m5h7KBZESwHtoj3RBrdpi7CkXA6i
        nLNgg17AlcGZ3AgKKxLgpzQ==
X-Received: by 2002:a17:90a:668f:b0:256:5637:2b30 with SMTP id m15-20020a17090a668f00b0025656372b30mr566759pjj.40.1686727473320;
        Wed, 14 Jun 2023 00:24:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7EPJjztLMyL9Tzcno6Zl5Y5jx5gQ+t9tCC5omV1ac4iYoqRpze/H9csdp7PFs0QWTEfbOY0w==
X-Received: by 2002:a17:90a:668f:b0:256:5637:2b30 with SMTP id m15-20020a17090a668f00b0025656372b30mr566748pjj.40.1686727472996;
        Wed, 14 Jun 2023 00:24:32 -0700 (PDT)
Received: from [10.72.13.126] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k65-20020a17090a4cc700b0025bf64ac0besm4465972pjh.55.2023.06.14.00.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 00:24:32 -0700 (PDT)
Message-ID: <d5407a0d-f97b-ce31-9319-911695f2e5e8@redhat.com>
Date:   Wed, 14 Jun 2023 15:24:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [dm-devel] [PATCH -next v2 6/6] md: enhance checking in
 md_check_recovery()
To:     Yu Kuai <yukuai1@huaweicloud.com>, guoqing.jiang@linux.dev,
        agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        song@kernel.org
Cc:     yi.zhang@huawei.com, yangerkun@huawei.com,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        yukuai3@huawei.com
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-7-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
In-Reply-To: <20230529132037.2124527-7-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


在 2023/5/29 下午9:20, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> For md_check_recovery():
>
> 1) if 'MD_RECOVERY_RUNING' is not set, register new sync_thread.
> 2) if 'MD_RECOVERY_RUNING' is set:
>   a) if 'MD_RECOVERY_DONE' is not set, don't do anything, wait for
>     md_do_sync() to be done.
>   b) if 'MD_RECOVERY_DONE' is set, unregister sync_thread. Current code
>     expects that sync_thread is not NULL, otherwise new sync_thread will
>     be registered, which will corrupt the array.
>
> Make sure md_check_recovery() won't register new sync_thread if
> 'MD_RECOVERY_RUNING' is still set, and a new WARN_ON_ONCE() is added for
> the above corruption,
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 22 +++++++++++++++-------
>   1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f90226e6ddf8..9da0fc906bbd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9397,16 +9397,24 @@ void md_check_recovery(struct mddev *mddev)
>   		if (mddev->sb_flags)
>   			md_update_sb(mddev, 0);
>   
> -		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
> -		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
> -			/* resync/recovery still happening */
> -			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -			goto unlock;
> -		}
> -		if (mddev->sync_thread) {
> +		/*
> +		 * Never start a new sync thread if MD_RECOVERY_RUNNING is
> +		 * still set.
> +		 */
> +		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +			if (!test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
> +				/* resync/recovery still happening */
> +				clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +				goto unlock;
> +			}
> +
> +			if (WARN_ON_ONCE(!mddev->sync_thread))
> +				goto unlock;
> +
>   			md_reap_sync_thread(mddev);
>   			goto unlock;
>   		}
> +
>   		/* Set RUNNING before clearing NEEDED to avoid
>   		 * any transients in the value of "sync_action".
>   		 */

It makes the logical more clear.

Reviewed-by: Xiao Ni <xni@redhat.com>

