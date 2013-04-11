From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Is (non-failed) disk replace possible without loosing redundancy
 ?
Date: Fri, 12 Apr 2013 01:16:21 +1000
Message-ID: <5166D3C5.5000407@websitemanagers.com.au>
References: <F5FBA8C0111F5C458B9E1BC24A3F4BDD01F43AAFA5@exchange2.ad.tlogica.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F5FBA8C0111F5C458B9E1BC24A3F4BDD01F43AAFA5@exchange2.ad.tlogica.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mihail Daskalov <mdaskalov@technologica.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/04/13 01:07, Mihail Daskalov wrote:
> Hi all,
> I am newbie to this list, so forgive me if this was already discussed, and answered. I have searched the archives, but could not find an answer to my question (except something called hot-replace, that I couldn't understand much about).
>
> I would like to replace a disk in a mirror (raid1 array) with a third disk, that is present in the system (it is actually added as a spare to the array).
> This is part of some storage reorganization and drive replacement process (change old disks with new ones).
> Is there a way to gracefully replace a non-failed drive in an array, without loosing redundancy. 
> I think I would like to achieve the following:
> 1.	Add a third disk to a mirror array
> 2.	Ask the md subsystem to create triple mirror, and sync information to the third disk.
> 3.	Remove one of the other 2 disks on the system
> 4.	The system will stay with 2 up-to-date mirrors of the blocks
>
> This could be called a 'Copy-and-replace' operation. It could have some optimization - for example - maintain only 2 copies of the information (for example blocks that were not yet copied to the third disk will be on disks {1,2}, and blocks that are already copied would be on {1,3} in the case when disk 2 is being replaced by disk 3).
>
> So my questions is how can I achieve this, or similar functionality, and in what version of the kernel and tools, if at all possible?
>
> I specifically would like to underline that I know I can do:
> 1. Add third disk as spare
> 2. fail disk 2
> 3. wait for the resync to finish
>
> I would like to avoid this, as while resync-ing I would only have one copy of the blocks.
>
I'm pretty sure this will work:
1) mdadm --manage /dev/md0 --add /dev/sdc1 # Add spare device
2) mdadm  --grow /dev/md0 --level=1 --raid-devices=3 # Grow the array to
three drive raid1
3) mdadm --manage /dev/md0 --fail /dev/sdb1 # After the resync is
finished, fail the old disk2
4) mdadm --manage /dev/md0 --remove /dev/sdb1 # Now remove the old disk2
5) # Now physically remove disk2.
Repeat steps 1, 3, 4, 5 to replace disk1 with disk4.

6) mdadm --grow /dev/md0 --level=1 --raid-devices=2 # Reduce the array
back to a two drive raid1

If you have a newer kernel and/or mdadm (I think very new) then you can
use the replace functionality you have read about.

BTW, you should test the above, or wait for confirmation from someone
else, I haven't actually tried that, and I don't even know if the
command options are exactly right, I'm just running from memory (see man
mdadm) hoping a quick reply will help you out.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

