From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID 10 Repairs
Date: Sat, 08 Jun 2013 13:35:08 -0400
Message-ID: <51B36B4C.4090101@tmr.com>
References: <CAE98Ua_Js7wpfkT7wAZhm79Y46t4Fqtfx3752SUO_+H-3jqqcQ@mail.gmail.com> <51AC260F.8050806@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AC260F.8050806@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner wrote:
> On 6/2/2013 9:07 PM, Rob Emanuele wrote:
>
>> So, I've been looking at repairing my RAID 10 software array. I have a
>> failing drive with incrementing SMART errors. I went to replace that
>> drive with a new drive.  The failing drive is 250,059,350,016 bytes
>> while the batch of new drives I bought as spares are 250,000,000,000
>> bytes.
>>
>> When I add the new drive it tells me the drive is too small.  Is there
>> a way to shrink the array so that new new drives (any any other
>> replacement drives around 250G) will work in the array?
> High Rob,
>
> They're 250GB drives.  Frankly what I'd do is get your investment backecho "want_replacement" >/sys/block/md/NNN//md/dev-/XXX//state
> from those 'new' drives, though it probably wasn't much if acquired
> recently.  Acquire a number of 750GB, 1TB drives that yield similar
> total space after RAID10 overhead.  Build a new array, mkfs, copy all
> the data over, and decommission the old disks, then Ebay them.
Assuming the that the kernel is semi-recent, you can put the new drive in the 
array as a spare, then
    echo "want_replacement" >/sys/block/md/NNN//md/dev-/XXX//state
to copy the contents to the new member. The advantage is that any valid data on 
the old failing drive is used rather than reconstructing each chunk. This is 
faster and safer, since reconstruction sometimes finds a bad block on another drive.

When the data are moved, you can remove the old member from the array.
> Or just acquire two 2TB drives an mirror them.  20x 250GB drives in
> RAID10 is 2.5TB net space.  Surely you don't currently have 20 drives in
> this RAID array.  If you're acquiring 250GB drives in 2013 I'd guess
> you're not after performance.  So reducing spindle count shouldn't be an
> issue, should it?
>
Actually the only reason to use small drives any more is for performance, fast 
drives (10k+ rpm) tend to be small. And expensive.
I agree that this user probably isn't doing that.
I see Newegg has decent TB drives for $59 now, not server grade, but decent stuff.

-- 
Bill Davidsen <davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010


