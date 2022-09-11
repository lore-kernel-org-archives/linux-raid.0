Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9647AECAAD3
	for <linux-raid@archiver.kernel.org>; Sun, 11 Sep 2022 18:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiIKSev (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Sep 2022 14:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIKSet (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 11 Sep 2022 14:34:49 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6F7BC31
        for <linux-raid@vger.kernel.org>; Sun, 11 Sep 2022 11:34:46 -0700 (PDT)
Received: from host86-157-192-122.range86-157.btcentralplus.com ([86.157.192.122] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oXRNE-0006Js-Cq;
        Sun, 11 Sep 2022 19:08:05 +0100
Message-ID: <2bcebfce-6def-38f8-99be-1f5702905f94@youngman.org.uk>
Date:   Sun, 11 Sep 2022 19:08:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: 3 way mirror
Content-Language: en-GB
To:     Reindl Harald <h.reindl@thelounge.net>,
        Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
 <53f5754d-e3e2-a8ba-bedb-07eb2b594595@thelounge.net>
 <CAJH6TXi=pCvV2xcyWcOD4KVDP6BcoPdgdMqhSwyW9BMVEhtzYA@mail.gmail.com>
 <dcef59a2-b8f6-ef8b-2fd6-2c8bfdfba4ad@thelounge.net>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <dcef59a2-b8f6-ef8b-2fd6-2c8bfdfba4ad@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/09/2022 13:20, Reindl Harald wrote:
> 
> 
> Am 11.09.22 um 13:35 schrieb Gandalf Corvotempesta:
>> Il giorno dom 11 set 2022 alle ore 12:52 Reindl Harald
>> <h.reindl@thelounge.net> ha scritto:
>>> just throw it out of the array - on a RAID 1 with two disk you have
>>> still redundancy and i won't trust a disk which recognized that it has
>>> errors on it's own
>>
>> Why ? if it's just a single sector, the rest of the disk could be used
>> properly until the replacement.
> 
> i simply don't trust drives which have thrown errors
> you don't lose anything when you push it out of the array

That's called paranoia - ALL drives have hiccups when there's absolutely 
nothing wrong with them. What are the manufacturer's error figures? 
Expect at least one error every two or three complete passes of pretty 
much every large big disk nowadays?

What's the point of having thousands of spare sectors, if you chuck the 
drive in the trash at the first hint of trouble?
> 
>>> what's the point of "can i delay" when you have no other options? :-)
>>
>> The option is: i've ordered the new disk, it should arrive this thursday.
>> If i'm still on the safe side, i'll wait, if not, i'll replace with
>> the first disk I have here, even if slower
> 
> you are clearly on the safe side with 3 mirrors and every rebuild wears 
> out the remaining drives, 1 out of the 3 would be enough since they hold 
> identical data
> 
> /dev/sdd: GB Written: 94.134
> 
> pretty impossible that both sides of the same mirror will fail within a 
> few hours
> 
You clearly have no clue why London Buses arrive in threes ... :-)

Cheers,
Wol
