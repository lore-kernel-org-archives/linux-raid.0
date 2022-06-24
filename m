Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC8CC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 22:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiFXWGT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 18:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiFXWGQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 18:06:16 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C741D88595
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 15:06:14 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 23so3579855pgc.8
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 15:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shenkin.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AEiwRb3PtIP5cqm7C9WIiX0GdkY/6fHNbc6KsIryUek=;
        b=f1AiigBAGZtgzEq4XYqVIm5SG9j2DJCyzEJEvQ0PzCHhqKBQ3wti/u96ta1jzgt33K
         Kg7Si2t50HqOdHOwBgzxcQgq+LUiK1k7yRb3IlvuoP6tyisI2SfXItOyULBn1SuJQ9bN
         sMlWXmgRipy5rv6BOPkPMVg1FV5jHbq31vz3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AEiwRb3PtIP5cqm7C9WIiX0GdkY/6fHNbc6KsIryUek=;
        b=M5kL9oZ2z+G5I9H+IUH6BAik1mkibTQsLGgT0BqNxEs+xmH6vNzuRmHGEnHEmTwJ39
         yu40c06E8B4LozXwTV72q+BCGP2JfLCNA8FMu31ZQQhLDriAI2Tm5f4biw1sLYMjlhrS
         721ab6RgWLqbzwVsQQPf/HeFi4GFLigsB5Oy3X/yadK1A3SnqNZUakbcZkjpjd/JP6lf
         8Zrlk4ePpjVuUfUyno3dmIigKplhR91rfGjxjdd/OnuCVlRChCAyDEYqbDQ1dxUszXgy
         tRngk4N0de6cozQaOMQDqA64QNdH3W6MXUz0YpKEf9kz7kL2Ea3rEuuS1d2EGbPgSRSi
         4jAg==
X-Gm-Message-State: AJIora8YxU6vRDAXPDWMgpZhGh4tODV/Q4WXJcu19Kq1wDZNHGaIQdJV
        6MLoYWV3i33SdLoTpw256Ee7nK1V1BN9qY0Q
X-Google-Smtp-Source: AGRyM1uEp2S2P07D4+WO1PbAnyaMApgbZNhD/N7uqqBnWphcdbuWZOmlktrPDArIL5qJwEiIpFJmcQ==
X-Received: by 2002:a05:6a00:140b:b0:4e1:2cbd:30ba with SMTP id l11-20020a056a00140b00b004e12cbd30bamr1305799pfu.46.1656108374162;
        Fri, 24 Jun 2022 15:06:14 -0700 (PDT)
Received: from [134.114.109.180] ([134.114.109.180])
        by smtp.gmail.com with ESMTPSA id j10-20020aa78d0a000000b00522c3f34362sm2176880pfe.215.2022.06.24.15.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 15:06:13 -0700 (PDT)
Message-ID: <62f37a72-cb0d-001b-3fa0-b3938e3069e5@shenkin.org>
Date:   Fri, 24 Jun 2022 15:06:12 -0700
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
 <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
 <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
From:   Alexander Shenkin <al@shenkin.org>
In-Reply-To: <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Got it, thanks.  I hopefully, should, have all my disks bootable... but 
better safe than sorry.

On 6/24/2022 3:00 PM, Wol wrote:
> On 24/06/2022 21:23, Alexander Shenkin wrote:
>> Smart, thanks Wol.  I'm good on the UUIDs.  Not sure what you mean by 
>> 'device 1' though?
> 
> Sata port 1. /dev/sda.
> 
> So your boot device is currently in physical connector 1 on the mobo. If 
> you move it across, you need to make sure it stays in physical position 
> 1, otherwise the mobo will try to boot off whatever disk is in position 
> 1, and there won't be a boot system to boot off!
> 
> Remember, uuids rely on linux being running. But linux can't run until 
> AFTER the boot code has run, so the boot code knows nothing about uuids 
> and relies on physical locations. Cart before horse, catch-22, all that 
> palaver you know :-)
> 
> Cheers,
> Wol
