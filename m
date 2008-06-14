From: "Sean Hildebrand" <silverwraithii@gmail.com>
Subject: Re: Rebuilding an array with a corrupt disk.
Date: Sat, 14 Jun 2008 06:54:09 -0400
Message-ID: <fa037c550806140354k7bcab83fs39738e165f3aba8d@mail.gmail.com>
References: <fa037c550806131922y475de7ew8c3a66aa06d081b1@mail.gmail.com>
	 <4853634C.90508@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4853634C.90508@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How's that?

The spare (/dev/sdd) seems to be fine. I haven't tried the rebuild
with any other disks, but smartctl doesn't report any issues with
/dev/sdd, only /dev/sda.

Ran ddrescue, managed to recover 559071 MB.. But the other 191GB was
thousand  upon thousands of read errors.

Now, prior to this with the array in degraded mode I was able to
access and modify all files I found, but mdadm would always fail on
rebuild, and fsck would always fail and the array would go down
roughly 75% through the scan, presumably when first encountering bad
sections of the disk.

ddrescue has not yet finished - It's currently "Splitting error
areas..." - Given that the array has been mountable prior to running
ddrescue, is it safe to assume that once it's done, the
partially-cloned /dev/sda1 that ddrescue has output onto /dev/sdd1
will be mountable as part of the array so I can assess file loss?

I am unsure of how data is spread through a RAID5. Each disk gets an
equal portion of data, but do drives fill up in linear fashion? I ask
this because whether the array is being rebuilt or fscked it fails at
roughly 75% through either operation, yet I never had the array go
down while I was using it - Only when fsck was running or mdadm was
rebuilding.

The array is 2.69 TB, with 1.57TB currently free - If the drives do
fill linearly (Or even semi-linearly) is it likely that the majority
of the 191GB of errors are empty space?

If this isn't making much sense I apologize. I'm sleep deprived and
not enjoying the prospect of losing large quantities of my data.

On Sat, Jun 14, 2008 at 2:21 AM, David Greaves <david@dgreaves.com> wrote:
> Sean Hildebrand wrote:
>> I had a batch of disks go bad in my array, and have swapped in new disks.
>>
>> My array is a five disk RAID5, each 750GB. Currently I have four disks
>> operational within the array, so the array is functionally a RAID0.
>> Rebuilds have gone fine, except for the latest disk, which I've tried
>> four times.
>>
>> At 74% into the rebuild, mdadm drops /dev/sdd1 (The spare being
>> synced) and /dev/sda1 (A synced disk active in the array.) due to a
>> read error on /dev/sda1. Checking smartctl, there have been 43 read
>> errors on the disk, and they occur in groups.
>
> You have 2 faulty drives.
>
> Pounding on them will only make things worse.
>
> Get 2 new drives and use ddrescue to copy /dev/sda to a new drive and replace
> /dev/sda. Then add your second new drive.
>
>> The array contents have been modifed since the removal of the older
>> disks - So only the four currently-operational disks are synced.
>
>> Fscking the array also has issues past the halfway mark - Namely, when
>> it gets to a certain point, /dev/sda1 is dropped from the array and
>> fsck begins spitting out inode read errors.
> Well, once sda is gone you're reading garbage if the array even stays up.
>
>> Are there any safe ways to remedy my problem? Resizing the array from
>> five disks to four and then removing /dev/sda1 is impossible, as for
>> the array to be resized, error free reads of /dev/sda1 would be
>> necessary, no?
> It depends how well ddrescue does at reading /dev/sda.
>
> The sooner you do it the more chance you have.
>
> David
>
>
