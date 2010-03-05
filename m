From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Removing drives
Date: Fri, 05 Mar 2010 12:00:16 -0700
Message-ID: <4B9154C0.7060200@vorgon.com>
References: <4B8F26AF.7080308@vorgon.com> <4877c76c1003041445g2ac9aaf6ua5fac64db975da1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003041445g2ac9aaf6ua5fac64db975da1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Current setup, 3 500gb sata drives, each with 3 partitions.
The first partition of each drive make up raid1 md0 boot and most software
The next partition of each drive make up raid1 md1 swap
The 3rd partition of each drive make up raid5 md2 main data storage

There is also a 40gb ide drive with 2 partitions, boot/software and 
swap. It was used for install and setup. But I never got boot changed 
over to md0. So currently md0 is not in use. md0 and md2 are mounted to 
folders on the 40gb so a precopy to md0 could be made before booting 
with a cd and copying what ever is left that needs coping. and to use md2.

Current
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
/dev/hda1       /               ext3    defaults,errors=remount-ro 0       1
/dev/hda5       none            swap    sw              0       0
/dev/md0        /mnt/md0        ext3    defaults        0       0
/dev/md2        /mnt/md2        ext3    defaults        0       0
/dev/hdb        /media/cdrom0   udf,iso9660 user,noauto     0       0
/dev/fd0        /media/floppy0  auto    rw,user,noauto  0       0

I want to change md0 and md1 from 3 drive mirriors to 2 drive mirrors.

Finish changing over to booting from md0, move swap to md1 and move the 
mount point for md2 to md0

Remove the the ide drive to free up space for the 4th 500gb drive.

Copy md2 over to the new 500gb temparally.

Get rid of the current md2 freeing up the 3rd drive since it was already 
taken out of the mirrors above.

Make a new md2 raid1 with the remaining space of the first 2 sata drives.

Move the data from the 4th drive back to the new md2

Repartition the 3rd drive to 1 partition same as the 4th drive.

Make raid1 md3 from the 3rd and 4th drives.

It's the steps/commands to change md0 and md1 from 3 drive mirrors to 2 
drive mirrors that I'm not sure about. Though now looking at fstab I see 
I never even switched over the swap. So I guess, those to arrays would 
be rebuilt. So it's more how to do that without messing with md2.

The computer is still on grub1. I haven't updated it it.

On 3/4/2010 3:45 PM, Michael Evans wrote:
> On Wed, Mar 3, 2010 at 7:19 PM, Timothy D. Lenz<tlenz@vorgon.com>  wrote:
>> Some time back I started setting up a couple of vdr computers with raid. The
>> one with 3 500gb drives, I setup 2 raid 1 partitions with 1 spare fo boot
>> and swap and used the rest of the 3 drives for a raid5 array. I had problems
>> getting it to boot, and it was advised to change the raid 1 arrays to 3
>> mirror which I did. Bu I got busy with other things and never tried to
>> switch it to boot from the arrays. Since then I aquired a 4th drive same
>> size and model. I want to change md0/1 back to 2 drive mirrors and change
>> md2 from raid5 to raid1 freeing up a drive which I then want use to with the
>> new drive to create another raid1 array. Before I can install the new drive,
>> I need to get it booting from md0 so I can remove the old ide drive.
>>
>> I figure I need to shrink md0 and md1 and then fail the 3rd drive in each of
>> those 2 arrays before changing them to 2 drive arrays? I find lots of stuff
>> about adding drives, but not much about removing the drives or how to change
>> them back to 2 drive arrays.
>>
>> Once md0 and md1 are back to 2 drives and it's booting, then I'll install
>> and format the new drive and copy the contents of md2 over. Then I need to
>> remake md2 as a 2 drive raid1. Then copy the data back and i'll have 2
>> drives to make md3.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Let's divide that problem up in to more manageable chunks.
>
> 1) Boot - This is small and trivial to backup and restore.
> 2) Swap - Not often /required/ and thus can be disabled and erased.
> 3) Raid5 - Your data, which you want to convert from Raid5 to Raid1 storage.
>
> The absolute easiest (and safest) thing to do is to backup your data,
> verify the backup, then erase all the disks and start clean.
>
> Otherwise the issues will have to be handled in the listed order:
>
> 1) Boot
> If you are using 'Grub 2' (non grub legacy) then it wants EITHER mdadm
> label 0.90 OR the option beneath.
> Otherwise you must use mdadm label format 0.90 or, IIRC 1.0 (metadata
> at the end of the area), and specify the device not as /dev/mdX but as
> one of the member devices.  You will have to manually mirror or
> duplicate the install sections.
>
> 2) swapoff, mdadm -S the device
>
> 3) Maybe someone else can help with the takeover?  In any event we DO
> need more directions.  You're trying to go from 2 usable drives worth
> of storage to 1, which isn't going to work.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
