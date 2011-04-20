From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Direct disk access on IBM Server
Date: Wed, 20 Apr 2011 13:40:23 +0200
Message-ID: <4DAEC627.3030904@grumpydevil.homelinux.org>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com> <iomfkq$qqr$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iomfkq$qqr$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/20/2011 01:24 PM, David Brown wrote:
> On 19/04/2011 22:08, Stan Hoeppner wrote:
>> David Brown put forth on 4/19/2011 8:21 AM:
>
> Pros for hardware raid:
>
> + It can have battery backup (I don't have one at the moment - I have 
> an excellent UPS for the whole system).
> + Rebuilds will be handled automatically by just adding new disks
> + The card supports online resizing and reshaping
> + It looks like the card supports caching with an SSD
> + The card supports snapshots of the virtual drives

I would add: no hassle to get boot loader installed on several disks, or 
on the raid. No limitation on which raid level used for booting
(this is the main reason i use LSI raid cards for the system. MD raid is 
used for the big data raids)
>
> Cons for hardware raid:
>
> - The disks are tied to the controller, so if the machine or its 
> controller fails, the data may not be recoverable (that's what 
> external backups are for!).
I have been using LSI for many years.
= The critical point is the controller, not the machine. I've moved 
controller & disks between machines several times and no problems
= if the controller fails, you can replace with same or later 
generation. It will recognize the disks and give you full access to your 
data. I've done this twice. Once from U160 to later U320 raid, once 
replacement with same generation card. The replacement of U160 to U320 
was not because of controller failure, i was upgrading the system.

> - If a drive is used for a particular raid level, it is /all/ used at 
> that level.  Thus no mixing of raid10 and raid5 on the same disk.
> - It needs the MegaCli or other non-standard software for 
> administration at run-time.
> - Testing and experimentation is limited, because you can't fake an 
> error (other than drive removal) and you can't fake drive size changes.
>
>
> Pros for software raid:
>
> + It's flexible (such as raid1 for /boot, raid10 for swap, and raid5 
> for data - all within the same set of disks).
> + It uses standard software (any live CD or USB will work, as will any 
> distribution).
> + You can put the disks in any Linux machine to recover the data if 
> the main machine dies.
> + You can use standard disk administration software (smartctl, 
> hddtemp, hdparm, etc.)
> + You can build layered raids, such as with one-disk mirrors at the 
> bottom and top, for extra safety during risky operations.  You can 
> also use external drives for such operations - they are slower, but 
> easy to add for temporary changes.
> + You have more choices for raid levels (raid10,far is particularly 
> useful, and you can have raid6 without an extra license key).
>
>
> Cons for software raid:
>
> - Adding replacement disks involves a few more changes, such as 
> partitioning the disks and adding the right partitions to the right 
> arrays.
>
With respect to layered RAID:
- several raid cards support RAID10.
- you can do MD raid in top of HW raid

Cheers,


Rudy
