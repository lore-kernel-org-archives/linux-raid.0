Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF73DECAAD8
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 19:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiIMTxm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 15:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiIMTxl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 15:53:41 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E7B6BCFC
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 12:53:40 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MRvKY3s21zXLb;
        Tue, 13 Sep 2022 21:53:37 +0200 (CEST)
Message-ID: <9c425005-ea35-6260-a476-4bf1fc6a941f@thelounge.net>
Date:   Tue, 13 Sep 2022 21:53:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: change UUID of RAID devcies
Content-Language: en-US
To:     Wol <antlists@youngman.org.uk>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <2341a2a9-b86e-f0e5-784a-05dbd474dec5@thelounge.net>
 <729bdc01-b0ae-887a-6d2a-5135d287636c@youngman.org.uk>
 <05a1161b-d798-c68f-d37c-a9fc373c6e73@thelounge.net>
 <0023fefe-aad1-e692-48dd-e354497f6e41@plouf.fr.eu.org>
 <1fb05e0f-34b7-3ec4-bc00-ec540e592f19@thelounge.net>
 <15fabdc2-b5d1-785d-b082-765d0650f475@youngman.org.uk>
 <46df9e38-e842-1b4a-2491-52961c42aefc@thelounge.net>
 <d6f7f391-ba1a-8afb-48b6-57ddb620c7c1@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <d6f7f391-ba1a-8afb-48b6-57ddb620c7c1@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 13.09.22 um 21:44 schrieb Wol:
> On 13/09/2022 19:03, Reindl Harald wrote:
>>
>>
>> Am 13.09.22 um 19:39 schrieb Wols Lists:
>>> On 13/09/2022 12:12, Reindl Harald wrote:
>>>>
>>>> "For example, you cannot create 3TB or 4TB partition size (RAID 
>>>> based) using the fdisk command. It will not allow you to create a 
>>>> partition that is greater than 2TB" makes me nervous
>>>>
>>>> how to get a > 3 TB partition for /dev/md2
>>>>
>>>> --------------------
>>>>
>>>> and finally how would the command look for "Then with just two 
>>>> drives you change the raid to raid-1"?
>>>>
>>>> the first two drives are ordered to start with 1 out of 4 machines 
>>>> ASAP given that the machine in front of me is running since 2011/06 
>>>> 365/24......
>>>
>>> Dare I suggest you read the raid wiki site?
>>>
>>> In particular
>>> https://raid.wiki.kernel.org/index.php/Setting_up_a_(new)_system
>>> https://raid.wiki.kernel.org/index.php/Converting_an_existing_system
>>>
>>> Also a very good read ...
>>> https://raid.wiki.kernel.org/index.php/System2020
>>> Which is the system I'm typing this on.
>>>
>>> These pages don't all jibe with what I remember writing, but read 
>>> them carefully, make sure you understand what is going on, and more 
>>> importantly WHY, and you should be good to go.
>>>
>>> And when you're wondering how to go from the 4-drive raid-10 to the 
>>> 2-drive raid-1, you should be able to just fail/remove the two small 
>>> drives and everything will migrate to your two new big drives, and 
>>> then it's just whatever the command is to convert between raid 
>>> levels. The drives will already be in a raid-1 layout, so converting 
>>> from 10 to 1 will just be a change of metadata
>>
>> if it's that easy why aren't mdadm doing it?
>>
>> [root@testserver:~]$ mdadm /dev/md0 --grow --level=1
>> mdadm: RAID10 can only be changed to RAID0
>>
>> virtual machine with two drives replaced against double sized
> 
> Hmm...
> 
> I don't know. I'll have to defer to the experts, but a raid-10 across 
> two drives has to be a plain mirror in order to provide redundancy.
> 
> So I don't know why it doesn't just change the array definition, because 
> the on-disk layout *should* be the same ...

not really - RAID 10 have stripes and it likely ends in having the data 
on both disk at different places
