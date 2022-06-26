Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15557C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 26 Jun 2022 15:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiFZPeN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Jun 2022 11:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiFZPeM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Jun 2022 11:34:12 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D07BB6
        for <linux-raid@vger.kernel.org>; Sun, 26 Jun 2022 08:34:12 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c4so6116976plc.8
        for <linux-raid@vger.kernel.org>; Sun, 26 Jun 2022 08:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shenkin.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9Tc1URP1zcuYa+k3rSHtXCfD6x/dX4jJKkoRfOkKduU=;
        b=V7l4vLVtnk1MlpyXdSheH79fflU92gMtTEsCklLJ6LdxQMaL5v0aWj6gGN6Z9MiWFr
         lxsW6Hstcfjq82+HRZXVzDZ7mdG/D14yrLNg5Fm1vUEar9KgYmbmUC/82zl+KjekKdeu
         TQg5aVQaPlg7Z3nMP0fxm8wJCGLwwITwozgO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Tc1URP1zcuYa+k3rSHtXCfD6x/dX4jJKkoRfOkKduU=;
        b=XCOj21y/xVass29w72faVF4VuiYJZj2ImjPhyERud+nbfBzaa8NaqmFqSrWQRlpll8
         lM5Oh2v9M6OSOb8joxPuHPEAajLIgYHOsQ4KWv0e9ophiz8OgwlXTFzTM6q6k8JT6ENy
         Tm+sjLS9M1eUaAvt5PyzlLcAz4WUMpbkF1GH40slI1FnGEXU6apbQENIWu3vrZ7msl8m
         bKM9t6fUMLP2S1LzQxyLRUfXssQ411gDxwgZqQBrWJirp/kpy4XrNVgSLEHRBgW+bCNV
         kqRM1PKimZO06wpi4NJD39X2H3nFbOU7MJaQdHRL1Gbqn/EY9zhD206PLhvROwoJMKhl
         NDcA==
X-Gm-Message-State: AJIora8d1KVp1rfSEm8cLSH4215l1qQFNio4JaC6DqrUiyRC9TZJAbEN
        X6Y3Ylul2cC2L7b0i52jy1fF1g==
X-Google-Smtp-Source: AGRyM1v4Bb1asvGxATfQGCkpp4RWnos7MPaj+iYor94yXZY3ZR8/gx5sm4isUeDQD/cu2WoqjIfGoQ==
X-Received: by 2002:a17:90b:3845:b0:1ec:c4a3:22be with SMTP id nl5-20020a17090b384500b001ecc4a322bemr10419994pjb.137.1656257651484;
        Sun, 26 Jun 2022 08:34:11 -0700 (PDT)
Received: from [192.168.1.243] ([47.215.181.107])
        by smtp.googlemail.com with ESMTPSA id r14-20020a17090a560e00b001eca01f4860sm5369387pjf.12.2022.06.26.08.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 08:34:11 -0700 (PDT)
Message-ID: <c9897e26-a919-f594-55f3-f3256ceb9f87@shenkin.org>
Date:   Sun, 26 Jun 2022 08:34:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Roger Heflin <rogerheflin@gmail.com>,
        Roman Mamedov <rm@romanrm.net>
Cc:     Reindl Harald <h.reindl@thelounge.net>,
        Wols Lists <antlists@youngman.org.uk>,
        Stephan <linux@psjt.org>, Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
 <20220624232049.502a541e@nvm>
 <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
 <20220624234453.43cf4c74@nvm>
 <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
 <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
 <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
 <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
 <20220625030833.3398d8a4@nvm>
 <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
 <s6nh748amrs.fsf@blaulicht.dmz.brux>
 <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
 <a16b44a7-ae37-7775-24c8-436dcbe69ae8@shenkin.org>
 <cb10aa14-3a52-740c-4f6b-d7816cb31155@youngman.org.uk>
 <414a502b-dffd-d4cc-4eaa-579589877cee@shenkin.org>
 <6257be2f-212f-72ed-228c-324253910666@thelounge.net>
 <20220626034554.4bfe7388@nvm>
 <CAAMCDecEd1po2WpGT_SyimkJLoitRL-=RxKgDdsFA0LX7=2QuQ@mail.gmail.com>
From:   Alexander Shenkin <al@shenkin.org>
In-Reply-To: <CAAMCDecEd1po2WpGT_SyimkJLoitRL-=RxKgDdsFA0LX7=2QuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/25/2022 4:28 PM, Roger Heflin wrote:
> Hostonly only builds the drivers that are needed to boot the given 
> host.  If you change the disk card it may no longer work.
> 
> Hostonly disabled adds all kernel drivers that could be used to boot.  
> Disabling hostonly should be done prior to starting the hw upgrades.   I 
> generally check the initramfs size before and after the rebuild as 
> disabled hostonly should be much larger.  I have also seen some dists 
> hostonly not work unless an extra rpm is added, and the size being much 
> larger made realize it failed before doing the hw migration and then 
> Having to rescue boot it to fix it.  The note about the extra rpm was in 
> dracut.conf where the hostonly setting is on the dist that needed the 
> extra rpm.

So, any idea how to disable hostonly?  I'm not finding it via google...
