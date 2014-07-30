From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: On URE and RAID rebuild - again!
Date: Wed, 30 Jul 2014 13:13:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>
References: <53D8ACF0.1070202@assyoma.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53D8ACF0.1070202@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 30 Jul 2014, Gionatan Danti wrote:

> QUESTION n.1: Is this explanation correct?
> QUESTION n.2: URE define a probability or a statistical evidence?

There has been much discussion about the URE figures. Some people 
interpret it one way, others another way. There is nobody here that knows 
for sure. Ask your HDD vendor, if they answer, do share here!

> 3) From what I understand having read some other mails, in the case of URE 
> during RAID rebuild mdadm will _stop_ the rebuild and inform you of what 
> happened. However, you could re-start the array, remount it and try to 
> recover data via normal filesystem copy. If, and when, the filesystem will 
> try to read the data affected by URE, mdadm will report back to it a "read 
> error" and the filesystem can react as it want (re-try the copy, report back 
> to user, abort the copy, etc.)
> QUESTION n.3: is it what really happen on parity RAID (5,6)?
> QUESTION n.4: what about mirror-striped array as RAID10? They follow the same 
> behavior?

When MD encounters an URE, it should calculate that block from parity 
information and write it. I have personally had problems with this not 
happening, seems it might be that if the URE doesn't happen repeatedly, MD 
might not re-write. All parity raid levels should behave the same, so this 
should work identically for RAID1, RAID10, RAID5 and RAID6.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
