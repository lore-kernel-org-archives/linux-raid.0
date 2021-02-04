Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FA0C433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 14:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8612364DDD
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 14:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbhBDOkn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 09:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236728AbhBDOih (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 09:38:37 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4EAC0613ED
        for <linux-raid@vger.kernel.org>; Thu,  4 Feb 2021 06:37:56 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id s24so3414700iob.6
        for <linux-raid@vger.kernel.org>; Thu, 04 Feb 2021 06:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z5Er49h0nki+mpmF33NkLblvneRJ6VCZjhJ+NjZ3ilo=;
        b=aPwg/fSUxWlYIhU6XQpE5dxsKWPORbfIvmpp406hfnwVSzPZ+n+iTodP1qlCqdtiVb
         Rg4HQt2xYJaOhkifn4jNr3DiObxD/5K5pFZqTKA1Kxi+WicMtnYJJFRqMShcyJL4qQ2g
         P2Qou4gr3K9YQ2RCAWFUqNbaCY3YdYWkAP0nJZ9yXuozde74OC3+RdfNqLWQujWFO8kE
         sOh229QXblUCXBZXKFBApg4NQgnWoGIsOuvvr/WX6BD26YiboeRZlgoz01pbi2+W77fe
         Ql5wfqVoEq36wqKWZCDLR+adqbbXDc/5D5P2qZ2zqt2LrpEJ4yKyNnSWQcdNYNCQxHx9
         ulcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z5Er49h0nki+mpmF33NkLblvneRJ6VCZjhJ+NjZ3ilo=;
        b=T9rUTv8Ef0JzY5/nGG7aj8gNLlRoaowZIC04wI7ql5LYcjqqOdUW0xgsXu7JkOjZwN
         S3pLJxjEe0pirJCLGRSjEp3Y900M5cqJ4pDq2zj/+BOf9PuZjRrh+2y+3R9aIDZmvhGW
         0wurEipm/Jg6MjaMmASBGQfvu1rs7xAngpJbIyoGGLLBB7b+sAiXcqadjaG9gtxXYlh+
         EfXsrWD3hBGUinHo2m7zSz4q30fR001PsrYcqmudHfxEeOdW5Yh29W/+52WZM1XHVyIA
         eatDM8/YJHu0YV+9MMXO6Qbb4/O4ALAeX4QCliyahoEqYFOCK3XXsSxonsYClwrRB0ni
         TXjQ==
X-Gm-Message-State: AOAM530juDpPr9WyRbjVxzbVqhR0qYHrooOvlrUbvRAbbi1a8ydRyfuo
        MOSaVjiLZMyvv2bwTG4kROmw8A==
X-Google-Smtp-Source: ABdhPJzQH1BNlkNjwkrgyzFcfjR9SY6y7uYPMPUTkb89Sy7GL+RhJQOzL+IzFVRptoWXiiBpFqf3eg==
X-Received: by 2002:a6b:7e49:: with SMTP id k9mr7059390ioq.181.1612449476207;
        Thu, 04 Feb 2021 06:37:56 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 11sm2595863ilq.88.2021.02.04.06.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 06:37:55 -0800 (PST)
Subject: Re: [GIT PULL] md-next 20210203
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
References: <E3580228-B816-42CC-9E36-B72FF6347452@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <19df70dc-fca2-e4eb-924a-6bbb9fd24c72@kernel.dk>
Date:   Thu, 4 Feb 2021 07:37:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <E3580228-B816-42CC-9E36-B72FF6347452@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/3/21 11:55 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following change for md-next on top of your 
> for-5.12/drivers branch. 

Pulled, thanks.

-- 
Jens Axboe

