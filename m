Return-Path: <SRS0=sV2i=CU=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57C2C2BC11
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 21:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E9CC221E5
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 21:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="iQs9Uo+P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgIKVhs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Sep 2020 17:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgIKVhp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Sep 2020 17:37:45 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FF5C061757
        for <linux-raid@vger.kernel.org>; Fri, 11 Sep 2020 14:37:45 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j34so7485432pgi.7
        for <linux-raid@vger.kernel.org>; Fri, 11 Sep 2020 14:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r51LP7m4rUbCgwSAKD5/YKIVFU6XhFovTY9ZXd0poEc=;
        b=iQs9Uo+P1Ikbj8cd9+UMIByGSZfY8FQ0QJZuAvFAdnVHZ6S2VEdIoRsEIeZscDM65u
         cWa15KtHgLUK7U5stSucP7JiIXMjHWYPHfo1lR8hWVJ6/aQDJ53YEPQAPszjOOWTRjue
         vYQLm2F2LBglhQqI8jxfy1gGKHwsSFZ7y65MlIi8/JmKo8VTKRcAR9Kj2KpT/CNnGIGk
         OFrCKVVNRZsg/vFOn/0zcxK4VHq9TRs9RcC2NNXZtADTW2Qczo1PjFs2GK7jHsfPo3Ht
         rcDRXeblqKoihzU2qqNlKZvOML2ysrpjVU7kPz6TaPT9j0S3gaRJg4Ff7Hk9n/X+ed2D
         5kbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r51LP7m4rUbCgwSAKD5/YKIVFU6XhFovTY9ZXd0poEc=;
        b=SD1anGZLKGvde/3QEpuX81M/GjwqImV9YKtxLLe/9hUhdTZDtbehJLCLI9OlYSKVoZ
         dclZJrCsgtySMY6LXmEJoOxa7VlhHdbx4p4rsWpLqt/UmDcPnNR7kDTo5EF6daPYelOW
         RI7N14N7qUt3eGiG8q0XtzEc9CzxEr54ParzwB4XUUJFSBrG8lbNr6DoSUYZgGuEyURY
         NZHvQPqtsxsUabCSF1Ce8Q2U6rGr4bAlEWooX1KiDTSuqq294sb4dAGEwPyQG7fjTeZm
         8sb8LevWV4JwNL0WWya96RJ77Q6tRYuuzX4DNrksArsgO9Qc7LsRQHmtsx5h91/zoCBU
         8Qsg==
X-Gm-Message-State: AOAM531IGfZX0tIMhCfd5GJ996PDhx6jl8iteR9qvlK8r1w2y4fJjMzr
        RgS+mDMIN1JZ/4iCRJXxFSkrlYFXMJ+zPpem
X-Google-Smtp-Source: ABdhPJxriWuG9UsTdeDt1QvD0oSEycaGqMo0AChaG8ybqdM56zVilrT2CJ0yt8sas2+GjdFcpoUfHA==
X-Received: by 2002:a63:cd4f:: with SMTP id a15mr3175439pgj.416.1599860265219;
        Fri, 11 Sep 2020 14:37:45 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m188sm3275508pfd.56.2020.09.11.14.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 14:37:44 -0700 (PDT)
Subject: Re: [PATCH v3 0/3] block: improve iostat for md/bcache partitions
To:     Song Liu <songliubraving@fb.com>, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org
Cc:     colyli@suse.de, kernel-team@fb.com, song@kernel.org,
        hch@infradead.org
References: <20200831222725.3860186-1-songliubraving@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0665df03-41a8-fb06-71d2-a487c31ad610@kernel.dk>
Date:   Fri, 11 Sep 2020 15:37:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200831222725.3860186-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/31/20 4:27 PM, Song Liu wrote:
> Currently, devices like md, bcache uses disk_[start|end]_io_acct to report
> iostat. These functions couldn't get proper iostat for partitions on these
> devices.
> 
> This set resolves this issue by introducing part_[begin|end]_io_acct, and
> using them in md and bcache code.

Applied, thanks.

-- 
Jens Axboe

