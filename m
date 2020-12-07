Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891AEC433FE
	for <linux-raid@archiver.kernel.org>; Mon,  7 Dec 2020 20:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44CAE2332A
	for <linux-raid@archiver.kernel.org>; Mon,  7 Dec 2020 20:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgLGUVh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Dec 2020 15:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgLGUVh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Dec 2020 15:21:37 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25348C06179C
        for <linux-raid@vger.kernel.org>; Mon,  7 Dec 2020 12:20:57 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id v3so13461112ilo.5
        for <linux-raid@vger.kernel.org>; Mon, 07 Dec 2020 12:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tej9GY05mZXgV9mNE704/sNm7beFt5nAhjB/8/aBReQ=;
        b=qVz/hPJJWHdcZHxyVJ8JMM9+L35D4za6j+qkK2Wtztfzdb3ErEPtrM9mH/UQTJeDHI
         7BvEq6Zh/3hXeOPvRPvsc3cIG7l0ez3EpuqYLqGEtbIMmNcBOM8Iea36oLC/YnTgxN7x
         SP4lPrG7E4kLDqKtAvvdiA/SbyENzgRWvpYTJ/14QC8VSIvLtWi/oLwDVUlF83qQVPm0
         AH7IakvwgEJuxvUXzQ5vqmoOiZ0gCtwMEyJCAiCZDXPJLxOkQzcwrKFEE+DJvh8+Wjez
         fMjLxxrviZtTsvUpQ6cqL3XeWlzKBdsX0DWUzV3u0UFbx8MB1aWPN4OT5qqBWYQf1I0/
         M3kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tej9GY05mZXgV9mNE704/sNm7beFt5nAhjB/8/aBReQ=;
        b=n1bVVUF/xZ1q2Bp4HaxuSPchqslY+fF5PH2+gTrbOV+WMU+C+fD7Nm7YlJwPnsbNx6
         DNH90l3+9uwfIDftdUiXjaXvM76Ik3lL0CJWtr67uusJUjvOVx9cfZIcrxAu9+hYETuR
         +po5SfvnF2Ci1VL1kGuD9P8Jts0CuX83gNB52l0WcUcblmDuo5R5lPxm/nw76vNktk3Z
         E+SxirhnDawhOsLCFXauP88LJ3qIKxrjvXV73xVgt/dt3LGiT+ZsSoObYj9ZzUOkwCto
         ffHdPuth1eYD3rzYfE2XuK/NgvQBa0l5kdnYrP1YUD/4FwWPgHA+cuLk0v+IRxhxb29W
         3W0w==
X-Gm-Message-State: AOAM532XlL3emKZopfLJr95HK9dviTTVHuDpulTNmY57pyI3eh0R0ftN
        05+j7J8tNy1JNbkp4bYNmY2xcw==
X-Google-Smtp-Source: ABdhPJy0Jnsr7/OtLB3lcu38tiaUnDGbRUb9mNjvFf3jY7wBcRk6npkyOfNJF05HCytsclSzwVrwaQ==
X-Received: by 2002:a05:6e02:13cf:: with SMTP id v15mr22654778ilj.222.1607372456254;
        Mon, 07 Dec 2020 12:20:56 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s17sm7855074ilj.25.2020.12.07.12.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 12:20:55 -0800 (PST)
Subject: Re: store a pointer to the block_device in struct bio (again)
To:     Christoph Hellwig <hch@lst.de>, Qian Cai <qcai@redhat.com>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <920899710c9e8dcce16e561c6d832e4e9c03cd73.camel@redhat.com>
 <20201207190149.GA22524@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ed7a484d-91d5-50fa-7927-2703b9426d65@kernel.dk>
Date:   Mon, 7 Dec 2020 13:20:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207190149.GA22524@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/7/20 12:01 PM, Christoph Hellwig wrote:
> Thanks for the report.
> 
> Jens, can you revert the series for now?  I think waiting any longer
> with a report like this is not helpful.  I'll look into it with
> Qian in the meantime.

Agree, I reverted it.

-- 
Jens Axboe

