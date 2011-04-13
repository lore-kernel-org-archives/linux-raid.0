From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
 unresponsive
Date: Wed, 13 Apr 2011 21:13:10 +1000
Message-ID: <20110413211310.53f6026f@notabene.brown>
References: <323937.22450.qm@web65109.mail.ac2.yahoo.com>
	<4DA58194.4070403@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA58194.4070403@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Gavin Flower <gavinflower@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Apr 2011 11:57:24 +0100 John Robinson
<john.robinson@anonymous.org.uk> wrote:

> On 12/04/2011 22:30, Gavin Flower wrote:
> > --- On Fri, 8/4/11, NeilBrown<neilb@suse.de>  wrote:
> > [...]
> >> No, it was clearly a disk-drive problem.
> >> e.g.
> >> Apr  7 14:42:12 saturn kernel: [231957.756023]
> >> ata3.00: failed command: READ FPDMA QUEUED
> >>
> >> a READ command sent to a n 'ata' device failed.  i.e.
> >> disk error.
> > [...]
> >
> > Hi Neil,
> >
> > I think it is either a drive or cable problem.
> >
> > However, I was wondering if /proc/mdstat could list drives in a more consistent manner.  The C drive has dropped out and affected all 3 RAID partitions.  A quick look at /proc/mdstat suggests that md2&  md1 have the same drive drop out [UUUU_], but a different drive for md0 [UU_UU].  In fact, the list of drives (...sda4[0] sdc4[6](F)...) is not consistent with the [UUUU_] representation even for the same mdN!
> >
> > # date ; cat /proc/mdstat
> > Wed Apr 13 08:40:09 NZST 2011
> > Personalities : [raid6] [raid5] [raid4]
> >
> > md2 : active raid6 sda4[0] sdc4[6](F) sdd4[3] sdb4[5] sde4[1]
> >        1114745856 blocks super 1.1 level 6, 512k chunk, algorithm 2 [5/4] [UUUU_]
> 
> This looks correct: sorting the first line into md slot order we have:
> md2 : active raid6 sda4[0] sde4[1] sdd4[3] sdb4[5] sdc4[6](F)
> which is UUUU_
> 
> > md1 : active raid6 sda2[0] sdc2[5](F) sdd2[3] sde2[2] sdb2[1]
> >        307198464 blocks level 6, 512k chunk, algorithm 2 [5/4] [UUUU_]
> 
> Similarly:
> md1 : active raid6 sda2[0] sdb2[1] sde2[2] sdd2[3] sdc2[5](F)
> which is UUUU_
> 
> > md0 : active raid6 sda3[0] sdb3[4] sdd3[3] sdc3[5](F) sde3[1]
> >        10751808 blocks level 6, 64k chunk, algorithm 2 [5/4] [UU_UU]
> 
> This one I don't get:
> md0 : active raid6 sda3[0] sde3[1] sdd3[3] sdb3[4] sdc3[5](F)
> which ought to be UUUU_ again...
> 
> Perhaps `mdadm -D /dev/md[0-2]` would make things clearer...
> 

This is actually more horrible than you imagine.

The number [] is not the role of the device in the raid.  Rather it is an
arbitrarily assigned slot number with no real meaning.

The original 0.90 metadata format has two numbers for each device.
These are in mdp_disk_t defined in include/linux/raid/md_p.h

They are 'number' which is the slot number and so is defined for spare
devices as well as active devices.
And there is the 'raid_disk' number which is the role that the device
plays in the array and is well defined for active devices and
meaningless for spares.

mdstat always showed the 'number'.

However the 0.90 format keeps 'number' and 'raid_disk' the same for active
devices (so why have two different numbers - who knows).
So people reasonably jumped to the technically wrong conclusion that the
number inside [] was the role number.

In 1.x, I keep the slot 'number' the same for the life of a device, but change
the role - from 'spare' to and active role to 'failed' - because this makes
sense.
However that means that the number in [] definitely isn't the role number any
more.  It might be when the array is created, but it is not certain to stay
that way.

As the current number is pretty much useless, I should probably change it to
the slot number, or an arbitrarily assigned larger number for spares.
This would be an incompatible change, but I very much doubt anyone uses the
numbers for what they actually are, so I doubt that would really matter.

It has just never really got high on my list of priorities....

Lesson:  Ignore the number in [] - it doesn't mean anything useful.

NeilBrown
