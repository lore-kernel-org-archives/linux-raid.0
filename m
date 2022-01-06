Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06D8C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  6 Jan 2022 19:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243375AbiAFTgY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 Jan 2022 14:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243381AbiAFTgX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 Jan 2022 14:36:23 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EE1C061245
        for <linux-raid@vger.kernel.org>; Thu,  6 Jan 2022 11:36:22 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id s6so4483267ioj.0
        for <linux-raid@vger.kernel.org>; Thu, 06 Jan 2022 11:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yShO6TuxlypU2l2O2KJankvVDTn2HcEl2Hu54/Ynlmg=;
        b=E42Pe1/zly2YibFE2zV3g0GNygveAUDteU81IWYI2KO1D3wgQRJqHb2XWIktSZPYRc
         wEVVnHEn4eEIKCS5sDDoAL4dUffvNwQFx19HrmqOJnb3oySJBBWUc0fto3TjW6gQwLWo
         Iy4dPrrXAANNHq4JoAp7brHsZpL85zNrq2zoJ9Iqt91Cs0sHfwAMNje03q/sH5vofpJ4
         yqg4nlX4PEGLh1NYDQ3PGif6BQX7g/7st7w1GT8frFDRt4ITkNUdqHjYTGS7lxXzZtTl
         70YNzp0I6mBkxQVZkTizFfUIpBy4ywGpb3S7pVsZbxQnNS1qK6CqZX0I9tP3FA/aj7w4
         SuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yShO6TuxlypU2l2O2KJankvVDTn2HcEl2Hu54/Ynlmg=;
        b=OqOcCh5INx+VPuh9un387TyCOQcdh/4hgSky8o/ainf/6DNRyUuRpGqr+KeFptK2TH
         LB6idiRB9/eMTdU7DV1MQVacuyjQYThO4SG0uUCYIedewb0SUSTIZjQBpF5usFp3SGOJ
         uIS6Xqbat3b7kE29hag9nR3bMreAUpOSJJeLh6c8L3ig3Q/xGOzeaU6K2uKDegXoFrBV
         Pj/LIGoOSE5nBV5os2ucHq1xiGRGKW8iXIt05r0rh6f/v2YmENwUmzGeKzlM1tWQTxk/
         I3fIg6ilPtceuYxpeuq62q4IVyHqz9EtL6JXOglVTAe3FbI+0cXCscButjFCHcmeISp5
         dMew==
X-Gm-Message-State: AOAM530OmEKmX0vZM41z5F7TGRZPykQi5hiNcY+iiEHjoYNeNCkYynza
        E0sjkvlA3XOj16vP//J2wDXPUA==
X-Google-Smtp-Source: ABdhPJyuhYbX/fK9gz/pxrqiN+Kdt73ViAQnL9G+Xp/dWPbPmiQHZq/1c5qT8PCNkVAKzcEmNto6dw==
X-Received: by 2002:a05:6602:2107:: with SMTP id x7mr28235868iox.58.1641497782156;
        Thu, 06 Jan 2022 11:36:22 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g11sm1546994ile.78.2022.01.06.11.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 11:36:21 -0800 (PST)
Subject: Re: [GIT PULL] md-next 20220106
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Davidlohr Bueso <dbueso@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xiao Ni <xni@redhat.com>,
        =?UTF-8?Q?Dirk_M=c3=bcller?= <dmueller@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vishal Verma <vverma@digitalocean.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <89E598F2-4885-4ADB-A234-2DA81A71F01C@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d2ec2b1f-fb60-d886-67d6-39cc3b33fcf6@kernel.dk>
Date:   Thu, 6 Jan 2022 12:36:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <89E598F2-4885-4ADB-A234-2DA81A71F01C@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/6/22 11:15 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your 
> for-5.17/drivers branch. The major changes are:
> 
>  - REQ_NOWAIT support, by Vishal Verma; 
>  - raid6 benchmark optimization, by Dirk Müller;
>  - Fix for acct bioset, by Xiao Ni; 
>  - Clean up max_queued_requests, by Mariusz Tkaczyk;
>  - PREEMPT_RT optimization, by Davidlohr Bueso;
>  - Use default_groups in kobj_type, by Greg Kroah-Hartman.

Pulled, thanks.

-- 
Jens Axboe

