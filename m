From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: quick help needed - smaller disk in raid5?
Date: Sat, 19 Feb 2005 21:56:51 -0800
Message-ID: <421826A3.30806@nsr500.net>
References: <200502192028.17397.michael.hebenstreit@fh-joanneum.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200502192028.17397.michael.hebenstreit@fh-joanneum.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

'fdisk -lu' shows in sectors of 512 bytes, useful in matching partition 
sizes for slightly different disks.

You will have to resize to the smallest (30401 cylinders).

Hebenstreit Michael wrote:
> Hello everybody,
> 
> I've been using a Raid5 with 3 disks of exactly the same size, a little bit 
> more than 250 GB (reported as 251)
> 
> Disk /dev/sdc: 251.0 GB, 251000193024 bytes
> 255 heads, 63 sectors/track, 30515 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1       30513   245095641   fd  Linux raid autodetect
> 
> Now I want to add a 4th disk - and got one slightly smaller:
> 
> sanjose:~ # fdisk -l /dev/sdd
> Disk /dev/sdd: 250.0 GB, 250059350016 bytes
> 255 heads, 63 sectors/track, 30401 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
> Disk /dev/sdd doesn't contain a valid partition table
> 
> 
> 
> Is it nevertheless possible (with some minimal losses in possible size) to add 
> the new disk? The Funny thing - all disks are from Maxtor, and should have 
> the same size.
> 
> Thanks a lot
> 
> Michael
> 
> 

-- 

