Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2152FC4338F
	for <linux-raid@archiver.kernel.org>; Wed,  4 Aug 2021 21:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC68961050
	for <linux-raid@archiver.kernel.org>; Wed,  4 Aug 2021 21:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhHDVux (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Aug 2021 17:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbhHDVuw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 4 Aug 2021 17:50:52 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE866C0613D5
        for <linux-raid@vger.kernel.org>; Wed,  4 Aug 2021 14:50:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id l19so5072128pjz.0
        for <linux-raid@vger.kernel.org>; Wed, 04 Aug 2021 14:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FoWlswAfyllOzLMIz8rgRgfEDw2D+/g/dcC75bl4PHg=;
        b=jvfzZTvuFRd3ysTrjOijaSX+Rqz16ako47VXX6uwcwhXmhsP6OVcejCbVPjSp7Fnp0
         OpZmMdIpkq1uXetbxooeaIkWob9NvQupwxjv5zeawyHaSebtbdlRSv/dMXY8JQ9V3A+e
         0aG/5/4RzrDoGMyxgYkNDZu9+fCFEkE5MlIRUF0u7NjVfq7gYfSejKbFz6saDnl2V1eZ
         HVpNmqnHP9VXQ/WS07uKWuP7xs2iHu13ElKrcoWHhB34HKazj5B/9rapKR0lx2x2FeKW
         qeRLva0f2reJ8hW4whmBfVWkToYSnI8GvawdmsqOZ/9NYqRitzmIXYY4WBf1AFhVMT0b
         8PPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FoWlswAfyllOzLMIz8rgRgfEDw2D+/g/dcC75bl4PHg=;
        b=JPQMI+tE7xPbGM+RsWLjD2HbRjeaShwfdlKgSMAKM//Ap9drG7SUvdX+atbVEITC+6
         yJvCXHVY7WoQTOzUzP1s/05v8dIsRG4iIYiUZlc3NOxHeG/uwoDObHPyvqqG0ktt7w//
         ztcA3vUAb8n3DmgSI5pomjQbsKf1TsPrupvAfrgOfL8CiZJxtpbfHlyIpMm5oFuyNF0T
         APWVROmxaSQXWx6bjvbgl7X22zfNQdpnV2jXfhsfWjBFLNjTgbKm8tpEni6j0bSK0wxf
         1mq6ZuiP3SszbGiSIQC9a8jUScYkCcN/JRw2YP7PFxoJFbabUIg4yaM7BWlLoWMBvKI/
         7AEw==
X-Gm-Message-State: AOAM532FC9c0mo0qj3M/mHEySirZVMQMfC271iC+ztk5nLisJcAWQFsp
        r0KQxCMoTzj1QW4XUwVv+8tPm0nbmTUGqXdP
X-Google-Smtp-Source: ABdhPJyB4pi9per3VYDq0iy6MP7n6GcgEXZRq9JNyiyBoM8HtGCIuwQZf32z+tN3L8M+gW4AEOOhCA==
X-Received: by 2002:a62:9712:0:b029:3be:3408:65a9 with SMTP id n18-20020a6297120000b02903be340865a9mr1422576pfe.63.1628113839189;
        Wed, 04 Aug 2021 14:50:39 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id u33sm3906041pfg.3.2021.08.04.14.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 14:50:38 -0700 (PDT)
Subject: Re: [GIT PULL] md-fixes 20210804
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Wei Shuyu <wsy@dogben.com>
References: <2D64F5A2-3D1B-4D27-BEA7-81B03B30D212@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <145aaf29-535b-a0b5-3c6d-25b036df6dbb@kernel.dk>
Date:   Wed, 4 Aug 2021 15:50:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2D64F5A2-3D1B-4D27-BEA7-81B03B30D212@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/4/21 3:47 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix on top of your for-5.14/block> branch. 

Pulled, thanks.

-- 
Jens Axboe

