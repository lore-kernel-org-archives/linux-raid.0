Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7FBC433DB
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jan 2021 18:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19F322583
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jan 2021 18:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbhAYSOt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jan 2021 13:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731283AbhAYRyU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jan 2021 12:54:20 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FE6C06178B
        for <linux-raid@vger.kernel.org>; Mon, 25 Jan 2021 09:53:40 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id i5so9443537pgo.1
        for <linux-raid@vger.kernel.org>; Mon, 25 Jan 2021 09:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s6C9gJtxVOS7uf+wB+GNYwlfWiptrVoeydv0VcfghHQ=;
        b=paXkl2zbKyHjc4GGkMjIRUdrHcPgKFNqCjQej+n1ZYOsCLguWtckSXACfUnZAkz0lD
         CcBdj+u28BfpSbhJ5e9gUHsu13jzfEj0RETbQhz6jh3dWIEy5FOWWVAQCdGvHjuysg2N
         aIAzmR84BWEHOE0buQQ5QVGCMrdjymYRkPk4CoCE3j4TRfCwe+jRqPh3FhmGXsv4T3Vb
         o0UHdnIyM1suQIVTObBDpeIbdx3kDgNAvM5Gy9MQWu0162mnI+4uuJiJZP51miHQ7K6r
         R5kL5Oyd+EDATnWW79f6/C0MXnBZe7p1rr2JggnemUDszgSyZxvBj5dEn1YG/icOR0dO
         5P2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s6C9gJtxVOS7uf+wB+GNYwlfWiptrVoeydv0VcfghHQ=;
        b=dND8E20We4YN4XvB6vjkeHbsHpb0y1dXylbLEhpXvLS73xENhKNbmomNmX8WCBBXwa
         +1crVFiTCV89WKbBOBnoB0MfD81zSXQFn11eipjZwlycEZOvE/o8GTE0E9YqzpCiWScf
         XH7sp6bMU4l/5lCToHuuyvOKxwfJcHQliCaqXZ0zFpGzIg/zbG46uURumh81EakEeUbz
         CXAG205EvHBRwiPWoiZ28E8y2n7SF1n5TzB0UoEuFjK6wsq5qm9J1o0zWDrmN3Ku107k
         CELGVmccV/Qcj6E7x6MriVX9CSAQlQ1vA7A1zHa02LZwfaJHtDD6V4y0iRdeJ5LzacQg
         WSYg==
X-Gm-Message-State: AOAM532QoMuOlqFvmq8wmaLnpUXGYLHt7WtYTh6TtRxZ8KkEHAzWThzk
        08+4ntOQg094yANPwLzRRyM5Ag==
X-Google-Smtp-Source: ABdhPJz+3LqFBlzn1c2vwQXmjnqICAm1FJDtAAzq4zb0CLdcKLr0vlHa6YNJJKFSu/hugPFO9HX2QA==
X-Received: by 2002:aa7:80c6:0:b029:1b6:92ae:a199 with SMTP id a6-20020aa780c60000b02901b692aea199mr1363354pfn.71.1611597219540;
        Mon, 25 Jan 2021 09:53:39 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n2sm17364646pfu.129.2021.01.25.09.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 09:53:38 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/10] block: do not reassig ->bi_bdev when partition
 remapping
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
References: <20210124100241.1167849-1-hch@lst.de>
 <20210124100241.1167849-6-hch@lst.de>
Message-ID: <dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
Date:   Mon, 25 Jan 2021 10:53:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210124100241.1167849-6-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Jan 24, 2021 at 3:05 AM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no good reason to reassign ->bi_bdev when remapping the
> partition-relative block number to the device wide one, as all the
> information required by the drivers comes from the gendisk anyway.
>
> Keeping the original ->bi_bdev alive will allow to greatly simplify
> the partition-away I/O accounting.

This one causes boot failures for me on my laptop...

-- 
Jens Axboe

