Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8394C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 18:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbhLNSJe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Dec 2021 13:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236936AbhLNSJd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Dec 2021 13:09:33 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CD4C061574
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 10:09:33 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id n8so14184793plf.4
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 10:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=3nsty8KvJFh1bWj+P+IzEqKdMBLMMutJFZTCPD86Nqc=;
        b=BFN1grMhLEVbieswSdLKfTkiwdnjqO9LnEZLBAUzLvmgRtIYSL+WOoYcuz6ptA4VLa
         X2cxLaYWdKPmW5JSz7PCUyHsa/3wZmAMcC6gOpM8alkvVrkxNQ2w4UPmGXgKBQk2zV31
         1lCNyH2ZJTScrC3ZZCw1zZjj30VgYu/8DtjNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3nsty8KvJFh1bWj+P+IzEqKdMBLMMutJFZTCPD86Nqc=;
        b=GcLrXX4wOTIgtGIR/o36eK7vkc87z9jnjAP8nJG6XrnUfs68GiUT+Muh6KGROSzmLp
         pAuNQGDMOA9fyc9TpizkSfCT9LK6veyfCvmr0eAVw9qL5s6LXQY7lwlVxm+/BPISF+Lp
         5z68ikZ0pgEvD9idSXvSQ/fMRn1oN7q90lW4dEw6JCqBhqRgfKpPcuusiXoFiYJsroSt
         jxlwm8HeZuOqlEZxd+4YZGnFZOTmR0kgTZXLn5kOfm0ey2mbUMeVoapWhL0wmYIdrfDG
         8VHSuMDbfQ05caqTcODlNI5DQZppslbPBj2CnWfsNNHx9YBkamhKD79IBev0ZA9H39k0
         RpnA==
X-Gm-Message-State: AOAM5338wHPUztm/xwv2rtibeGvVOUfuMO2Pxo5Mk6iE/vzT2fa28kbK
        2lWyzurzUsWvwYFfheTMcK0e7p9pZfCGOA==
X-Google-Smtp-Source: ABdhPJyQU6DupC6Lel+VfAFQWCG6p8iiWKJw0FOkWWcwaKsdWOxz875xI0LRxiwE+2gIOWuWCiOXDg==
X-Received: by 2002:a17:902:d2d0:b0:148:a2e8:2764 with SMTP id n16-20020a170902d2d000b00148a2e82764mr551528plc.107.1639505372432;
        Tue, 14 Dec 2021 10:09:32 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id u14sm463301pfi.219.2021.12.14.10.09.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 10:09:32 -0800 (PST)
Message-ID: <6762feab-a621-0c27-eb92-8a777038d9a9@digitalocean.com>
Date:   Tue, 14 Dec 2021 11:09:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
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
 <07adb65e-d018-e8d4-61e6-3ca3273cc1bd@digitalocean.com>
 <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/14/21 10:08 AM, Song Liu wrote:
> On Tue, Dec 14, 2021 at 7:30 AM Vishal Verma <vverma@digitalocean.com> wrote:
>>
>> On 12/13/21 6:12 PM, Vishal Verma wrote:
>>> On 12/13/21 6:11 PM, Song Liu wrote:
>>>> On Mon, Dec 13, 2021 at 4:53 PM Vishal Verma
>>>> <vverma@digitalocean.com> wrote:
>>>> [...]
>>>>> What kernel base are you using for your patches?
>>>>>
>>>>> These were based out of for-5.16-tag (037c50bfb)
>>>> Please rebase on top of md-next branch from here:
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
>>>>
>>>> Thanks,
>>>> Song
>>> Ack, will do!
>>>
>> After rebasing to md-next branch and re-running the tests 100% W, 100%
>> R, 70%R30%W with both io_uring and libaio I don't see any issue. Thank you!
> That's great! Please address all the feedback and submit v5.
>
> Thanks,
> Song
Yup, will do later today or tomorrow. I need to test raid10 with similar 
cases and not 100% sure about discard case.
