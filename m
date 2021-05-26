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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB11C2B9F7
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 07:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F97861437
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 07:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhEZHzF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 May 2021 03:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhEZHzC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 May 2021 03:55:02 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C4EC061574
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 00:53:30 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id l70so276718pga.1
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 00:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ogGlgaTUyUebGNz9NxIIWjP5JTBg6nr2KS2EtWTwmDo=;
        b=KmeO8huojX739kr3yYo8vs9L5X4ZSVRFc+pUshqPb7T1uBvhEhwWvJ8xfQwtGNQW8l
         Bulu7e/S9I6n82fnISrfRIK6fGUr/f4DTGGKYuEuOi4Dd9zsWJiFhBoNdGnluFsYY6uu
         aamfpTlsl5iG3cluAvTZ9ZMsFjlgIejcbrB9GzqBGvxnXD5XN+i9x75hKFXNc1A7xj9P
         OTTwKB44uz2Ut8sOGm4POy56S4F20ws215glLFRRqHcC/GmNCvRlEogp/jSTp3xTQdyL
         CKawKw88tW7T5uQhlDahyTLUunEyoO+PyI+TuSCXDOjcRyCwHz4wj1DvPlNnTj1Qy9pi
         ygnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ogGlgaTUyUebGNz9NxIIWjP5JTBg6nr2KS2EtWTwmDo=;
        b=J1tu9cPT79DyzT/21uTgDN8KItPKT+E7wuspdNxcxe2Jf7v8VeZzQd5N1weoHd3CxN
         D2R6voixLG013QH07LNsFx3aQWH9UBrPio0tRQ85NMR05ognTkJZ+4x/gGzrMpYaLQcS
         0UPd0QUXTp/s4kN1uJmMI+IzLtCEa4TlKdQ7lH0iS2n4fPA4ePjdPMEoi40rpszcX5a0
         S0225irPniuEkOiTWO5/s4DOBFktEmNWGoVHTioXNEej/Nkp2cRrcYJaP7sIAkbSPmYh
         QBdeOdgmI1woWnGE3NYrGDfga+UQJOSe+YHKuqUNTjgvxaAX0wysxrY6f137wSiIDtMn
         xPxA==
X-Gm-Message-State: AOAM533Lvdk1txPMbrvgx1WktpDtSpHv9L7Lv4n5EDaYVjs8PLxFtrJA
        IYTmQBwU/oiHZJrHJtYSPA1ewRcOYqJ5WQ==
X-Google-Smtp-Source: ABdhPJyAufpGlXWXXat3SG+yRnptwgkMd1W65/hBfkiOctFLnVLWsVlUrksunHqBptPnobSNszkCDQ==
X-Received: by 2002:a62:4e10:0:b029:2cb:cf3b:d195 with SMTP id c16-20020a624e100000b02902cbcf3bd195mr34203588pfb.74.1622015610273;
        Wed, 26 May 2021 00:53:30 -0700 (PDT)
Received: from [10.6.1.115] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id z18sm2060205pfc.23.2021.05.26.00.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 00:53:29 -0700 (PDT)
Subject: Re: [PATCH V3 2/8] md: add io accounting for raid0 and raid5
To:     Song Liu <song@kernel.org>, Guoqing Jiang <jgq516@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
 <20210525094623.763195-3-jiangguoqing@kylinos.cn>
 <CAPhsuW6WyvFtvJVw1q5tpx9C9wWMh8YDEd8v+xdY=P4yLiKELA@mail.gmail.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <a2342aab-28da-64a2-9591-bc7b482e1751@gmail.com>
Date:   Wed, 26 May 2021 15:53:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6WyvFtvJVw1q5tpx9C9wWMh8YDEd8v+xdY=P4yLiKELA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/26/21 2:32 PM, Song Liu wrote:
> On Tue, May 25, 2021 at 2:47 AM Guoqing Jiang <jgq516@gmail.com> wrote:
>
>
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -2340,7 +2340,8 @@ int md_integrity_register(struct mddev *mddev)
>>                                 bdev_get_integrity(reference->bdev));
>>
>>          pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
>> -       if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
>> +       if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
>> +           bioset_integrity_create(&mddev->io_acct_set, BIO_POOL_SIZE)) {
> Added better error handling here.

No need to do it here, because md_integrity_register is called from
md_run() -> pers->run(), if above returns failure, then the path
(bioset_exit -> bioset_integrity_free) is triggered.

I thought we probably need a comment here given it is not explicit.

>
>>                  pr_err("md: failed to create integrity pool for %s\n",
>>                         mdname(mddev));
>>                  return -EINVAL;
>> @@ -5569,6 +5570,7 @@ static void md_free(struct kobject *ko)
>>
>>          bioset_exit(&mddev->bio_set);
>>          bioset_exit(&mddev->sync_set);
>> +       bioset_exit(&mddev->io_acct_set);
>>          kfree(mddev);
>>   }
>>
>> @@ -5864,6 +5866,12 @@ int md_run(struct mddev *mddev)
>>                  if (err)
>>                          return err;
>>          }
>> +       if (!bioset_initialized(&mddev->io_acct_set)) {
>> +               err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
>> +                                 offsetof(struct md_io_acct, bio_clone), 0);
>> +               if (err)
>> +                       return err;
>> +       }
> And here (for the other two bioset_initialized calls).

Yes, it looks correct to me.

>
>>          spin_lock(&pers_lock);
>>          pers = find_pers(mddev->level, mddev->clevel);
> [...]
>
>> +
>> +       if (!blk_queue_io_stat((*bio)->bi_bdev->bd_disk->queue))
>> +               return;
> Added blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue); to md_run.
> We still need it as md doesn't use mq. Without it, the default iostats is 0.
>

It enables io accounting by default, so raid5 and raid0 users have to
disable it if they don't want the additional latency.

Thanks,
Guoqing
