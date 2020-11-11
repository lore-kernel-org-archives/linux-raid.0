Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E728AC5517A
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 16:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 886EE20659
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 16:13:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="0mdj8CtO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgKKQNJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 11:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgKKQNI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Nov 2020 11:13:08 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08265C0613D6
        for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2020 08:13:07 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id x20so2442757ilj.8
        for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2020 08:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7yS21c4EDamv1N5jFFAli/djfW/+Q3U+ZJfbXcDD9kI=;
        b=0mdj8CtO/R56ulgEDkoqOJkeoWn//omJtQsjKRxVAfyHMuD/i84TcxrzvRmjPiwu8d
         5QHIjv1vEPSxJ7oTOr3oXq08szlvpuUQyhdRv82dm8eKD6yeTe6aZ6F47Ab+TgA8euaS
         uCAQOWouzIbjPJKUwWzjNHJhlRh+SAuaCVGBS6zxaeSmTlcD93GvFMRBY2JS+rvj9/71
         62v/XE93mWLRdieAXrh+wRWHWhL/1mkIIJYsWWeoVEyvPFkHo6lRccH7n6CWyIJQ4DnD
         LGdZYCEGD4DexxHWKSV8QfZBXsJhbXqpD26FOUoZ7CLbUXUFw/+F2whGdyrKEEu1f005
         +RFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7yS21c4EDamv1N5jFFAli/djfW/+Q3U+ZJfbXcDD9kI=;
        b=oItBM4zfgxgVZeuAg06BLm/5fj7FVhcUphBCG10rBnRwFx6NTMO5tcsCuETFxeq7T6
         0yse/u86L1Ksiyg2VUIdA2mzM7Ukc/UtlAPaeSFMIBc04836vXHr/hk0/gimyx0KuYaj
         dA6i3/pAxEe8cPmcpB5meGxExYX97mbKpLd+0t6Grstmxyo0ajg3rDYS25NFH6c3kXg1
         NW2Cn+16cy5z4Aa0PnQj/sytQZmWzNVQ7H3NYliEQc0Q2htJWiwqXBwmUXrV4sJ1EgjT
         IQoIRlv3jALiA/ILRCto0f7ts/j/Uv2g0UzuWVQbXuCYh36xfwHftbIlIJufOTjZ5+2G
         fyUg==
X-Gm-Message-State: AOAM530Zl6YURiYAmI9zkOWDH1Dc4AesrOe3w6t3xZ14iAkjibnacvuZ
        qbF12to6S+ol37Bq3CbM+JsO5umn0OB2ug==
X-Google-Smtp-Source: ABdhPJzwILifX5tSP9gqWXbZq1R8Jv1w+MiHneN+v+U9u5cRPw2dSbsLytSjWr9uVfmYJHN8DBeLZw==
X-Received: by 2002:a92:8541:: with SMTP id f62mr20043826ilh.9.1605111187075;
        Wed, 11 Nov 2020 08:13:07 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j85sm1478517ilg.82.2020.11.11.08.13.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 08:13:06 -0800 (PST)
Subject: Re: block ioctl cleanups v2
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
References: <20201103100018.683694-1-hch@lst.de>
 <20201111075802.GB23010@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <92a7c6e5-fe8b-e291-0dce-ecd727262a2e@kernel.dk>
Date:   Wed, 11 Nov 2020 09:13:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201111075802.GB23010@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/11/20 12:58 AM, Christoph Hellwig wrote:
> Jens, can you take a look and possibly pick this series up?

Looks good to me - but what is the final resolution on the BLKROSET
propagation?

-- 
Jens Axboe

