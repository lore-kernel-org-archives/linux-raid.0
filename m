Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FADC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 23 May 2022 18:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241977AbiEWSi5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 May 2022 14:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242961AbiEWSiu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 May 2022 14:38:50 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BC234670
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 11:18:24 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q4so13812360plr.11
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 11:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KbNCTEB3bVHoGK/29gDr/2Aw9DkpggimAQw8175RAGo=;
        b=ta4ij6Lslx2MuHcwK8qnUBmcKGa6VJNRIRmZwMJIS1KSjLWYneqH9hUkceyllla1Fg
         GwnJZvijbWcsyMoN/wvUmud9cUewH8X//aTztck7IgqL3BI9tlp2O07lALsRheBeWKXa
         j6HVKBJxIq8A0QO7xcV/w/eBqP905kY8EBKnVZjFM740WwD2E1GeTLLOVCpRJgk/tA/i
         n19zmvuoT3wekWEbT9qCuc1O7o7s1VrefAiNPino6W6v7YzZcjCqJa6Do3A8lqxIFAW4
         pZ8xLbWQ214sDSFthjQxBgINc2c2lAepZlCHgT1yFhEDZM41CUMVnoS55skdwZj1298y
         lt6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KbNCTEB3bVHoGK/29gDr/2Aw9DkpggimAQw8175RAGo=;
        b=emHLguv+hOms27gZoE0mrXmig+gffDaFQrxp8IvrdJ2COpvaDgID7zoeybH4r7cZwm
         S/WxnEHULBSfTOvytcl4KsGBvs39w9uBsSyR5PNG06029lRbvFwJSsRhUdE0xKDL7v9s
         AI+t5PqtZZ7kNrxCuUgzMp24p9Z5HVRds9bM5qT2wdwijkRtaUvyRDHZP9sfd2GIF56K
         /jfwnvZDaX0meNm1YSKNR5cnLFLzi/stltA38KL/joW4JDwbvPiLMAMpZwuB7+xKHpmi
         6VR/tq98+k4ezy+2pRwBB+Jo+nVx7uL05iCmrPi97+3yTnlc5BHndthL+DDkflcI+0xT
         ZX3Q==
X-Gm-Message-State: AOAM533GqteG5oyh5QEMuCz6Rlos7oY5M6l0SPWiemsv+L1PYUrNiGph
        7NS0FuxuwKqyLuJnyAPSRVTdZg==
X-Google-Smtp-Source: ABdhPJxT8hUmFmBpwmJqWo/tJe/fqqRPFLL7cYkiO/RK8Ac9oq3ggZIeekznz268paScDiKUnnmOvw==
X-Received: by 2002:a17:90b:1a8b:b0:1e0:4bbb:33bd with SMTP id ng11-20020a17090b1a8b00b001e04bbb33bdmr284979pjb.144.1653329895280;
        Mon, 23 May 2022 11:18:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p29-20020a63951d000000b003c265b7d4f6sm5113218pgd.44.2022.05.23.11.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:18:14 -0700 (PDT)
Message-ID: <3b5599cc-2d04-c2f0-b456-3db77fb44e91@kernel.dk>
Date:   Mon, 23 May 2022 12:18:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [GIT PULL] md-next 20220523
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Guoqing Jiang <jgq516@gmail.com>, Xiao Ni <xni@redhat.com>
References: <1711B04D-64AF-4398-8852-57AF79260EE3@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1711B04D-64AF-4398-8852-57AF79260EE3@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/23/22 12:11 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your 
> for-5.19/drivers branch. The major changes are:
> 
>   - Remove uses of bdevname, by Christoph Hellwig;
>   - Bug fixes by Guoqing Jiang, and Xiao Ni. 

Grmbl, why are these sent in so late?? I spot checked a few and they are
~11 days old since you said you applied them. It seems like I have to
bring this up every merge window, but changes should be sent in AT LEAST
a week in advance so they can get some linux-next soak at least.

I'll pull them and then do _another_ pull request in this merge window,
but they will sit for a week or so before going any further.

-- 
Jens Axboe

