Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8598FC433ED
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 01:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 310BC61404
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 01:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhEMBVQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 21:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhEMBVO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 21:21:14 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE45EC061574
        for <linux-raid@vger.kernel.org>; Wed, 12 May 2021 18:20:04 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id c21so19769354pgg.3
        for <linux-raid@vger.kernel.org>; Wed, 12 May 2021 18:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=vBsNNhS4SGhEj0Kx/oNja1GcHMEOZ8OnrTENTnBDF50=;
        b=DIlAMF8Iq7ZwZWbTY5Z6/AKvhMLoz86hueZfKboha8BralBucEerrN4huuSWEihr0D
         c6PD49IkCW4kLplLUiosrnCGGHqWROf/cwfy+36ziGG/030oW1qSErHFpauJHZZpWI61
         LOpEFHyY+hUrjydpnrlsb2ApL6lOSL0KTUYiI58klt/NuiRGQae8+s3wA/uC2XH8Nj1O
         70ZITa9KUraMiH6FYffXiO4ZsoDELYCbrvKiG9qvfuw0eI6s+k5ZMPJHQV0pUq59QCwC
         9lbcKejQnxY73xipgP+P/uIb2aNg6vOB0OI5eh+6s8vakqCF+sHMxqlhqOj9/fZUas/9
         1Tzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vBsNNhS4SGhEj0Kx/oNja1GcHMEOZ8OnrTENTnBDF50=;
        b=GGq91DD9/SEAcXSi4Q+Swwym/bT710YZo9NM409ECoqqfZq+HIgM0ohfziVKQXDZyd
         j5MqD/09G7x7WS66QPB2C801T4HWQ0VnXTs8JYMo5yr1TtrkJgh36tB1gpHBHvjtYFoe
         CA9Aoh4xQ6DNLNGfL75llzk9RyFJJjpOcIj9R5+rh21QiZICsYjeMqevDDaSYLC9wWDa
         kxnCYWXYjYJnfeqq+DjHM7/DYpDnmmmWzRgqpBXzpcyivmcnBIeTDLnnqzbZbM+uK+fC
         aTG7gjQNMihR7U6ysjVLXL8UJCdRHVe7tpStHZwxcqKKO9Ja7HnmNx3+XyQ91n+VQbtI
         L+dQ==
X-Gm-Message-State: AOAM53151pfhTtZJ3w0nEGViUdNwupEQhFh50+TjiwmNZEXmmWkSMq8W
        JG2M1ZR2vjr5z3ys5MEaleI=
X-Google-Smtp-Source: ABdhPJzcqa+Gp4twUmHBy+vD8zSI06fHsYGdV89GQKhuVTVVN7XAV+3Qx5LojYFtSXDadLz1Gqc8Fw==
X-Received: by 2002:a05:6a00:ac6:b029:27b:5d2:6e66 with SMTP id c6-20020a056a000ac6b029027b05d26e66mr37553065pfl.14.1620868804514;
        Wed, 12 May 2021 18:20:04 -0700 (PDT)
Received: from [10.6.2.83] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id q24sm815185pgk.32.2021.05.12.18.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 18:20:04 -0700 (PDT)
Subject: Re: [PATCH] md: warn about using another MD array as write journal
To:     Vojtech Myslivec <vojtech@xmyslivec.cz>, Song Liu <song@kernel.org>
Cc:     Manuel Riel <manu@snapdragon.cc>,
        Linux-RAID <linux-raid@vger.kernel.org>,
        Michal Moravec <michal.moravec@logicworks.cz>
References: <DAEB6C2F-3AE0-4EBE-8775-7C6292F8749A@snapdragon.cc>
 <CAPhsuW4=XoyQV_HNVnFnMWS2PvvU1+Rtbh9SJB-FQTO3haa3ig@mail.gmail.com>
 <27EE5CBC-B1B8-4463-87F5-2AE73F30941B@snapdragon.cc>
 <C990C60B-FB5A-4709-949B-6D86AF9FA6B1@snapdragon.cc>
 <CAPhsuW5urYTuOago=5sGiQ_7huQ6S+2rYkQ=n+_TwxQtxC3tWQ@mail.gmail.com>
 <0016997f-7fbe-a346-e94a-b3dd6d5e04c0@xmyslivec.cz>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <cb0f312e-55dc-cdc4-5d2e-b9b415de617f@gmail.com>
Date:   Thu, 13 May 2021 09:19:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <0016997f-7fbe-a346-e94a-b3dd6d5e04c0@xmyslivec.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/13/21 6:39 AM, Vojtech Myslivec wrote:
> It has been two months since I last reported the state of the issue:
>
> On 17. 03. 21 16:55, Vojtech Myslivec wrote:
> > Thanks a lot Manuel for your findings and information.
> >
> > I have moved journal from logical volume on RAID1 to a plain partition
> > on a SSD and I will monitor the state.
>
> So, we run the MD level 6 array (/dev/md1) with journal device on
> a plain partition of one of SSD disk (/dev/sdh5) now. See attached files
> for more details.
>
>
> Since then (March 17th), our discussed issue happened "only" three 
> times. First occurrence was on April 21st, 5 weeks after moving the 
> journal.
>
> *I can confirm that the issue still persist, but it is definitely less
> frequent.*

Could you check if this helps?

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bd813f747769..b97429f19247 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1014,6 +1014,7 @@ void md_super_write(struct mddev *mddev, struct 
md_rdev *rdev,
             !test_bit(LastDev, &rdev->flags))
                 ff = MD_FAILFAST;
         bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA 
| ff;
+       bio->bi_opf |= REQ_IDLE;

Thanks,
Guoqing
