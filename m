From: Juri Haberland <list-linux.raid@spoiled.org>
Subject: Re: Missing capacity in a RAID 5 array?
Date: Thu, 6 May 2004 10:18:07 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <news2mail-c7d3cv$bpa$1@cartman.spoiled.org>
References: <4099D554.808@jmorrow.org>
Reply-To: Juri Haberland <juri@koschikode.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Morrow <jmorrow@jmorrow.org> wrote:
> I've created a software RAID 5 array consisting of 8 160 GB drives.  One 
> of the drives had prior data I wanted to keep, so I first created a 
> 7-drive array, copied the data from the original drive to the array, 
> then added the 8th drive using raidreconf.  Worked like a charm (took 
> about 27 hours, though!)
> 
> The OS now reports that the total capacity on /dev/md0 is about 920 GB:
> 
> /dev/md0             923029884 172872252 750157632  19% /mnt/store
> 
> Now, even if we take into account that the drives are 160 decimal GB, 
> which equates to 149 binary GB, my array should still have a total 
> capacity somewhere around 7 x 149 = 1043 GB.
> 
> Am I really losing 120 GB to reserved space for RAID and/or filesystem 
> accounting?  I feel like I'm missing something obvious here.  Can I get 
> my full terabyte somehow?

So you created a RAID5 array out of 7 disk. The capacity of a RAID5
array of equally sized disk can be calculated like this:
total_size = (n -1) * single_disk_size
which calculates to a total size of 894MB - 960MB (depending on how you
calculate a MegaByte).
The extra disk that you added is most certainly now seen as a spare disk
which adds now capacity to the array, just a instant replacement in case
of failures.

What you should have done:
Create a degraded RAID5 array out of 8 drives with the 8th one marked as
missing/failed. Then copy all the data from the 8th drive to the array.
After this hot-add the 8th drive to degraded array and let it rebuild.

Regards,
Juri

-- 
Juri Haberland  <juri@koschikode.com> 

