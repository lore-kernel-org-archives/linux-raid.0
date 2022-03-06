Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C66C433F5
	for <linux-raid@archiver.kernel.org>; Sun,  6 Mar 2022 18:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiCFSHI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Mar 2022 13:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiCFSHI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Mar 2022 13:07:08 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F927574B4
        for <linux-raid@vger.kernel.org>; Sun,  6 Mar 2022 10:06:15 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id e6so11754443pgn.2
        for <linux-raid@vger.kernel.org>; Sun, 06 Mar 2022 10:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3IDySe6/HojQ3jDxfjpKc6zpBwkz5pfcZNFnpj0OwBo=;
        b=ECZvhaTcTYSYuxNQf0dXjupv9p+mdfcNTTw6ViBX4xP0zeXJMhvpwIQK9qTWRQKsVD
         SQtDRh+omkTij3RdK9ud99NHyowBI2gvl+kctfY8m9J7D3ThNlQNDH+yPjn/dzgq2HXm
         2JTWmnVhMWChL+QJMuKarlAx+hNcxWxldBAieo0PZnSkx1O1pSIizg87Z3lyOVDTTuug
         KnXayEwHBgey7lOMeKpKoB9emHN2YgUdy7f3A033WZdOK6lEDPzdtuAFqwcQtULwuojV
         63zGCRF1wVcH1aP3PvwIGNKv5PX7kI8fxhX2v/p71xw3jOuV10Biivx8AejciDrjQqf4
         MiGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3IDySe6/HojQ3jDxfjpKc6zpBwkz5pfcZNFnpj0OwBo=;
        b=FtSC5ocLRNGAsLw76Sl5Oa1v7mQhBaf+/zcglIXyQX1gduvQtRzEjIngWPpGvxbRic
         2/xPaqRAjnSSpkDosM57E7NVyDOYrkixuspVjHXanIGapr0iZj5B7jDHr7QTmEoknCMR
         GFqhSxCVjdxIKgUP/hVUPLhvksyroY9SapbWvAUOPwXDPtvey/8DiSd5M0Tpr2XLmY3Q
         +U6IXoOg7afYaVMOg/z0IdU2bfskiOfxvVKDpYUUZa49Sv2Z5zJYmQMiM6lPGuQYEX5Z
         Ea6Q+veVT1e343Xm5tEy1YkHV5l3iqv3yFfiPaKwNVMVPmH1xNYATk6Bg39DQMNTu5nf
         x0Ag==
X-Gm-Message-State: AOAM530Jyijk4bbDRaEvgoQCu6hghZtQ7QgMINt7odQeAjDbG2T6bar4
        F2ICxnkjqrghcWeuSmwaXCvARA==
X-Google-Smtp-Source: ABdhPJzZKQnoFchQw6tzr1OIIZ1uDCy2Ywxdu5LxhrSM3BjvQrLV0Y79FSWzFuuduKBiryJFzTjlfw==
X-Received: by 2002:a63:d74f:0:b0:374:5bda:909d with SMTP id w15-20020a63d74f000000b003745bda909dmr6973383pgi.215.1646589974835;
        Sun, 06 Mar 2022 10:06:14 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a00115000b004f6ff260c9esm931995pfm.207.2022.03.06.10.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 10:06:14 -0800 (PST)
Message-ID: <f08db783-a665-2df6-5d8e-597aacd1e687@kernel.dk>
Date:   Sun, 6 Mar 2022 11:06:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 2/2] block: remove the per-bio/request write hint
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dave Chinner <david@fromorbit.com>, sagi@grimberg.me,
        kbusch@kernel.org, song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org
References: <20220304175556.407719-1-hch@lst.de>
 <20220304175556.407719-2-hch@lst.de>
 <20220304221255.GL3927073@dread.disaster.area>
 <20220305051929.GA24696@lst.de>
 <20220305214056.GO3927073@dread.disaster.area>
 <2241127c-c600-529a-ae41-30cbcc6b281d@kernel.dk>
 <20220306180115.GA8777@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220306180115.GA8777@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/6/22 11:01 AM, Christoph Hellwig wrote:
> On Sun, Mar 06, 2022 at 10:11:46AM -0700, Jens Axboe wrote:
>> Yes, I think we should kill it. If we retain the inode hint, the f2fs
>> doesn't need a any changes. And it should be safe to make the per-file
>> fcntl hints return EINVAL, which they would on older kernels anyway.
>> Untested, but something like the below.
> 
> I've sent this off to the testing farm this morning, but EINVAL might
> be even better:
> 
> http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/more-hint-removal

I do think EINVAL is better, as it just tells the app it's not available
like we would've done before. With just doing zeroes, that might break
applications that set-and-verify. Of course there's also the risk of
that since we retain inode hints (so they work), but fail file hints.
That's a lesser risk though, and we only know of the inode hints being
used.

-- 
Jens Axboe

