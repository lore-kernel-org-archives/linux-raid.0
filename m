Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF1AC43334
	for <linux-raid@archiver.kernel.org>; Wed, 29 Jun 2022 02:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiF2CLF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Jun 2022 22:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiF2CKt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Jun 2022 22:10:49 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483073587C
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 19:10:39 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id y10-20020a9d634a000000b006167f7ce0c5so11150154otk.0
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 19:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=gkHfsXLx9qHK2Yq1QGAscG2j8XUUkAsHOvO+dNYDUI4=;
        b=OhXJFdeQ+g9SZU442aHOwY0b8hqtivrhKuQtduBp20eq9p7/6HOUYVORnWFEk0QvR6
         0J4jEH6x8TCeKo96bjLqCrXp0HYqExagdLJxFO/CHsOARNjceFqiotrBY4BMqVYRHe+q
         970NjyKHSQXvqT/mDWLn6zIvgO2/Et3Eh72uzdUbiDHsU/JCO2/c6AG2+1xBjf6jMlsb
         xz+h9L6TFEKB3LQ0zvDudQJKVa3B7Sm4749lxLFUVuEfds/DuESHwkxm0uNvD5DYt9KF
         P3x34XQdm8LcA2iA7t6MKWTyRWGxanWC3ky1+D9e8XVjv75OBol/WM2y2Dtv2ybkonFS
         zmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gkHfsXLx9qHK2Yq1QGAscG2j8XUUkAsHOvO+dNYDUI4=;
        b=kpY9ihD9ODbnWS2nFZbJcHmwz+hDUnkFBKOOHldJIXwmKGfhdeeSTtcmsUzMXfkxMI
         yiT+orNolp6CbSQNr1tnjodUtKXhn4jWwgIizUiK+1aYN7tA5296n1oAcex6fVawwcV6
         guAIHB9O5B2EN8edNo7N09MCq8domnWIZTw9zmyJcbzWJylvErVsNDB4hC5U5w96RLfU
         I7vyVTSF8kkYv+qABsr7Es0RBrplfTw2CBkTNfKFrP9lN76EKGmXkDQk9fQtMQm6M8Zs
         9O3PTThr8PzydczGk3U0ogWyTfKoo4FEPqssacIsQBzG6hupAGwAaXDbAbFWNYjxJxeR
         /3bQ==
X-Gm-Message-State: AJIora+uLAY7krtVR+tvcXQkgkFAi6p57WNR5HM8YZnR5iWv/nqEV0Ek
        fttV2mLld7YlZhdGbbPuChaSlgMA5t4a6N/s
X-Google-Smtp-Source: AGRyM1spFHgUavhAA5ryXFFQIqxmv7GQ9apiCMR0zUZ+LjEFKyqoBgxGQnz6OejyM89KeUMIQ8LcmA==
X-Received: by 2002:a9d:6ac4:0:b0:616:b183:c7e6 with SMTP id m4-20020a9d6ac4000000b00616b183c7e6mr515732otq.353.1656468638335;
        Tue, 28 Jun 2022 19:10:38 -0700 (PDT)
Received: from [192.168.3.92] ([47.189.16.5])
        by smtp.gmail.com with ESMTPSA id k11-20020a9d198b000000b0060bf670dd35sm8966217otk.49.2022.06.28.19.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 19:10:37 -0700 (PDT)
Message-ID: <0b025627-8496-030a-2971-6ca72d73b428@gmail.com>
Date:   Tue, 28 Jun 2022 21:10:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Alexander Shenkin <al@shenkin.org>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
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
 <b6df7f34-befc-0131-f4d3-45b64eff9a94@shenkin.org>
From:   Ram Ramesh <rramesh2400@gmail.com>
In-Reply-To: <b6df7f34-befc-0131-f4d3-45b64eff9a94@shenkin.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When all else fails, I use a usb3 NIC until the correct NIC drivers are 
found :-)

I think you can use another disk to install UEFI setup and boot your 
raid from that install. If you do not have a spare disk, use USB to 
experiment. They are cheap to buy and use as you only need a bare 
install (on USB)  to get started.

I converted several legacy to UEFI. However, none was from a RAID. I 
always leave 32G in every install/boot disk for crunch work like this. I 
recommend this. Even the machine that has RAID1 boot has first 32G on 
each RAID1 disk unused (so that I can convert this install too into 
UEFI, when I decide to)

Note that you need GPT for UEFI boot disk. So, separate disk/USB is the 
best.

Ramesh


On 6/28/22 20:05, Alexander Shenkin wrote:
> Thanks all,
> Once I installed a graphics card, I was able to enable CSM and I've 
> booted successfully.  Thanks everyone for your help. Converting to 
> UEFI would be a good idea, though not sure how easy that will be given 
> that /boot is a RAID1 array (how do you resize all the partitions, etc?).
>
> Anyway, now looking for a network driver for this mobo...  ;-)
>
> On 6/28/2022 2:57 PM, Ram Ramesh wrote:
>> On 6/28/22 16:32, Alexander Shenkin wrote:
>>>
>>> On 6/27/2022 7:26 AM, Pascal Hambourg wrote:
>>>> On 27/06/2022 15:57, Alexander Shenkin wrote :
>>>>>
>>>>> CSM is greyed out.  I think I need a graphics card
>>>>
>>>> Is secure boot disabled? Legacy boot is not compatible with secure 
>>>> boot.
>>>
>>> There's no way to completely disable secure boot on this mobo. It's 
>>> an Asus Prime B560M-A.
>>
>> Can you boot legacy install with UEFI boot disk? Have you  tried 
>> booting with sysrescuecd or some such to boot your installed OS?
>>
>> Have you considered converting UEFI? CSM/Legacy boot support is 
>> dropping steadily. Sooner or later it will be extinct.
>>
>> Regards
>> Ramesh
>>

