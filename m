Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1635AC00144
	for <linux-raid@archiver.kernel.org>; Mon,  1 Aug 2022 17:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiHARW5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiHARWz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Aug 2022 13:22:55 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6516AB7F9
        for <linux-raid@vger.kernel.org>; Mon,  1 Aug 2022 10:22:53 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id l24so8871544ion.13
        for <linux-raid@vger.kernel.org>; Mon, 01 Aug 2022 10:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rtANSwu1GpI2ScUwowvl4P6CwMalWtSiuJe6mvxQs3E=;
        b=QT/JvuoXRpWs48xxXzBjKmttjqUgVme13yxHucYUp7DO82uwAqVRcO6pxTT2nqjDs9
         NmnRUf0MOfUy26JN7fss6VkeGua0ZiCOnKv/QF4MmoXuTmMitkRIRlP758iBRu7I1iB/
         oKvlRjgkJCJo2zpwEF0H7M1/PvhRA9g/qDsrDz4dbsECjQdRSlPb4NDKzntsFqZ/5COk
         qheo7L7C8P5DZQrqzf8yAKxUqgrrWR2hBEL9oTrwv07gw6U/sn1UGxtyr6z5hPQ39qmX
         tmbmOpC7roJ68y0GKSpAvCZp2JiaRb51i2hlRcDTcmAW0myl7JEf39TXxVOzmNF79Zgm
         dlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rtANSwu1GpI2ScUwowvl4P6CwMalWtSiuJe6mvxQs3E=;
        b=LR3jgZuyr9odmcriVRotqEzjitPybOuTUdgoqillIp+pX4HkHOmoidrlzOs/Pj3x5J
         b9ggbNDVBUucBd4Y1sNvQBUykbsZf55xPNX/iU1JmFn1ufbfFjvt87DD9s6TbfukTYdI
         sHSw7Yf/lk1OUrlSCIrRB6QHCAkgU5hXhY2GNRc6WeJGIWNkzHxqi12AIf9UOMrhNIi+
         J8B5ExyqTvy24c5M7Lmj4jlSuvAlV7rmwQJBho0NgSqpH1q9td32VqxkJFiOm19pOZ7B
         SiV2XesfHcSR/8tH7zEDqr9IWpANw1fRToKZDoMj2uAeecyVx11wztH0XHx8psI3Trc4
         dwFg==
X-Gm-Message-State: ACgBeo3MQbJYkuRDxSeJ/NQk3ehJ7AvSDPo7qZaJqmhK9Hv41CAn8/5t
        mclKl639EWKvciQrrjIDA8GBjQ==
X-Google-Smtp-Source: AA6agR7KwwP501rS1ZwN9XiC6xO6IfX7Kk4npT8f3ErxQYoFz5Oq8aj31gT5wSjgP2Wz9Nin6Ueuvw==
X-Received: by 2002:a05:6638:470c:b0:342:71b6:87e0 with SMTP id cs12-20020a056638470c00b0034271b687e0mr3012395jab.231.1659374572756;
        Mon, 01 Aug 2022 10:22:52 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z12-20020a056638214c00b003427f78c30fsm159629jaj.8.2022.08.01.10.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 10:22:52 -0700 (PDT)
Message-ID: <e8c5335a-fc77-6539-e5d6-46bccac4890a@kernel.dk>
Date:   Mon, 1 Aug 2022 11:22:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-next 20220801
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wentao_Liang <Wentao_Liang_g@163.com>
References: <3F8544E8-484A-4E67-9052-90C07F1C387D@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3F8544E8-484A-4E67-9052-90C07F1C387D@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/1/22 11:15 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-5.20/drivers-post branch. The major change is:
> 
> 1. Fix potential deadlock with raid5_quiesce and and raid5_get_active_stripe, 
>    by Logan Gunthorpe.

Pulled, thanks.

-- 
Jens Axboe

