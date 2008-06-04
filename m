From: Jules Bean <jules@jellybean.co.uk>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Wed, 04 Jun 2008 09:30:19 +0100
Message-ID: <4846529B.1000809@jellybean.co.uk>
References: <4844E994.8020808@jellybean.co.uk>    <4845B573.7090801@jellybean.co.uk> <48675.192.168.1.70.1212528422.squirrel@neil.brown.name> <484636B9.20700@jellybean.co.uk> <48464B3A.7070206@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48464B3A.7070206@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Jules Bean wrote:
>> As to where my superblock has gone, the only theory I have is that the
>> MD layer knew that my partitions were 400G large while the kernel was
>> convinced they were 250G large, so the md layer tried to write the
>> superblock at (approx) +400G, and the kernel refused to do that.
> 
> I failed to do a similar grow operation recently and had to re-create.
> 
> I was using 0.9 sb which is stored at the end of the disk.
> I have no idea how this is supposed to work...
> 
> If I have sda1 at 250Mb then the sb is at 250-d Mb
> I'd like to stop the array, remove the partition, grow the partition to 400Mb
> and start the array.
> This won't work because md won't find an sb at 400-d Mb and so won't know that
> it's an md component.

That doesn't matter.

Just add it as a fresh component. The old SB is irrelevant.

1. Fail component
2. remove component
3. resize partition
4. FORCE KERNEL TO NOTICE NEW SIZE (that's what I got wrong!). Reboot is 
safest.
5. add component as new
6. watch as md layer rebuilds

If I hadn't screwed up step 4, I would have been fine. I have now done 
step 4 correctly and grown my array to used dev size 400 (up from 250).

Of course this does assume your RAID level has the redundancy required 
to remove a component (i.e. not RAID0).

 > in step 4 mdadm may want to call the reread pt ioctl (which is what
 > blockdev --rereadpt does)

Seems to me that whilst cfdisk makes no visible attempt, plain 'fdisk' 
does try to call this ioctl but nonetheless it doesn't work if some 
other partition on that disk is busy (e.g. involved in some other md 
device, or mounted elsewhere). I saw messages to this effect whilst 
experimenting with different partition sizes looking for my missing 
superblock.


> This approach, it seems to me, would avoid any reconstruction and would be a
> 'safer' way to grow the components.

It would avoid reconstruction which is good for the impatient.

I don't really see that it's "safer" though. I would have thought it was 
quicker but potentially less safe.

Jules
