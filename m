From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Linux Raid confused about one drive and two arrays
Date: Fri, 23 Jan 2004 11:39:55 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16400.27995.140124.502374@notabene.cse.unsw.edu.au>
References: <6a.3aa594bc.2d413983@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from AndyLiebman@aol.com on Thursday January 22
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 22, AndyLiebman@aol.com wrote:
> I have just encountered a very disturbing RAID problem. I hope somebody 
> understands what happened and can tell me how to fix it.

It doesn't look very serious.

> 
> I have two RAID 5 arrays on my Linux machine -- md4 and md6.. Each array 
> consists of 5 firewire (1394a) drives -- one partition on each drive, 10 drives in 
> total. Because the device ID's on these drives can change, I always use MDADM 
> to create and manage my arrays based on UUIDs. I am using MDADM 1.3. Mandrake 
> 9.2 with mandrake's 2.4.22-21 kernel.
> 
> After running these arrays successfully for two months -- rebooting my file 
> server every day -- one of my arrays came up in a degraded mode. It looks as if 
> the Linux RAID subsystem "thinks" one of my drives belongs to both arrays.
> 
> As you can see below, when I run mdadm -E on each of my ten firewire drives, 
> mdadm is telling me that for each of the drives in the md4 array (UUID group 
> 62d8b91d:a2368783:6a78ca50:5793492f )  there are 5 Raid devices and 6 total 
> devices with one failed. However this array always only had 5
> devices.

The "total" and "failed" device counts are (unfortuantely) not very
reliable.

> 
> On the other hand, for most of the drives in the md6 arary (UUID group  
> 57f26496:25520b96:41757b62:f83fcb7b), mdadm is telling me that there are 5 raid 
> devices and 5 total devices with one failed.
> 
> However, when I run mdadm -E on the drive currently identified as /dev/sdh1 
> -- which also belongs to md6 or  the UUID group 
> 57f26496:25520b96:41757b62:f83fcb7b -- mdadm tells me that sdh1 is part of an array with 6 total devices, 5 
> raid devices, one failed.
> 
> /dev/sdh1 is identified as device number 3 in the RAID with the UUID 
> 57f26496:25520b96:41757b62:f83fcb7b.  Howver, when I run mdadm -E on the other 4 
> drives that belong to md6, mdadm tells me that device number 3 is
> faulty.

So presumably md thought that sdh1 failed un some way and removed it
from the array.  It updated the superblock on the remaining devices to
say that sdh1 had failed, but it didn't update the superblock on sdh1,
because it had failed, and writing to the superblock would be
pointless.


> 
> My questions are:
> 
> How do I fix this problem?

Check that sdh1 is ok (do a simple read check) and then
  mdadm /dev/md6 -a /dev/sdh1

> Why did it occur?

Look in your kernel logs to find out when and why sdh1 was removed
from the array.

> How can I prevent it from occurring again?

You cannot.  Drives fail occasionally.  That is why we have raid.

Or maybe a better answer is:
  Monitor your RAID arrays and correct problems when they occur.


NeilBrown
