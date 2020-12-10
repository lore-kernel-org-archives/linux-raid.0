Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A1AC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 14:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C86723B85
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 14:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387871AbgLJOJw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Dec 2020 09:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgLJOJk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Dec 2020 09:09:40 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA6AC0613CF
        for <linux-raid@vger.kernel.org>; Thu, 10 Dec 2020 06:08:59 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id r9so5634541ioo.7
        for <linux-raid@vger.kernel.org>; Thu, 10 Dec 2020 06:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l666f9hxREhiyP65Bq+dygMssg+tElf27r2XG5nBtRY=;
        b=wkpejLagQAbihQq8Ex9HlR2P3RqG0Rv3zz6Efe3aIibMsmROypSXb7YkAhkP3bPxtu
         xKK5PS46B+Irnop0GYcc2XwPI3TnUgU666TsgwmtSDR71j03tXlyMocjFaufqFJflkUx
         cFyPyHtKDOjPymH1VHSkJDTBE2ohQlFOAqezTJiYPJAuzDfAxPKgUHD0G059TH3HyORf
         w1iRNYolQYx452xm/Q+Sfc25XZFzi9wghOkFZ3F0M9QvvYyHRn3Ru73+IzpJsmx+eAN5
         qRxSrGCjnDit8dH2waIAdFWTyUMSFoayFjMJ/ogkAupfLryPN3lYMrKAvWQrscJfmuJ0
         kjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l666f9hxREhiyP65Bq+dygMssg+tElf27r2XG5nBtRY=;
        b=LgAjMcyGqJNAyQBpjK2hMyQRy+xTB98/JeVVZmWf0y8tyV93j+QGaKfQTwUGgHhKMG
         +JSlUsyxFcRWs+CIqaEbM7WR0HNBnS/fPXKw41JoQxupE2vm+W3gCFQ+q11f/KNjnGsK
         fUaM8AbeSBzTRAozsFCD3Nsd9QQQiZnWsIGsAl8bLE3oYboyKev+tb9pBX0PBR6nT7jC
         yhZRWNWHoaTq9dCuS/QlKLZT2rDWJ8v8eEx3ajIm+Q6O1DKnPsvU7R392HZ9oGvtHW1a
         0BRdFbSeKEEPc1JzL20G0Uigq7G+yr+G9m3rt0FnEpOPp14UpBRul8MtM1ohs3WgXDIu
         ajYQ==
X-Gm-Message-State: AOAM532dgVuxZKmyVJQN+CzJsL+2BSMLjI8aWE99vGDipsXM4Bq+Lhjj
        BRbRuYizCYHuC0p0OmQiKwzZzg==
X-Google-Smtp-Source: ABdhPJzKQf1C7zwysJtBAHiayrg+i1SOYpA/WuU4j8EbTglbWR7FHo38+x1I2bgZiRwnLnofdlXQgA==
X-Received: by 2002:a5e:d510:: with SMTP id e16mr8456738iom.21.1607609339026;
        Thu, 10 Dec 2020 06:08:59 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s4sm2800314ioc.33.2020.12.10.06.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 06:08:58 -0800 (PST)
Subject: Re: [GIT PULL v2] md-fixes 20201209
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Mike Snitzer <snitzer@redhat.com>
References: <0C161FAC-8A21-4EAF-B3B4-A7BF04089213@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aa01f088-c4a5-2eed-3e74-2288554ea98a@kernel.dk>
Date:   Thu, 10 Dec 2020 07:08:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0C161FAC-8A21-4EAF-B3B4-A7BF04089213@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/9/20 9:59 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes on top of your block-5.10 
> branch. This is to fix raid10 data corruption [1] in 5.10-rc7. 

Pulled, thanks.

-- 
Jens Axboe

