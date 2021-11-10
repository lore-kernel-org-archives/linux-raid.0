Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D13C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 17:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEBC661241
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 17:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhKJRHU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Nov 2021 12:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhKJRHU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Nov 2021 12:07:20 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6225FC061764
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 09:04:32 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id e65so2815453pgc.5
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 09:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=7FMYFnLu3I3/58T4ySEb6oqOYV4tVexvkZQnsU0PdxU=;
        b=WiRvFcpIO9dRXaqOKtGrXrPK2evZXUC6D8RUK4qN66cZFdGCU4oUOpTn9HhW+WI1Ko
         B/808zj1k+/cMblnUOXTYcpEmB7pbyC9r2prgRdTdjFQ/ro9aWe378v41kWHCW7vcf9W
         hzFTtLXnuGXxyt+e7ovwT7O1vFlMgD2UiNtkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7FMYFnLu3I3/58T4ySEb6oqOYV4tVexvkZQnsU0PdxU=;
        b=AE5iK8Jj7aeYHBCVQaU68qGssf2pskF8oMEk+vmWF68/P9KGXp8mlwm+NacAKX3+9p
         90VTZIX4JhYIHrHNnC1GjDotz7J9e1fI/nPxHlybTdxnOX/OrbufgIlrb3oDkzdzhSNx
         u98onNLFJIhcUmiN7A6LXkoKIlhboczJzcvxHaopYABxVkat2r1YRi4FO1Vp+obH/goG
         4R1C2Akl4vtqVgl0gEKDgyeS66Hl+SxW3H4iWNMaZ+9jztb4VvvlkDYW/CP0hTBbfQWH
         nZYbRJmLSS8eThToG94YSA9y1nzEoRbNpUoErZ/uF/XtvYm3bIjtRn2N43efxi7uOlfm
         gF6Q==
X-Gm-Message-State: AOAM530jYVpK3sBJ+znk9iTAzWaD9WKZWiLo7RMavb69rDgFk9P3PJsJ
        vFtn39kIzNU+nZnU54Oj4wuD1g==
X-Google-Smtp-Source: ABdhPJxVquqoVKyqeZI/LPn7wIeIrCaaV8i2hgB3+EfDvAG0+allMxfntEZUTGT4jiUsPRkVNwZlFQ==
X-Received: by 2002:a05:6a00:1310:b0:494:672b:1e97 with SMTP id j16-20020a056a00131000b00494672b1e97mr643069pfu.77.1636563870369;
        Wed, 10 Nov 2021 09:04:30 -0800 (PST)
Received: from [192.168.1.7] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id l12sm246309pfu.100.2021.11.10.09.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 09:04:30 -0800 (PST)
Message-ID: <d494671a-214c-aa10-393d-2ba12f479b3b@digitalocean.com>
Date:   Wed, 10 Nov 2021 10:04:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v3 2/2] md: raid1 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com>
 <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <97bff08e-ecb7-37d7-c113-7f33bfca02d9@digitalocean.com>
 <4d0dd51b-9176-99df-2002-77ecf48c6d20@digitalocean.com>
 <CAPhsuW56xhYA3Si65Hvvp-1HU3KTrjU8RN_aKWXw2A5C0YsVPA@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW56xhYA3Si65Hvvp-1HU3KTrjU8RN_aKWXw2A5C0YsVPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Ack, thanks!

On 11/10/21 10:02 AM, Song Liu wrote:
> On Tue, Nov 9, 2021 at 12:59 PM Vishal Verma <vverma@digitalocean.com> wrote:
>> Hi Song,
>>
>> I did modify raid456 and raid10 with nowait support, but unfortunately
>> have been running into kernel task hung and panics while doing write IO
>> and having hard time trying to debug.
>>
>> Shall I post the patches in to get the feedback or go with an
>> alternative route to have a flag to only enable nowait for raid1 for now?
>>
> There is still sufficient time before 5.17, so I would recommend we do all
> personalities together. You can always post patches as RFC for feedback.
>
> Thanks,
> Song
