Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB64DEB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 18:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjFWSAR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 14:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjFWSAP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 14:00:15 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8073D2133
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 11:00:13 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-66c2d4e507aso139080b3a.1
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 11:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687543213; x=1690135213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JAgMgxXigoPT50uZbQt8XuUfVxpF0U/ZKTsPyU0nxcY=;
        b=fznyG4t+TrbC3spN8VRHw+NwnC4506sjb9aMw7NCLYVwc10XCDz9hRVmNNvFC//SVO
         lSObT0dn2EcKfknGAxWT9YXKqrf7LuenOkBfOnqCnE3vZqMkSJA++ejLNlngRUGvdc/4
         Ma96iLvKGpBw9cp1YFo30PVc6AHxqKpPDqr3I453ZDwMzMHZT3NBBeAwMwMhmyQTMOXe
         VP4Q41hcbg1XmUqMYdWI6eQ0MCHh8gd0Zptv/heh36PfpsgFfKDfUjVlnAqXE+mGY6oh
         02OcWAbtzguVcCMrPZotoCQBphoVFLzzAV835UVefvzITzCrdF87JCAJMMM4EnlLIk6g
         r22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687543213; x=1690135213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JAgMgxXigoPT50uZbQt8XuUfVxpF0U/ZKTsPyU0nxcY=;
        b=N2smiZc5S9F4LGPO26isvrzRP1ucPfEe6BWpZ9762TcZitgCk/QxIFmBAAgClyiuWV
         nS59UVSDBGSnm3fMcx2Y3t0toCa9kqfruG1ONmSgmsnV6gADxiyc/b571KP8eZpFsKOH
         JAhkl3unUD4Sgg6ezAR/UuoINZhqANj9DbEp8/KKEnDSEzuBWsoXRhk5hRO06T+BJSTt
         X4gqQNCy3hwCpLNpnFUj1v9WxnRFwXUGBMKk0fB50bA9IOV2GPwzncfqDGHTpPvqLJ1a
         iMoGiHD7/4asPfBg1btCf3m5xTH3Rbt62409k4p2nBXCyz87Izvkz4fd7MgUuYUW8cVr
         FZQA==
X-Gm-Message-State: AC+VfDws/+F9dtxOPNXYd5sgCF2pPZ7W9lwcZBmdaSIw9AuYO5rJQCdc
        IM/+YJ3fGLV1svRHLA6OPF/s4g==
X-Google-Smtp-Source: ACHHUZ57g3dU/9OxdbUN4GmSMxPT5QnzucJapfYF1xj4FbQA1M5tMgTcTU8j36c6hMFuizK46EyFgw==
X-Received: by 2002:a05:6a20:549e:b0:111:77cf:96dd with SMTP id i30-20020a056a20549e00b0011177cf96ddmr28018476pzk.5.1687543212971;
        Fri, 23 Jun 2023 11:00:12 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fe15-20020a056a002f0f00b006687f6727e1sm6273162pfb.206.2023.06.23.11.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 11:00:12 -0700 (PDT)
Message-ID: <343874ee-9b2c-c333-e270-59c0c6a0244f@kernel.dk>
Date:   Fri, 23 Jun 2023 12:00:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [GIT PULL] md-next 20230622
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        linux-raid <linux-raid@vger.kernel.org>,
        Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>
References: <BCD9738E-472D-4AA7-B4F9-CCF36B5DA0E1@fb.com>
 <83240030-681c-9ff5-6e2c-600e83b0cc71@kernel.dk>
 <392A5BF5-2961-4F2C-A1C6-D6532B5AAFC2@fb.com>
 <480ac9e9-9257-b1a9-520e-50feb54dfdf5@kernel.dk>
 <bb837894-de92-62f8-05ce-f06b86876ea0@kernel.dk>
 <B68B4659-E6BA-464A-8433-BFF952F6527F@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <B68B4659-E6BA-464A-8433-BFF952F6527F@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/23/23 11:03?AM, Song Liu wrote:
> 
> 
>> On Jun 23, 2023, at 8:41 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/23/23 9:16?AM, Jens Axboe wrote:
>>>> I will prepare another PR with just fixes. 
>>>>
>>>> Christoph, 
>>>>
>>>> Please let me know if you need set #1 (deprecate file bitmap) to 
>>>> unblock other work. Otherwise, we will delay it until 6.6. 
>>>
>>> I've done a for-6.5/block-late and put your stuff there, but it can be
>>> dropped very easily. It doesn't really matter if Christoph's stuff can
>>> get pushed, it's still a lot of commits late. So regardless of that, the
>>> only real difference with a new PR would be that we'd drop some bits.
>>> It'd still go into a late branch, as it is indeed late.
>>
>> On second thought, yes let's go your suggested route. Make a branch with
>> JUST the fixes, and send them my way. Anything else will have to wait
>> for 6.6 at this point. I'll drop my late branch for now.
> 
> Sounds good! Here is the updated pull request with only minor fixes. 
> Three of the fixes are for patches in the for-6.5/block branch:
> 
>  - md: use mddev->external to select holder in export_rdev()
>  - md/raid1-10: fix casting from randomized structure in raid1_submit_write()
>  - md: fix 'delete_mutex' deadlock

Thanks, added to the for-6.5/block-late branch.

-- 
Jens Axboe

