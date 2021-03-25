Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E36C433C1
	for <linux-raid@archiver.kernel.org>; Thu, 25 Mar 2021 19:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48BD661A31
	for <linux-raid@archiver.kernel.org>; Thu, 25 Mar 2021 19:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCYTUN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Mar 2021 15:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCYTTo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 Mar 2021 15:19:44 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B902C06174A
        for <linux-raid@vger.kernel.org>; Thu, 25 Mar 2021 12:19:44 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id f19so3027172ion.3
        for <linux-raid@vger.kernel.org>; Thu, 25 Mar 2021 12:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7FGVDBBCPBh1jtuK9BpZWv58y5ooNq8bPMjwN3tHoIM=;
        b=gKH41Y72QIc5q5bb0S3FA10Xvz+x6kEZo9oVXBCP4g6oKKbOB7MKNmjASbLfy+Mn8j
         QZvS4HmUbDmd4gBhrDYisdt6yMIet+P7rizFQXkherf2EmPdTT9VqUz12PZa7+8Bh2Gf
         2vEK6PLEZdKh3UmGuxiIJGqQ8MoFn+8etIJUq+aX/jqbmpvyu1OgPP4dZcHT9n/4vSKC
         9k6MeKM5dcSMBR+0i7HRPV5XWW1tNGUtjWYzrrv/yR1GNoxaHe5kTkDjeZzdU9/YFjgD
         soF/Cy0/yEglR2brmw5q1Aws5/LEzfCregFRVAWBWGK6KuY0kJIvuSi0pax2AVdWVtyX
         fG3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7FGVDBBCPBh1jtuK9BpZWv58y5ooNq8bPMjwN3tHoIM=;
        b=C5LhMVuM3lILIC8SJLf5EFjzzT3wIbwmTCGT7z7VJE5HzDCndR6VXqauCZFmnUob7v
         uMTK5eJphh+APbZib+zJJlu5oLolG77yIlkn/+7hi224kd2oZG9bOd86Rm7F01hzNZus
         sikyUL09o8XKgwZhb0doqTFODu0w5T9K9gnd43DT+uo1ZpbfU8l+N4JSkQLmYHAikW0j
         0f8Mv+7J4xTMiDjFi3HlP+67Ft1qe35oRVcMhhkvxwpw8qKMQu0LfOosKJdK9RP2H5VK
         BYlkevVvPVvMiPviF5XpYvy4EMukPHHJvBuMjoqvsGMFyOkR0zgCGqWhV7alAIylWV2+
         YOdw==
X-Gm-Message-State: AOAM532xb3PpthXu4H8v2zmJLEOYrRbYoliM2xoKqHqatmukmKG+zCsW
        Haaq+4Artz0Mimj8Vgd097DjiQ==
X-Google-Smtp-Source: ABdhPJyRYdwwnUHPsMQKJc5GYiKGowJaY0sGzz8f67Bz9VInwUMoMqHiQtNFvV/Fi73O5p1et8peZw==
X-Received: by 2002:a05:6638:58f:: with SMTP id a15mr8688537jar.35.1616699983827;
        Thu, 25 Mar 2021 12:19:43 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 13sm3212443ioz.40.2021.03.25.12.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 12:19:43 -0700 (PDT)
Subject: Re: [GITPULL] md-next 20210324
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>, Jan Glauber <jglauber@digitalocean.com>
References: <145EAE56-F35D-4475-BCB9-C67F5A95FE18@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d495b47a-db2f-547e-6fab-1b3d87722696@kernel.dk>
Date:   Thu, 25 Mar 2021 13:19:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <145EAE56-F35D-4475-BCB9-C67F5A95FE18@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/24/21 5:46 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your 
> for-5.13/drivers branch. 
> 
> The major changes are:
> 
>   1. Performance improvement for raid10 discard requests, from Xiao Ni. 
>   2. Fix missing information of /proc/mdstat, from Jan Glauber.

Pulled, thanks.

-- 
Jens Axboe

