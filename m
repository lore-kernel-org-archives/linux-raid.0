Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD24C7EE22
	for <linux-raid@archiver.kernel.org>; Sun,  7 May 2023 07:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjEGHgE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 7 May 2023 03:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjEGHgC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 7 May 2023 03:36:02 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB17A279
        for <linux-raid@vger.kernel.org>; Sun,  7 May 2023 00:35:59 -0700 (PDT)
Received: from host86-157-72-252.range86-157.btcentralplus.com ([86.157.72.252] helo=[192.168.1.99])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pvYw1-0002oz-5x;
        Sun, 07 May 2023 08:35:58 +0100
Message-ID: <b754545f-c505-71d9-6da0-2df8c607ae52@youngman.org.uk>
Date:   Sun, 7 May 2023 08:35:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Second of 3 drives in RAID5 missing
To:     Alex Elder <elder@ieee.org>, Hannes Reinecke <hare@suse.de>,
        linux-raid@vger.kernel.org
References: <d11acbac-a31b-b38c-8e10-b664ec52a47b@ieee.org>
 <7605c54f-670a-a804-b238-627cd561ce52@suse.de>
 <0b5a2849-90ec-573c-03ed-0847135a4e9d@youngman.org.uk>
 <8f046b28-f187-66d8-f67c-3e5821f66e92@ieee.org>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <8f046b28-f187-66d8-f67c-3e5821f66e92@ieee.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 07/05/2023 02:29, Alex Elder wrote:
> On 5/6/23 6:28 PM, Wol wrote:
>>
>>
>> On 06/05/2023 23:29, Hannes Reinecke wrote:
>>>>     Device Role : Active device 2
>>>>     Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
>>>> root@meat:/#
>>>>
>>> mdadm manage /dev/md127 --add /dev/sdd ?
>>
>> OMG NO!
>>
>> That really will trash your array ...
>>
>> Cheers,
>> Wol
> 
> This is why I sent the original message; I really
> want to avoid losing my data because of a dumb
> misunderstanding.  I did look at the Linux_Raid
> page on raid.wiki.kernel.org but was not confident
> I knew the right thing to do.  I'm very familiar
> (as a developer) with storage software, just not
> MD and the tools to manage its volumes.
> 
> I suspect that putting a proper MD superblock on the
> middle partition (sdc1, out of sd{b,c,d}1) might be
> enough to get it to assemble again.  After that I
> think I'll be able to rebuild the newly replaced
> drive and also rename it to /dev/md/z.
> 
> Is it an easy command?  Is any more information required?
> 
mdadm array --add /dev/sdc1

The reason I reacted with horror at the previous message is that 
/dev/sdd1 is already part of the array. Adding /dev/sdd (which is quite 
possible) would destroy /dev/sdd1 and you'd be left with only one 
working partition out of three - that's the array gone ...

Read the wiki on how to add a drive. I suspect that's where you went 
wrong in the first place. Make sure you've got the right drive to add - 
it said you had sdb1 and sdd1, so sdc1 is missing and that's the one you 
want to add (CHECK BEFORE YOU ADD). The kernel can move things around so 
make sure between booting and adding that nothing "weird" has happened.

Then you should be good to go. Just CHECK. And DOUBLE CHECK.

Cheers,
Wol

