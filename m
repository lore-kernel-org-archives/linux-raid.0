Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424B8C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 30 Mar 2022 19:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245705AbiC3TDR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Mar 2022 15:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350525AbiC3TC4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Mar 2022 15:02:56 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EACE3E0E4
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 12:01:11 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id 14so10485121ily.11
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 12:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9Frv66bS5CjndiU0lVrvfF/G0GqtvSRDQkexHAo8Ips=;
        b=zMlEmWHb0kR3zu63RagNKj83MC4yVZqN235xljB5sMGLtz5kzfDVUuKFOh7e/qBIU7
         3qdw7HA0wuarPxmTyC+ztHto4WtJNeYYZxhM6BEXB+rpfCla3qaIMZew6aswiIG3fpNu
         YQ205szRjteUgbD8OjsK6ECryCACx/WAq1QcGFBLi/LSFe22YVxWtAcIodvaaVfDSlY8
         6/21hfXjP1xNicr2Hzn0SBlldh2vWZY81mx5Nc1inclv8ZndXKKs7uFRW88f5K5DO8UA
         LLp8mJhecsFl0r/jZl10orvMYB3ZBeX1iJoNq5WN6AvPstddOH70K3bC4Y/gY3cnzeCu
         irCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Frv66bS5CjndiU0lVrvfF/G0GqtvSRDQkexHAo8Ips=;
        b=IXA12Q5aWmW88nwTitW4zepk7y9ttF0egLigF8f8OpvhfbZY3fCipVJbHS+7dOq16T
         raVLG3adc/K72oSDRi0Y8p1GrldjHFQQ09Zn4koplptSBqqTrvEKH2YIz2KnvM2UN7G2
         u1nBClfsW6dMl4dOhchzwa439kZRxFoV/drb3qkBWtJna6QqqX9QeXB/MkPoXPdOx97d
         RIkW6clNRcng82hlp/f1+K8rILGKmaxyi1RDJOA05Ho8U0qsgQvJnTxaLiS+4ZG88N5T
         Sa+cXRc1T7SnpocEMpxR1gh6V1dgv30G/Y4IXTrVX/bv4WQ8PSvXvsxUiepbbJ0MrboH
         pX+Q==
X-Gm-Message-State: AOAM532ejXXivLM/1cha/Y/dInYb67R/1CFHt8t5wM9ri5T1JgTpx5ja
        6XHrPWukmdI8kxolsHIXGkNmkw==
X-Google-Smtp-Source: ABdhPJwBAUBGoiK+MD47RfSd+e+hx5S5jrVCYFjYWmibacCC0gbOY9e6EUGUwdyOxVf/uKSMvljo5g==
X-Received: by 2002:a05:6e02:1989:b0:2c9:f711:abb3 with SMTP id g9-20020a056e02198900b002c9f711abb3mr265398ilf.36.1648666870628;
        Wed, 30 Mar 2022 12:01:10 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x3-20020a92d303000000b002c9e4d9e3e6sm1483986ila.28.2022.03.30.12.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 12:01:10 -0700 (PDT)
Message-ID: <2a5dab10-ce94-e0a5-1a83-70f318702e07@kernel.dk>
Date:   Wed, 30 Mar 2022 13:01:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
To:     Song Liu <song@kernel.org>, Roger Heflin <rogerheflin@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Wilson Jonathan <i400sjon@gmail.com>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
 <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
 <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
 <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
 <88ddb41a-75cb-df50-6679-6801e85dc196@nuclearwinter.com>
 <4a40d169-21c9-8292-7d0e-b68753265108@kernel.dk> <YkR0gvkIOONNYo/d@kroah.com>
 <46cb9609-ffb5-74aa-e4a1-598c86be9db9@kernel.dk>
 <CAAMCDefQQqwsLNmBjArTipLDnKzW2nQBW4MTHajrjKS4oi=JFg@mail.gmail.com>
 <CAPhsuW4XuW0Ejb5hL+vk7Vt=MTPgE3R2666bo1O2bJV7FoSZXw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAPhsuW4XuW0Ejb5hL+vk7Vt=MTPgE3R2666bo1O2bJV7FoSZXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/22 12:50 PM, Song Liu wrote:
> On Wed, Mar 30, 2022 at 8:58 AM Roger Heflin <rogerheflin@gmail.com> wrote:
>>
>> If someone sends a patch that will apply for 5.16 I can patch and compile, and run normal IO and a few raid checks tests.
>>
>> On Wed, Mar 30, 2022 at 10:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 3/30/22 9:17 AM, Greg Kroah-Hartman wrote:
>>>> On Wed, Mar 30, 2022 at 08:49:07AM -0600, Jens Axboe wrote:
>>>>> On 3/30/22 8:39 AM, Larkin Lowrey wrote:
>>>>>> Thank you for investigating and resolving this issue. Your effort is
>>>>>> very much appreciated.
>>>>>>
>>>>>> I am interested in when this patch will end up in a release. Is it
>>>>>> going to make it into a 5.17.x release or will it not come until 5.18?
>>>>>
>>>>> The two patches are merged for 5.18, and I just checked and they apply
>>>>> directly to 5.17 as well.
>>>>>
>>>>> Greg, care to queue up the two attached patches for 5.17-stable?
>>>>
>>>> Now queued up, but shouldn't they also work for 5.16?  They don't apply
>>>> there, but the Fixes: tag says it should.
>>>
>>> Yes, they should go to 5.16-stable as well. Song, do you have time to
>>> port and test on 5.16?
> 
> I ported the two patches on top of 5.16.18 (attached). They look good
> in my tests.

Thanks!

-- 
Jens Axboe

