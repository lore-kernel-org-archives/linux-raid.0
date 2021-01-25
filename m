Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3941DC433DB
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jan 2021 16:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F8C221E5
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jan 2021 16:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbhAYQY6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jan 2021 11:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730722AbhAYQYq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jan 2021 11:24:46 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45668C061786
        for <linux-raid@vger.kernel.org>; Mon, 25 Jan 2021 08:24:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id u4so9055435pjn.4
        for <linux-raid@vger.kernel.org>; Mon, 25 Jan 2021 08:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fXfkMAEQ+Munc2QVdjGnmLY18me6kBjN2JpuXybmej8=;
        b=melUhKvefiahTWBZSTKnTQngCuLKRwnWefzG8XCrqod+qu6V+whvzgVbndvXcGW1nO
         LxBQ+exeD5hag1d5iYB8naQfZY4cxiHbHgkUyoXcpFy3pIyk+EdGzNfiSZmUVzdZu7mR
         8vcZimLHfgSMwehelNQYJnbCqWJ5+aXM1UBAA3pvwyL5o10YuTGKRq1Mb+onVYA5X5eh
         J217+Wc3qyJEBUDkRVfOCj4J44rCBjHroAocrNVibYZ718Gm9WEmExM5pIhjGp2ZCbaE
         yJs/OVNHe6RTrlruJEOrM9kkYU2IHim66Ngv64asDPXaHnH2u0UOtKLzWbptyFjWn/vj
         Fo8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fXfkMAEQ+Munc2QVdjGnmLY18me6kBjN2JpuXybmej8=;
        b=j0vX/HAHeW6f+AVnsCXosf6NQp3cGcAwaeKb35tAjGPKHI7tzCKFUT1DfRlyuFhO+5
         N0Zv9/EXiXDbnfPcRSIfacSsGfnqvlWjDv28DGRQGi80hgLPnqOmaxvJF4WAz6a0bxDn
         qzO6Agw0ItAOURZHeCMa8inf/hUZoaNM8gu8jCgN5sMPQj4he5mHfF0Xne9BO1Jvegpo
         b6mQJ36R0PAZ8DfxaTBu7Fd2mjNhDVDuxnrpcSZRtVK+VtuRQAkbeN+cFFroX+lJ+Vm9
         7PCUI2QFCv6EwkMgJIoDnFjxFRz4E9NgTzSzEPWzs/LEnhfHFnbKqd1AKKjtOcTLCx4A
         EyFg==
X-Gm-Message-State: AOAM532HkU5ZlsPZ1PhcqtTj0b2LLZjbnseawBjNIuTBYN4uUAHv3mSk
        +Y5Rc1EbFJVgyMs2wHwEwFM3Ng==
X-Google-Smtp-Source: ABdhPJyZ7TqSW5vYzS6sR2enGCQzoNcpXGNgER6vx3ER9uTn7PeFaeI8bJWpz6MeQxBxo7yasuILmQ==
X-Received: by 2002:a17:90b:908:: with SMTP id bo8mr987716pjb.206.1611591845774;
        Mon, 25 Jan 2021 08:24:05 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id gd11sm19028097pjb.16.2021.01.25.08.24.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 08:24:05 -0800 (PST)
Subject: Re: store a pointer to the block_device in struct bio (again) v2
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
References: <20210124100241.1167849-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <86dd18e9-43e9-efe5-8445-88952a95b5d8@kernel.dk>
Date:   Mon, 25 Jan 2021 09:24:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/24/21 3:02 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series switches back from storing the gendisk + partno to storing
> a block_device pointer in struct bio.  The reason is two fold:  for one
> the new struct block_device actually is always available, removing the
> need to avoid originally.  Second the merge struct block_device is much
> more useful than the old one, as storing it avoids the need for looking
> up what used to be hd_struct during partition remapping and I/O
> accounting.

Applied for 5.12, thanks.

-- 
Jens Axboe

