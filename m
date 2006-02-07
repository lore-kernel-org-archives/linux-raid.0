From: Neil Brown <neilb@suse.de>
Subject: Re: Question: read-only array
Date: Tue, 7 Feb 2006 20:18:36 +1100
Message-ID: <17384.26092.151307.152503@cse.unsw.edu.au>
References: <20060206174121.2b528f5f@mwdsp001.swissptt.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Osicki on Monday February 6
Sender: linux-raid-owner@vger.kernel.org
To: Chris Osicki <osk@admin.swisscom-mobile.ch>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday February 6, osk@admin.swisscom-mobile.ch wrote:
> 
> Hi
> 
> I've just noticed that setting an array readonly doesn't really make
> it readonly.
> 
> I have a RAID1 array and LVM on top of it.
> 
> When I run 
> 
> /sbin/mdadm --misc --readonly /dev/md0
> 
> /proc/mdstat shows:
> 
> Personalities : [raid1]
> md0 : active (read-only) raid1 sda[0] sdb[1]
>       160436096 blocks [2/2] [UU]
> 
> However, it doesn't prevent me from activating volume groups, mounting 
> filesystems and write files onto it.
> 
> Is it a bug, feature or my misunderstanding of the meaning of readonly flag?
> 

It should prevent you from mounting a filesystem writable directly on
the md array, but I can see from the code that it won't stop a lot of
other write accesses such as including it in an LVM set, or in an md
array, or (I think) simply opening it and writing to it.

Basically, the readonly 'policy' doesn't seem to be implemented very
uniformly in the kernel.

This is not something particular to md.  I suspect other devices that
are flagged 'readonly' will not always be treated the way you expect.

I've put it on my todo list to look into this some more, but I cannot
make any promises.

Thanks for the report.

NeilBrown


> 
> I use RedHat AS 4 (U1) on a dual core Opteron machine.
> Kernel 2.6.9-11.ELsmp as delivered with RH.
> 
> mdadm - v1.12.0 - 14 June 2005
> 
> Thanks for your time.
> 
> Regards,
> Chris
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
