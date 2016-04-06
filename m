From: Ron Leach <ronleach@tesco.net>
Subject: Re: Repairing R1: Part tabl, & precise command
Date: Wed, 06 Apr 2016 11:14:02 +0100
Message-ID: <5704E16A.3060806@tesco.net>
References: <57038211.6040101@tesco.net> <57039BCC.6040103@tesco.net> <5703AE18.700@tesco.net> <5703D98F.4020503@turmel.org> <5703E909.8090903@tesco.net> <57044EA8.2010506@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57044EA8.2010506@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/04/2016 00:47, Adam Goryachev wrote:
> That is one option (reduce the swap partition size). You might also
> look at the mdadm information of the array, generally it is possible
> to create a raid1 array across two devices that are different size,
> and mdadm will automatically ignore the "excess" space of the larger
> drive.
>
> eg:
> sda1 1000M
> sdb1 1050M
>
> The disks and partition tables will show both disks 100% full, because
> the partition fills the disk
> mdadm will ignore the extra 50M on sdb1 and create a raid1 array of 1000M
> LVM (or whatever you put onto the raid1) will show 1000M as the total
> size, and will know nothing about the extra 50M
>
> I think mdadm is silent about size differences if the difference is
> less than 10% (or some other percentage value).

Adam, thank you for confirming that reducing swap might work.  I'd 
prefer that because I worry that if the md beneath the LVM reduces in 
size, then I could lose data that is in that LVM at present.

I checked fstab and realised that the swap partitions on /dev/sdb are 
not used, so I have gone ahead and reduced the swap partition, and 
rebuilt a good gpt table.  That went ok.  mdadm is now 'add'ing the 
partner partitions to the 3 md devices in the system.


>
> [snip]
>
> Can you provide full output of smartctl, it should show more details
> on the status of the drive, what damage it might have/etc...
>


I thought this was good advice but apt-get isn't finding smartctl.  I 
think your surmise is likely, though, that this disk has 'reduced' in 
size because of faults, and I've a new 3TB drive on its way.  I'll 
replace this suspect disk as soon as it arrives.

Grateful for the help

regards, Ron

