Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBEDC48BD1
	for <linux-raid@archiver.kernel.org>; Thu, 10 Jun 2021 22:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D6C760231
	for <linux-raid@archiver.kernel.org>; Thu, 10 Jun 2021 22:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhFJWfh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:35:37 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:39579 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhFJWfg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Jun 2021 18:35:36 -0400
Received: by mail-pl1-f181.google.com with SMTP id v11so1806103ply.6
        for <linux-raid@vger.kernel.org>; Thu, 10 Jun 2021 15:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OpE6XuS15o0Tkv/uW902Pp248VP9w6hEci8230uHR7o=;
        b=X5Ba811UXeRjZLaQdBg+ycjwPjzQeaZFTGzXZXun6LDAqpPPqbbfTDyx3CHMd6t+qN
         sLWGIPo232HZWnIrpAWtvA3HC15HivXxqK806sX6NcyYEgxiTAIRAsKEHc27xxBgfC8J
         EfST1TJ6R9CkgTtxbbHRX/QSRZEJf9ChlpDzuzBrBONBZHglO8US9IuizEGIHfcKea5j
         9eVJFSg279BoRO2OI3Itz1IHr0RtGE+wlHGx5BoNpbFvNyr47s4WhKSQ0nasgc/ClbcV
         sjHx4/GL5EGtPPxTfK2rm39qWVpAdijXFACj/cyWlUtLoNYgQQAb6vfUThLV5UVG5UMW
         Qhhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OpE6XuS15o0Tkv/uW902Pp248VP9w6hEci8230uHR7o=;
        b=TiWzs6L8xX2plPerIMZKOtCp7W1ZTprjASB+DcH4WkGf4yU3YfPtFnKTZF9rN/wcLY
         ow9r8UZUFmzioVjWCaBlknX+qdzgk+TU+iVTeZ67N9lPuSJWTTUbKSdq+Gf+OSJBYD8E
         rXyBSpmYL3Xhr8oklJSKdFxApRD3ZhqfpcU+9CShpkZirMV/taotg/FZ5+cKwnfRxMId
         NuE778vsSHuKwU7Zbt5CJx/e/qjfVP2hm2oSD+anWmB3Nwcd10pD2Bpry7fxBMo1YaLP
         UYaT4+y1yrKFurlxJbRF6/pAyTUTkj3H2JEI37F9BCp+VHtw35NeT4Z/++TBohblQ2z4
         HmDQ==
X-Gm-Message-State: AOAM5332lQZDN7IsNllJwoayYl9vvB3XuzfXwNM8POxO58NCKLdpqU02
        EWCUdXsZbGl68ZMeY4HEc8w7NZCwBu4D2A==
X-Google-Smtp-Source: ABdhPJzBVhl3tpoGDruOYD+x7NKsjHy7h0bYkUuiTzv4WEaQU7JAJTveNPw6gQB1Jos2Q0O9L+ja4A==
X-Received: by 2002:a17:902:bb8e:b029:f4:58d1:5170 with SMTP id m14-20020a170902bb8eb02900f458d15170mr929344pls.84.1623364343686;
        Thu, 10 Jun 2021 15:32:23 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id w2sm3301767pjq.5.2021.06.10.15.32.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 15:32:23 -0700 (PDT)
Subject: Re: [GIT PULL] md-fixes 20210610
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>
References: <7105FB78-55FF-41EC-A84E-6113512598B8@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <05d5f3cc-3dd8-6054-d939-7e32d9de53ad@kernel.dk>
Date:   Thu, 10 Jun 2021 16:32:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7105FB78-55FF-41EC-A84E-6113512598B8@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/10/21 3:29 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix on top of your block-5.13 branch. 
> This fixes a NULL ptr deref with raid5-ppl. 
> 
> Thanks,
> Song
> 
> 
> The following changes since commit 41fe8d088e96472f63164e213de44ec77be69478:
> 
>   bcache: avoid oversized read request in cache missing code path (2021-06-08 15:06:03 -0600)
> 
> are available in the Git repository at:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
> 
> for you to fetch changes up to 36fa858d50d9490332119cd19ca880ac06584c78:
> 
>   It needs to check offset array is NULL or not in async_xor_offs (2021-06-08 22:49:24 -0700)
> 
> ----------------------------------------------------------------
> Xiao Ni (1):
>       It needs to check offset array is NULL or not in async_xor_offs

This commit message really needs to get rewritten, that's not a valid
subject for the commit.

Can you fix it up and resend?

-- 
Jens Axboe

