Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC06AC7618A
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 00:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjCTAep (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 20:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCTAeo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 20:34:44 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8274849FB
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 17:34:43 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id x24-20020a4aca98000000b0053a9bbbe449so607060ooq.9
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 17:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679272483;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mjpS6iIjP+bfWVAUsSg/ByBh0/3Ichqt56T7xNMjeps=;
        b=d15ln6rfpU4QiACiOUGJO5TVRHyW5jIOCsIpHURDBMsYyN6BOrWhItrkW78S252czN
         w/VNs998uquaday17aUH7AGc5BJpSBYP5FAW9dQo5vdE5fl9cLk66ULeCo8sCeChzg0P
         wU8tiNhl9wi1LAPV13z5Lq1Uw+ldqA1mCFTz1C3gKfPJti0tbSFFRBGA6CKdiXxVvA9B
         jme7n/66W4iJKHV2z+kVqBzUTp1YD7II+pd6X3BekcnpP9NH1klWQY/ia+gqs4D2hxzj
         QDdiRwqC+jcLcetdreKAkMHMl+KlM2l5qbBwPlFqj86geG0E3S9hS/oIXr0f7acIuRHi
         j7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679272483;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mjpS6iIjP+bfWVAUsSg/ByBh0/3Ichqt56T7xNMjeps=;
        b=IU6xIDZlA5zo+mGnT25c6w1OBgJKkqxMSYd45ULAn0wtqLc7yr3SJJlA4aPjtMB8KN
         sbKUEOmETowipdJjUhaup/69PHre2jPDFNGpOlxKLhNrR/8BRiQFUldQoDuIgATlzLvy
         PrxrERm11FBe9/S5mHyz4fEa+8r3wHNOu2qMwVCism+biwYMEDfQcCK7lOWek3Zmf2nq
         4r0L/lvNhqV+ah9fFCQhCtQZLVvfMlOqtAD7WYMlieBH850N14361UFWK5diH2HBWdie
         6QZPHq1LgY6Q8NZUBnfblo3TnAFyikzFLoB/QorvS0kRDsUgP9anr37z6I7Wn191wYnt
         3cTA==
X-Gm-Message-State: AO0yUKWJa00H4h2lj85qdDr7XaIgMt63U8Gaw4HzH4nqsMqWwQqgYVH3
        SChz+uEF/qPOfwwyTVE9nGHDyN83V4c=
X-Google-Smtp-Source: AK7set+/V5f7rBHEg9wDPDMe91/XiNm1PvGkjFXpOS2kCU/WgjQWmBr9oefeNPgw60Y9Vu0+H3qLXg==
X-Received: by 2002:a4a:4117:0:b0:538:243:2191 with SMTP id x23-20020a4a4117000000b0053802432191mr2735477ooa.7.1679272482807;
        Sun, 19 Mar 2023 17:34:42 -0700 (PDT)
Received: from [192.168.3.92] ([47.189.247.51])
        by smtp.gmail.com with ESMTPSA id s2-20020a4a5102000000b005252e5b6604sm3291967ooa.36.2023.03.19.17.34.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Mar 2023 17:34:42 -0700 (PDT)
Message-ID: <c4f58d3f-57a8-81ce-5a04-47744504a648@gmail.com>
Date:   Sun, 19 Mar 2023 19:34:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Renaming md raid and moving md raid to a different machine.
Content-Language: en-US
To:     Wol <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
 <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
 <7037738d-05e3-b277-61ed-37f66cfdef7e@youngman.org.uk>
 <671da160-d5b3-8ed1-f7c1-672fa587ecad@gmail.com>
 <029ada0e-2b85-8999-007b-65f3bfdbc034@youngman.org.uk>
From:   Ram Ramesh <rramesh2400@gmail.com>
In-Reply-To: <029ada0e-2b85-8999-007b-65f3bfdbc034@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/19/23 19:01, Wol wrote:
> On 19/03/2023 23:29, Ram Ramesh wrote:
>>>>    My primary DVR is old and I need to move it to more recent 
>>>> hardware. I have two md raids (a raid1 and another raid6) called 
>>>> /dev/md0 and /dev/md1. I plan to have root on the new machine on 
>>>> raid1 and thus I like to rename my /dev/md0 to /dev/md1 in the old 
>>>> machine before I move it to the new machine. After that I want to 
>>>> move the disks in the most recommended way to minimize the chance of 
>>>> loss.
>>>
>>> Do you have an mdadm.conf, or do the arrays auto-assemble without one?
>> I have mdadm.conf and each md is named in that file.
>>
>> ARRAY /dev/md/1 metadata=1.2 name=zym:md1 
>> UUID=0e9f76b5:4a89171a:a930bccd:78749144
>> ARRAY /dev/md2  metadata=1.2 name=zym:2 
>> UUID=d4e30060:d6395b41:dde52d2e:35ffa6fd
> 
> Okay. May I suggest that
> 
> (1) try getting rid of mdadm.conf - temporarily - and see if everything 
> boots fine.
> 
> (2) see if you can hard-rename (as in force an update to the metadata) 
> the array to a named array eg something like "zym:data"
> 
> If you can do (2), then (1) will boot and the array will come up as 
> /dev/md/data.
> 
> At which point you will be able to move the disks across and everything 
> should "just work".
> 
> Note that in the modern world your arrays should not be named md1, md2 
> etc, as I said. The default numbers count down from - as I said - I 
> think 127, and you're advised not to use numbers. I created my original 
> arrays as 0, 1, 2 and promptly found they came back as 127, 126, and 125.
> 
> I don't know whether advising you to "not have an mdadm.conf" is a good 
> idea, but I've never had one, and storing things like array name in the 
> metadata is much better than having it stored in an external file.
> 
> And it means you won't have clashing names :-) Actually, if you use 
> mdadm.conf to rename the arrays you're moving up to md3 or md4, see if 
> they boot fine on the old system, and again you can then just dd your 
> system across, then move the raid drives across, and you shouldn't have 
> any problems.
> 
> Cheers,
> Wol

Yes the names must be in the metadata of the md because I populate 
mdadm.conf after every change by actually using the output from mdadm 
--detail -scan. Since that comes up with md0/md1/md2, I assume somehow 
mdadm simply finds them again and again with exact same name.

I do not ever get md127.

Regards
Ramesh

