From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: mdadm ddf questions
Date: Fri, 25 Feb 2011 18:53:38 +0100
Message-ID: <4D67ECA2.2020201@gmail.com>
References: <4D5FA5C4.8030803@gmail.com>	<4D63688E.5030501@gmail.com> <20110223171712.09509f9e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110223171712.09509f9e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  Hi Neil,

I investigated a bit further, and here are my findings:

Looking at /proc/mdstat I see the following:

- When I create a ddf containter with a name (say /dev/md0), I stop it 
and start it again, the name has always changed to /dev/md127,
don't know if this is intentional.
- After creating the containter, all disks are marked as spare, 
designated with the (S) ending. However, when I put a disk in an array, it
still stays marked as (S) in the containter entry in /proc/mdstat. I 
think those disks should be branded (S) anymore.
- When I fail a disk, it is kicked out of the array, effectively back 
into the container. However this does not always work, e.g. when I 
created two arrays in the container and
fail a disk of the second array, this does not happen.
- A failed disk stays marked (S) in the container, I think it should now 
be marked (F).

Looking at the end of the output of mdadm -E /dev/md127 I see the disks 
in a table, with a unique serial nr, the devicename and the status.
A freshly created container contains all disks marked as 
GlobalSpare/Online. Adding a disk to an array marks it as active/Online. 
So far so good.

- When I fail a disk, it is marked as active/Online, Failed. A bit 
confusing as it has failed it cannot be active. When I fail a second 
disk, the status
stays active/Online. Only when I stop the arrays and container and 
restart it (mdadm -A -s) it gets marked as failed.
- When I remove a failed disk from the containter, the entry for the 
disk stays online in the mdadm -E output, only the device file is 
removed, but the disk is still marked active/Online, Failed.
I think this whole entry should be removed.
- When I add the disk again, it slots in its old entry, and is still 
marked active/Online, Failed, apart from active/Online bit I agree, the 
disk had failed anyway.
- But when I zero the superblock (mdadm --zero-superblock /dev/sdb) and 
then add it, I get a new entry in the container, which now contains an 
extra entry
apart from the old entry with not device mentioned. This makes sense 
(effectively I added a "new" disk) but the old entry should have been 
removed.

I have also encountered the fact that the same disk was used as a spare 
disk in two arrays created in the containter. In other words, /dev/md1 
failed -> disk replaced,
after that /dev/md2 failed -> same spare disk used for replacement. How odd.

If I assume that the output of mdadm -E (especially the disk entries at 
the end) isl taken from the superblock(s) it looks like these are not 
updated correctly.

I also noticed that a RAID5 array created in a containter cannot be 
expanded with another disk (option -G) as it can in normal setup (i.e. 
without using the container).
The same hold for a RAID1 where you cannot add a third disk.

I hope this gives you more clues about a possible fix?

Cheers,

Albert

On 02/23/11 07:17 AM, NeilBrown wrote:
> On Tue, 22 Feb 2011 08:41:02 +0100 Albert Pauw<albert.pauw@gmail.com>  wrote:
>
>> When I removed the correct disk, which can only be done from the container:
>>
>> mdadm -r /dev/md127 /dev/sdb
>>
>> the command mdadm -E /dev/md127 showed the 5 disks, the entry for sdb
>> didn't had a device but was still
>> "active/Online" and sdd was marked Failed:
> .....
>
>> So it looks like there are some errors in here.
>>
> Indeed it does.  Thank you for putting some time in to testing and producing
> an excellent problem report.
> I have not put as much time into testing and polishing the DDF implementation
> as I would have liked, partly because there doesn't really seem to be much
> interest.
> But reports like this make it a whole lot more interesting.
>
> I will try to look at this some time soon and let you know what I find in the
> code - feel free to remind me if you haven't heard in a week.
>
> Thanks,
> NeilBrown
>
>

