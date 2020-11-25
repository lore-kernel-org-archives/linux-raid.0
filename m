Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5282BC5519F
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 14:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE39B2076B
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 14:38:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d8uV47nw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbgKYOir (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 09:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgKYOir (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Nov 2020 09:38:47 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16B3C0613D4
        for <linux-raid@vger.kernel.org>; Wed, 25 Nov 2020 06:38:28 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id h3so3026156oie.8
        for <linux-raid@vger.kernel.org>; Wed, 25 Nov 2020 06:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ceai17vNjagV32U5CwY6P5pQ9SlxYbGeVqfrh3m1vwA=;
        b=d8uV47nwMRPXQhCfptxSRVJ0VhBMjUUX8HzdfYmmN/PO5dpBhKL5FQ04s61ImnfFBE
         9cuRQG+N49QIUfTpaGhlHC/GkHNGFsOXI8PiMZi+wDU1szdhCA7TWWhwAB5UYfFPBbzq
         iDGiOG793SsiX3ELuFIVuWCh+x3hSmhzTE/r2gm6CV6VDOyi4K/pnsbDKDXAOJzxJ5Rr
         JRDukJPxalqOZNEkyTtn2m7QqcEFr5dpvWbn9HBz26YaUqs/k5FwNZX4PaKICRFZXyFV
         SCFRxPcN88nG5kZY0lLmHTLukdp2Co0G+sPWhON0q/YdmSxX99DEd9a6paVqT9/IfgDx
         Au+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ceai17vNjagV32U5CwY6P5pQ9SlxYbGeVqfrh3m1vwA=;
        b=BnDllvC+3xT3q3me9Uclqyox0Ma95y2+7gMxNuWFEcbAH2V26SzGik211E8MIqtfeN
         zoYvTu3Kig1JYeUMoc6/pr7IfNLUy8aaoRUMiJYpFgj8XEeJoqyYENndzVdGJS4Eqa7k
         R727vTm71a7ec4dY0Kc1ypsJv5u2XKQp0czOgs2nMtm4D0ylddg0ZIa9XVmNiRY7I0hS
         UzijufpuHWOthABVFVCohuwOLF4Q5XaILZi+kENS2/ZGWfvbU37guIu2+HEl9DHOQQBR
         x2qVS0dt8XRgV5YecVMITZZXGGZ2ClWh0LCqH3R7Q0D51cRjuvaLNrmpuSIYHlGvM2mf
         82pg==
X-Gm-Message-State: AOAM533bepgrxMYPT7ObsBl3D5qXoE54j65XQR7yU3mkTDZBdq6CE6ZS
        /8SUVSs0CAHxWSHsGOyKIJHmJ/kZL5U=
X-Google-Smtp-Source: ABdhPJyVet8am/gXiYJGAGF9lU/sIJ1W+LzuX8IWEgA6CmYpznOM055L/lQS2F7d+6CLdlCLvmtqHw==
X-Received: by 2002:aca:c311:: with SMTP id t17mr2464169oif.46.1606315107917;
        Wed, 25 Nov 2020 06:38:27 -0800 (PST)
Received: from [192.168.3.75] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id z25sm1528842ooj.39.2020.11.25.06.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 06:38:27 -0800 (PST)
Subject: Re: Considering new SATA PCIe card
To:     Alex <mysqlstudent@gmail.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
References: <CAB1R3sgQm2_-Bhbzned4y056XP5hM9oz1OnTZSfHH9+L5sdpFQ@mail.gmail.com>
 <c629eb5c-ee37-a7fc-6ffb-8035945e5f16@gmail.com>
 <CAB1R3sgK3cmqhNM-PcMP88yhFV6mgQwdVYOkUbf4N1aM-BB9sw@mail.gmail.com>
 <25741f58-676a-c4ef-7463-31b5b3a08bc5@gmail.com>
 <CAB1R3siNB0u8g+JNcLf+n0BEpUt2HjXam4DmqMXNDuVTjoWaWg@mail.gmail.com>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <df36257c-1302-ea39-9d9f-f7ed11b0562f@gmail.com>
Date:   Wed, 25 Nov 2020 08:38:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAB1R3siNB0u8g+JNcLf+n0BEpUt2HjXam4DmqMXNDuVTjoWaWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/20 9:28 PM, Alex wrote:
> Hi,
>
>>>> If plan to use addon cards, please consider LSI SAS9211-8i cards. Well
>>>> supported and reliable.
>>> Oh yes, how quickly I forgot. I actually have one of these in another
>>> server, but I think it's too long to physically fit in the case. Just
>>> to be sure, this is the card you're referencing, right?
>>>
>>> https://www.ebay.com/itm/LSI-SAS-9211-8i-8-port-6G-IT-Raid-Card-ZFS-JBOD-HBA-SAS-SATA6-0-2008-8I/143735992677
>> Yes. Any one of those that mentions this controller and preferably IT
>> (just HBA) firmware instead of IR (Raid) firmware as your raid will be
>> implemented as SW mdraid over JBOD.
> Thanks so much for your help. Are there other similar LSI cards that
> are also well supported?
>
> This looks like a 4-port version of the same card that would certainly fit.
> https://www.ebay.com/itm/IBM-H1110-81Y4494-SAS-2-6Gbps-HBA-LSI-9211-4i-P20-IT-Mode-for-ZFS-FreeNAS-unRAID/143488380023
>
> And here's a 1GB cache version?
> https://www.ebay.com/itm/LSI-MegaRaid-SAS-9270CV-8i-1G-Cache-PCI3-0-6Gb-s-Raid-Card-SAS-Controller/143780173461

I am not an expert by any means. I have purchased just one 9211 card and 
it is working well so far. Yes, there are several. I think PCIe version 
may be newer with higher numbered cards, but not sure. In any case, 
vanilla simple 9211 will be more than enough for spinning disks.

I could not figure out if the cache version you list above is meant to 
do HW raid. I was told by those knowledgeable here that HBA or JBOD 
cards are more suitable for mdraid.

Like others have said, this is unlikely to speed up your disk access as 
spinning disks are too slow compared to PCIe/SATA line/cable rates. Buy 
RAM/SSD or do something more fancy  like bcache/lvm cache, if 
performance is a real need vs. feel good state.

Regards
Ramesh

