Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22438C64E8A
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 02:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD08020757
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 02:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Kje1TCyT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgK3CcF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgK3CcF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 29 Nov 2020 21:32:05 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FF6C0613CF
        for <linux-raid@vger.kernel.org>; Sun, 29 Nov 2020 18:31:18 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id m16so13673673edr.3
        for <linux-raid@vger.kernel.org>; Sun, 29 Nov 2020 18:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EMrBGIYRCauK+kgCvThhHlPwPG6uXDLHeYr60pnOrSo=;
        b=Kje1TCyTDXxzkS54EhleTCApleyH99KJlxBWtbleQEe4kI1YfixWcHKqclCH5xFXuL
         QlEsnuuJsDSCF4bbyV0pwi4O6UuPbueasbwDcW5oGKxSLatgh3hIrJQbLyzt/2H5VvHH
         yIXI1UhEUkzS/SY048zdn3kDXajwPWw53cLut3Kr36VOTFxIyPUFy+1HbMtT4tHDvZw2
         THiIQrf+HshsW8sMOhuMBi45rntDPPNwiUj/mPqKk9K1yoQyGyO7wW7kWN8H0pbZhPti
         dGO8/FU1oRjDPbyrHmjWHU+TohYxE4ynynwlsSSKdAriXIf03W04ZhUr9IAuJq3caUd/
         urAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EMrBGIYRCauK+kgCvThhHlPwPG6uXDLHeYr60pnOrSo=;
        b=BrPDFitPlfxk5J0OoCMt7nMDe4uDoYrZWrVOAsDk/II2lyKdMbiomgTMP3Skdjbe29
         0T99moEtWSwbVIJrWufFujGvYXcTWYZ0WOckPzwDApt2k+xDNYujdR9NHLgHqC4goITq
         rmlRYmYk9HiUtMtHEC8iFYlnLMbEPTt22skNOT6KJmWb1iUSDx3/Jx0fqpX0usuL4Mbl
         a5C3KXIa/aY+7+rNtO+Rzv6RpZ+SQbv7986G8UzYGsXetpDyoYINp6likEekac/+BckU
         PMCx0kj44VGTQL9s1wh9R+S3Las0YDS6LZWwLbHOywECXIcmPpN1Fp22tfYNI5Uj+nD+
         HDeg==
X-Gm-Message-State: AOAM530K42fxIwbsS7aj+1PO1YYNiuxtA9FGOvH9Q+9BdPDKP+4uy1f3
        fooVuFs0/FeRH7BeTKQ/YmddueL+M3M4qA==
X-Google-Smtp-Source: ABdhPJwM87aosHJO/9vPRF55NPMJp0HAPyQ2sZ68XrJqA/qaO9vj4xYYLpo/9UEUVdv5VL66WMGm7g==
X-Received: by 2002:a05:6402:54d:: with SMTP id i13mr20110784edx.3.1606703477597;
        Sun, 29 Nov 2020 18:31:17 -0800 (PST)
Received: from ?IPv6:240e:82:0:92f3:e12d:4673:cbec:1111? ([240e:82:0:92f3:e12d:4673:cbec:1111])
        by smtp.gmail.com with ESMTPSA id dk14sm7891781ejb.97.2020.11.29.18.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 18:31:17 -0800 (PST)
Subject: Re: [PATCH v4 2/2] md/cluster: fix deadlock when node is doing resync
 job
To:     Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        song@kernel.org, xni@redhat.com
Cc:     lidong.zhong@suse.com, neilb@suse.de, colyli@suse.de,
        stable@vger.kernel.org
References: <1605786094-5582-1-git-send-email-heming.zhao@suse.com>
 <1605786094-5582-3-git-send-email-heming.zhao@suse.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <b120e2b5-f322-6dd2-2b3e-8b7eb7f2bc3d@cloud.ionos.com>
Date:   Mon, 30 Nov 2020 03:31:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1605786094-5582-3-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/19/20 12:41, Zhao Heming wrote:
> mkfs.xfs /dev/md0

This would make people think clustered raid can co-work with local fs 
well ...

> mdadm --manage --add /dev/md0 /dev/sdi
> mdadm --wait /dev/md0
> mdadm --grow --raid-devices=3 /dev/md0
> 
> mdadm /dev/md0 --fail /dev/sdg
> mdadm /dev/md0 --remove /dev/sdg
> mdadm --grow --raid-devices=2 /dev/md0

The above is good fit for a new test case in mdadm.

Thanks,
Guoqing
