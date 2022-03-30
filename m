Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB65C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 30 Mar 2022 15:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345231AbiC3Pld (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Mar 2022 11:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240274AbiC3Pla (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Mar 2022 11:41:30 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D32EE43
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 08:39:45 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id p22so25202457iod.2
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 08:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s7xiTOM9p+1JnHJVgwLS6+HB054dCnV2sG6lBDtO5KE=;
        b=U1CLVtgkmv6QP6yy6RedNBC0dCNziI9Zw7v5E+7GJzLYBhmA4+ha2OT4hkE+Xhgln4
         bF/4pd37LiKz6Iw5gJ3K/BI3sZDgtz6QfowAm96ULfS4Cqgt2WxCk7z29NPyjMNejMiU
         yfn/hIRct+ZuDQNsXyQ1e68LRZmS0qADuw9KTlItOaJ4GY7G+47d0j6t2BzgWG9II/yX
         hwp1OHq/bxjEgvePWL5VlYNKbMFStsTLJuYM7mALALuxvJ/zc2TkOpRblaCw1wNM1Cdq
         M9PdF20XlYGg+FqPmiIoqwxJGtPwcEXV+/PI039d6epi/jBLLfp6WweowjfHrh6whriv
         aIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s7xiTOM9p+1JnHJVgwLS6+HB054dCnV2sG6lBDtO5KE=;
        b=jvMNbsLThdYLnvQk1YTq/8h+uhgLgRcE45LxHh7xJQNASGn25b4YlrsGiCLinhoO3c
         D2qTDUt5qxDa2jhiojx1fpl30c5TLE1JMYWPjSACGu2DXcqphLdM4fGastJIjFD0fkZ+
         n1J059PzjS+usI/9+uI7CQ5aOP+5ezT3OoXbbPq1G2SzcARQO0udBu47BWuK19WV0gBR
         bV506ns9BJsGXcGPxCbbE8IsN5VGbvhE7IHWG2AJWcfz12Z0qRcbHVirgcQKvQGUfgtV
         DM2eXF0Yu5q095aAfqR8eOvW0oDMuquMqOwzZ+ALMXn0YbaVxkNi6jf/X1e8wvSFmcvU
         Z5qw==
X-Gm-Message-State: AOAM531s0OP1bf4wXAqmtiuipOGDj6mWvPnhEgG/UfAN6H+alLX9/k1h
        nNtR4O/t+QCRiGiL/H/XJHoL1g==
X-Google-Smtp-Source: ABdhPJwrqVGUc9z1e5XKd/pz/vJUe6VkuiErlEFnZxk2KgauxhvvZFOysUPfspvSnZHRSoJmKrwMPg==
X-Received: by 2002:a05:6638:2601:b0:31a:632e:3d69 with SMTP id m1-20020a056638260100b0031a632e3d69mr115496jat.229.1648654784826;
        Wed, 30 Mar 2022 08:39:44 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r4-20020a924404000000b002c9dc82ab11sm1931104ila.79.2022.03.30.08.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 08:39:44 -0700 (PDT)
Message-ID: <46cb9609-ffb5-74aa-e4a1-598c86be9db9@kernel.dk>
Date:   Wed, 30 Mar 2022 09:39:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
 <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
 <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
 <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
 <88ddb41a-75cb-df50-6679-6801e85dc196@nuclearwinter.com>
 <4a40d169-21c9-8292-7d0e-b68753265108@kernel.dk> <YkR0gvkIOONNYo/d@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YkR0gvkIOONNYo/d@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/22 9:17 AM, Greg Kroah-Hartman wrote:
> On Wed, Mar 30, 2022 at 08:49:07AM -0600, Jens Axboe wrote:
>> On 3/30/22 8:39 AM, Larkin Lowrey wrote:
>>> Thank you for investigating and resolving this issue. Your effort is
>>> very much appreciated.
>>>
>>> I am interested in when this patch will end up in a release. Is it
>>> going to make it into a 5.17.x release or will it not come until 5.18?
>>
>> The two patches are merged for 5.18, and I just checked and they apply
>> directly to 5.17 as well.
>>
>> Greg, care to queue up the two attached patches for 5.17-stable?
> 
> Now queued up, but shouldn't they also work for 5.16?  They don't apply
> there, but the Fixes: tag says it should.

Yes, they should go to 5.16-stable as well. Song, do you have time to
port and test on 5.16?

-- 
Jens Axboe

