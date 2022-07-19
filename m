Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D47C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 18:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbiGSSm6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiGSSm5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 14:42:57 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0A15D0C4
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:42:56 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id w1so1104289ilj.9
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5N+6LceYKxwiROSSb15RQOFWcA8NLEVdbaJvslmNBA4=;
        b=cU6nGj5TpH8vUbxsj4W09oX9LS0ZN7Ca70jut5CYv0CHBgVUQ7Eo0QHmeSwU3PlKYI
         vLOb4uPIzExw+sG6MKBzJ1MT9PlzSAOfWItU63oGSSP6X2RFA6g2tbCly6a2fr2kd6v1
         u2Xu3+8rYA6/RENMT4c3BxjWLN2jQ8v6XBS9/pmBxNnSMxYKOQD0V0lvMM3+HG3HH9FI
         zVouzqx7xsry4YGh02v2PYlO77tX/331qtpDus2lZkLLikuJSblYX3mPMkUIushPUzps
         o1N4dEwyhUFFQuYKtz8CAeUCj+Fe8dm7MlSMg0y11OUqR9wW3+50CNN4IXYXp5JQDSmy
         kSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5N+6LceYKxwiROSSb15RQOFWcA8NLEVdbaJvslmNBA4=;
        b=A80FYonB/5tj+Msvr14xqyZXsAZXlkjYbOdd9ETJ2MDtenS5Ykca4PCA06QEw9AJCm
         4lZHF+E0pirQGIrMm0N3bKXrAqRt58VfYzwNwHz4TWE512NzL5aaQXvE/bws/hRpi+Ij
         vXZtmw6tT6grmM03mClKdHRxtKKNKTBpy/hnGNvImX0p8L06lz8XROo3bVIIlGqzyMhM
         UFizjcwP4UpzSmW/91i6Bv+nnOVgpuvWoTU+mSutUzTVLqd8iiqOmBOTg3Jdl3qi65yC
         vIX8LXDg5K9swOOxXZDPakRWTVB5CWOwmhEN9hsKdn4XBvJGHi4HgkpJdKbINQffis10
         MiRA==
X-Gm-Message-State: AJIora93Q80ZbSAovaDW6tQzemDekzRNSso3BGZCtlVdP8eJjMDhtmHA
        mxy0FfJC/vzy9Kw/lJSTc3Tshg==
X-Google-Smtp-Source: AGRyM1uH3ebXW/oVIQmGIxpQH+MsMOKJ5yqTjch4oP5HUobvzcjQrFhfxoKEJOhtwM1mFeIQoXzK+A==
X-Received: by 2002:a05:6e02:2188:b0:2dc:7546:1ea9 with SMTP id j8-20020a056e02218800b002dc75461ea9mr17902263ila.136.1658256175821;
        Tue, 19 Jul 2022 11:42:55 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n10-20020a056e02140a00b002dc2faaa48dsm5925666ilo.86.2022.07.19.11.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 11:42:55 -0700 (PDT)
Message-ID: <dedf1dbd-f9d9-692e-6ea6-63095b146674@kernel.dk>
Date:   Tue, 19 Jul 2022 12:42:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-fixes 20220719
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>
References: <4B55D811-BD3F-4D15-8176-816B5828309C@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4B55D811-BD3F-4D15-8176-816B5828309C@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/19/22 12:36 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix on top of your block-5.19 branch. 

Pulled, thanks.

-- 
Jens Axboe

