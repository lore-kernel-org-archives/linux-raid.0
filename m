Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0108AC7619A
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 14:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjCTO4Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 10:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjCTO4B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 10:56:01 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BD3DBF6
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 07:54:01 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id q30so1750077oiw.13
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 07:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679324028;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kN45BwF8OFZJwE1iXHbUk40Ipr7bsnobVCNQZIp5skM=;
        b=XumhpbFTm8a9ZQsLwy6cgury8RD8F/0I186R9x4TnyRt/NzQakqtujMEospgZLb0L4
         KenfdxcBIb9Nl6UWqH1PGYdBy4XjG4Te0xN9PjmGncey/h3GoLgtl461gSV9i5CKvLkK
         0k/xtWB7BllJPUf+YEtTWM3eT/MYdChMMFxZIyqoKVXcpE4Z7LPM71YIVqALu0yKSSjr
         FpxhpT14E5BBM5GMVBccEavHplWIeCo9tJAv+BV7CMHrpaUyD6riLzfUV+176U3X8VEY
         BGkoITLi+jzyfcmcTdGDS4n7oAFz5r/W52dYzJCQADGLHfU4SDgQ85OebQFoAHadX9Yy
         jXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679324028;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kN45BwF8OFZJwE1iXHbUk40Ipr7bsnobVCNQZIp5skM=;
        b=ulGVzSeQYKL/3lM+q5r0r5q8ktwY54qs1qJEfUK5mPJWZ9dHznQU8fnr+fr3UYrB0r
         ZnQNhRtHAtp+Gar3gza/ToY2Rj1NkieXugv21nqDycDtwJmwQBa6hXgnLxHXmCEWCYED
         ZSSINkc8g9VrrB+H07yV1Yt6+snFplOxhC80PfAQEjA7w0pxBGoHX11MQuZjbv4I+25s
         JmhEUX/jHdXvU8IXEs3w0tnArwhzEIdHLnj8bZtNrrUVCmGO6g8wQAFiBh3KYrXvgA+e
         72pz8uP66EwTz1viuweYMJFMkE9yHXQ0skGXNjVsKp/CvfiqBFcld/SEvwZTPtzqTPK6
         iNcg==
X-Gm-Message-State: AO0yUKXzgVEfBhfYTPO/f3DB4sXKNZuhWqSJlIkJvJz8hpg5+y8lso3+
        ea8n8ROOmJitT+iP6Sk3I98=
X-Google-Smtp-Source: AK7set8FYXRiKoqvugaTBp5bUDaqTZUSEiB/hMGXa1tOiOHruBUamph9b01PadczXhS6tpGEHVPhow==
X-Received: by 2002:a05:6808:256:b0:364:c9b7:bc with SMTP id m22-20020a056808025600b00364c9b700bcmr9188285oie.56.1679324028057;
        Mon, 20 Mar 2023 07:53:48 -0700 (PDT)
Received: from [192.168.3.92] ([47.189.247.51])
        by smtp.gmail.com with ESMTPSA id d6-20020a056830004600b0069451a9274bsm4055761otp.28.2023.03.20.07.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 07:53:47 -0700 (PDT)
Message-ID: <a8e3587b-63ef-2a80-df36-d81653f4e338@gmail.com>
Date:   Mon, 20 Mar 2023 09:53:47 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Renaming md raid and moving md raid to a different machine.
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
 <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
 <7037738d-05e3-b277-61ed-37f66cfdef7e@youngman.org.uk>
 <671da160-d5b3-8ed1-f7c1-672fa587ecad@gmail.com>
 <029ada0e-2b85-8999-007b-65f3bfdbc034@youngman.org.uk>
 <c4f58d3f-57a8-81ce-5a04-47744504a648@gmail.com>
 <46bab918-f683-d1e2-3409-46a2a03914d3@youngman.org.uk>
