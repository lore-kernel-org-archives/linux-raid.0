Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D0DC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 03:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239226AbiGTDD7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 23:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237926AbiGTDD5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 23:03:57 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07782CC82
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 20:03:56 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s206so15222785pgs.3
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 20:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZE4PQQauPNTQ0e0AiqJ/q0VNU8qjmMdzHSDhYu5A3AM=;
        b=pE4Xe3/P4YO0mR1bt59A++kA6dceip3ptmI1zEwxEIhE8fnElgoRpflLKQGB2eoVd9
         c5JXaandVM8yquuo0s4fKE/ngcyt9J64y7NvXa6n/lbIuPoOaERmaGN2zmCZa8XF+Clv
         XLG16UDTTZ+AQkhTsC6yA/cE4BSxkLV3e4FHWJ+7TemVKSDNGZLVWMmGhYRLjEP5ZmHR
         1y86LdGFHJ2VruI5h33TphJ+3pB1GOfbrQx8Y+c6rar3n1ItLxKrH/IBBVHWGhVrVDM5
         b+hM8Mh4si9AzFbhnX1p9TKCaz3VlaYc4pFukjErhA/In+1gy7ykSO50kFrhE2a5A0w0
         1DGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZE4PQQauPNTQ0e0AiqJ/q0VNU8qjmMdzHSDhYu5A3AM=;
        b=ALoZyeC6tBL2x/AXgfh8VNbhpJJ5kIdn6ILiF4cPnCe3XunU1HOF4r5jslSzb26Wak
         7HvtRh9gzglLRuY9RT1pkVhBRrABGdOuPX7AKpR8CrUKqsJxGl2GOIUKwE0WbwVd8Fiv
         0vnylspEJRjs8G9AgaCKF2cGi4NgweeuSodQ2+o7njrbC4cmGui0wj8pf5QAxy9ugtHj
         uCgA06iMLX2YcpNCDQ2Ztc97VfTTIajDmkZ/zy4LJzbDlPyp4mSqrSbUB5yGf5ln9RBv
         KqveH6w+I+Q8E4jCZhk8FEK6jvqAwR6DLxzNnY7QsnURoU4rVMbKFhE4vQztS0TYSazj
         HZxQ==
X-Gm-Message-State: AJIora95ww45jFhMJUxoSQE/6ovB2sato+BRfY7hzSi+2/AiPR4nOZ9O
        1bcCk4R+uh8tfkS2dbGuqjVTDjUnmSUl9Q==
X-Google-Smtp-Source: AGRyM1v/CzzO6Irc2tsU9AaGCHpOrRE6kTXxuCaSYE21VVfxPqiRFCQnN6mySuJq0DAwMxv+JSbAYQ==
X-Received: by 2002:a63:688a:0:b0:412:6728:4bf3 with SMTP id d132-20020a63688a000000b0041267284bf3mr32296109pgc.339.1658286236187;
        Tue, 19 Jul 2022 20:03:56 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d12-20020a170903230c00b0016c6a6d8967sm12529415plh.83.2022.07.19.20.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 20:03:55 -0700 (PDT)
Message-ID: <c8cad78b-08cf-43e4-6610-6978fe0ce201@kernel.dk>
Date:   Tue, 19 Jul 2022 21:03:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-next 20220719
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Logan Gunthorpe <logang@deltatee.com>
References: <5553FDCD-7628-4A40-A228-8E1BEF6FFFA1@fb.com>
 <57876115-7e41-f11e-3cca-738235cd68db@kernel.dk>
 <7C4DD0FE-6C05-4BF4-9A20-8C6A012B6658@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7C4DD0FE-6C05-4BF4-9A20-8C6A012B6658@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/19/22 1:10 PM, Song Liu wrote:
> 
> 
>> On Jul 19, 2022, at 11:45 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 7/19/22 12:43 PM, Song Liu wrote:
>>> Hi Jens, 
>>>
>>> Please consider pulling the following changes on top of your for-5.20/drivers
>>> branch. The major changes are:
>>> 1. Fix md disk_name lifetime problems, by Christoph Hellwig;
>>> 2. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
>>> 3. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 
>>
>> This has worse conflicts, it looks like. And not particularly trivial.
>> Do you have a merge resolution?
> 
> Hmm... it was a clean merge on top of Linus' tree, but got conflicts
> with linux-next. I guess the conflict is from other changes in the
> block tree?

Most likely core block changes, I would suspect, from Christoph.

>> We might want to consider doing a special branch for this...
> 
> Yeah, I can port each patch on top of the special branch. To make sure
> they all work. 

I've done a for-5.20/drivers-late branch that you can base on, that
should be the sanest way to do this.

-- 
Jens Axboe

