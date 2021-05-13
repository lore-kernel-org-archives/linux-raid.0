Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75832C433ED
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 07:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38BD0611CA
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 07:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhEMHZ4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 May 2021 03:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhEMHZz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 May 2021 03:25:55 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2729AC061574;
        Thu, 13 May 2021 00:24:45 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id l70so5819291pga.1;
        Thu, 13 May 2021 00:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=rgXzYYK5Z0MLecdxrChbPktgTp37eF6Gz82P771tZ9Y=;
        b=aliCCdsndaLIJHzenXEP2v4OAlnRaIuN4jnQ0SBGwc4KQWKn7U5OzyXxbGn3QeUKhg
         kdeprgYn6hBiZtpZdzDe79aD0V2nGSCmPeZPs+1pdWwVohAwDr5XNWIN5gyvOB70vd3Y
         dTBH4+SEIezEZKW8e9lK8gbgmvN+04YI9Dy/DE9G3pPVot2Tspcq3P5VmHsBOpO+1XRu
         j7cUts4NK6dJrhyKks/QeO+lmNPnRphVila4we/7mYxGiZ0tnmxbKMe8Ky7C9MTAvGU/
         urGh9pNr/7Vr8LoDy7VLYGS2H04Pd5y2Hvwwy4NJezFaULBPrv/pfi1Gl65TDjcIk1Q+
         wUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rgXzYYK5Z0MLecdxrChbPktgTp37eF6Gz82P771tZ9Y=;
        b=R6bzusk62TYOEgxVPf9YOZ+wsGDqW2R7pYWF/MuYU+IngAAShU6qzJU4BAsi99IVP4
         TSo7Dl5ibPjlbsNH9mN6w96VjHQ77s8F+Oh9rSWWcMxbwL/LKWF/xbVfTkbl/LNxK6Op
         st5esdK7Pjlc0P6BRt8oQPho7LjOha+OK7XUyeomlOCl/a6+Mflu5tRpTKWYsTSF9CaO
         NBXGfKtPmOYppiHk3DhRuO8na9pZTjCVVgd/LNIpQMPcE5TYnQdVIgl4G3abLS2iiex1
         ZHJooYts6Y8122+YIwfZgZqFwUpDqQvkJnKgPBElFpwPjkrmdHoX7ZRCVSNwfxCcUyn5
         mFqQ==
X-Gm-Message-State: AOAM532HHntV+NFkrBk01wuGgubvNZ1YqO++ktfaaVTQ4NK+4Mhh0pit
        gVLFcy0QjgMuhM/fwWJ0hx8=
X-Google-Smtp-Source: ABdhPJwXx2OG5VpEqLvmWJKr9VJYqB7FB0b1I2Ulw/Z+ul3Z1eFnl+dLZ1lBmiKOpg8es32j4owqzg==
X-Received: by 2002:a62:528e:0:b029:1f5:c5ee:a487 with SMTP id g136-20020a62528e0000b02901f5c5eea487mr38685998pfb.7.1620890684676;
        Thu, 13 May 2021 00:24:44 -0700 (PDT)
Received: from [10.6.2.84] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id n9sm1514251pgt.35.2021.05.13.00.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 00:24:44 -0700 (PDT)
Subject: Re: [PATCH] md: don't account io stat for split bio
To:     Christoph Hellwig <hch@infradead.org>, Song Liu <song@kernel.org>
Cc:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Pawe?? Wiejacha <pawel.wiejacha@rtbhouse.com>
References: <20210508034815.123565-1-jgq516@gmail.com>
 <YJjL6AQ+mMgzmIqM@infradead.org>
 <14a350ee-1ec9-6a15-dd76-fb01d8dd2235@gmail.com>
 <6ffb719e-bb56-8f61-9cd3-a0852c4acb7d@intel.com>
 <c1bc42ff-eae7-d0ba-505d-9c6a19d60e93@gmail.com>
 <CAPhsuW44cc2p+29_rLqrq7i3R0d03sjtwRQtbLRkta+jzsdYsw@mail.gmail.com>
 <YJot2JAZkQi7RPGS@infradead.org>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <5e91dccb-31f3-daa0-f974-9c3211cc6b15@gmail.com>
Date:   Thu, 13 May 2021 15:24:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YJot2JAZkQi7RPGS@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/11/21 3:10 PM, Christoph Hellwig wrote:
> On Mon, May 10, 2021 at 11:58:32PM -0700, Song Liu wrote:
>> IIUC, the sysfs node is needed to get better performance (by disabling
>> accounting)?
> FYI, we already have that sysfs file in the block layer
> ("queue/iostats"), please just observe QUEUE_FLAG_IO_STAT flag.

Seems only nvdimm observe the flag before call bio_{start,end}_io_acct.
Does it make sense to make the checking mandatory? Something like.

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1315,6 +1315,9 @@ static unsigned long __part_start_io_acct(struct 
block_device *part,
         const int sgrp = op_stat_group(op);
         unsigned long now = READ_ONCE(jiffies);

+       if (!blk_queue_io_stat(part->bd_disk->queue))
+               return 0;
+
         part_stat_lock();
         update_io_ticks(part, now, false);
         part_stat_inc(part, ios[sgrp]);
@@ -1351,6 +1354,9 @@ static void __part_end_io_acct(struct block_device 
*part, unsigned int op,
         unsigned long now = READ_ONCE(jiffies);
         unsigned long duration = now - start_time;

+       if (!blk_queue_io_stat(part->bd_disk->queue))
+               return;
+

Thanks,
Guoqing
