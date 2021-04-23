Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F59C433B4
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 16:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0582B6115C
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 16:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhDWQ6V (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Apr 2021 12:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhDWQ6U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Apr 2021 12:58:20 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70FFC061574
        for <linux-raid@vger.kernel.org>; Fri, 23 Apr 2021 09:57:42 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id x20so16039499oix.10
        for <linux-raid@vger.kernel.org>; Fri, 23 Apr 2021 09:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8xSYxVTFZohjteH6RKT5eYOLIGoQTTioQaElK4q/Vcc=;
        b=alyrn+d7wI9Gd5O9tAdN2YV/Xj3caHrJGzb+dqTYOVi5WZS2S5sYEA733EpXe0OJR6
         hcJpVMARPqCFvwHNGSPgcaAMhXDZYehXy+uZGjmUPc3InZ2OJyVeAZn7Xk1Obrnd8LMx
         zAitGPjCyf6jT6EFRncJPX4drrPwB8muF9fiGA7v5GqZXqu90y1qq/TEx9nQA9olItF0
         fnLut6DB6xsRqsQ0fr8/0BAJfI/vZINzGlcd5fEpPxWiDRorIAiVdVnylaxZ71VbXrR/
         PEKE/ZFKhjRvx3JuMzsf17F1JNmv4hYF0rAi1mdk5ttH64BT0gqzCtD+MXUpE2oEQdEo
         QAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8xSYxVTFZohjteH6RKT5eYOLIGoQTTioQaElK4q/Vcc=;
        b=LP5yzzqHrdKhxnCWlKYodxI7/b+yGG5uJloCSyOgkYWN9a6YmMy/y16q8OGqzu8Bj9
         6hL8fIBt9X4Jkwc3sS4rJLrRZODvhMndTSEkJd0a7I6ahMMMmeq7f2YZStXWfOj6X2tq
         ueE9fC7ypyjRVaa8q8JHXWWCele+S9wJiTe9EUapP9BTwVKStyJzlfhWilXPI/5Ezi2S
         qKj2R6V/W/QMrn/3IV2NOEAn7wTt2P5HxSc8G8Fg9pfLxrCB7/TII1+UrncO1pQfSMNg
         /mnzHaoY9K869IxzeLlQCD9mzAcMq2dO56qoBoe4QUQb4kbnbe96Uhw79emJuo5XZZ9g
         dljA==
X-Gm-Message-State: AOAM532C+067T+5RRehZyGFtqFE1Dob2E7JqWZb9B3VVP+Abv/zylLsH
        V2A9snhD/sUzc/csX924Jo4xiA==
X-Google-Smtp-Source: ABdhPJye6mReK1W2g75bverrJNT0CrOrrin35J/camLD6zXLHtgY0j0vHlqdaRc52CtLN/atH70kFQ==
X-Received: by 2002:aca:be83:: with SMTP id o125mr4740853oif.75.1619197062252;
        Fri, 23 Apr 2021 09:57:42 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id c65sm1367744oia.47.2021.04.23.09.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 09:57:41 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20210423
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Zhao Heming <heming.zhao@suse.com>,
        Paul Clements <paul.clements@us.sios.com>
References: <008BB114-41A4-4534-A06C-24F2C3701009@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eb59b9df-6069-9084-5f63-7c017f79e01e@kernel.dk>
Date:   Fri, 23 Apr 2021 10:57:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <008BB114-41A4-4534-A06C-24F2C3701009@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/23/21 10:53 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your 
> for-5.13/drivers branch. Both changes are bug fixes. 

Pulled, thanks.

-- 
Jens Axboe

