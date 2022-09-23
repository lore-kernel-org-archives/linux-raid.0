Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36045C04A95
	for <linux-raid@archiver.kernel.org>; Fri, 23 Sep 2022 21:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiIWVAQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiIWVAO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Sep 2022 17:00:14 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C73BA98C5
        for <linux-raid@vger.kernel.org>; Fri, 23 Sep 2022 14:00:12 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id e205so924273iof.1
        for <linux-raid@vger.kernel.org>; Fri, 23 Sep 2022 14:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=n+GSOx7RX7Ww763AAFYmTwtTb8kBPDzlON6qDPatuwo=;
        b=YPQW5GWe+IWVwksPpcVa1akvdLOnKSET3BWdtaG3I2EWcCjYZ4ZvHkXhVwNLt0Df6A
         J8+FgPnKkwwJlbGgCOpL7uLflISaCOpWfH3nJi2n+iaOiwyBYD+nB16dPqJ6pDUk8Gz2
         yA3ao22YoGqb58XvnfWgfVnIzixg2+ss7hiSgoRh/t2WKSzIOxPs4EftAwuW93DpzHuS
         lBEAVR7nJ6jZfIKT+djmcFu7YdhSX9u2++ys+l1VmWo4HLIdZLVh7BvUnTEOoDbNmQCw
         CyzG1XA5Xu74gQeDAMuac7pv47n3umgjo3fmsKA7oMXzUrRYZwPw/gjoujNFy+isiPia
         1szw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=n+GSOx7RX7Ww763AAFYmTwtTb8kBPDzlON6qDPatuwo=;
        b=Xy4WMy2DZgyrCkCOE+xZBABfD6lHp+oEdgBQ++RkCiFswI3ETNptS3Iz7BX6YTRJ8Q
         5vNRtAU8rMO1jSbqlxPMc8fe/2VAgSVN9wiEWT7X58W4/liZS8jYmTJXb9XSdt1qAp7+
         k7RYc9+3M3oZjf6gyLgY9gQGUicvFSLrE/zoqoLOlNU8uRL0zpf41zti2587BbYGmi5z
         /WO0LyHjanljnIlUe1QWzdwgXXT3QYq4WLkNRzyfhDR9l2jGydaCgrcgzyHbEIDd0UHY
         99jxNOv0RSu9pLJdaZlFc0ucSRMMR5cKRDs4bqUzVe5dXzyGvJZf8dmEilr4GJsdnouT
         Q2EA==
X-Gm-Message-State: ACrzQf1VKrW0mIUjcZzCUkW7gISw9cRhMyHiF2WfgfzvuO1rH008Ut9O
        YZ1PVdF4T0wQxi7PzxCw2WhGNA==
X-Google-Smtp-Source: AMsMyM5toa0D5utyhhKNwqmnaltsm4ia6ai/Cgb/bPlZqZ9EZQcLfMAX8cFf5DMHlJsA72nt5FKqCg==
X-Received: by 2002:a5e:d502:0:b0:689:72da:ab3f with SMTP id e2-20020a5ed502000000b0068972daab3fmr4788296iom.109.1663966811521;
        Fri, 23 Sep 2022 14:00:11 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t131-20020a025489000000b0035a2efb05b1sm3655278jaa.114.2022.09.23.14.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 14:00:11 -0700 (PDT)
Message-ID: <a92d9756-56c9-f43e-68e4-fe5080c82cd9@kernel.dk>
Date:   Fri, 23 Sep 2022 15:00:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [GIT PULL v2] md-next 20220922
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        David Sloan <david.sloan@eideticom.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        XU pengfei <xupengfei@nfschina.com>,
        Zhou nan <zhounan@nfschina.com>
References: <68A2557F-ED5B-4644-AE9D-97F3F9881BA1@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68A2557F-ED5B-4644-AE9D-97F3F9881BA1@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/22/22 1:07 AM, Song Liu wrote:
> Hi Jens,
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.1/block branch (for-6.1/drivers branch doesn't exist yet). 

Not doing two branches going forward, probably, so it's all in block
for now.

>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

I used:

https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

-- 
Jens Axboe


