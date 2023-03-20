Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CC9C7618A
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 08:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjCTIA7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 04:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjCTIA5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 04:00:57 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90D912F31
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 01:00:54 -0700 (PDT)
Received: from host81-156-202-200.range81-156.btcentralplus.com ([81.156.202.200] helo=[192.168.1.99])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1peARo-00084R-Eu;
        Mon, 20 Mar 2023 08:00:52 +0000
Message-ID: <46bab918-f683-d1e2-3409-46a2a03914d3@youngman.org.uk>
Date:   Mon, 20 Mar 2023 08:00:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Renaming md raid and moving md raid to a different machine.
To:     Ram Ramesh <rramesh2400@gmail.com>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
 <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
 <7037738d-05e3-b277-61ed-37f66cfdef7e@youngman.org.uk>
 <671da160-d5b3-8ed1-f7c1-672fa587ecad@gmail.com>
 <029ada0e-2b85-8999-007b-65f3bfdbc034@youngman.org.uk>
 <c4f58d3f-57a8-81ce-5a04-47744504a648@gmail.com>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <c4f58d3f-57a8-81ce-5a04-47744504a648@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20/03/2023 00:34, Ram Ramesh wrote:
> On 3/19/23 19:01, Wol wrote:
>> On 19/03/2023 23:29, Ram Ramesh wrote:
>>>>>    My primary DVR is old and I need to move it to more recent 
>>>>> hardware. I have two md raids (a raid1 and another raid6) called 
>>>>> /dev/md0 and /dev/md1. I plan to have root on the new machine on 
>>>>> raid1 and thus I like to rename my /dev/md0 to /dev/md1 in the old 
>>>>> machine before I move it to the new machine. After that I want to 
>>>>> move the disks in the most recommended way to minimize the chance 
>>>>> of loss.
>>>>
>>>> Do you have an mdadm.conf, or do the arrays auto-assemble without one?
>>> I have mdadm.conf and each md is named in that file.
>>>
>>> ARRAY /dev/md/1 metadata=1.2 name=zym:md1 
>>> UUID=0e9f76b5:4a89171a:a930bccd:78749144
>>> ARRAY /dev/md2  metadata=1.2 name=zym:2 
>>> UUID=d4e30060:d6395b41:dde52d2e:35ffa6fd
>>
>> Okay. May I suggest that
>>
>> (1) try getting rid of mdadm.conf - temporarily - and see if 
>> everything boots fine.
>>
>> (2) see if you can hard-rename (as in force an update to the metadata) 
>> the array to a named array eg something like "zym:data"
>>
>> If you can do (2), then (1) will boot and the array will come up as 
>> /dev/md/data.
>>
>> At which point you will be able to move the disks across and 
>> everything should "just work".
>>
>> Note that in the modern world your arrays should not be named md1, md2 
>> etc, as I said. The default numbers count down from - as I said - I 
>> think 127, and you're advised not to use numbers. I created my 
>> original arrays as 0, 1, 2 and promptly found they came back as 127, 
>> 126, and 125.
>>
>> I don't know whether advising you to "not have an mdadm.conf" is a 
>> good idea, but I've never had one, and storing things like array name 
>> in the metadata is much better than having it stored in an external file.
>>
>> And it means you won't have clashing names :-) Actually, if you use 
>> mdadm.conf to rename the arrays you're moving up to md3 or md4, see if 
>> they boot fine on the old system, and again you can then just dd your 
>> system across, then move the raid drives across, and you shouldn't 
>> have any problems.
>>
>> Cheers,
>> Wol
> 
> Yes the names must be in the metadata of the md because I populate 
> mdadm.conf after every change by actually using the output from mdadm 
> --detail -scan. Since that comes up with md0/md1/md2, I assume somehow 
> mdadm simply finds them again and again with exact same name.

Not necessarily. mdadm could (probably is) be reading mdadm.conf, 
building the array using the name in mdadm.conf, and then rebuilding 
mdadm.conf based on the name it got from mdadm.conf.
> 
> I do not ever get md127.
> 
If you boot with no mdadm.conf whatsoever? If that gives you md127, then 
you can rename the arrays on the old system by messing with mdadm.conf.

Also, it's just struck me, you're matching array to name using the UUID. 
So, assuming that's the array UUID (what else could it be) when you dd 
the root filesystem across and boot, that array should NOT be called 
md0, because the UUIDs won't match.

Cheers,
Wol
