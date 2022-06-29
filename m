Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FFCC43334
	for <linux-raid@archiver.kernel.org>; Wed, 29 Jun 2022 01:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiF2BFK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Jun 2022 21:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiF2BFJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Jun 2022 21:05:09 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606E419C12
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 18:05:08 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so17737199pjr.0
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 18:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shenkin.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=LGch3VMeA6wRZben3VOeYtS19rEL+Dto7mF3Y0ORe8Q=;
        b=ffjYfPbggQUiySP1IDYjilpkwmJ6oSlkRQVDLsuFX+9B6sVXeGIozOVOhRKsOnxKJ2
         /33MO7XWi2FWcMCtdLjOu95uJh2tEJNLfCPHnMIdFqyfZPlJJphSjmIPKjbAKIyFHbYg
         imPPyGvFemwTaZ5zkqG6cuNjFkajLBZ04t4Qc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LGch3VMeA6wRZben3VOeYtS19rEL+Dto7mF3Y0ORe8Q=;
        b=GI88vTyt+mY0aIhwtjhIxT5V2FkYdcJMpdY2YRnEYuEDDDLnc+mZXiLSPX542dsw8Y
         WDifLDvCF3PyHEC+7w1snAvsxX/TrVwWchWCuAkgbMVhmMYbfeNEnPnhsXvkJa1Chl8k
         ht9F4c61gujAbLNx0vo+fOCj9dp4jjAeKko5L1/+zOFydqnAvWZ1uz9/keQcMHMLG+Bt
         LpC4lNeF/odiD6QnYIMbbo4IIOG/CoQ1HRiUCnVpQr+euFeF9MWPBFU+hbi/pkZ/KzMW
         QDmROaIs4T64VXhesRdlvw2nL2uIkVrf2Ws34zXVHFJSQWIwOVHAB1gawMOlYlyjOJ/r
         Lbsw==
X-Gm-Message-State: AJIora+NKFXk7GJ1ADhw7bw90JhgQ3FBxkP3dgmUDI6y9DVlIBNjjKpX
        iSyIhFaxoiVKGomZNoGovdDY8g==
X-Google-Smtp-Source: AGRyM1sRhr0VDSyLPNOIwVmMsWI4PQGoVkrSa6uFin1insbMrqr//Z8EPtXbNJue4wDUQsR9G2l6Pw==
X-Received: by 2002:a17:903:41c3:b0:16a:55e0:6c6c with SMTP id u3-20020a17090341c300b0016a55e06c6cmr6474593ple.49.1656464707755;
        Tue, 28 Jun 2022 18:05:07 -0700 (PDT)
Received: from [192.168.1.243] ([47.215.181.107])
        by smtp.googlemail.com with ESMTPSA id u15-20020aa7838f000000b0052592a8ef62sm7154001pfm.110.2022.06.28.18.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 18:05:07 -0700 (PDT)
Message-ID: <b6df7f34-befc-0131-f4d3-45b64eff9a94@shenkin.org>
Date:   Tue, 28 Jun 2022 18:05:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Ram Ramesh <rramesh2400@gmail.com>,
        Linux Raid <linux-raid@vger.kernel.org>
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
 <f971e15d-9cd4-e6de-c174-f3c6bd338bb6@plouf.fr.eu.org>
 <b1c6b0c2-ff7b-59e0-580c-81d57b8f8ddb@shenkin.org>
 <20220627160558.0ec507ae@nvm> <693d4b1c-ee58-4cc2-854b-4ae445ff7d24@Spark>
 <3e756547-ae18-c0d8-209e-8dd1fc43bb0f@plouf.fr.eu.org>
 <24ac75be-4e0b-0c50-8d87-b673535f7686@shenkin.org>
 <2bece936-f802-3137-3597-6269b1cfc9bb@gmail.com>
From:   Alexander Shenkin <al@shenkin.org>
In-Reply-To: <2bece936-f802-3137-3597-6269b1cfc9bb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks all,
Once I installed a graphics card, I was able to enable CSM and I've 
booted successfully.  Thanks everyone for your help.  Converting to UEFI 
would be a good idea, though not sure how easy that will be given that 
/boot is a RAID1 array (how do you resize all the partitions, etc?).

Anyway, now looking for a network driver for this mobo...  ;-)

On 6/28/2022 2:57 PM, Ram Ramesh wrote:
> On 6/28/22 16:32, Alexander Shenkin wrote:
>>
>> On 6/27/2022 7:26 AM, Pascal Hambourg wrote:
>>> On 27/06/2022 15:57, Alexander Shenkin wrote :
>>>>
>>>> CSM is greyed out.  I think I need a graphics card
>>>
>>> Is secure boot disabled? Legacy boot is not compatible with secure boot.
>>
>> There's no way to completely disable secure boot on this mobo. It's an 
>> Asus Prime B560M-A.
> 
> Can you boot legacy install with UEFI boot disk? Have you  tried booting 
> with sysrescuecd or some such to boot your installed OS?
> 
> Have you considered converting UEFI? CSM/Legacy boot support is dropping 
> steadily. Sooner or later it will be extinct.
> 
> Regards
> Ramesh
> 
