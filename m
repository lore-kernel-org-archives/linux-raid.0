From: Alexander =?iso-8859-1?b?S/xobg==?= <alexander.kuehn@nagilum.de>
Subject: Re: unable to recover RAID 5 due to bad block
Date: Thu, 10 Nov 2011 17:20:03 +0100
Message-ID: <20111110172003.Horde.byVZeZk8pphOu-mzTQXxKL8@cakebox.homeunix.net>
References: <4EBBF60F.4030606@northfolk.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBBF60F.4030606@northfolk.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Chris Purves <chris@northfolk.ca>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

ddrescue to the rescue!
Get a another new disk, then ddrescue the one with the read error to  
the new disk.
Assemble the array using the new disk instead of the one with the read error.
You will loose the blocks that can't be read of course.
And in the future do run raid check/scrubbing at regular intervals. ;)
Alex.

Zitat von Chris Purves <chris@northfolk.ca>:

> Hello,
>
> I have a 5 disk RAID 5 where one of the disks died completely.  I  
> replaced the failed disk and added a new disk to the array.  While  
> it was rebuilding the new disk there was a read error on one of the  
> "good" disks that caused the disk to be reset by the controller and  
> the array was brought down.
>
> I can bring the array back up in degraded mode by running mdadm  
> --assemble --force /dev/md1; however, I have been unable to build  
> the fifth disk.  I would appreciate any help.
>
> -- 
> Chris Purves
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
