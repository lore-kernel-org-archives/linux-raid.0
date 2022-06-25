Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFC3C43334
	for <linux-raid@archiver.kernel.org>; Sat, 25 Jun 2022 17:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbiFYRxs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Jun 2022 13:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiFYRxr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Jun 2022 13:53:47 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE08FD00
        for <linux-raid@vger.kernel.org>; Sat, 25 Jun 2022 10:53:46 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id l2so4403720pjf.1
        for <linux-raid@vger.kernel.org>; Sat, 25 Jun 2022 10:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shenkin.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Q1anFBDzFQo0hJDDTOv0qIgRJGkxIp8gc0/1aSZZsK8=;
        b=kz8IvBbOlDVcjR+P4jTgLyj3kk6o+Ic3um/i3PrUMZMqtzmRyczjSdh58m0RFHv19t
         xjJA7rIdoTkBadWVQd28tFpfv4ZmalLwsXFG9F13vCZfX20J+802LXi3wDrW/1Uz1bNl
         QNHuT2n5/NioZ+t9Xdwgm9cTi0EQ1DLPiNzMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q1anFBDzFQo0hJDDTOv0qIgRJGkxIp8gc0/1aSZZsK8=;
        b=BzsKwNqH51V28jk+8VnLtVJeKXHaihJbdpsOGNAT3H2Q5w11iev+1PxB/W1DHldQmc
         t0yyW2HfDiHgUQ7bVcdlJjS8AcKz0rPBQYt3s4+WpzuXLAVnXBmLOmKago2F5waOAej7
         /YTP/OHTMug4KLL8etCfT+eoxulwOtmPzqVNRFxMDafhjmVBffUNYcPQhgeCe+0Jo3MA
         S0t9asWIr7wGEiAkRpnz70oAoTqz2SlgB/Ei6B+enBS5YcpkO2WWRuhw1/h8KDTNnp8q
         8iJn1v5BvUK7mJk+tq+J+mRyXKIawLUJujIuTagqv0VsgZhSLnQGt3z09kbIHZq+j6OL
         52cw==
X-Gm-Message-State: AJIora/H7F856AeicZTxfyT/RgEG2fp836ddG5JPFGtNiejTfCFCx8Lq
        z7pBgLWA0zw4N70ajqhdz45rwYhAxEaq7LCL
X-Google-Smtp-Source: AGRyM1sAUG9vLbQfnJBTESMN0jzg4Fh/r3I6zFHDtoma3vc6xpxhzq40LJjVjL/ENYBtBDhTWDIRvA==
X-Received: by 2002:a17:903:120c:b0:167:8847:21f2 with SMTP id l12-20020a170903120c00b00167884721f2mr5258199plh.11.1656179626103;
        Sat, 25 Jun 2022 10:53:46 -0700 (PDT)
Received: from [192.168.1.243] ([47.215.181.107])
        by smtp.googlemail.com with ESMTPSA id s9-20020a6550c9000000b00408af01cb42sm3841962pgp.81.2022.06.25.10.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jun 2022 10:53:45 -0700 (PDT)
Message-ID: <414a502b-dffd-d4cc-4eaa-579589877cee@shenkin.org>
Date:   Sat, 25 Jun 2022 10:53:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>, Stephan <linux@psjt.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
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
 <20220625030833.3398d8a4@nvm>
 <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
 <s6nh748amrs.fsf@blaulicht.dmz.brux>
 <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
 <a16b44a7-ae37-7775-24c8-436dcbe69ae8@shenkin.org>
 <cb10aa14-3a52-740c-4f6b-d7816cb31155@youngman.org.uk>
From:   Alexander Shenkin <al@shenkin.org>
In-Reply-To: <cb10aa14-3a52-740c-4f6b-d7816cb31155@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org




On 6/25/2022 10:43 AM, Wols Lists wrote:
> On 25/06/2022 18:38, Alexander Shenkin wrote:
>>
>> On 6/25/2022 10:10 AM, Wols Lists wrote:
>>> On 25/06/2022 14:35, Stephan wrote:
>>>>
>>>> Pascal Hambourg <pascal@plouf.fr.eu.org> writes:
>>>>
>>>>> Why 0.90 ? It is obsolete. If you need RAID metadata at the end of
>>>>> RAID members for whatever ugly reason, you can use metadata 1.0
>>>>> instead.
>>>>
>>>> Does mdraid with metadata 1 work on the root filesystem w/o initramfs?
>>>>
>>> If you're using v1.0, then you could boot off of one of the mirror 
>>> members no problem.
>>>
>>> You would point the kernel boot line at sda1 say (if that's part of 
>>> your mirror). IFF that is mounted read-only for boot, then that's not 
>>> a problem.
>>>
>>> Your fstab would then mount /dev/md0 as root read-write, and you're 
>>> good to go ...
>>>
>>> Cheers,
>>> Wol
>>
>> My metadata is 1.2... I presume that won't cause problems...
> 
> Do you need an initramfs to assemble raid ... I thought you did ... in 
> which case your system will not boot without one if your root is v1.2 ...
> 
> Cheers,
> Wol
I have no idea.  My system boots fine now.  Will any of this impact 
booting after the switch to a new CPU + motherboard?
