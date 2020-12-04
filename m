Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B12C4167B
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 16:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70A8C2054F
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 16:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgLDQnn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728382AbgLDQnm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Dec 2020 11:43:42 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761AEC061A54
        for <linux-raid@vger.kernel.org>; Fri,  4 Dec 2020 08:43:02 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id k8so5764581ilr.4
        for <linux-raid@vger.kernel.org>; Fri, 04 Dec 2020 08:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eMCK196yGD9HEmztT5X4HDwb0AlO+qvFoU6onkVpAVY=;
        b=m3sqnXWJeTAd3qQUF1d9wJyXwHu7JxXcC6uKIzKnlo7TpnJ0vYQXk+eWhirNC1qNc6
         aWtFXzQOh0tidKwXqU80pwMzIT8ZRZt5PRaxJSJc8E29JFtApk6BEQdYW7hsB24li7Wz
         GaHvnlkDkAXaS5vCx5OsdA8Gdjg2fKCwfxWclRwxoS6t079ff5UktFuwRsCmmeiSXiuT
         xW/GuQxNIV2YBOU7ho2AFYAEGF1BA6L5NjXH97l1WWxaDgleOwbf8TG5h9LgnhjdG/OI
         JRD43kLpWzFWbCzhBfc/Q4Pv6ykA/JlxFPWiKSwSGdMJVYAl1gBtHvq4FoMJiyhXaw3Z
         plEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eMCK196yGD9HEmztT5X4HDwb0AlO+qvFoU6onkVpAVY=;
        b=LqphFTIR4vBYF2hoiv4VfOON8MiXfLlP0MGMuktx4D93h9zEuS6RCqV7orJ2ywOcpd
         EOasZjtLVxvIQQc16vgGtIW/CixojV985pE3baCWU5SMFc0DMwI1Sxwlov2b6S6g45Qr
         7X/7RwfR7VbqJIdm9bTjKwrzTtGOF0UvvDPfOPr1WOxtUk4dcbu2dc4HqNEBWulf0qVf
         oXm1MThLB2m6LuMtv327lIX6by7PhaycDTn3W2m+YVsJFvqy+q4HCzGgaFYeNHpk34P1
         w8Zy/466FaIltZHnTpLu7hNExIh5JDIdoWP+leC8K+kXAEedI8oH3+lQk0OzD4buQsmL
         xviw==
X-Gm-Message-State: AOAM532lY3lb0IMxvJyzGdZu4t1AaytR5DU0tuOKq3bOko4R5KnsPw4S
        MhYx1w21Wd500R9hIGKjOfG2pA==
X-Google-Smtp-Source: ABdhPJzAzVGKZD0+jfQBEzVp6xMbQWg671BzhxHKVihCK0qVzrk8H6Zb94kitBpSOVrN+CsFf10McA==
X-Received: by 2002:a92:58cb:: with SMTP id z72mr7331084ilf.104.1607100181830;
        Fri, 04 Dec 2020 08:43:01 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm1874781ilj.8.2020.12.04.08.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 08:43:01 -0800 (PST)
Subject: Re: store a pointer to the block_device in struct bio (again)
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
References: <20201201165424.2030647-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <285e5e82-2e9c-a1db-b9b6-b82ec95aea6d@kernel.dk>
Date:   Fri, 4 Dec 2020 09:43:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/1/20 9:54 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series switches back from storing the gendisk + partno to storing
> a block_device pointer in struct bio.  The reason is two fold:  for one
> the new struct block_device actually is always available, removing the
> need to avoid originally.  Second the merge struct block_device is much
> more useful than the old one, as storing it avoids the need for looking
> up what used to be hd_struct during partition remapping and I/O
> accounting.
> 
> Note that this series depends on the posted but not merged
> "block tracepoint cleanups" series.

Applied, thanks.

-- 
Jens Axboe

