From: Kurt Newman <kurt@lamer.org>
Subject: Re: Simple Raid-1 setup question
Date: Fri, 13 Nov 2009 17:26:06 -0600
Message-ID: <4AFDEB0E.7000004@lamer.org>
References: <4AFDC2DD.9040002@lamer.org> <70ed7c3e0911131302o21bd47cbua1f2858c98edb201@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0911131302o21bd47cbua1f2858c98edb201@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That clears up a lot of my questions.  Although, --assume-clean isn't
doing what I'd like, I did some searches using the keyword,
'--assume-clean'.  That lead me back to the linux raid wiki.

Apparently I lack the ability to read 'Initial Array Creation' the last
time I was there.

Thank you for the help.

Majed B. wrote:
> 1) No need to sync if both disks are new (or have no data).
> That can be accomplished using: --assume-clean
> 
> 2) It shouldn't be a problem. If you still can't force mdadm, use dd
> (be very sure you're writing to the correct disks!!)
> dd if=/dev/zero of=/dev/sdx bs=10M count=1
> 
> That will write 10MB of zeros to the disk. It should corrupt any
> filesystem laying there.
> 
> Remember to change the partition type to "FD" for RAID auto-detect.
> 
> Create your filesystem on the array after you create it & that's it.
> 
> On Fri, Nov 13, 2009 at 11:34 PM, Kurt Newman <kurt@lamer.org> wrote:
>> My questions are as follows:
>>
>> 1) If you're creating a completely new array (e.g. raid-1) on new
>> partitions that aren't formatted, do you still have to sync?  I'm having
>> difficulty finding information on why and when a sync is needed.  I was
>> under the impression a sync is only needed when there's existing
>> information on one or more of the drives.
>>
>> 2) If there used to be information on each device, but has since been
>> repartitioned, so that new partitions and a raid device can be
>> created... is there any way to prevent mdadm from asking if you really
>> want to create the array?  Using `--force' doesn't seem to help.
>>
>> mdadm: /dev/sda1 appears to contain an ext2fs file system
>>   size=1464840K mtime=Fri Nov 13:04:09 2009
>> mdadm: /dev/sdb1 appears to contain an ext2fs file system
>>   size=1464840K mtime=Fri Nov 13:04:09 2009
>> Continue creating array?
>>
>> As a side note, there really isn't an existing ext3 fs on it, but there
>> used to be.  To re-use the device, I issued the following commands:
>>  > parted -s /dev/sda mklabel msdos
>>  > parted -s /dev/sda mkpart primary ext3 0 1500
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> 