From:   Ram Ramesh <rramesh2400@gmail.com>
In-Reply-To: <46bab918-f683-d1e2-3409-46a2a03914d3@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/20/23 03:00, Wols Lists wrote:
> On 20/03/2023 00:34, Ram Ramesh wrote:
>> On 3/19/23 19:01, Wol wrote:
>>> On 19/03/2023 23:29, Ram Ramesh wrote:
>>>>>>    My primary DVR is old and I need to move it to more recent 
>>>>>> hardware. I have two md raids (a raid1 and another raid6) called 
>>>>>> /dev/md0 and /dev/md1. I plan to have root on the new machine on 
>>>>>> raid1 and thus I like to rename my /dev/md0 to /dev/md1 in the old 
>>>>>> machine before I move it to the new machine. After that I want to 
>>>>>> move the disks in the most recommended way to minimize the chance 
>>>>>> of loss.
>>>>>
>>>>> Do you have an mdadm.conf, or do the arrays auto-assemble without one?
>>>> I have mdadm.conf and each md is named in that file.
>>>>
>>>> ARRAY /dev/md/1 metadata=1.2 name=zym:md1 
>>>> UUID=0e9f76b5:4a89171a:a930bccd:78749144
>>>> ARRAY /dev/md2  metadata=1.2 name=zym:2 
>>>> UUID=d4e30060:d6395b41:dde52d2e:35ffa6fd
>>>
>>> Okay. May I suggest that
>>>
>>> (1) try getting rid of mdadm.conf - temporarily - and see if 
>>> everything boots fine.
>>>
>>> (2) see if you can hard-rename (as in force an update to the 
>>> metadata) the array to a named array eg something like "zym:data"
>>>
>>> If you can do (2), then (1) will boot and the array will come up as 
>>> /dev/md/data.
>>>
>>> At which point you will be able to move the disks across and 
>>> everything should "just work".
>>>
>>> Note that in the modern world your arrays should not be named md1, 
>>> md2 etc, as I said. The default numbers count down from - as I said - 
>>> I think 127, and you're advised not to use numbers. I created my 
>>> original arrays as 0, 1, 2 and promptly found they came back as 127, 
>>> 126, and 125.
>>>
>>> I don't know whether advising you to "not have an mdadm.conf" is a 
>>> good idea, but I've never had one, and storing things like array name 
>>> in the metadata is much better than having it stored in an external 
>>> file.
>>>
>>> And it means you won't have clashing names :-) Actually, if you use 
>>> mdadm.conf to rename the arrays you're moving up to md3 or md4, see 
>>> if they boot fine on the old system, and again you can then just dd 
>>> your system across, then move the raid drives across, and you 
>>> shouldn't have any problems.
>>>
>>> Cheers,
>>> Wol
>>
>> Yes the names must be in the metadata of the md because I populate 
>> mdadm.conf after every change by actually using the output from mdadm 
>> --detail -scan. Since that comes up with md0/md1/md2, I assume somehow 
>> mdadm simply finds them again and again with exact same name.
> 
> Not necessarily. mdadm could (probably is) be reading mdadm.conf, 
> building the array using the name in mdadm.conf, and then rebuilding 
> mdadm.conf based on the name it got from mdadm.conf.
>>
>> I do not ever get md127.
>>
> If you boot with no mdadm.conf whatsoever? If that gives you md127, then 
> you can rename the arrays on the old system by messing with mdadm.conf.
> 
> Also, it's just struck me, you're matching array to name using the UUID. 
> So, assuming that's the array UUID (what else could it be) when you dd 
> the root filesystem across and boot, that array should NOT be called 
> md0, because the UUIDs won't match.
> 
> Cheers,
> Wol

I avoid UUID issues for rootfs by image copying partitions across the 
systems. I always have two installation in any each machine in two 
different partitions. One natively installed using distros USB (safeos) 
and one that is transferred from old system using image copy (masteros). 
This way I have a back up OS to boot and fix any mistakes I make.

I boot safeos and make the image copy of masteros. Mount copied system 
root, fix things like hostname, NIC name etc. I also fix 
fstab/mdadm.conf and a few other things that will cause errors when I 
boot that system.

After that I update-grub to add masteros to safeos bootmeny and reboot 
into masteros and update-grub and update-initramfs -u on the masteros, 
and reboot back into masteros. Now I start fixing any missing pieces. 
BTW, I did have md127 when I first booted masteros and it went back to 
/dev/md0 after I updated initramfs on masteros and rebooted. This, 
incidentally matches the note Reindl made.

I can give you more details, if that will help understand better what I 
have. This I do because I understand unix side and not mythtv side 
enough to fix issues on the latter. So, I always make image copies to 
keep mythtv happy. After all that is the purpose of this system.

Regards
Ramesh



