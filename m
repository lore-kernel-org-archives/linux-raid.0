Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB4DC49EA5
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 01:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51B58608FE
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 01:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhFYCAt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Jun 2021 22:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbhFYCAt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Jun 2021 22:00:49 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBBFC061574
        for <linux-raid@vger.kernel.org>; Thu, 24 Jun 2021 18:58:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c15so3908904pls.13
        for <linux-raid@vger.kernel.org>; Thu, 24 Jun 2021 18:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BeHfuJbIyh6CSOX8Q3bHVHdRWHhrvCCOIkyyQ4UHKq4=;
        b=WSR/dmKVo6dY/UVC34liyf1ROOc2BVgo+MD2txPASAThenSSBo2Xye/LDv6ZiHu/d5
         YtSWuFpf/ksQOaFeyPkFymEZcUseZnlTYnSfw7ksAV7hIt4yfPpgyEGg6jQxyljnS4Xa
         1z42iyqsJQSqON0FrL/uHA/JV0UXUJJSiUjsWO5Li4EUi/yn05O4lb6WGOF0fdqE/Id9
         1DQUS5TSB2U8t2KU4x/A+FEE/Rh/hj4EuxsPe/UJENlBB9ScEhff/ARN06J+wmbyh+ic
         e7tQAHqMCwQ0bv9HDT+WUF5kzDIWVk31N4QDO2Ha89x9+EnWqpdjdogB/PCaJ8DhUzTJ
         hMyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BeHfuJbIyh6CSOX8Q3bHVHdRWHhrvCCOIkyyQ4UHKq4=;
        b=Z0l0Se4CmG4I1FhR7AnO3tsnFCDwnAeIeFdxOZoxS/lp7ID7bNhD3iLhzKwGO2D3A2
         YaTZOjMTuz83eZXcwtFRBtk8S/Jib8vgMdGkPxWuTxanQLItUnkHVd8dOGbMIpF2wE8V
         IUmhJYvMdBxdRkSYs2a88RiSCntpYM77Xz9mIJOq9Y7goZuMmzIIDX+HiI4Wd1e0lQOV
         cPWZNdPd/LeMYbCMmEuHnYPyv0XHx5ik634A0hU1ty402mH17YJMa+yJEoFDwcZeaBfd
         46YDIoodjGqnmNeexoJrbwDXNZN9hkAFQtQkAdMUJLv+QDEJY7xtcJqc32BVvyVSSY+D
         vO6g==
X-Gm-Message-State: AOAM530kcjcW/h4QMF6KrJ98mxv0ZnRlscl8OJHaRR4SE0xkMrezvSuY
        FO6Ye30UvfZJEMdmpKFH1SQJBUlp00/y/DnN
X-Google-Smtp-Source: ABdhPJzamUuA/ryox2w4AcSeB+wt0zAoEMd0adJ38E0B9gyhFYBzxOfUpK+r8g2G/KBjzq5OkbDQ8Q==
X-Received: by 2002:a17:90a:b107:: with SMTP id z7mr13025961pjq.226.1624586307817;
        Thu, 24 Jun 2021 18:58:27 -0700 (PDT)
Received: from [10.6.1.181] ([89.187.161.160])
        by smtp.gmail.com with ESMTPSA id co18sm9063366pjb.37.2021.06.24.18.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 18:58:27 -0700 (PDT)
Subject: Re: [PATCH] md/raid10: properly indicate failure when ending a failed
 write request
To:     wsy@dogben.com, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org,
        Paul Clements <paul.clements@us.sios.com>,
        Yufen Yu <yuyufen@huawei.com>
References: <E1lwU4E-0029Uw-MM@dogben.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <9245e56b-33f3-35f8-c02e-4d57a809c2c8@gmail.com>
Date:   Fri, 25 Jun 2021 09:58:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <E1lwU4E-0029Uw-MM@dogben.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/25/21 2:27 AM, wsy@dogben.com wrote:
> Similar to commit 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd, this patch
> fixes the same bug in raid10.
>
> Fixes: 7cee6d4e6035 ("md/raid10: end bio when the device faulty")
> Signed-off-by: Wei Shuyu <wsy@dogben.com>
> ---
>
> Maybe there are other bugs fixed in one but left open in the other?
>
>   drivers/md/raid10.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 13f5e6b2a73d..f9c3b2323d7c 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -475,6 +475,8 @@ static void raid10_end_write_request(struct bio *bio)
>   			if (!test_bit(Faulty, &rdev->flags))
>   				set_bit(R10BIO_WriteError, &r10_bio->state);
>   			else {
> +				/* Fail the request */
> +				set_bit(R10BIO_Degraded, &r10_bio->state);
>   				r10_bio->devs[slot].bio = NULL;
>   				to_put = bio;
>   				dec_rdev = 1;

While at it, could you also delete the incorrect comment? I don't know 
how the above part is relevant
with failfast after the refactor.

                         /*
                          * When the device is faulty, it is not 
necessary to
                          * handle write error.
-                        * For failfast, this is the only remaining device,
-                        * We need to retry the write without FailFast.
                          */

Thanks,
Guoqing
