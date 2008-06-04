From: David Greaves <david@dgreaves.com>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Wed, 04 Jun 2008 12:51:11 +0100
Message-ID: <484681AF.8030004@dgreaves.com>
References: <4844E994.8020808@jellybean.co.uk>    <4845B573.7090801@jellybean.co.uk> <48675.192.168.1.70.1212528422.squirrel@neil.brown.name> <484636B9.20700@jellybean.co.uk> <48464B3A.7070206@dgreaves.com> <4846529B.1000809@jellybean.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4846529B.1000809@jellybean.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jules Bean <jules@jellybean.co.uk>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jules Bean wrote:
> David Greaves wrote:
> Just add it as a fresh component. The old SB is irrelevant.
> 
> 1. Fail component
> 2. remove component
> 3. resize partition
> 4. FORCE KERNEL TO NOTICE NEW SIZE (that's what I got wrong!). Reboot is
> safest.
> 5. add component as new


> 6. watch as md layer rebuilds
And that's the bit that shouldn't be needed :)

Otherwise you're 'just' replacing devices one at a time which isn't very
interesting.

> Of course this does assume your RAID level has the redundancy required
> to remove a component (i.e. not RAID0).
Neil, would the sb-move approach support RAID0?

>> in step 4 mdadm may want to call the reread pt ioctl (which is what
>> blockdev --rereadpt does)
> 
> Seems to me that whilst cfdisk makes no visible attempt, plain 'fdisk'
> does try to call this ioctl but nonetheless it doesn't work if some
> other partition on that disk is busy (e.g. involved in some other md
> device, or mounted elsewhere). I saw messages to this effect whilst
> experimenting with different partition sizes looking for my missing
> superblock.
I read (http://linux.derkeiler.com/Mailing-Lists/Kernel/2003-10/4319.html) there
are some ioctls that work even when some disk partitions are still in use
(providing there is no impact).
However I couldn't see them in the block-layer ioctls or any code in
fs/partitions/check.c

>> This approach, it seems to me, would avoid any reconstruction and
>> would be a
>> 'safer' way to grow the components.
> 
> It would avoid reconstruction which is good for the impatient.
> 
> I don't really see that it's "safer" though. I would have thought it was
> quicker but potentially less safe.

Avoiding a lot of time stress testing the disks in degraded mode isn't 'safer'?

David

