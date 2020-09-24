Return-Path: <SRS0=HtB1=DB=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7FCC4363D
	for <linux-raid@archiver.kernel.org>; Thu, 24 Sep 2020 19:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E970A2220C
	for <linux-raid@archiver.kernel.org>; Thu, 24 Sep 2020 19:48:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="FexggIT1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIXTsC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Sep 2020 15:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgIXTsB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Sep 2020 15:48:01 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8BFC0613CE
        for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2020 12:48:01 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b17so342161pji.1
        for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2020 12:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2OYG9mygTeIwd3eXCqdDkc2EJID9VW1FmMPEh3/Wf1k=;
        b=FexggIT1JeZknPy3pFy/61i8kvMFqbwVxaZ6RfvNqDhI881+H9OuafRAZNw9G2uVXM
         DVKwTt26oyHU5ic/QmDs96kNDXa66TixT/3IfrOurCscqWA/xMbfxp6NJBp8ATs+VCLL
         ucbs399nhzGOnzxOytvo97SZQ6Om4j4Gs+hkCj1b7Oi9SsFnTKw4Z8ka/rW1ATJmqGzE
         sTlteynM87H05Z9ZiDHyo0iTT1NJ9HgB/fZYZLTVrnS+A+R4jeMhpG2LzTX2ILB2moqo
         Z/Lh3fdiFZGw8TMfEtVek6GQePCVwhLfEZ+0JsmsRlTepJ3oFsLmpQG5cE7vgYEqVg/W
         qctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2OYG9mygTeIwd3eXCqdDkc2EJID9VW1FmMPEh3/Wf1k=;
        b=dgb6RpE0LgnTpSO2oe9WxN1GMP8Snwf5tG3+KWjbPyfWVVMGArl/3B17W+p8T+Euzx
         RbvLZeW4CxQ2VuRXKHtlN/Ex0RvGeS9ePiBYTU6r3SQeIlIfMbY9YhSAV1u61acYLP38
         BcwNss0BZy0yEJTLHIaz2lFSnCwnROC7RbNsw9I8mazL/xANKJRoT8O5XHk9vGz5Ty6m
         TIJOnvUL19fwLyKfDukmnRjEyGq5jRAv55UlvAm9s8TWVsUv2VGH8cm7C89BjxfQXgrX
         YRS7EHid5dHTM2wlIxCco175Jg4nPwSZFVDqZtpkgUUYd+4HSM/CPakIXSUmvT5T1KZ/
         vhww==
X-Gm-Message-State: AOAM532lCLqtDQAL0N9LZ48akGBv/2w48t/1wDjWeUJ8azCkplLlaKIL
        MDCizlFNY/iduRWglfW+D22fzw==
X-Google-Smtp-Source: ABdhPJxhFmFszaCsxMfmB5ZEkvdnPuJUFSosIpkxGW0L8EN0AXYSjGLvXRjEShv7eK+rFvz3VEgucg==
X-Received: by 2002:a17:90a:8c8a:: with SMTP id b10mr517941pjo.216.1600976881416;
        Thu, 24 Sep 2020 12:48:01 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21d6::1911? ([2620:10d:c090:400::5:d63d])
        by smtp.gmail.com with ESMTPSA id n9sm184766pgi.2.2020.09.24.12.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 12:48:00 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20200923
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>, Zhen Lei <thunder.leizhen@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Xianting Tian <tian.xianting@h3c.com>
References: <8960F87F-602B-40B0-863F-E3DE75ACCD45@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <40dbf27a-1c5e-6d32-1bb8-6f8f8d1ac46a@kernel.dk>
Date:   Thu, 24 Sep 2020 13:47:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8960F87F-602B-40B0-863F-E3DE75ACCD45@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/23/20 4:56 PM, Song Liu wrote:
> 
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your 
> for-5.10/block branch. 

Pulled, thanks.

-- 
Jens Axboe

