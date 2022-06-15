Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CC5C43334
	for <linux-raid@archiver.kernel.org>; Wed, 15 Jun 2022 17:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbiFOR4r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Jun 2022 13:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbiFOR4r (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Jun 2022 13:56:47 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4084544C9
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 10:56:45 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k12-20020a17090a404c00b001eaabc1fe5dso2848970pjg.1
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 10:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6tu/PXCuzboKn8KtLN4dueuaqnuH/gB3XpGb85zxIo0=;
        b=3zZBDHJah12crDuoUrJBu5cDwOHUBer5czgCqsSnEh47t1S7Y55HAaQMTELgZ8o9dU
         0jzEayoZSwFkMcXmtC37sj9WZEUhBjWI3oCehHfuEh6qX8PJEeYoz8n+iPfnHPIb2+6S
         3gcMZrhsdLvpL3cqWZz9BHTeTqybi35kqdxyJh4D/bW1zBJ6pUblW/bWeEBCyf2mrYMo
         toHKHx8cbbtwR8HNlCZtTYvbnPpeL23sAd6J6G4YT4kxQR2Jr0ZraDlF2sugEeqluQvM
         dwKA8GDXzeixy5Il5FQJOD4RYzFcXDCe8Bcobe60khdsYUC9l5cd+LTRWzNJf2Dhh1Ln
         64WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6tu/PXCuzboKn8KtLN4dueuaqnuH/gB3XpGb85zxIo0=;
        b=OSFSGQsIc67RlsJIDDuiXaSKMcu8A5L0RvpIAf7Ay6E/tUWe584wE2LiZFBsQRDo5h
         c07dGh68mVy+fDESdnf9u0Thbkmcnab6ooOFKYtmJ4rWNeNus4gooAIqMP03rnmFvZxr
         Q10g7qh2BhWayt6sSUjfonxB4yRoTzOv3CMBiloS8X8W9yBsVYOWBI3h6YaYdNjD1Buk
         i16VmsqrjRV4iUGJ5XDAX5/Z6Ni53mD9hhtNJG+4VkAqbUrsNWRPs2Nqfnx4e+U2on01
         5zQkIPXKOhalRSMwOpJ55MLQqwH5337ACAXPfyoY1L9NZJmZsSvsenwvXr1Opo/5+UHy
         HZpg==
X-Gm-Message-State: AJIora8EqZi1NzL2OyyECm7dPkAqCSNBVS9uWzoDJYxBya7BDbL4kum/
        JfM5hJnwH5GuEYnK5+B8psOz0Y88HnUbHw==
X-Google-Smtp-Source: AGRyM1tl+JeCaKL6HcB2hS5YL8TCizV1gPadRWvvDora7vdsAaCAEfmKbNETFTqr9Ake9Kjf3tREUw==
X-Received: by 2002:a17:902:f54e:b0:166:3b30:457c with SMTP id h14-20020a170902f54e00b001663b30457cmr538518plf.1.1655315804052;
        Wed, 15 Jun 2022 10:56:44 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s2-20020a17090302c200b00168d9630b49sm7530814plk.307.2022.06.15.10.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 10:56:43 -0700 (PDT)
Message-ID: <4af9d025-cbc2-d137-4d82-7aeeb9a424e0@kernel.dk>
Date:   Wed, 15 Jun 2022 11:56:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-fixes 20220615
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Guoqing Jiang <jgq516@gmail.com>,
        Logan Gunthorpe <logang@deltatee.com>
References: <91D222B9-E849-4518-86FA-5D7D3A3DA773@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <91D222B9-E849-4518-86FA-5D7D3A3DA773@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/15/22 11:48 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fixes on top of your block-5.19 branch.

Pulled, thanks.

-- 
Jens Axboe

