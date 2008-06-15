From: "Sean Hildebrand" <silverwraithii@gmail.com>
Subject: Re: Rebuilding an array with a corrupt disk.
Date: Sun, 15 Jun 2008 07:54:10 -0400
Message-ID: <fa037c550806150454v68089bcbg50203b454ae593e0@mail.gmail.com>
References: <fa037c550806131922y475de7ew8c3a66aa06d081b1@mail.gmail.com>
	 <4853634C.90508@dgreaves.com>
	 <fa037c550806140354k7bcab83fs39738e165f3aba8d@mail.gmail.com>
	 <4853AFCF.5050209@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4853AFCF.5050209@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Unfortunately, ddrescue didn't do me any good. The amount of data
taken from /dev/sda1 and output to /dev/sdd1 was not sufficient to
include /dev/sdd1 in the array.

However, since I was only using around a third of the array, it looks
like there wasn't much data in the latter portion of /dev/sda1. I
mounted the array and cp'd data off - Ended up having only 11 read
errors, all of which caused the array to kick /dev/sda1 out as a
failed disk, and three of which were severe enough to stop the
motherboard from recognizing the disk until after a reboot.

I got all my data, save the eleven folders that read errors occurred
in - Thankfully the data lost isn't terribly important.

Is there no way to get mdadm to allow a certain number of read errors
from a disk, instead of removing it from the array immediately?
Manually unmounting, stopping, and re-assembling is somewhat of a
chore, especially when the system locks access to the array while
copying, despite the read error.

>IIt also depends on previous usage - was the disk ever more full? etc. etc.

To answer that: The drive was brand new. The thing I find odd about
this failure is that it was integrated into the array without issue,
meaning the disk has no issues writing to the bad sectors, just
reading. Never had that before.

In any case, I'm very glad to have got my data with minimal loss. And
to think, all this could have been avoided if I'd just made my array a
RAID6 when it was first built. Certainly when I have a new fifth disk
the array will be rebuilt as such.

On Sat, Jun 14, 2008 at 7:47 AM, David Greaves <david@dgreaves.com> wrote:
> Sean Hildebrand wrote:
>> How's that?
>>
>> The spare (/dev/sdd) seems to be fine. I haven't tried the rebuild
>> with any other disks, but smartctl doesn't report any issues with
>> /dev/sdd, only /dev/sda.
> Sorry, misread what you said.
> Thought you had errors on both sda and sdd.
>
>
>> Ran ddrescue, managed to recover 559071 MB.. But the other 191GB was
>> thousand  upon thousands of read errors.
> Looking fairly bad then.
>
>> Now, prior to this with the array in degraded mode I was able to
>> access and modify all files I found, but mdadm would always fail on
>> rebuild, and fsck would always fail and the array would go down
>> roughly 75% through the scan, presumably when first encountering bad
>> sections of the disk.
> Sounds reasonable.
>
>> ddrescue has not yet finished - It's currently "Splitting error
>> areas..." - Given that the array has been mountable prior to running
>> ddrescue, is it safe to assume that once it's done, the
>> partially-cloned /dev/sda1 that ddrescue has output onto /dev/sdd1
>> will be mountable as part of the array so I can assess file loss?
> It should be.
> Additionally, the raid won't die as fsck works.
>
> However if any of the other disks die then you will have problems.
> Its safer to add the spare when it arrives and go to a redundant setup. Then, if
> any one drive dies, fsck will continue.
>
> Also note that you *may* recover more data by using ddrescue with a logfile and
> re-running it after chilling the failed drive etc. Google...
>
> The longer you persevere with ddrescue, the more data you have the chance of
> recovering. Maybe keep at it until the replacement spare arrives. Again - read
> up on ddrescue - the list archives had something in the last few weeks.
>
>> I am unsure of how data is spread through a RAID5. Each disk gets an
>> equal portion of data, but do drives fill up in linear fashion?
> No. the data is spread amongs the drives. You've lost everything from the 75% up
> mark on all the drives.
>
>> I ask
>> this because whether the array is being rebuilt or fscked it fails at
>> roughly 75% through either operation, yet I never had the array go
>> down while I was using it - Only when fsck was running or mdadm was
>> rebuilding.
>
>> The array is 2.69 TB, with 1.57TB currently free - If the drives do
>> fill linearly (Or even semi-linearly) is it likely that the majority
>> of the 191GB of errors are empty space?
> I don't know how various filesystems use space.
> It also depends on previous usage - was the disk ever more full? etc etc.
> I do know that with 'normal' filesystems (ext/xfs/etc) then the answer is undefined.
> Plus it's 191Gb x4 - so ~800Gb of corrupted md device.
>
> Sorry - keep fingers crossed.
>
>> If this isn't making much sense I apologize. I'm sleep deprived and
>> not enjoying the prospect of losing large quantities of my data.
> Sad, but people do use RAID instead of backups.
> RAID is a convenience that helps with uptime in the event of a failure and
> reduces the risk of data-loss between backups.
>
> Lets see what can be done to get it all back though - you may be lucky.
>
> David
>
