Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EE6C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 01:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiCIBJv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Mar 2022 20:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiCIBHs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Mar 2022 20:07:48 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AD813DE11
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 16:48:01 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id j5so804819qvs.13
        for <linux-raid@vger.kernel.org>; Tue, 08 Mar 2022 16:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3cjPbjJH9uXLy+Kg7OLfwDqt9ffrwtxgMUY97L/gMTU=;
        b=T3DO42rjUyNpLlzahOzPNUFbyglXTOoWm6nN/H4naIxG+BY9g2l+FcovQR6eQ8unyS
         BfROAQI6hULhuqWpzB+T9OJvia7BGLAlS4ufSvAP9q0ABeegJUKr52HsK3md1zOdOxNM
         0RvsYc477soK5TE0SU6n43hlVabnsPhTKdV0FC4LJ6c/40lrd5CyYm8aUNQwuJwLXy7n
         BKWDK3iDRudFKYqd/XHXCEthOFuAn9CZobqVuBiRbgDSUWAkKQ+b/SAmxm2qlC7jbgZ7
         6cfr78oM60RQzvPLoVgVrzTrpm3B9Ye4NMks7v+Gl3wCn5nOO4zH0uRkt7qRuueO7ssC
         OowA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3cjPbjJH9uXLy+Kg7OLfwDqt9ffrwtxgMUY97L/gMTU=;
        b=uZcDS6rALOGhl+6k8JoJVkfBgaiNeDWd7erzgnPJkn4PgEhW4aojPaPRsDl/5RrNAt
         /7msesTr/LJbVIF1h7voR9XILNQglbYZi/uLTtzn5F+Oe8CM9uxg+CU1cEs+zJWX2XFl
         vmKVuGz26arxMaw72Wse9ket4/UUblLE6gfGefSzaZrVI7x2xr8BuqSQ63FJRnai4bJW
         CLJ0VUczh9fGo5D7601Ona/EwrkyCPZNTbJuFPu2MTe5toCrAScgQ0Wr9iSgj0PjGapR
         h1ArSnNFeXD/fKvKOmo3kmHwhTjQb314O0LVJfV/K/dzPiZ0FRsgqecQxOleyCW3Oavr
         ucEQ==
X-Gm-Message-State: AOAM532kBjKqLMZSqGndkk0yTVkdPGvFhjpS6XLNIRzD8IrG3cRh/ibh
        C41BDpuUM/NnQ9584jtA1vUm4nsludvyOXOT
X-Google-Smtp-Source: ABdhPJyHw92YpKGiU3VfxFiqT9aAFhjZMGSMT82pl3hBHC9Lvd79IHd8fdVSwYipTNozpK5w/qNHUg==
X-Received: by 2002:a05:6a00:989:b0:4f6:f12a:e2ab with SMTP id u9-20020a056a00098900b004f6f12ae2abmr15548199pfg.34.1646782888841;
        Tue, 08 Mar 2022 15:41:28 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k20-20020a056a00135400b004ecc81067b8sm197417pfu.144.2022.03.08.15.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 15:41:28 -0800 (PST)
Message-ID: <d7203721-8f0e-d4e4-7324-b2a0f5f73ad7@kernel.dk>
Date:   Tue, 8 Mar 2022 16:41:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [GIT PULL] md-next 20220308
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Dirk_M=c3=bcller?= <dmueller@suse.de>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <A2D06574-B7A1-4126-A3FA-FA24A61C5276@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <A2D06574-B7A1-4126-A3FA-FA24A61C5276@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/8/22 4:36 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-5.18/drivers branch. Most of these changes are minor fixes and 
> clean-ups. 

Pulled, thanks.

-- 
Jens Axboe

