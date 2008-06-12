From: Neil Brown <neilb@suse.de>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Thu, 12 Jun 2008 13:59:13 +1000
Message-ID: <18512.40721.405851.78859@notabene.brown>
References: <4844E994.8020808@jellybean.co.uk>
	<4845B573.7090801@jellybean.co.uk>
	<48675.192.168.1.70.1212528422.squirrel@neil.brown.name>
	<484636B9.20700@jellybean.co.uk>
	<48464B3A.7070206@dgreaves.com>
	<4846529B.1000809@jellybean.co.uk>
	<484681AF.8030004@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Wednesday June 4
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Jules Bean <jules@jellybean.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 4, david@dgreaves.com wrote:
> Jules Bean wrote:
> > David Greaves wrote:
> > Just add it as a fresh component. The old SB is irrelevant.
> > 
> > 1. Fail component
> > 2. remove component
> > 3. resize partition
> > 4. FORCE KERNEL TO NOTICE NEW SIZE (that's what I got wrong!). Reboot is
> > safest.
> > 5. add component as new
> 
> 
> > 6. watch as md layer rebuilds
> And that's the bit that shouldn't be needed :)
> 
> Otherwise you're 'just' replacing devices one at a time which isn't very
> interesting.
> 
> > Of course this does assume your RAID level has the redundancy required
> > to remove a component (i.e. not RAID0).
> Neil, would the sb-move approach support RAID0?

Maybe.  If the old partitions were all exactly the same size, and the
new are too.
If you start with different sized partitions, md/raid0 uses all the
space by having some stripes across fewer devices.  So changing the
sizes of the partitions will confuse things.

> 
> >> in step 4 mdadm may want to call the reread pt ioctl (which is what
> >> blockdev --rereadpt does)
> > 
> > Seems to me that whilst cfdisk makes no visible attempt, plain 'fdisk'
> > does try to call this ioctl but nonetheless it doesn't work if some
> > other partition on that disk is busy (e.g. involved in some other md
> > device, or mounted elsewhere). I saw messages to this effect whilst
> > experimenting with different partition sizes looking for my missing
> > superblock.
> I read (http://linux.derkeiler.com/Mailing-Lists/Kernel/2003-10/4319.html) there
> are some ioctls that work even when some disk partitions are still in use
> (providing there is no impact).
> However I couldn't see them in the block-layer ioctls or any code in
> fs/partitions/check.c

linux/block/ioctl.c.
 BLKPG_DEL_PARTITION
 BLKPG_ADD_PARTITION

Only works if the partition being changed isn't in used though.

NeilBrown
