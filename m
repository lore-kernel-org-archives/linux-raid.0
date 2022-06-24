Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7F6C43334
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 22:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiFXWmZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 18:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiFXWmY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 18:42:24 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1F688953
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 15:42:24 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id u189so5362710oib.4
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 15:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ya003vOXh4mSBe3TjFFSPoC9DSThjddYdcF7fjRbids=;
        b=hMr4DzSenFCFU+NKJRjI5JoxxHYSr36rIY4F2tC7/s6o8PQBPspjDNiQ9k/ZMPxdE6
         j9T3Z90J9C+tNXzMsJMsWLVQJ4wJDxa9vB+PR4UFWXDJhGehMQURfrnk7c4VdwnalGTc
         BhxLZwYnpZqyZpcM9Mo8YZ6dKlEYkapHOyb6pYYTobKWAHXoXhSh7l8St2bAscLXosnb
         3omMG/fCFpSuxdsP2wBWRCBgdwIb4zByvm1TgB3Hk9nzcXBMLeXbS0+W/WXvvDeatNes
         0aP6s8RpTFhhOEyfyF2XloUcKKS44hf/AxE7CjjI1eNDggWNzAdBEuGEV1MaiMTzHT4a
         qO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ya003vOXh4mSBe3TjFFSPoC9DSThjddYdcF7fjRbids=;
        b=YvJqxqgfsh/BqV6v0exxBG/4y5qRkqtWSsYqj/YFXx8zCmE7vqhATH8hd62e9bQfeH
         O4gq8TLR+OGHfokfjfWeMgfmLW1Xk8NOCvHsPlH9dTg5gIV5HfgHV5ikLP5Xp8/AaDbk
         Enh7n9KE5Obw7v/BSovwCfImz9vRXhjHt8fhDYy6Es9mM/8y93uNmJ7CX5OBKBB5gqSJ
         iwbv6KN/wT7Tg4e9aRiLIimc+1574jrD41jsAbv3PDpPbm/G+bcxYBUnEP+rsdA44j7K
         QralIO8aHM55dB/a4iaYqB403dyJrEQBZpNoigZB+BclBDznMtBYc3HKPrsVIJlksWL3
         ua3A==
X-Gm-Message-State: AJIora/Dh2z+zUIalKv41lU+hiBlRk0J8f9Mgxi17l/hz1RHcoSn54bO
        mc2yVwA7SU9JOg/EGXoNU+g=
X-Google-Smtp-Source: AGRyM1u3oF2Y2vSuX5o/OxypfGB9Obt3lpRf4isrtAFi5Hgzdd1SWuYO+iJh5IzUwdBr9HxRh44hIg==
X-Received: by 2002:a05:6808:1893:b0:331:481e:7ab5 with SMTP id bi19-20020a056808189300b00331481e7ab5mr3451885oib.70.1656110543521;
        Fri, 24 Jun 2022 15:42:23 -0700 (PDT)
Received: from [192.168.3.92] ([47.189.16.5])
        by smtp.gmail.com with ESMTPSA id 23-20020aca1217000000b00328c9e63389sm1816448ois.11.2022.06.24.15.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 15:42:22 -0700 (PDT)
Message-ID: <9d1465a0-f6c0-0161-1c8c-2a66e7939e30@gmail.com>
Date:   Fri, 24 Jun 2022 17:42:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Alexander Shenkin <al@shenkin.org>, Wol <antlists@youngman.org.uk>,
        Roman Mamedov <rm@romanrm.net>
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
 <62f37a72-cb0d-001b-3fa0-b3938e3069e5@shenkin.org>
From:   Ram Ramesh <rramesh2400@gmail.com>
In-Reply-To: <62f37a72-cb0d-001b-3fa0-b3938e3069e5@shenkin.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/24/22 17:06, Alexander Shenkin wrote:
> Got it, thanks.  I hopefully, should, have all my disks bootable... 
> but better safe than sorry.
>
> On 6/24/2022 3:00 PM, Wol wrote:
>> On 24/06/2022 21:23, Alexander Shenkin wrote:
>>> Smart, thanks Wol.  I'm good on the UUIDs.  Not sure what you mean 
>>> by 'device 1' though?
>>
>> Sata port 1. /dev/sda.
>>
>> So your boot device is currently in physical connector 1 on the mobo. 
>> If you move it across, you need to make sure it stays in physical 
>> position 1, otherwise the mobo will try to boot off whatever disk is 
>> in position 1, and there won't be a boot system to boot off!
>>
>> Remember, uuids rely on linux being running. But linux can't run 
>> until AFTER the boot code has run, so the boot code knows nothing 
>> about uuids and relies on physical locations. Cart before horse, 
>> catch-22, all that palaver you know :-)
>>
>> Cheers,
>> Wol
Whenever I upgrade my machine (new MB/CPU), I note down the name of the 
disk I currently boot from. Look /dev/disk/by-id and note down the disk.

After building new machine, get into BIOS setup and choose that disk as 
the first boot disk. You will have to enable CSM before choosing the 
disk, if it is legacy boot.

Recent motherboard's BIOS will not enable CSM without video card as 
video bios is removed in those MBs. So, you may have to either switch to 
UEFI boot first (very doable) on the old machine itself or get a spare 
video card (I have never used this approach, so so not sure).

Also, 12th gen intel CPUs need 5.16 or later kernel for video support. 
Otherwise, you will get blank screen. I have no idea why.

Also, make sure you go to manufacturer's website and read the MB spec to 
ensure all devices (network/audio etc) you care about are supported in 
your kernel.

Booting from bleeding edge hardware has always been in my experience.

Regards
Ramesh

