Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F28C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 31 Mar 2022 21:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241886AbiCaVgJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 17:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbiCaVgI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 17:36:08 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EEA50E3A
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 14:34:19 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1na2Qr-0005uF-5x;
        Thu, 31 Mar 2022 22:34:18 +0100
Message-ID: <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
Date:   Thu, 31 Mar 2022 22:34:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Trying to rescue a RAID-1 array
Content-Language: en-GB
To:     bruce.korb+reply@gmail.com
Cc:     linux-raid@vger.kernel.org
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
 <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 31/03/2022 19:14, Bruce Korb wrote:
> On Thu, Mar 31, 2022 at 10:06 AM Wols Lists <antlists@youngman.org.uk> wrote:
>>
>> On 31/03/2022 17:44, Bruce Korb wrote:
>>> I moved the two disks from a cleanly shut down system that could not
>>> reboot and could not
>>> be upgraded to a new OS release. So, I put them in.a new box and did an install.
>>> The installation recognized them as a RAID and decided that the
>>> partitions needed a
>>> new superblock of type RAID-0.
>>
>> That's worrying, did it really write a superblock?
> 
> Yep. That worried me, too. I did the command to show the RAID status of the two
> partitions and, sure enough, both partitions were now listed as RAID0.
> 
>>> Since these data have never been
>>> remounted since the
>>> shutdown on the original machine, I am hoping I can change the RAID
>>> type and mount it
>>> so as to recover my. .ssh and .thunderbird (email) directories. The
>>> bulk of the data are
>>> backed up (assuming no issues with the full backup of my critical
>>> data), but rebuilding
>>> and redistributing the .ssh directory would be a particular nuisance.
>>>
>>> SO: what are my options? I can't find any advice on how to tell mdadm
>>> that the RAID-0 partitions
>>> really are RAID-1 partitions. Last gasp might be to "mdadm --create"
>>> the RAID-1 again, but there's
>>> a lot of advice out there saying that it really is the last gasp
>>> before giving up. :)
>>>
>>
>> https://raid.wiki.kernel.org/index.php/Asking_for_help
> 
> Sorry about that. I have two systems: the one I'm typing on and the one
> I am trying to bring up. At the moment, I'm in single user mode building
> out a new /home file system. mdadm --create is 15% done after an hour :(.
> It'll be mid/late afternoon before /home is rebuilt, mounted and I'll be
> able to run display commands on the "old" RAID1 (or 0) partitions.
> 
>> Especially lsdrv. That tells us a LOT about your system.
> 
> Expect email in about 6 hours or so. :) But openSUSE doesn't know
> about any "lsdrv" command. "cat /proc/mdstat" shows /dev/md1 (the
> RAID device I'm fretting over) to be active, raid-0 using /dev/sdc1 and sde1.

Well, the webpage does tell you where to download it from - it's not 
part of the official tools, and it's a personal thing that's damn useful.
> 
>> What was the filesystem on your raid? Hopefully it's as simple as moving
>> the "start of partition", breaking the raid completely, and you can just
>> mount the filesystem.
> 
> I *think* it was EXT4, but. it might be the XFS one. I think I let it default
> and openSUSE appears to prefer the XFS file system for RAID devices.
> Definitely one of those two. I built it close to a decade ago, so I'll be moving
> the data to the new /home array.
> 
>> What really worries me is how and why it both recognised it as a raid,
>> then thought it needed to be converted to raid-0. That just sounds wrong
>> on so many levels. Did you let it mess with your superblocks? I hope you
>> said "don't touch those drives"?
> 
> In retrospect, I ought to have left the drives unplugged until the install was
> done. The installer saw that they were RAID so it RAID-ed them. Only it
> seems to have decided on type 0 over type 1. I wasn't attentive because
> I've upgraded Linux so many times and it was "just done correctly" without
> having to give it a lot of thought. "If only" I'd thought to back up
> email and ssh.
> (1.5TB of photos are likely okay.)
> 
> Thank you so much for your reply and potentially help :)
> 
If it says the drive is active ...

When you get and run lsdrv, see if it finds a filesystem on the raid-0 - 
I suspect it might!

There's a bug, which should be well fixed, but it might have bitten you. 
It breaks raid arrays. But if the drive is active, it might well mount, 
and you will be running a degraded mirror. Mount it read-only, back it 
up, and then see whether you can force-assemble the two bits back 
together :-)

But don't do anything if you have any trouble whatsoever mounting and 
backing up.

Cheers,
Wol
