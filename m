From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Raid 5 to Raid 1 (half of the data not required)
Date: Wed, 24 Aug 2011 09:03:55 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1108240851190.6833@unicorn.drogon.net>
References: <BAY148-W51F7F3A42E515F76BB76EFEF2E0@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-W51F7F3A42E515F76BB76EFEF2E0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 23 Aug 2011, Mike Viau wrote:

>
> Hello,
>
> I am trying to convert my currently running raid 5 array into a raid 1. 
> All the guides I can see online are for the reverse direction in which 
> one is converting/migrating a raid 1 to raid 5. I have intentionally 
> only allocated exactly half of the total raid 5 size is. I would like to 
> create the raid 1 over /dev/sdb1 and /dev/sdc1 with the data on the raid 
> 5 running with the same drives plus /dev/sde1. Is this possible, I wish 
> to have the data redundantly over two hard drive without the parity 
> which is present in raid 5?

3-drive RAID5 -> 2-drive RAID1...

Neils solution is interesting (and he should know :), but personally, I'd 
probably take a much simpler approach without FS resizing, etc. so this 
allows you to change filesystems or use something other than ext3...

So start with taking a backup :)

Then verify the existing RAID5 array (echo "check" > .. etc.) and wait...

Then "break" the array by failing /dev/sdb1

Create a single-drive RAID1 using /dev/sdb1 and "missing"

mkfs the filesystem of choice on this new MD drive and mount it.

use cp -a (or rsync) to copy data from the raid5 array to the new raid1 
array.

stop the raid5

hot-add /dev/sdc1 into the new raid1

then fiddle with whatever boot options, etc. to make sure the new drive is 
assembled at boot time, mounted, etc.

This isn't as "glamorous" as Neils method involving lots of mdadm 
commands, shrinks and grows, but sometimes it's good to keep things at 
a simpler level?

Well, it works for me, anyway!

Gordon
