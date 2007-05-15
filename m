From: Neil Brown <neilb@suse.de>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 21:12:21 +1000
Message-ID: <17993.38293.284914.403623@notabene.brown>
References: <4649760A.1060805@wpkg.org>
	<17993.34959.150157.200536@notabene.brown>
	<46498D34.1060901@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomasz Chmielewski on Tuesday May 15
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 15, mangoo@wpkg.org wrote:
> 
> Interesting lecture, thanks a lot. I'm gonna take that path.

:-)

> 
> I have one more question, though.
> 
> I want to migrate:
> - from 4x400GB HDD RAID-10
> - to 4x400GB HDD RAID-5
> 
> Obviously, I need 8 disks for that, but I have only 6.
> 
> So my idea was to kick one disk from RAID-10, and use it for RAID-5 for 
> the time of migration.
> 
> This means, I would have only 3 disks out of 4 in RAID-5 array.

Yes... that would work....  How much do you trust your drives, and how
much to do value your data?  Presumably 

  perceived likely hood of failure * value of data < price of 2 drives.

> 
> 
> Is it possible to create a degraded, 4 disk RAID-5 array with just 3 
> drives? I would add the 4th drive once migration from RAID-10 is done.

Certainly.  When you create the raid5, use the word "missing" in place
of the drive which is ... missing.  This will create a degraded
array.  You the drive becomes available, simply add it in to the
array.
If you drives are not identical (same number of sectors), make sure
the last drive you add is not the smallest, else you won't be able to
add it.

NeilBrown
