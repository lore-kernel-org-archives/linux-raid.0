From: Neil Brown <neilb@suse.de>
Subject: Re: Thoughts on using SSD
Date: Fri, 27 Mar 2009 15:37:23 +1100
Message-ID: <18892.22531.392563.258229@notabene.brown>
References: <49CC0B0D.5000904@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Thursday March 26
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday March 26, davidsen@tmr.com wrote:
> I'm building a fairly aggressive machine for both a backup host for 
> virtual machines and spare time development platform, compile engine and 
> testbed both. I want to get cost effective use from an SSD unit, and I 
> propose to use a 32GB unit as follows: for the root filesystem, 12GB, 
> which should hold all the usual root things, and 16GB for swap (12GB 
> RAM, and I want boot and/or hibernate to happen NOW). The remaining 
> space I think might be used for various high impact things, and one of 
> those with speeding raid.
> 
> If I were to create a small raid device, raid1, made of the 4GB Ssd and 
> 4GB of SATA space, if I made the SATA write-mostly and write-behind, and 
> put the journal for my raid arrays (and bitmaps?) that seems likely to 
> provide a significant performance gain in small storage.
> 
> Am I missing anything here? Is there an obvious drawback I'm missing?


I'd probably just put the journal on the SSD and mount my ext3
filesystem data=journal

That has a similar effect to raid1/write-behind in that data is
written to both but we only wait for the write to the SSD to
complete.  But as it is done at the filesystem level - and the
filesystem has a much better idea what it is doing - you would expect
to get much more efficient results.  e.g. less wasted memory, much
larger amount of data that is safe of SSD but still trickling out to
the HD.

I guess there might be a small lost in data safety as is the journal
device fails you lose your journal.  But that is only 5 seconds of
data, and I suspect SSDs don't suffer from many of the failure modes
of HDs.

.... I wonder if it would make sense to mirror two partitions of the
one SSD?? It would save you from media errors and only expose you to
total-drive-death errors.


NeilBrown
