From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Software RAID Stopped Working With Aurora Kernel
Date: Thu, 30 May 2002 09:16:26 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15605.24906.442772.449984@notabene.cse.unsw.edu.au>
References: <15601.48418.82978.28645@notabene.cse.unsw.edu.au>
	<CPEAKNIMKMJOCFPEOBGAMEDNCFAA.cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Calvin Webster on Wednesday May 29
To: cwebster@ec.rr.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 29, cwebster@ec.rr.com wrote:
> > > "mdadm --examine /dev/sda1" shows "State : dirty, no-errors". All other
> > > RAID drives show the same.
> > >
> > > "lsraid -D -a /dev/md0" shows "state		= good".
> > All other RAID devices
> > > show the same.
> >
> > I have never looked at "lsraid".  My guess is that "good" is
> > equivalent to "no-errors" and that lsraid doesn't bother to report
> > "dirty".  This shouldn't relate to the filesystem superblock though...
> >  still, a fsck every few months is a good idea.
> 
> What made this observation noteworthy, however, was that it persisted even
> _after_ e2fsck was run on /dev/md0.

The raid "dirty" or "error" flags are completely separate from any
filesystem "dirty" or "error" flags.  So fsck will not affect the raid
flags.

The raid "dirty" flag simply means that the array has been started and
not yet stopped.  Either it is active or you had an unclean shutdown
and will need to regenerate redundancy.

The raid "error" flag is meaningless.  It is never set by anything,
and I cannot think of any use that it might be put to.  But it is
there is the definition of the superblock, or mdadm reports it.

NeilBrown
