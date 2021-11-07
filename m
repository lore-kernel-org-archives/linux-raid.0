Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4E9C433EF
	for <linux-raid@archiver.kernel.org>; Sun,  7 Nov 2021 00:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5631B61059
	for <linux-raid@archiver.kernel.org>; Sun,  7 Nov 2021 00:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhKGAU6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 Nov 2021 20:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbhKGAU5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 Nov 2021 20:20:57 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF76C061570
        for <linux-raid@vger.kernel.org>; Sat,  6 Nov 2021 17:18:16 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id bg25so20472873oib.1
        for <linux-raid@vger.kernel.org>; Sat, 06 Nov 2021 17:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=WzDEOfcTHqeLIFGR8NFpCHWfDSCLsXExcjKRZZjH8gk=;
        b=U569YGbhymqGilrUBNH4jVv1+RHTHeBsyWy4cNYRYTVn2StbO2G+H1ADeUS0p33qM4
         svT8KTlubGFYvlAWV8oJZs0ldrpfnHybkoCdUrmQHblx1i34SS8ccBurIRftTem1xWSK
         JFjOtufxJXP9cW2BwqVNCwqqT+BE2BvCP/s8E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WzDEOfcTHqeLIFGR8NFpCHWfDSCLsXExcjKRZZjH8gk=;
        b=nfIhHrtjDmS+IEIYCvE75ezNy5we/Kr6R7pNI8Qd95OijVjDdprHdwsoHJZfxUXT9D
         4AMzUmXhr488vyO9tIKjBt1TM91diA26V5peJxj4fnSmhg55QtMaLujLCv3Vl8rHKL5q
         mPFVOkLfm6Oc96v0N2WizTEVA1C8gOor1cC2SGO6Vh+d06UYz9f6RqTQlh+vIYB/PRrK
         peh9dN1FsdSuPMXwjx/9qgRVM49FCvkek+Uc8BrcCacJE+h8ZrSrzDZq82nHauhhAVES
         WA7zaVN8Q1uPcBgTsJ4dcXhiqyoYM4vKiLHDWH0mH+pq4pfyVyMInFt0gAo/kA5HlZ5i
         Z+Bg==
X-Gm-Message-State: AOAM5325dboGJkPgwx+H4VuzNw59L4j1uTO9osu1ozQxgiHKzWPV1OmT
        y/Apo1RzQ5vR8XiKVqpFMYTVKQ==
X-Google-Smtp-Source: ABdhPJzQsSH+v5UPTHsmgIfpuRM9V80b4flezA4JOM5KZIYNaGFzpoMDyhyMif3iCeuXavvEFbR3jw==
X-Received: by 2002:a05:6808:2182:: with SMTP id be2mr12261268oib.80.1636244295412;
        Sat, 06 Nov 2021 17:18:15 -0700 (PDT)
Received: from [192.168.1.7] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id h1sm1875191oom.12.2021.11.06.17.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 17:18:15 -0700 (PDT)
Message-ID: <0d28b836-113c-4b7b-92ba-68d84275a441@digitalocean.com>
Date:   Sat, 6 Nov 2021 17:18:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v3 2/2] md: raid1 add nowait support
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org,
        linux-raid@vger.kernel.org, rgoldwyn@suse.de
Cc:     axboe@kernel.dk
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com>
 <595ad3d1-ea04-c04a-50ed-3385b44d0d40@linux.dev>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <595ad3d1-ea04-c04a-50ed-3385b44d0d40@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Yes, that will be next.
Sorry I wasn't clearer, but wanted to see if the changes so far for 
raid1 makes sense or not.

On 11/6/21 8:24 AM, Guoqing Jiang wrote:
>
>
> On 11/4/21 12:51 PM, Vishal Verma wrote:
>> This adds nowait support to the RAID1 driver.
>
> What about raid10 and raid456?
>
> Thanks,
> Guoqing
