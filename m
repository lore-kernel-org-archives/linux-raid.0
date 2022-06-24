Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0125AC43334
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 20:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiFXUXQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 16:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiFXUXP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 16:23:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC0F11A1D
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 13:23:13 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k7so3020515plg.7
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 13:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shenkin.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1KzBCrQIUf4j33zw/ZtEaYJqjh3gSF2oCDYLwFaWn0I=;
        b=NFFivtQF4qaZ6e5sUWDgiRyiJkDvg7fD7CXFsMVa0Wgzfo9NImZZw9ZDk6sVUaJzhl
         7Uv+59GOCeO3yHOG06TAM693OGIkA6sy+d3aLlGFaElGLf3ISGO1oqZt3phbMy1myYJo
         uGY3+Ew9Axq2rMKBtVzVmCOMQVutHZsMByTUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1KzBCrQIUf4j33zw/ZtEaYJqjh3gSF2oCDYLwFaWn0I=;
        b=2F2Dh0DV37s8X/G5Jiep4pFrf1sAqiH5wsv02jheoh8smwuzFCDD/b+pH32+YSKw17
         hxhKVAB3eWCzQpSGH7fF/4oi+FfJEx7bEEK80g1hMCriyGZofEIFYPfhRwbzB88AQO6D
         fOTzFoQx7OCZyAp8K9s66FJ1eIvZn1QvS6Lotm2ZtbNDLdhGkAe76xC3usStfSttBopf
         RgJxuXijbLia/6VlFmHJuBORM7jhZBUD28NgpQpsLDViN/y4PdtLCqUcOyTVOTlzVtOb
         OXc12ZO4h7ZH5vyaCJj8suHcP86vfSM4+GKYIdaQJeII++YNDFQvXljJbj/BZ/f2bAOv
         JCiA==
X-Gm-Message-State: AJIora9DDlVxrLxKdrazzVn0MHlKIrznhUfTRIfjKwsFEFJxgQ7MosIF
        9eRnzuTX1bRY1i00jynXDzpxeCvEjTV6S7L+
X-Google-Smtp-Source: AGRyM1vFcoybbY3GtSdgi0O2xOHxJpnh9x4qnuMWXKHwA63KsoCi+LbDFzswwIjvm/gD/wqVfxjSug==
X-Received: by 2002:a17:902:c285:b0:16a:1631:afe3 with SMTP id i5-20020a170902c28500b0016a1631afe3mr792939pld.93.1656102193130;
        Fri, 24 Jun 2022 13:23:13 -0700 (PDT)
Received: from [134.114.109.180] ([134.114.109.180])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902e54100b00168adae4eb2sm2225312plf.262.2022.06.24.13.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 13:23:12 -0700 (PDT)
Message-ID: <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
Date:   Fri, 24 Jun 2022 13:23:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Wol <antlists@youngman.org.uk>, Roman Mamedov <rm@romanrm.net>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
 <20220624232049.502a541e@nvm>
 <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
 <20220624234453.43cf4c74@nvm>
 <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
 <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
From:   Alexander Shenkin <al@shenkin.org>
In-Reply-To: <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Smart, thanks Wol.  I'm good on the UUIDs.  Not sure what you mean by 
'device 1' though?

On 6/24/2022 12:14 PM, Wol wrote:
> On 24/06/2022 19:46, Alexander Shenkin wrote:
>> Fantastic, thanks Roman.
>>
>> On 6/24/2022 11:44 AM, Roman Mamedov wrote:
>>> On Fri, 24 Jun 2022 11:27:08 -0700
>>> Alexander Shenkin <al@shenkin.org> wrote:
>>>
>>>> I have 1 RAID6 (root) and 1 RAID1 (boot) array running across 7 drives
>>>> in my Ubuntu 20.04 system.  I bought a new motherboard and CPU that I'd
>>>> like to replace my current ones.  In non-raid systems, I get the sense
>>>> that it's not a very risky operation.  However, I suspect RAID makes it
>>>> more tricky.
>>>
>>> Luckily with software RAID using mdadm it does not.
>>>
> Just make sure fstab (and anywhere else you may have manually altered) 
> is using uuids, and not device references (like /dev/sdxn).
> 
> Oh - and EFI / BIOS will always look for device 1. So that's a minor pain.
> 
> And both of those rules apply raid or not :-)
> 
> Cheers,
> Wol
