Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7DFC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 14:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81A9C206D5
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 14:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389846AbgLJOyl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Dec 2020 09:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387518AbgLJOyc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Dec 2020 09:54:32 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA402C061793
        for <linux-raid@vger.kernel.org>; Thu, 10 Dec 2020 06:53:51 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id c18so5529110iln.10
        for <linux-raid@vger.kernel.org>; Thu, 10 Dec 2020 06:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=esgYMFP901gzD8Owdhn8snvRqo2CEArHngCjX2ez6RQ=;
        b=qazRxHUBYoui34lpr8rDfJ7BliQRNs+k+ZO5b6tJxrB7+pTr7vb5mGsd6WL+LoBSKp
         nC9O3ZZjJ/TfkytUouVF2hl1/BSvL4WiXmPkZRcRrWRWQ+VNsgWOq7FC+sk7ZpYDyD+N
         3YJNENxy56lyY7uA+39AToEwjeCcuT2LgpQ5wdkUDNI/DgOX4wZneNTNNoD2mWwq2iJJ
         FLiq4V0FyOoO94ldlGMXjwe/h4YcZYYcp3JXxeIjRDL/IfWErOkUjau4cDLGU7VmL9eO
         mhsolfTe9jkLGYdwBcx2vB9FkoBqRbawvelyK29Ze0HRjF1RwxbyEU7fOuIx9SNxtq76
         k1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=esgYMFP901gzD8Owdhn8snvRqo2CEArHngCjX2ez6RQ=;
        b=c5X4yA8HZqp4z0+YctAhP/AZRy61ZS0om6xKylGVLr1xUDT74i3+iOqkIJleOVbe1q
         IM2AvJ8zzuE0QuafbckN95SwISsA/gRZHqgNi2WLQqCCgHuuUuvRnkK7R9cZrzN+LJtc
         DyQ6GTiF6DXjXLoNAxUrWOeo3Ym1Z07qhLtWBeK8nZyrjgDgvxX1u0yIrFI0BCJicMGx
         uoAzKRDgAaAJuzeVuBdb2GT/Y924Wefm3KIV0jAT+nyxfTPjVQ3A6x4TRsxsr5yRjC2S
         8H31qNseE74qBE8rDIOjtwgplExx2Kv8qCMKtpu+bxlBlDgxDQmDcecLjqqC2v1Ql9nw
         Vznw==
X-Gm-Message-State: AOAM533mJBuB4CJvaC+B+esiNxZagLHq9csbhh93uEqKXJJqpi5JtGdF
        sqcqSR0nC9RA1kDTSyOdYNa0Mw==
X-Google-Smtp-Source: ABdhPJz0iWIdZ4Nq041NxAkwYQBamnYgHqUQsw+iWN43E1ulz9L+uBmdI67Q8hw/uqnd/8Y9DQzYUg==
X-Received: by 2002:a05:6e02:5ab:: with SMTP id k11mr2759126ils.189.1607612031177;
        Thu, 10 Dec 2020 06:53:51 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h18sm2756370ioh.30.2020.12.10.06.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 06:53:50 -0800 (PST)
Subject: Re: [GIT PULL v2] md-fixes 20201209
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Xiao Ni <xni@redhat.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>
References: <0C161FAC-8A21-4EAF-B3B4-A7BF04089213@fb.com>
 <aa01f088-c4a5-2eed-3e74-2288554ea98a@kernel.dk>
 <20201210145119.GA9856@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <00e0d114-e45e-9fbc-0f44-2eb1d81f992d@kernel.dk>
Date:   Thu, 10 Dec 2020 07:53:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201210145119.GA9856@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/10/20 7:51 AM, Mike Snitzer wrote:
> On Thu, Dec 10 2020 at  9:08am -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 12/9/20 9:59 PM, Song Liu wrote:
>>> Hi Jens, 
>>>
>>> Please consider pulling the following changes on top of your block-5.10 
>>> branch. This is to fix raid10 data corruption [1] in 5.10-rc7. 
>>
>> Pulled, thanks.
> 
> Hi Jens,
> 
> Can you please pick this related revert up too?:
> https://patchwork.kernel.org/project/dm-devel/patch/20201209215814.2623617-1-songliubraving@fb.com/
> 
> I asked Song to do so in v2.. seems it got overlooked.
> 
> Patchwork didn't grab my Acked-by, but I did provide it (should be in
> your INBOX).

I would, but looks like the offending patch isn't even in my block-5.10.
So probably best if you just ship that one.

-- 
Jens Axboe

