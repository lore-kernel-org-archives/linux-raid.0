Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AE3C4361A
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 16:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 649EE22AED
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 16:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbgLDQmv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728382AbgLDQmv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Dec 2020 11:42:51 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEECAC0613D1
        for <linux-raid@vger.kernel.org>; Fri,  4 Dec 2020 08:42:10 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id g1so5748565ilk.7
        for <linux-raid@vger.kernel.org>; Fri, 04 Dec 2020 08:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fikGB5tiwbaXtQtRZDejlU5o/PV+EqzyE1dSj5rzFBI=;
        b=bHiFuCI22AZUnNQBHXT6REoQEzckuQnfklBROQQuCQtPbr+ryyHI3/pLtt8VoCk+ps
         ONudM1PD8q/KEEZEAjy61xxHR9GuhlgiAzjsU/lD9M+TL1zbBzJEx7YJqWgYtjdmS14I
         xtGYUaM8Rh2C5gkaCUW2tP+MGsW04Ot92aC5zICkV6oozDh5teeY5ZkC+x7K+D/BANVj
         3uzhgRSyfXDxJjYoMw2QZCISqhM9oCYzAhLiucg+EMULUrI4Cq9I5wKbhc5LQEfh7X/H
         0mUYOtWhEgNuc8rfdXggbUAfYFrdg5xl3F9NN3vTQEkrBY3OpI/Zy102mmDdV2eJXkmw
         Wl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fikGB5tiwbaXtQtRZDejlU5o/PV+EqzyE1dSj5rzFBI=;
        b=cEwkMRwqwDZgoaMRj/WSh7GkMsq4O6BkeY7cBKlCwmayKdNHpukKMYqTlbvylhhdVB
         Y1aHP0cNRMnmWMTNDge0QyC9DFB20U/ou4Ql6C18PcFIMiUNKvFUDJJX3ImLVoCFbsjc
         IqSlDXOGzx9f9V5GbU8Zu1DDX1P0Tt+JHAQn0HlJQlEdvQMFtrVgc3SP816Aq34rma5E
         CNT2kFfTxf8h+gI1JJdeh1w8zt001G0uL+HuqMyJad9RAsrLqcWSPGbhdS0Rjfutw6n3
         CBReupvr/e9NGstijPwf2m85EWWZicYwR61CcfVYES4pX3WEx3b1D2qhRheqWOQXC5yp
         ChyQ==
X-Gm-Message-State: AOAM530QuAODuay4WM68Nxmer/hIQ9Y/NvwwzxV1j7pEtWEq2SlU6Hsz
        WevGwlEc/YkxmPZFLuUVo6sZ/A==
X-Google-Smtp-Source: ABdhPJyW5yIk7VMQwzcjfu979UjnKKVuVKC1F7TQhIJYUX++QDtGzNaJxMSREo0fly/SWSE8ENM4PA==
X-Received: by 2002:a92:204:: with SMTP id 4mr5121778ilc.79.1607100129990;
        Fri, 04 Dec 2020 08:42:09 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u16sm1849585ilj.6.2020.12.04.08.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 08:42:09 -0800 (PST)
Subject: Re: block tracepoint cleanups v2
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tejun Heo <tj@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20201203162139.2110977-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8859c43f-a1fa-60dc-ea27-4a126f95dc68@kernel.dk>
Date:   Fri, 4 Dec 2020 09:42:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201203162139.2110977-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/3/20 9:21 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series cleans up the block layer tracepoints by removing unused
> tracepoints or tracepoint arguments and consolidating the implementation
> of various bio based tracepoints.

Applied, thanks.

-- 
Jens Axboe

