From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: help: re-add needed after each reboot
Date: Tue, 15 May 2012 09:27:41 -0400
Message-ID: <4FB259CD.5070802@tmr.com>
References: <5d1b39dd26f138ed494e779218d21346.squirrel@anguish.kchang.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d1b39dd26f138ed494e779218d21346.squirrel@anguish.kchang.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

D. Lin wrote:
> Hi,
>
> I am running 3.2.0 (ubuntu 12.04). My raid5 has 3 disks (sd[cbd]1) and no
> spares. The system boots off a non-raid device and auto discovers and
> mounts the raid device.
>
> For some reason, sdc1 is not automatically detected and is always missed
> on each boot. I have to re-add it back. What could be causing this?
>
> This did not happen while I was running 2.6.38.
>
Unless you can get back to that kernel and the problem goes away, that's likely 
to be irrelevant.

If this only happens on power cycle I would suspect a slow spin-up on one drive, 
otherwise that's not it. Be any chance is that drive, and only that drive, set 
to spin down when not in use?

Check partition types. That shouldn't be an issue, but check anyway.

Have you run SMART on the drives? Ignore this idea if you don't see the problem 
when booting off the old kernel. Just because you changed software and the 
problem occurred, don't completely rule out hardware, or a subtle config problem.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
