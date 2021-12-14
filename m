Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5EEC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 15:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhLNPaf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Dec 2021 10:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhLNPaf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Dec 2021 10:30:35 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CBCC061574
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 07:30:34 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id p13so18148290pfw.2
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 07:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:from:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=ZQkOSkJuQ+4bHF5MJEMdnH70DGLXRZi9apczuOhnBK4=;
        b=TFr1tCjvMu1t8CZrvzss3VQvBhgL5Ob2VeGBNoQeb4eBrNztGbKmuu87nNghuRhXR9
         oZxMiOAZGfRNGrNZyGN39cKhiNTIcmrV+o30H3bymMSkNBGMkgxh559EAWFGiWaBcvTh
         b+1NCU17ZV2zwCcG4tFBEOzWHLjjaUAOLTDlw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=ZQkOSkJuQ+4bHF5MJEMdnH70DGLXRZi9apczuOhnBK4=;
        b=HmGcMVjkhPZXRID5z7Zz6EAtMx/S6rKcHjlqwpEMWQp8StKWGSNgIDSeontegd/UHi
         E+sULae0sr4UUzb0qwCnLbjmIWEdyr+KDdATaGbBGaZR/MRiG0AiBZXhH512ghSQDNIj
         009409vmD8N8uo2+zjD/tHQeReWrrtJZ7yK8Gf4Vjznqn0UIoPxT9DZZkJgoTtUfZoQj
         fgxqlupu1GBLAu/TYOievbK88NhgrHdqjLw5eI1GGNbWNGB1WjxUbHcDpuIPCPSqvFit
         yu+m30wDA1I3GRH8AfJMJ9t7ZT7DF7lVuYzHrHZGcR9tBFhhARpH5u6LxxpZKnQ5MG0D
         nYjw==
X-Gm-Message-State: AOAM532EqXXyrvM39TIxzT1o9O0XwZAnM9AAewMkeIcviX5JX//DvuBf
        Kvs5ZiY2yQ3JcvJRFcRjcQbigSvgo27aFQ==
X-Google-Smtp-Source: ABdhPJzxgoulHX0X8aUHPQ+6AQGDAbwsSMAzd2KlRE8BGIUv8jpmMSi+4pi9N5CsUhdYIB1Qx9PUqw==
X-Received: by 2002:a63:2254:: with SMTP id t20mr4213337pgm.487.1639495834377;
        Tue, 14 Dec 2021 07:30:34 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id pc1sm3523838pjb.5.2021.12.14.07.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 07:30:33 -0800 (PST)
Message-ID: <07adb65e-d018-e8d4-61e6-3ca3273cc1bd@digitalocean.com>
Date:   Tue, 14 Dec 2021 08:30:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
From:   Vishal Verma <vverma@digitalocean.com>
To:     Song Liu <song@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
 <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
 <2354ab61-0d13-aec5-a45f-23c5cd3db319@digitalocean.com>
 <CAPhsuW7r-JX+zOadzbzLDa0WxZdLws9=mTbPc0ci6qNfRBxgjA@mail.gmail.com>
 <998a933f-e3af-2f2c-79c6-ae5a75f286de@digitalocean.com>
 <b70fded5-8f65-7767-25c1-d45b1dcbbddf@kernel.dk>
 <78d5f029-791e-6d3f-4871-263ec6b5c09b@digitalocean.com>
 <CAPhsuW6VsNPcG3VSLPk-zq16GYp1CN=X0jk9AGveAWaCBLgoig@mail.gmail.com>
 <255f6109-55ee-a54e-066a-9690da9412ce@digitalocean.com>
In-Reply-To: <255f6109-55ee-a54e-066a-9690da9412ce@digitalocean.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/13/21 6:12 PM, Vishal Verma wrote:
>
> On 12/13/21 6:11 PM, Song Liu wrote:
>> On Mon, Dec 13, 2021 at 4:53 PM Vishal Verma 
>> <vverma@digitalocean.com> wrote:
>> [...]
>>> What kernel base are you using for your patches?
>>>
>>> These were based out of for-5.16-tag (037c50bfb)
>> Please rebase on top of md-next branch from here:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
>>
>> Thanks,
>> Song
> Ack, will do!
>
After rebasing to md-next branch and re-running the tests 100% W, 100% 
R, 70%R30%W with both io_uring and libaio I don't see any issue. Thank you!
