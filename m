From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Missing capacity in a RAID 5 array?
Date: Thu, 06 May 2004 10:12:26 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4099D74A.20103@wasp.net.au>
References: <4099D554.808@jmorrow.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4099D554.808@jmorrow.org>
To: Jeff Morrow <jmorrow@jmorrow.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Morrow wrote:
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

What filesystem are you using and how much space does it reserve for Root?
Plus, how much space does the filesystem metadata take up? Perhaps reduce the number of inodes to 
reclaim some space (Can't do that once there is data on there though)


On my 2.1TB I told mke2fs not to reserve any space for root as I was going to lose about 105MB.

Regards,
Brad
