From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 08:35:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 11 Oct 2013, Guillaume Betous wrote:

> Hi all,
>
> Now my RAID is back thanks to all your precious advices, I want it to
> be as reliable as possible, knowing that I own "ordinary" hadrware :
> - standard PC (Atom based)
> - standard hard drives (some WD Red, but also Green, and Seagate
> without ERC capabilities)
> - standard need : NAS service, which aims at reliabily serve files for
> the whole local network (Gigabit).
>
> So, here is my current setup :
> - The RAID contains a spare disk
> - I set timeouts to 30" at every boot

I would recommend setting this to 180 seconds.

> - The default SCT ERC value is 7" on my two Red disks
> - I cron a check every week
>
> What other advice could be done *before* the failure happens ?

RAID6, preferrably with a spare.

Also save mdadm --examine and smartctl -a from all drives at each start 
(or at least after every time you've done a change to the array), so in 
case you get catastrophic superblock failure you can match roles and 
serial numbers of each drive.

I would also recommend having a recent enough kernel so you can do 
in-place replacement. I believe this is 3.3 and later.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
