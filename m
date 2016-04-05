From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Repairing R1: Part tabl, & precise command
Date: Wed, 6 Apr 2016 09:47:52 +1000
Message-ID: <57044EA8.2010506@websitemanagers.com.au>
References: <57038211.6040101@tesco.net> <57039BCC.6040103@tesco.net>
 <5703AE18.700@tesco.net> <5703D98F.4020503@turmel.org>
 <5703E909.8090903@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5703E909.8090903@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/04/16 02:34, Ron Leach wrote:
> On 05/04/2016 16:28, Phil Turmel wrote:
>
>>
>> If your array has write-intent bitmaps, use --re-add instead of --add.
>> It'll be quick.  Otherwise just --add and let it rebuild.
>>
>
> Phil, thanks for the advice.
>
> I hit an unexpected problem fixing the partition table on /dev/sdb, 
> the disk that dropped from the Raid1 array.  The problem is caused by 
> /dev/sdb being *smaller* than /dev/sdc (the working array member) - 
> despite the disks being identical products from WD.  gdisk complains 
> that partition 5 (/dev/sdb5), which is to be the Raid1 partner for the 
> LVM containing all our backed up files, is too big (together with the 
> other partitions) for the /dev/sdb disk.
>
> Presumably, raid1 doesn't work if an 'add'ed disk partition is smaller 
> than the existing, running, degraded array?  Am I right in thinking 
> that the LVM won't be able to be carried securely on the underlying md 
> system?  lsdrv is reporting that /dev/md127 has 0 free, so it seems 
> that the LVM is occupying the complete space of /dev/md127, and it 
> must be using the complete space of the underlying /dev/sdc5 because 
> only sdc is active, at the moment (the Raid1 being still degraded).
>
> To protect the LVM, what would be a good thing to do?  Should I define 
> a slightly shorter 'partner' partition on the failed disk (/dev/sdb) - 
> I would think not, but I would welcome advice.
>
> I did think about reducing the size of one of the other partitions on 
> /dev/sdb - there's a swap partition of 2G which could become 1.5G, 
> because there's another 2G on the working disk anyway. Doing that, the 
> partner partitions for the real data could be the same size, though 
> not in exactly the same place on both disks.  I think this might work?
>
> regards, Ron

Hi Ron,

That is one option (reduce the swap partition size). You might also look 
at the mdadm information of the array, generally it is possible to 
create a raid1 array across two devices that are different size, and 
mdadm will automatically ignore the "excess" space of the larger drive.

eg:
sda1 1000M
sdb1 1050M

The disks and partition tables will show both disks 100% full, because 
the partition fills the disk
mdadm will ignore the extra 50M on sdb1 and create a raid1 array of 1000M
LVM (or whatever you put onto the raid1) will show 1000M as the total 
size, and will know nothing about the extra 50M

I think mdadm is silent about size differences if the difference is less 
than 10% (or some other percentage value).

Another concern I have is that the drive has a number of damaged 
sectors, has used up all the "spare" sectors that it has for 
re-allocation, and is now reporting a smaller size because it knows that 
a number of sectors are bad. I don't think drives do this, but it is a 
failed drive, and manufacturers might do some strange things.

Can you provide full output of smartctl, it should show more details on 
the status of the drive, what damage it might have/etc...

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
