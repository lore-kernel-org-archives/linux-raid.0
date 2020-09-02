Return-Path: <SRS0=XO6g=CL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1998AC433E7
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 18:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD441207EA
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 18:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F6Oo7Cij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgIBSRk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Sep 2020 14:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBSRj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Sep 2020 14:17:39 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E28C061244
        for <linux-raid@vger.kernel.org>; Wed,  2 Sep 2020 11:17:39 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id a65so107125otc.8
        for <linux-raid@vger.kernel.org>; Wed, 02 Sep 2020 11:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Hg6KKlPRHWruE7xfP4SnF9BClGwveeSrrR6qQuLz4TA=;
        b=F6Oo7CijKkMkwrKUuUs5Bj9GXFLzWOUAB6v9bXD2U9sdS6WGntKTMyASWulcSYK1wD
         e7EG3EkuLYKe8LZiGIIWszUZxGvWSceicz6q4dydB9SEyeLYmlM/pvBPwOM5oXNA5hgZ
         o/v6+ajb7XWCVOlk6gmZEm14m3Aqirhlf0VX7MwDKFEHAP84XTTofvaSMuAHspDWaNmX
         6npfumx5mAM96gPAKp+7Uq3PPKfV/UURWYv4Dm7pSB66ldteEvq538LGmEncLdUsAJGl
         qlbyHawOvaYqRyRz3GfT4HMDO0bBVIuv2ILje1M2zU1HJhekBSb+3vnEP7RiBjbuHe6Z
         Wtjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Hg6KKlPRHWruE7xfP4SnF9BClGwveeSrrR6qQuLz4TA=;
        b=EeRreMLlhtHz/TWeKqJNsm6klJPlkjFYnLGKdCLsnSTMHkvkunkbg6+fCO1xmGhtE7
         pQCPbGZzCMMgh4l7LmrKWkSESlmnMc5RgWOdIuvLqEsEZM1R+6SPDNLamBf00m6Uocbe
         myI3IM3M2u4Q1LqNFT4LbhciHlk1OwZOISZesJlk4cHso+fOS4hKj9k0hO3h0rKlm5Xo
         6pnLSc6q2bM5JLWe4ao/+34FZOJxVtxGS3gcCTz0hgveIrvMMgWc5J8zEYwkSd7NLkP3
         C66tv8UA+0ltCS383Wv9HLew1YSE5IWMVfI6vOd90DzbGxS7bCbh/tEafFjfUNsxJ514
         GZBw==
X-Gm-Message-State: AOAM533Zp79uAfU6VOROH1Dt4hyxYDGQZ6RGlxcxpHN3BQX7tiZEa/b2
        7ZHIDdGACVXylrucQKBQD0ly/3xk/Z8=
X-Google-Smtp-Source: ABdhPJzRhN33c8mPVIp0dQxNvD7jlLnKAhA0r61kyzoUlNLrJIrzPAEzAqQmjj9TjkqNYernWNqSAA==
X-Received: by 2002:a9d:6458:: with SMTP id m24mr1743869otl.298.1599070658383;
        Wed, 02 Sep 2020 11:17:38 -0700 (PDT)
Received: from [192.168.3.65] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id n11sm23354oie.21.2020.09.02.11.17.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 11:17:37 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     Kai Stian Olstad <raid+list@olstad.com>
Cc:     Drew <drew.kay@gmail.com>, antlists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
 <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
 <d4d38059-eaaa-a577-963a-c348434c260e@verizon.net>
 <CACJz6QvRqq+WLmbOYR=YECNwHzpedUjJEAcoaHseEzEd2Bq8nQ@mail.gmail.com>
 <79c15e0e-5f34-2b1a-282c-8bb36f2e3e81@gmail.com>
 <20200901170158.acaq54zxfeaiasdk@olstad.com>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <d48e1365-a86c-bdcd-fd2a-d65767fbf2fa@gmail.com>
Date:   Wed, 2 Sep 2020 13:17:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200901170158.acaq54zxfeaiasdk@olstad.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/1/20 12:01 PM, Kai Stian Olstad wrote:
> On Tue, Sep 01, 2020 at 11:12:40AM -0500, Ram Ramesh wrote:
>> I really wished overlay fs had a nice merge/clean feature that will allow us
>> to move overlay items to underlying file system and start over the overlay.
> You should check out mergerfs[1], it can merge multiple directories together
> on different disks and you can transparently move files between them.
> Mergerfs have a lot of other features too that you might find useful.
>
> [1] https://github.com/trapexit/mergerfs/
>
Kai,

   Thanks. It is interesting. However, my starting point for this 
discussion was improving performance and this one seems a bit backward 
as it uses FUSE. I still think it is a good step. So I will learn a bit 
more to see if I can use it.

Regards
Ramesh

