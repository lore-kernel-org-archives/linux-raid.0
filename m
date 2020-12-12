Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC9AC4361B
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 16:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6AAB22AAF
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 16:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439567AbgLLQUZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Dec 2020 11:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439331AbgLLQUP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 12 Dec 2020 11:20:15 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF112C0613CF
        for <linux-raid@vger.kernel.org>; Sat, 12 Dec 2020 08:19:35 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id b5so4126333pjl.0
        for <linux-raid@vger.kernel.org>; Sat, 12 Dec 2020 08:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fNUq3Wc2zyF78i1TDeUWX/K7G8NedjGivLTs4+QSolE=;
        b=LTZNePXBTgDYI4q1Kttkm7xj4XaujiGk0aV9r/hbhrWSMs3e33/4D09/LhLmgUZ7bl
         JQhyrU5XJMwN/TxQI5hQqdFu4Fc6knNwu8yvlDzr1p5GBxxKAO1A0tcBjEg8QQBcveA7
         VguKbKQpEz7N5/HMEstuHfD72ue2bn0JGt02Te821uZh3emZJ04cmAHntRzDefnudKs2
         VQ4qWalEqdjPk+S95cpkpiww4cObnnYy+ZQ/XvwTLesmNScrfVkQBhJK9W9jlNGUb2CO
         4R+6KpT9UVxT4t/sbm3/4+6Zn+DPfRATXoacGgmyNSwW5M8ruOxm+MlxAwfBWrR3miJl
         x1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fNUq3Wc2zyF78i1TDeUWX/K7G8NedjGivLTs4+QSolE=;
        b=nbup6AMMTDXSqmtOKpRxnxwZ7zOq5rQOmjx5HXB1ngo/9fkJV5akY6Vd6VpTr1qvaV
         OvPdCOOUOgw6X0eFLhfqHnU6YhK04uKCeOPgwo/kKfg8GjpoMAhTynPp0lALfwXlweTU
         pcY+zm3fYMtspQFV1Qjy6Ae1jVEOlhe260mEGli6cCP9p56st8w2EWNODSZbJNJZfp+A
         F4dCYvSimu6tITWLgHaSSCFYu62UkKEcqV7lMUihopZCM1R390DNuTo/xHp7BWj6THYr
         FZWowcr5UR4Gj+TQbjoMbIBQT88h1jWiSceAYa2qn6mk6B+PnDCreKyU5PMXVwCTJhNA
         0igw==
X-Gm-Message-State: AOAM531EQvQ8Rqi2eWiJzxgRHDnoOYQ9XC+JxUAHXT3M6Ff8QRvvrkaN
        AwOLcM+rQKNK2VSutd/I6XKXsA==
X-Google-Smtp-Source: ABdhPJysddQ9smuBu62L9UTvcsZIdUYzHjtesiAECFxawtc2gj+hUqTQwGm7Bvo1X8/iYSvnI2ctTQ==
X-Received: by 2002:a17:90a:414d:: with SMTP id m13mr18174699pjg.229.1607789975168;
        Sat, 12 Dec 2020 08:19:35 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g30sm6701523pfr.152.2020.12.12.08.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 08:19:34 -0800 (PST)
Subject: Re: [GIT PULL v3] md-fixes 20201212
To:     Mike Snitzer <snitzer@redhat.com>, Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Xiao Ni <xni@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
References: <D6749568-4ED2-49A7-B0D3-F0969B934BF6@fb.com>
 <20201212144229.GB21863@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2799b859-c451-c3f6-7753-fe08e35f4a7c@kernel.dk>
Date:   Sat, 12 Dec 2020 09:19:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201212144229.GB21863@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/12/20 7:42 AM, Mike Snitzer wrote:
> On Sat, Dec 12 2020 at  4:12am -0500,
> Song Liu <songliubraving@fb.com> wrote:
> 
>> Hi Jens, 
>>
>> Please consider pulling the following changes on top of tag
>> block-5.10-2020-12-05. This is to fix raid10 data corruption [1] in 5.10-rc7. 
>>
>> Tests run on this change: 
>>
>> 1. md raid10: tested discard on raid10 device works properly (zero mismatch_cnt).
>> 2. dm raid10: tested discard_granularity and discard_max_bytes was set properly. 
>>
>> Thanks,
>> Song
>>
>>
>> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/
>>
>>
>> The following changes since commit 7e7986f9d3ba69a7375a41080a1f8c8012cb0923:
>>
>>   block: use gcd() to fix chunk_sectors limit stacking (2020-12-01 11:02:55 -0700)
>>
>> are available in the Git repository at:
>>
>>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
>>
>> for you to fetch changes up to 0d5c7b890229f8a9bb4b588b34ffe70c62691143:
>>
>>   Revert "md: add md_submit_discard_bio() for submitting discard bio" (2020-12-12 00:51:41 -0800)
>>
>> ----------------------------------------------------------------
>> Song Liu (7):
>>       Revert "dm raid: remove unnecessary discard limits for raid10"
>>       Revert "dm raid: fix discard limits for raid1 and raid10"
>>       Revert "md/raid10: improve discard request for far layout"
>>       Revert "md/raid10: improve raid10 discard request"
>>       Revert "md/raid10: pull codes that wait for blocked dev into one function"
>>       Revert "md/raid10: extend r10bio devs to raid disks"
>>       Revert "md: add md_submit_discard_bio() for submitting discard bio"
>>
>>  drivers/md/dm-raid.c |   9 +++++
>>  drivers/md/md.c      |  20 ----------
>>  drivers/md/md.h      |   2 -
>>  drivers/md/raid0.c   |  14 ++++++-
>>  drivers/md/raid10.c  | 423 +++++++++++++++++++++++++++++------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>  drivers/md/raid10.h  |   1 -
>>  6 files changed, 78 insertions(+), 391 deletions(-)
>>
> 
> Jens already pulled 95% of these changes no? why are you sending a pull
> that ignores that fact?
> 
> And as I stated here:
> https://www.redhat.com/archives/dm-devel/2020-December/msg00253.html
> 
> I don't agree with reverting commit e0910c8e4f87bb9 ("dm raid: fix
> discard limits for raid1 and raid10").  Espeiclaly not like you've done,
> given it was marked for stable any follow-on fix/revert needs to be as
> well.
> 
> Simply changing 'struct mddev' chunk_sectors members from int to
> 'unsigned int' is the better way forward I think.

I agree, that'd be simpler. Mike, care to send a real patch for that
against block-5.10?

-- 
Jens Axboe

