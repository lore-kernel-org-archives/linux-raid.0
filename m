Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29F7C4332F
	for <linux-raid@archiver.kernel.org>; Thu,  8 Dec 2022 21:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLHVnE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Dec 2022 16:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHVnC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Dec 2022 16:43:02 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8492FBC3
        for <linux-raid@vger.kernel.org>; Thu,  8 Dec 2022 13:42:59 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id b2so7112410eja.7
        for <linux-raid@vger.kernel.org>; Thu, 08 Dec 2022 13:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dmus8qU3OR2V6ptX/70pkjoUCURDpIlMmKAImtK+dVE=;
        b=WuhGMobMImVX40M8IWpXxiRqBEU9r8H+bsr63ECa8336nV2B/yWTHwwJwGlf0b7ko6
         Zl9tDGLmiZyfzCjofXo40g8BmGeR3anSOddprJiTDppf8uRvP8aTets2Kj41w/WZG5fQ
         Qs57hKNH+xKTFeHUcuBw9uAR6slmFQHHzwJQG9LGe9FOmUwraLA75jmNuO8+SVjIJJnU
         YRAv8kIrp5nrOz2e0+CS2srfYuEW5kLrmU3CZjrI7oaSwiLwPwaCZZhqO5sghodDjf4o
         097SrbB8BGzKkpK96Ql9IGkk/XrOmMbUVPceQ1YGCoXR/akhRVIgKpedPI0EexjwEJbh
         wvXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmus8qU3OR2V6ptX/70pkjoUCURDpIlMmKAImtK+dVE=;
        b=VwkHz1zxt1m5vr5cx1g6jUdwdye9oQKX5dxkSAQaPUtG25KlESce/oEG2ZJA8pbSlv
         i0KRL8qsDypXPCjC0V3DcllW8z6/5YAQzWHdXLHiWnuHLfVDehkqIdajanCd7RhAZhaB
         Xh79uNl1570LxQTpnsmPYKtLf4CDHlCo1cOZLZ2ZILkS3N8qmF4sNzDpGjlTFVpFeDh4
         UTwjzR8x2SKK04unnyfGhxk8YqdNbdGXt67gfIqQoHooL19jcO6J5dpurUYGry80iUdn
         c9WzGh9VJZSKr7Gkd+KLCPv5pOdboY4dHUxLKK3eYLv8y1L+mlxW7yFzNXNsubO/ipwH
         VHOg==
X-Gm-Message-State: ANoB5pl3PZO3HGF0FW0p1cXPoA1KzDfEq2n+hSOxMiaJ8xPOPwE1gb2m
        aXQ39yh90Xs6HTXAWNCc/BY=
X-Google-Smtp-Source: AA0mqf6wQ56s/dIi3HSAdSbgWr7EjSUTGNuYgVITgPhp2UP6/6yxBV+AKUKWt/ssdX/BJxYQR73s8w==
X-Received: by 2002:a17:907:1395:b0:78d:f459:718f with SMTP id vs21-20020a170907139500b0078df459718fmr2951032ejb.58.1670535777840;
        Thu, 08 Dec 2022 13:42:57 -0800 (PST)
Received: from ?IPV6:2a02:578:8538:b00:f169:6894:e08d:96c6? ([2a02:578:8538:b00:f169:6894:e08d:96c6])
        by smtp.gmail.com with ESMTPSA id g6-20020a17090613c600b007c0deb2449fsm6349236ejc.82.2022.12.08.13.42.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 13:42:57 -0800 (PST)
From:   Janpieter Sollie <janpietersollie@gmail.com>
X-Google-Original-From: Janpieter Sollie <janpieter.sollie@gmail.com>
Message-ID: <00e1f7f0-3b02-83e3-dacc-c23afd6e9c36@gmail.com>
Date:   Thu, 8 Dec 2022 22:42:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
To:     piergiorgio.sartor@nexgo.de
Cc:     linux-raid@vger.kernel.org
References: <YaZPScnojOLqDNPc@lazy.lzy>
Content-Language: en-US, nl-BE
Subject: Re: Using aGPU for RAID calculations (proprietary GRAID SupremeRAID)
In-Reply-To: <YaZPScnojOLqDNPc@lazy.lzy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Tue, 30 Nov 2021 17:20:25 +0100, Piergiorgio Sartor wrote:

 > On Tue, Nov 30, 2021 at 12:58:10PM +0100, Paul Menzel wrote:
 > > > Dear Linux folks,
 > > > > I read about GRAID SupremeRAID [1], which seems to be an Nvidia T1000 card
 > > and software to use the card for RAID calculations.
 > > > > GRAID SupremeRAID works by installing a virtual NVMe controller onto
 > > > the operating system and integrating a PCIe device into the system
 > > > equipped with a high-performance AI processor to handle all RAID
 > > > operations of the virtual NVMe controller
 > > > According to the review *GRAID SupremeRAID SR-1000 Review* [2] it performs
 > > quite well. I couldn’t find any driver files online.
 > > > Now I am wondering, why a graphics card seems to help so much. What
 > > operations are there, modern CPUs cannot keep up with?
 > > > If GPUs are that much better, are people already working on a FLOSS solution
 > > for the Linux kernel, so people can “just” plug in a graphics card to
 > > increase the speed?
 > > > Does the Linux kernel already have an API to offload calculations to
 > > accelerator cards, so it’s basically plug and play (with AMD graphics cards
 > > for example using HSA/KFD)? Entropy sources, like the ChaosKey [3], work
 > > like that. If not, would the implementation go under `lib/raid6`?
 > I think this was somehow discussed here some times ago.
 > That is the use of "GPU" to accellerate the parity computation.
 > There are a couple of things to keep in mind.
 > One is the data transfer to / from the video card, which might be a bottleneck.
 > At any rate, there will be a write and read streams going across the system bus(es).
 > An other point is that, unless an high end video card is used, with ECC memory,
 > the reliability of the whole process might be of concern.
 > Finally, usually video cards, while having a lot of memory (caching could be good),
 > they miss the battery backup. Power is off, data is gone...
 >
 > bye,
 >
 > pg

Hi pg,

I'm sorry to wake up this thread again, but I actually thought it was a very interesting idea:

I'm new here, but I'm giving up on hardware raid because I think the idea is obsolete. But I 
read your mail above:

what if the GPU could be used for verifying raid 5/6 in realtime? something like verifyread ...
the "real" parity calculation should still be done by the CPU for reliability, but at least the 
GPU can signal something may be wrong.
with nvme drives pushing 4-5GiB/s these days, a raid 6 of 10 nvme drives could easily outperform 
a single CPU core.
for raid 5, I doubt anyone will benefit from it, as it's a simple XOR calculation, but might it 
be for raid 6

For your concern about the read/write on the system bus, I agree: as with every situation, it 
will depend on the config, but it is unlikely it will never be a problem.

Your BBU remark is also interesting to me: why would data be "gone" at a power off?

kind regards,

Janpieter Sollie
