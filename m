Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C00C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  1 Apr 2022 21:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350944AbiDAVEK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Apr 2022 17:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239280AbiDAVEJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Apr 2022 17:04:09 -0400
X-Greylist: delayed 4628 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Apr 2022 14:02:18 PDT
Received: from mail-out-auth1.hosts.co.uk (mail-out-auth1.hosts.co.uk [195.7.255.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8321F6F0E
        for <linux-raid@vger.kernel.org>; Fri,  1 Apr 2022 14:02:18 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1naOPQ-00048I-6R;
        Fri, 01 Apr 2022 22:02:17 +0100
Message-ID: <0955d209-ab2b-dc20-a9fb-ad15c09eb884@youngman.org.uk>
Date:   Fri, 1 Apr 2022 22:02:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Trying to rescue a RAID-1 array
Content-Language: en-GB
To:     bruce.korb+reply@gmail.com
Cc:     linux-raid@vger.kernel.org
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
 <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
 <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
 <776f85f6-33a2-f226-f6ff-09e736ccefd1@youngman.org.uk>
 <CAKRnqNL0aNWGHFgcz-KVKn3dpVpUa1oN5miu+oiv16vdJx3OHw@mail.gmail.com>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <CAKRnqNL0aNWGHFgcz-KVKn3dpVpUa1oN5miu+oiv16vdJx3OHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 01/04/2022 21:23, Bruce Korb wrote:
>> Because if it did your data is probably toast, but if it didn't we might
>> be home and dry.

> If I can figure out how to mount it (read only), then I can see if a
> new FS was installed.
> If it wasn't, then I've got my data.
> 
That looks promising then. It looks like your original array may have 
been v1.0 too ... a very good sign.

Read up on loopback devices - it's in the wiki somewhere on recovering 
your raid ...

What that does is you stick a file between between the file system and 
whatever's running on top, so linux caches all your writes into the file 
and doesn't touch the disk.

Let's hope xfs_recover didn't actually write anything or we could be in 
trouble.

The whole point about v1.0 is - hallelujah - the file system starts at 
the start of the partition!

So now you've got loopback sorted, FORGET ABOUT THE RAID. Put the 
loopback over sdc1, and mount it. If it needs xfs_recover, because 
you've got the loopback, you can let it run, and hopefully it will not 
do very much.

IFF the wind is blowing in the right direction (and there's at least a 
decent chance), you've got your data back!

If it all goes pear shaped, it may well still be recoverable, but I'll 
probably be out of ideas. But the loopback will have saved your data so 
you'll be able to try again.

Oh - and if it looks sort-of-okay but xfs_recover has trashed sdc1, at 
least try the same thing with sde1. You stand a chance that xfs_recover 
only trashed one drive and, the other being an exact copy, it could have 
survived and be okay.

Cheers,
Wol
