From: David Greaves <david@dgreaves.com>
Subject: Re: Convert raid5 to raid1?
Date: Fri, 11 Mar 2005 08:58:30 +0000
Message-ID: <42315DB6.5030604@dgreaves.com>
References: <4230BE56.6090905@advocap.org> <4230D279.5090101@wasp.net.au> <4230E003.4040609@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4230E003.4040609@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: John McMonagle <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John McMonagle wrote:

> Not saying its broke.

good :)

> Part of my reasoning to go to raid5 was that I could expand.

OK that is really quite hard.
Unless you run lvm2 over the top - in which case it's a doddle (though 
constraints apply)
I'd do it anyway (run lvm2). It causes almost no performance issues and 
you can then grow your fs later.
You could build a raid5 then linearly extend onto a raid0

> While it can be done I don't really see it as practical.
> Also it's looking like I probably will not need to expand.

Oh.

> raid5 with 3 drives and 1 spare
> or 2 - 2 drive raid1 drives have the same space.
> Which is less likely to have a failure cause data loss?
> I'm guessing raid1.
> If I'm wrong I'd like to know now.

A 4x raid5 gives 3X space and survives 1 disk failure (a spare can be 
added later)
A 2x raid1/raid0+2 gives 2X space and if 1 disk fails then there's a 1/3 
chance that a second failure will cause total failure.
A 3x raid5+1s gives 2X space and the ability for 2 simultaneous* disk 
failures
A 4x raid6 gives 2X space and the ability for 2 simultaneous** disk failures

* simultaneous here = apart from the few hours whilst a resync occurs - 
really I'm more interested in the lack of resilience during the few 
weeks whilst the RMA happens. Although I ended up with a spare 'cos I 
waited for a failure and bought a spare on next-day delivery whilst 
wrapping the failed disk for RMA

** really simultaneous

>
> Also concerned about the resync times. It was going to take a couple 
> days to resync under a rather light load if it weren't for the fact 
> that it couldn't because of a bad drive and a kernel panic caused by 
> the read error.

Hmm, took a few hours to resync 1Tb here. (maybe as much as overnight)

> Still not certain about the cause of problem my current guess is the 
> sata controller.

I run a 7 device SATA and it's81 stable (on 2.6.11.2 now).
I had a few minor problems a few months back but I think they've been 
sorted.

> I'm glad there is work being done on the resync issue.
> Also think the ideas to attempt to fix read errors are great.

Yes the "read error = kick disk" is still a significant failing :(

> My only suggestion is that there should be provision to send 
> notification when it happens

such as this one:

This is an automatically generated mail message from mdadm
running on cu.dgreaves.com

A Fail event had been detected on md device /dev/md0.

Faithfully yours, etc.


man madm
(or Debian sets it up automagically)

HTH

One other suggestion is to consider using lvm over 2 raid1 devices 
rather than md0/md1 - I think you'll find a lot more flexibility there.

David
