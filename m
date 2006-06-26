From: Neil Brown <neilb@suse.de>
Subject: Re: Is shrinking raid5 possible?
Date: Mon, 26 Jun 2006 17:41:44 +1000
Message-ID: <17567.36792.303403.35943@cse.unsw.edu.au>
References: <44960C45.9050407@anu.edu.au>
	<17558.10906.59066.196870@cse.unsw.edu.au>
	<449B3A80.4070602@tmr.com>
	<17563.17224.85968.572754@cse.unsw.edu.au>
	<bb145bd20606231116g7808e467w29a9bf273ba0df52@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christian Pernegger on Friday June 23
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 23, pernegger@gmail.com wrote:
> > Why would you ever want to reduce the size of a raid5 in this way?
> 
> A feature that would have been useful to me a few times is the ability
> to shrink an array by whole disks.
> 
> Example:
> 
> 8x 300 GB disks -> 2100 GB raw capacity
> 
> shrink file system, remove 2 disks =
> 
> 6x 300 GB disks --> 1500 GB raw capacity
> 

This is shrinking an array by removing drives.  We were talking about
shrinking an array by reducing the size of drives - a very different
think.

Yes, it might be sometimes useful to reduce the number of drives in a
raid5.  This would be similar to adding a drive to a raid5 (now
possible), but the data copy would have to go in a different
direction, so there would need to be substantial changes to the code.
I'm not sure it is really worth the effort I'm afraid, but it might
get done, one day, especially if someone volunteers some code ... ;-)

NeilBrown


> Why?
> 
> If you're not backed up by a company budget, moving data to an new
> array (extra / larger disks) is extremely difficult. A lot of cases
> will hold 8 disks but not 16, never mind the extra RAID controller.
> Building another temporary server and moving the data via Gigabit is
> slow and expensive as well.
> 
> Shrinking the array step-by-step and unloading data onto a regular
> filesystem on the freed disks would be a cheap (if time consuming) way
> to migrate, because the data could be copied back to the new array a
> disk at a time.
> 
> Thanks,
> 
> C.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
