From: coreyfro@coreyfro.com
Subject: Re: RAID5 crash and burn
Date: Sun, 31 Oct 2004 09:19:21 -0800 (PST)
Message-ID: <1990.63.204.219.3.1099243161.squirrel@63.204.219.3>
References: <1430.63.204.219.3.1099198742.squirrel@63.204.219.3>   
    <200410310518.i9V5ION22004@www.watkins-home.com>
    <1867.63.204.219.3.1099216777.squirrel@63.204.219.3>
    <4184CBE3.10801@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4184CBE3.10801@robinbowes.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hey everyone, I'll just get these all in one e-mail

First off, my disks had the following config each

2GB partition for mirrors (boot, backup, and upgrade mirrors)
256MB swap paritions
198GB RAID5 paritions

so, i had six swap partitons for a total of 1.5GB + .5GB of RAM

This is way more than I need, and now that I think about it, a bad idea. 
Swap was MAJORLY fast, but who cares, I rarely used it.

Because I used them all, I will be facing a slowdown, even with RAID1's
distributed read, but I don't really care...  I plan on Mirroring it three
ways, so I have two 256MB swap mirrors.  Overcompensating, I know.

What I was more concerned about was if people did it and it could be done.

> What other reasons are these (genuine question - I'm curious)

The other reasons for swap are these.

1. Linux caches all HDD activity.  Allowing Linux to use RAM for cache and
HDD for swap can actually speed up system with lots of RAM.  Now, linux
may never actualy swap anything if you have WAY too much (is there such a
thing?) RAM, but the point is still valid.
2. Linux isn't very good at memory clean up.  Unused pages in RAM may
never get flushed, or if they do, it requires actual processing (if forget
which) while unused pages in Swap just get forgotten.  This may lead to
guy's 100% CPU utilization, I don't know if the persons swap was full or
buggy or what, but it sounds like the arguement for using swap.  So, in
short, swap can be used as "/dev/null" for unused pages.
3. Disk be cheap.

There were more, but I forget

There was a big debate on the Linux Kernel forum between the "Use" and the
"Use nots" and the "Use" people made more good arguments, which the key
argument was "It can't hurt" (which isn't 100% true, but, its around
97.523423333_% true.)

========================================================================
For your reading pleasure

Linux: Is Swap Necessary?
http://kerneltrap.org/node/view/3202

