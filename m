Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D60C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 23:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B1C260E52
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 23:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347328AbhIGXGn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Sep 2021 19:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241821AbhIGXGm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Sep 2021 19:06:42 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64981C061757
        for <linux-raid@vger.kernel.org>; Tue,  7 Sep 2021 16:05:35 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id g9so645967ioq.11
        for <linux-raid@vger.kernel.org>; Tue, 07 Sep 2021 16:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/WqGdTadLCtXXo2y/kR/SCyjXiwUCBFZHM8m7zSgBq4=;
        b=ZeZ+12BAIiillN1quw9HtNbnsbBpRYvadFQPd1qT/RKk6Ma3+8A4wVxtWMq82N9pP7
         fXmnGkz66jgOVcfmO4ULXPBWITfunTYijvJICK2vJDyREWjmlstRlOnVn028yQ9jJq68
         Sm59cWiEJtlLxqCmhukG1MnsbZtdGmIQmsJ45Gh1/ZNEOUCq+5+vYYfDnFsWZVGzVb0I
         4DxH+xRZt6GfAf9U58X4yduUao2q59Zva9fHsI9uIalnkYj41C0xTzZArV7C79tN54UT
         6mBliiodfePrMtFa0XNpJk/cl2RBD0HuKVhDqWOALwuK62mP9GQrmL38ob6jxf3NdgLH
         UmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/WqGdTadLCtXXo2y/kR/SCyjXiwUCBFZHM8m7zSgBq4=;
        b=tUg2DKJGFUSBu7NHWbDlJRXer+j7nw5CySL1xO3E2Oh6BWWNFT1dkb5Y35p23O4d4U
         XBd8oOGQno+Dc9q0mVk0EeIcsIHLoW6JgBur7LGDqNkk9sJh4mBFZrQF4s97S8g78TSp
         MPPZpqYQmRROODngZnxmouMrQY5plDyX1UOHNlSbDwn9IZPPsq/OnyIh3ozPfJoYiWvT
         hCBNTurCwAjezf+9A8E2heshFir1GqJZmBjc8/9nUQUcLNRQp7qNTi1NC2IchhJKzFGE
         HvYXtA0XgqskveRZJIK/N8scd3NlRYzyZkLa46x82TI66tX31nrdQTDyjdtLatpI1rkQ
         LSWQ==
X-Gm-Message-State: AOAM532uXxBPQExe/fiJ2ExT/pkKF8i9VH1zsZ8Jk0sl9CV1keGhFHJY
        QsRyiM0kbW0WyHwILQZQK9Qcgg==
X-Google-Smtp-Source: ABdhPJxBWhJg3BewEfgj77vyghzozcl09E8uSOxe9n6t0/3BjeM+dZopb0kYT4NeYjPcZYK9K4GF3g==
X-Received: by 2002:a05:6602:1581:: with SMTP id e1mr516323iow.49.1631055934716;
        Tue, 07 Sep 2021 16:05:34 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j5sm238994ilu.11.2021.09.07.16.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 16:05:34 -0700 (PDT)
Subject: Re: [PATCH] blk-mq: allow 4x BLK_MAX_REQUEST_COUNT at blk_plug for
 multiple_queues
To:     Song Liu <songliubraving@fb.com>, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
Cc:     marcin.wanat@gmail.com
References: <20210907230338.227903-1-songliubraving@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f64a938a-372c-aac1-4c5c-4b9456af5a69@kernel.dk>
Date:   Tue, 7 Sep 2021 17:05:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210907230338.227903-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/21 5:03 PM, Song Liu wrote:
> Limiting number of request to BLK_MAX_REQUEST_COUNT at blk_plug hurts
> performance for large md arrays. [1] shows resync speed of md array drops
> for md array with more than 16 HDDs.
> 
> Fix this by allowing more request at plug queue. The multiple_queue flag
> is used to only apply higher limit to multiple queue cases.

Applied, thanks.

-- 
Jens Axboe

