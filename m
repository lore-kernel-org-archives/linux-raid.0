Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B3CC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 28 Jun 2022 21:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiF1V5a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Jun 2022 17:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiF1V50 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Jun 2022 17:57:26 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E981D300
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 14:57:23 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id e131so19019487oif.13
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 14:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=fF4X3Udqcbdm+20pG2a7lwakaQN12PolF+9BMFiW+H0=;
        b=gh5Vf03rGMKd8nWGtCdvwZ5tn2M5MZkQ3NzGAMmet5AOtpSGgQvhyBNpviN59H7Hqm
         24mnFamJ1kP3Sou6RohLmZFSPb69k13+wBUJtTlndMmw0KFntxe7SfcB/P7nb/Rf6HC4
         1h7ATQ19q7mfucFVkD3YBXTBAYKKNAbMvkvYtooEhTW1wHmXuPeSkmHOi2XQi1Oj/zGn
         MWuZpPcfyO7WoMYg2FsXXodyL5gY5XeE1Pe6SojkwL8p81rYH3LuJN6wUp0dLQIw/h2m
         sOjO7Ril/+VeykVx9rOVSSEtthMXu7Y+j6/MMczHO4osdVEdfE36AjLbcwfBFKOZZIYR
         IGPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fF4X3Udqcbdm+20pG2a7lwakaQN12PolF+9BMFiW+H0=;
        b=sEMDDRFALfR9i+oSQYXD+x6OFfIUvvF5W7lkBNqp2j76M7qxqSECQ5VYxuBbWKCyo/
         rwNV926RolyoD1UZZysKOlxLQZ/PGINkj0UmvzMRDs67Aa2qw4kNGGWnHfX6t5EMP/S5
         9VZpSk6DhiIKPG7l7/h+OjnwzD8y8KiABSAo0exrgS0k/aBeSIRxP6uEMVb7UulIHsdO
         wKfKb0TmFIIIyHY41amKHFEpLGdJJHdP7VBcOjcz+lMCyi1PTiyzIYjGnfZL07MF/yCL
         yHVMnM5Qj0XTC+y1F/eK/o4HeCnpyyilMs0pAUKiJfL+6RLch9SPoPtaUrtcXZ+UCpyF
         rbMA==
X-Gm-Message-State: AJIora8SF4bBzLlqglBIZcgCDGqunibjDt0Eq0Lrbh1GooqM5U//q+L5
        zX56sxrn9sEHDDvf4tj4SVk=
X-Google-Smtp-Source: AGRyM1vaLBLGGANA4S4ZZe76iW8/UQXcyVQIKXLPeE2aE4G3r5rIf2WAuG6wINyUL74i2KEuIACRog==
X-Received: by 2002:aca:b744:0:b0:32f:4c19:cec1 with SMTP id h65-20020acab744000000b0032f4c19cec1mr92658oif.43.1656453442817;
        Tue, 28 Jun 2022 14:57:22 -0700 (PDT)
Received: from [192.168.3.92] ([47.189.16.5])
        by smtp.gmail.com with ESMTPSA id u9-20020a0568301f4900b0061680c8c9e2sm8574677oth.70.2022.06.28.14.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 14:57:22 -0700 (PDT)
Message-ID: <2bece936-f802-3137-3597-6269b1cfc9bb@gmail.com>
Date:   Tue, 28 Jun 2022 16:57:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Alexander Shenkin <al@shenkin.org>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
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
From:   Ram Ramesh <rramesh2400@gmail.com>
In-Reply-To: <24ac75be-4e0b-0c50-8d87-b673535f7686@shenkin.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/28/22 16:32, Alexander Shenkin wrote:
>
> On 6/27/2022 7:26 AM, Pascal Hambourg wrote:
>> On 27/06/2022 15:57, Alexander Shenkin wrote :
>>>
>>> CSM is greyed out.  I think I need a graphics card
>>
>> Is secure boot disabled? Legacy boot is not compatible with secure boot.
>
> There's no way to completely disable secure boot on this mobo. It's an 
> Asus Prime B560M-A.

Can you boot legacy install with UEFI boot disk? Have you  tried booting 
with sysrescuecd or some such to boot your installed OS?

Have you considered converting UEFI? CSM/Legacy boot support is dropping 
steadily. Sooner or later it will be extinct.

Regards
Ramesh

