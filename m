From: "Luke Rosenthal" <luke@luko.org>
Subject: Recovery question - not strictly raid related
Date: Thu, 20 Nov 2003 20:17:22 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <008901c3af47$1ba93a40$5002a8c0@desktop>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This isn't strictly raid related, but after lurking I've noticed the folks
here know a LOT about partition stuff in general, so I'm hoping someone can
shed some light on this:

Say I had a disk with a handful of ext3 partitions on it, ala RedHat 7.3 -
eg. /, /boot, /usr, /var and so forth.  I accidentally scrubbed all those
partitions, created one large ext3 partition that filled the disk, began
copying, then realised my mistake and needed information that would have
been about three quarters the way thru the disk (on the last partition,
thankfully).  At this stage I had not copied anywhere near enough data, if
it were written sequentially, to go that far through the disk.

Is it too late to recover files from that last partition?  Does ext3 copy
sequentially?  I've noticed that backup superblocks will be written through
a partition as well.  Will that complicate things if they were written into
the partition I'm trying to recover?

So far the best chance is a program called "parted".  But I've come into
some usability problems with that - it won't seem to reconstruct the
partition table to the point where anything's mountable.  I also fear if it
were mountable, the process of recovering it to the point of being usable
might destroy it.  Anyone got any experience doing this stuff?

Luke.

