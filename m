From: CaT <cat@zip.com.au>
Subject: raid5 stuck in degraded, inactive and dirty mode
Date: Wed, 9 Jan 2008 16:55:44 +1100
Message-ID: <20080109055544.GR3940@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've got a 4 disk RAID5 array that had one of the disks die. The hassle
is that the death was not graceful and triggered a bug in the nforce4
chipset that wound up freezing the northbridge and hence the pc. This
has left the array in a degraded state where I cannot add the swanky new
HD to the array and have it back up to its snazzy self. Normally I would
tinker until I got it working but this being the actual backup box, I'd
rather not lose the data. :)

After a bit of pondering I have come to the conclusion that what may be
biting me is that each individual left-over component of the RAID array
still thinks that the failed drive is still around, whilst the array as
a whole knows better. Setting what used to be the left-over hd failed
produces a device not found error. The components all have different
checksums (which seems to be the right thing judging by other, whole
arrays) and the checksums are marked correct. Event numbers are all
thesame. The status on each drive is active, which I also assume is
wrong. Where the components list the other members of the array the
missing drive is marked 'active sync'.

I'd provide data dumps of --examine and friends but I'm in a situation
where transferring the data would be a right pain. I'll do it if need
be, though.

So, what can I do? 

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
