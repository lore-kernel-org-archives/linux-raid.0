From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: no journaling and loops on softraid?
Date: Wed, 07 Mar 2007 11:49:09 -0500
Message-ID: <45EEED05.5030600@tmr.com>
References: <200703052355.15363.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200703052355.15363.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore wrote:
> http://gentoo-wiki.com/HOWTO_Gentoo_Install_on_Software_RAID#Data_Scrubbing
>
> "Warning: Be aware that the combination of RAID5 and loop-devices will most 
> likely cause severe filesystem damage, especially when using ext3 and 
> ReiserFS. Some users suggest that XFS is not affected by this, but this has 
> not been entirely confirmed. See kernel bug 6242 for updates on this bug.
>
> Note: There are also reports that Journaled Filesystems are problematic on all 
> Software-RAID levels. No kernel bugs have been submitted regarding this bug 
> as of yet. A number of the reports involve using cryptoloops which are known 
> to cause corruption. See http://forums.gentoo.org/viewtopic-t-412467.html for 
> more information. This thread should be taken with a grain of salt."
>
> Can someone shed some light on this? I have XFS on my raid and *had* problems 
> when unpacking large archives with many small files.
>   

To start, the report mentions a number of unrelated layers, evms, 
dm-crypt, and some total misinformation, claiming that evms is needed to 
allow growing of raid. I can't speak to XFS over RAID, I've seen report 
of XFS problems on native partitions, and just don't have enough 
information to have a good opinion.

But I have been running ext3 over RAID1 and RAID5 for years, and just 
haven't seen the problems you mention, or anything else which concerns 
me. There were recovery issues in early kernels, but I have no reason to 
think that there's any basic problem at this point. Reports of problems 
often outlive the problem, and problems with multiple layers of device 
manipulation you increase the chance of failure, because a chain is as 
strong as the weakest link, and decrease the chances if identifying 
which layer is actually a problem. If you have any hardware issues, you 
now depend on every layer not only handling them, but passing them up 
and down layers.

I have put lvm over raid, but even that would be an issue to debug. I 
would simplify if I had your problem.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

