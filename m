Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C4FECAAD8
	for <linux-raid@archiver.kernel.org>; Tue, 20 Sep 2022 14:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbiITORb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Sep 2022 10:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiITORI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Sep 2022 10:17:08 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488D0183AF
        for <linux-raid@vger.kernel.org>; Tue, 20 Sep 2022 07:14:40 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e205so2367410iof.1
        for <linux-raid@vger.kernel.org>; Tue, 20 Sep 2022 07:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=/yot0ov3usmKB3Zy+wkJUKPk22BQTuylnVUMZmxsCR4=;
        b=lIXZTwlaHIbQQ9hNPvRV7HuGvm5RDJYX8qcUeX22OX83N0tkw9Xt13KdlC/anWINwm
         GSdQCjuqFlnjXmK6d3quFgRZ7vkpgfhPiFdng2KG0u9ylgvfBvqMepItjYQ2ivjERQGp
         8lbIhTvYiKoy9hpyPK3TjnPUEnO2JyjF2hhVOdKkuSRa0+4ZtVIZ0cplD7cmpKuDl69T
         uqT78PPAKOllkkBpBIUzKAmALjQnSnksHUYVyAn5ydOljMtwsZEGwWrugEhmfOR/ZRxs
         gaLDLph39qi7lQQj9HHR0xjlCHEUwJZ+rHe2pgOisLfuPgHb7r7OhEJ2DUDpVDTh2sgy
         kqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/yot0ov3usmKB3Zy+wkJUKPk22BQTuylnVUMZmxsCR4=;
        b=R7R2NJXQGPHUkARz9xuuYu1lUKi8Z8bZUSIqRm8IDKP+3BoAq1sDvh5ISdrsJQ8j0z
         uTOSpxDZIENNIDe7269M7Drf4S1Koi2mxAg8BMsOmyE/67Lmr/mP4QBgfiJ+AfHo4a+J
         GdV5ETQ+hCNNw0mUtHualK+vywWFvP/n+x9UTf8meAh/7OHI+el0zRJllJkFHx24HuHN
         VkPyZh88FYweDDfasvxlKS3xr7abySdxvDkIG7l/8L7igE82dP7fv76S25SEFY+E+vu5
         D5MyGHqG4ZFrGqRTS/cA7q+Qv00Anq9n3ld24VKNrpi4gFoX6KUDIn/5I21h/E1Lo7c7
         fg0A==
X-Gm-Message-State: ACrzQf2jm2vWg3E84bUScl6LFt7WzTLlAhz4VkljrBXwP7ta4AcWrmRd
        28fD09nnlaDVXvHBFvW6yWmJ8w==
X-Google-Smtp-Source: AMsMyM4Fm0kTiShfxuAAb97HY9gCdOOBLEjpM6ZrfDeefAteWrULruA4zXYQ/fIChp4JLiLJB3BlqQ==
X-Received: by 2002:a5d:9902:0:b0:6a2:f72d:4b21 with SMTP id x2-20020a5d9902000000b006a2f72d4b21mr5956574iol.113.1663683273188;
        Tue, 20 Sep 2022 07:14:33 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w16-20020a056e0213f000b002f5cd533b31sm125125ilj.0.2022.09.20.07.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 07:14:32 -0700 (PDT)
Message-ID: <9594af4b-eb16-0a51-9a4a-e21bbce3317d@kernel.dk>
Date:   Tue, 20 Sep 2022 08:14:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: regression caused by block: freeze the queue earlier in
 del_gendisk
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Dusty Mabe <dusty@dustymabe.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <017845ae-fbae-70f6-5f9e-29aff2742b8c@dustymabe.com>
 <YxBZ4BBjxvAkvI2A@T590> <20220907073324.GB23826@lst.de>
 <Yxr4SD4d0rZ9TZik@T590> <20220912071618.GA4971@lst.de>
 <Yx/jLTknQm9VeHi4@T590> <95cbd47d-46ed-850e-7d4f-851b35d03069@dustymabe.com>
 <f2c28043-59e6-0aee-b8bf-df38525ee899@leemhuis.info>
 <d39e9149-fcb6-1f7c-4c19-234e74f286f8@kernel.dk>
 <20220920141217.GA12560@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220920141217.GA12560@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/20/22 8:12 AM, Christoph Hellwig wrote:
> On Tue, Sep 20, 2022 at 08:05:06AM -0600, Jens Axboe wrote:
>> Christoph and I discussed this one last week, and he has a plan to try
>> a flag approach. Christoph, did you get a chance to bang that out? Would
>> be nice to get this one wrapped up.
> 
> I gave up on that as it will be far too much change so late in
> the cycle and sent you the revert yesterday.

Gotcha, haven't made it all the way through the emails of the morning yet.
I'll queue it up.

-- 
Jens Axboe


