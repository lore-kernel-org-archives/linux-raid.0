From: David Mansfield <md@dm.cobite.com>
Subject: Re: raid5, media scans and stripe-wise resync
Date: Mon, 25 Oct 2004 15:47:02 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1098733622.5399.44.camel@duxeon.cobite.com>
References: <1098718593.5399.29.camel@duxeon.cobite.com>
	 <e9132f82041025123926140ece@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9132f82041025123926140ece@mail.gmail.com>
To: Bruce Lowekamp <lowekamp@cs.wm.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2004-10-25 at 15:39, Bruce Lowekamp wrote:
> There was a recent conversation on this mailing list about
> transparently recovering from read errors (essentially just rewriting
> the bad stripe and letting the disk handle it), but I think it focused
> on Raid 1.  It would be a natural for Raid 5 or 6, but I haven't seen
> an experimental patch to do that.
> 
> If you just want to monitor, look at http://smartmontools.sourceforge.net
> each of the drives in my array has a montoring config:
> /dev/hda -a -o on -S on -R 194 -s (S/../.././02|L/../../6/07) -m
> lowekamp@cs.wm.edu
> 

Thanks for the reference.

> two weeks ago I got email that one disk had a bad read on a sector
> during its weekly long scan (an entire surface scan).  I failed that
> drive manually, waited until it resynced on the spare, overwrote the
> entire drive to let the drive clear the sector (and make sure there
> weren't any other problems), then reran the test and set that drive as
> the spare.
> 

Check out the utility 'scu' at the url: 
http://www.bit-net.com/%7Ermiller/scu.html

It will allow you to 'reassign' the block directly by accessing the scsi
commands.  I've tried the rewrite method you used above, and once or
twice had problems.

> I'd still feel safer if it automatically overwrote only the sector
> with the read error, but at least this way I knew that the other 9
> drives had passed a surface scan just before, so I wasn't likely to
> run into a second read failure on rebuild.
> 

Yeah.  After scanning all disks you are reasonably assured.  But should
it happen that there are two defects, you are completely screwed.  No
way around it, I think.

I'd really like a way to resync a single stripe...

David

