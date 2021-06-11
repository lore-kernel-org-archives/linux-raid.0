Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61178C48BE0
	for <linux-raid@archiver.kernel.org>; Fri, 11 Jun 2021 17:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4655961357
	for <linux-raid@archiver.kernel.org>; Fri, 11 Jun 2021 17:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFKR6f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Jun 2021 13:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhFKR6f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Jun 2021 13:58:35 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A43C061574
        for <linux-raid@vger.kernel.org>; Fri, 11 Jun 2021 10:56:37 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id z26so5059439pfj.5
        for <linux-raid@vger.kernel.org>; Fri, 11 Jun 2021 10:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O90bpOt247YRrOXgCy4oZuj+EtYC+LzD4V/qD12F52o=;
        b=JpaXwGGJIWRifXg91oRxcXsofVVJnAblXQKuUFnbEnsM5wsah1+GkZJHtOLTfx51cA
         T05dWLQ2xReMES8kp4O1hvNdhYtgo88KnWjh+NHsiPQ52BlnjksAzZ8O7NXqHShyDN8g
         0P3lgGDHn/nFL218JBRdriNju/doOxeH5O466YzQTpxxwXiPj4dlqyIpCCBuZv8ettaL
         Ah/EhJ7RyiJDTQt4kyrjAO7e66YZz6UJ/DIlQpOnSF2wBGmaKteebMd4rVGu2NeOzq0V
         v2Drr4dVXCXw/+KxC2nrIw+6W7ieqQDq12sNBTHqB6ybhlrQqZQr2CL2b6qi+Q7fpXQF
         NaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O90bpOt247YRrOXgCy4oZuj+EtYC+LzD4V/qD12F52o=;
        b=qCbTTCEwJZ3yfbRJ1OKIH9LkRrYwDDG22hQqK2NBs57ODEtsHoBQD/KUrT9y0V/hdi
         YJizlqoKi21bEPy2xYmp3KiAV1v9eLEZMuppS3dQVYt3al+aaWoD4L38/5Xgx/mSY4uw
         J/1vIScPBQ+eZzOgS2DPgXBOfF4i3rr35DjFj+ydldKEhy3GOaokBVTh+RiRYmS1DwMi
         fKsRAyb+Zj+azkWfMGbFPDxItrLGnQsN4bkzBY0FEfTiPR0idV5ZMwOK1hGB4EHmgPzY
         aqF+pKUwEM+egotH31ekirDfOh+JQZNbZSPkWegcScbMPQTovDjU1/XGvCx/i5w61Fki
         P/3Q==
X-Gm-Message-State: AOAM530H3f7T/Ldmp/MWKoH4vG5G/i4jTX/ynhGlL3zncFlnMLFFLhZ8
        CwKUqCPyhetvLsOwR66d8f0x8w==
X-Google-Smtp-Source: ABdhPJwQwDp/tIjIzKcOc2t3XRp1Rl2eQ/urAc1Zd00GX35xtPNNTPT5/HKCvZU0OX+RPbEV/7X+Zg==
X-Received: by 2002:a63:40c:: with SMTP id 12mr4868513pge.174.1623434196476;
        Fri, 11 Jun 2021 10:56:36 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l5sm5478160pff.20.2021.06.11.10.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 10:56:36 -0700 (PDT)
Subject: Re: [GIT PULL] md-fixes 20210610
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
References: <7105FB78-55FF-41EC-A84E-6113512598B8@fb.com>
 <05d5f3cc-3dd8-6054-d939-7e32d9de53ad@kernel.dk>
 <1EDCDE82-77DE-48C3-96ED-139591C5687E@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8ae5685f-822e-4fe0-eed8-0f5cf6954d19@kernel.dk>
Date:   Fri, 11 Jun 2021 11:56:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1EDCDE82-77DE-48C3-96ED-139591C5687E@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/10/21 8:53 PM, Song Liu wrote:
> 
> 
>> On Jun 10, 2021, at 3:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/10/21 3:29 PM, Song Liu wrote:
>>> Hi Jens, 
>>>
>>> Please consider pulling the following fix on top of your block-5.13 branch. 
>>> This fixes a NULL ptr deref with raid5-ppl. 
>>>
>>> Thanks,
>>> Song
>>>
>>>
>>> The following changes since commit 41fe8d088e96472f63164e213de44ec77be69478:
>>>
>>>  bcache: avoid oversized read request in cache missing code path (2021-06-08 15:06:03 -0600)
>>>
>>> are available in the Git repository at:
>>>
>>>   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
>>>
>>> for you to fetch changes up to 36fa858d50d9490332119cd19ca880ac06584c78:
>>>
>>>  It needs to check offset array is NULL or not in async_xor_offs (2021-06-08 22:49:24 -0700)
>>>
>>> ----------------------------------------------------------------
>>> Xiao Ni (1):
>>>      It needs to check offset array is NULL or not in async_xor_offs
>>
>> This commit message really needs to get rewritten, that's not a valid
>> subject for the commit.
>>
>> Can you fix it up and resend?
> 
> I am sorry for this problem. Please consider pulling the updated version
> below:
> 
> The following changes since commit 41fe8d088e96472f63164e213de44ec77be69478:
> 
>   bcache: avoid oversized read request in cache missing code path (2021-06-08 15:06:03 -0600)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
> 
> for you to fetch changes up to 9be148e408df7d361ec5afd6299b7736ff3928b0:
> 
>   async_xor: check src_offs is not NULL before updating it (2021-06-10 19:40:14 -0700)
> 
> ----------------------------------------------------------------
> Xiao Ni (1):
>       async_xor: check src_offs is not NULL before updating it
> 
>  crypto/async_tx/async_xor.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Pulled, thanks.

-- 
Jens Axboe

