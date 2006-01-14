From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: md faster than h/w?
Date: Sat, 14 Jan 2006 16:23:41 -0500
Message-ID: <20060114212341.GB20464@lug.udel.edu>
References: <dq7jii$n1c$1@sea.gmane.org> <Pine.LNX.4.44.0601131720090.24299-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0601131720090.24299-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 14, 2006 at 01:40:53AM -0500, Mark Hahn wrote:
> > Initially, we were getting 'hdparm -t' numbers around 80MB/s, but this 
> > was when we were testing /dev/sdb1 - the (only) partition on the device. 
> > When we started testing /dev/sdb, it increased significantly to around 
> > 180MB/s. I'm not sure what to conclude from this.
> 
> there are some funny interactions between partitions, filesystems 
> and low-level parameters like readahead.

Hmmm, I'm not convinced, though it could be that the disks in my
workstation are not fast enough.

I used hdparm and your iorate program to compare the performance on my
fastest disk (7200rpm, ATA100).  The difference between partition vs.
disk is definitely within the margin of error: 2-3MB/sec when I'm
averaging around 50MB/sec.

I'd be suspicious of much more difference between the two...

> I'm about to test an 8x 3ware 9550 this weekend.  but 4x disks on a $US 60
> promise tx2 will already beat your system ;)

No way.  Cause you're gonna max the PCI bus if you use that card with MD.
Say you're running on a 66MHz PCI bus, you'll max at 266MB/sec.  For
four disks, 266/4 = 66.5MB/sec, you're already slower than the
original poster's RAID.  Add network traffic to that equation, and
Promise is laughable.

The 3Ware will rock considerably, as it's real hardware, so you'll
only send one copy of the data.  On top of which, the PCIX will be
hard to fill up.  I've seen 32-bit, 33MHz 3Ware cards hold 80MB/sec
without breaking a sweat.

If there's a PCI-X or PCI Express version of the TX4, then just
pretend I didn't post this  ::-)

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
