From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID10 Layouts
Date: Sat, 22 Aug 2009 08:31:17 +0200
Message-ID: <878whcl5qi.fsf@frosties.localdomain>
References: <200908210627.06241.Info@quantum-sci.net>
	<87ljldce33.fsf@frosties.localdomain>
	<200908211102.58744.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908211102.58744.Info@quantum-sci.net> (Info@quantum-sci.net's
	message of "Fri, 21 Aug 2009 11:02:58 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Info@quantum-sci.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Info@quantum-sci.net writes:

> Thank you Goswin.
>
>
> On Friday 21 August 2009 09:43:28 Goswin von Brederlow wrote:
>> I don't think lilo or grub1 can boot from raid10 at all with offset or
>> far copies. With near copies you are identical to a simple raid1 so
>> that would boot.
>> 
>> So to be bootable even with a failed drive you should partition the
>> disk. Create a small raid1 for the system and a large raid10 for the
>> data.
>
> Uh oh, already set all 3 parts for RAID10, but haven't switched over yet.
>
> As it happens my / is on sda1 and /home is sda3  (swap is sda2), so it'll be pretty easy to just make / RAID1.  Do I need to make swap RAID1 and not 10?

Need? no. Want? No idea. My experience is that if you need swap (as in
swap in/out, not just it being used for garbage) then you have lost
anyway. Half or twice the speed on swap doesn't matter, the system
will crawl anyway.
  
>> I would stay away from any half baked bios stuff. It will be no better
>> than linux software raid but will tie you to the specific bios. If
>> your mainboard fails and the next one has a different bios you can't
>> boot your disks.
>
> Thank you.
>
>  
>> > How does this look:
>> > # mdadm --create /dev/md0 --level=raid10 --layout=o2 --metadata=1.2 --chunk=64 --raid-disks=2 missing /dev/sdb1
>> 
>> On partitions it is save to use 1.1 format. Saves you 4k. Jupey.
>
> 4k of what?  One time only, or on every cluster?  Any additional benefit to 1.2?

4k of space overall. The 1.2 format leaves the first 4k of the device
free for use of a bootloader/MBR.

> My system records mpeg4 from DishNetwork satellite (R5000-HD), so it
> handles mostly files over 1GB.  However its most rigorous duty is
> scanning those videos for commercials, and marking locations in a
> mysql database.  The disk light is constantly on and system response
> is sluggish when this is being done.  I don't understand how an
> advanced drive like this can be so bogged down, but I hope RAID10
> will speed things up.  Maybe there is a way to increase disk cache
> size?

man blockdev

Raid1 and the different Raid10 layouts work good for different access
patterns. The plain raid1 allows 2 streams to read from the drive in
parallel. If you have multiple streams that will reduce seeks. On the
other hand the raid10 far layout double sequential read speed. And so
on. Every layout behaves differently.

For scanning your videos raid10 with far layout is probably best with
a large read ahead. For your database a simple raid1 is probably better.
It might be benefitial to have the two on seperate partitions with
different raid mode.

Or it might be benefitial to have 2 partitions (sdX3 + sdX4) both with
simple raid1 but flag sdb3 and sda4 as --write-mostly. That way the DB
would always read from sda while the videos read from sdb.

As said before a lot of this depends on the usage pattern and that
means trying different things with the work load you will have
productively.

>> You should play with the chunksize though and try with and without
>> bitmap and different bitmap sizes. Bitmap costs some write performance
>> but it greatly speeds up resyncs after a crash or temporary drive
>> failure.
>
> My partitions and data are so enormous that I can't really do any
> experimenting.  Definitely will use write-intent log.

That is always a problem.

MfG
        Goswin
