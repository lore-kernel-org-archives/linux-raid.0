Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54487C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 28 Nov 2021 21:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhK1V1D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Nov 2021 16:27:03 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:42525 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233848AbhK1VZC (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 28 Nov 2021 16:25:02 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mrRcG-0009El-5R; Sun, 28 Nov 2021 21:21:44 +0000
Message-ID: <f80d37f6-afb6-4080-d80d-7457a7d26b90@youngman.org.uk>
Date:   Sun, 28 Nov 2021 21:21:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: Nothing wrong, but is my website advice wonky?
Content-Language: en-GB
To:     John Stoffel <john@stoffel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <1c63e476-b253-cb17-3299-f9d09453ee19@youngman.org.uk>
 <12dd9f53-aab2-c487-9663-b799c2d0e8dd@youngman.org.uk>
 <24995.58211.78152.138025@quad.stoffel.home>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <24995.58211.78152.138025@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/11/2021 20:15, John Stoffel wrote:
>>>>>> "Wol" == Wol  <antlists@youngman.org.uk> writes:
> 
> Wol> Problem solved! My usual problem of missing the detail...
> 
> How was the problem solved?  Can you provide details on the before and
> after setup?  It should be trivial to test with loop back devices.
> 
> Wol> I'd described starting with a 2-drive mirror and converting it to
> Wol> a 3-drive raid-5. I was actually starting with a 2-active-1-spare
> Wol> mirror ...

So I converted it to raid-5, and because there were only two active 
drives, it carried on running as a degraded two-drive raid-5.

Once I brought the spare into service with --raid-devices=3, it started 
reshaping.

The website said to add the new drive and set raid-devices to three, I 
misread my own stuff and thought simply converting to raid-5 would bring 
in the spare.
> 
> So if you had removed the spare before hand, would it have jumped
> straight to a three drive RAID 5 setup? 

No - because I didn't tell it to use all three drives.

> And curious why you didn't
> goto RAID6?  RAID5 just makes me nervous these days, I don't trust it
> since drives tend to fail in waves.

Well, with two DVD drives and a floppy in an old chassis, I've only got 
room for three drives. Well, there should be room for four, but my 
drives are a bit too fat ... :-)

Plus (1) I've had no trouble so far with my drives (famous last words), 
(2) the drives are two new Ironwolves and an old Barracuda so I'm only 
likely to lose one so long as I keep an eye on things, and (3) all the 
drives have dm-integrity on them, so a corrupt drive should sort itself out.
> 
> But in my home system, I also mostly just mirror (or even triple
> mirror!) my important data for both speed and ease of recovery.
> 
The trouble with a plain mirror is if your data is corrupted ...

And if you've got raid you need to keep an eye on it. I'm planning to 
get an 8TB drive for backups ... probably configure it to snapshot once 
a week (I'm running lvm over raid over dm-integrity) and then use rsync 
to back up the volume over the network. Mind you I'm going to have to 
learn a lot of rsync - configure client/server and then get it to back 
up just the one file ...

Cheers,
Wol

> Wol> On 28/11/2021 09:25, Wols Lists wrote:
>>> Finally upgrading my system to raid-5 - two Seagate Ironwolves and a
>>> Barracuda ... :-(
>>>
>>> As per my own advice, I added the third drive as a spare, then grew the
>>> array to raid-5 in two separate commands.
>>>
>>> Trying to track what's going on, "cat /proc/mdstat" just shows two
>>> drives as sync'ing. "mdadm --detail" shows two active drives and a spare.
>>>
>>> The drives are quite clearly working away - as I would expect.
>>>
>>> So. What I *think* is happening is that my mirror is upgrading to a
>>> 2-disk raid-5, and when that's finished it will add the spare and
>>> upgrade to a full 3-disk raid-5. Does that sound right?
>>>
>>> What I *hoped* would happen (and thought *should* happen) was that it
>>> would spot the third drive, add it, and just resync straight away to
>>> full raid-5.
>>>
>>> So at 7 or 8hrs per pass (3TB per drive) I'm now looking at my upgrade
>>> taking about 15 hours. Whoops.
>>>
>>> So basically, does my scenario sound right? Would have explicitly
>>> changing raid-devices to 3 at the same time as converting to raid-5
>>> improved matters?
>>>
>>> Okay, I'm going to build a new raid-testing computer in the near future
>>> so testing this sort of thing will be easy, but that is predicated on me
>>> finding enough time without upsetting the wife ...
>>>
>>> Cheers,
>>> Wol
