From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 00/16] bad block list management for md and RAID1
Date: Fri, 18 Jun 2010 13:58:18 +1000
Message-ID: <20100618135818.79967b83@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
	<hvd5iq$u83$1@dough.gmane.org>
	<003901cb0e35$422f9020$c68eb060$@woodlea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003901cb0e35$422f9020$c68eb060$@woodlea.com>
Sender: linux-raid-owner@vger.kernel.org
To: Graham Mitchell <gmitch@woodlea.com>
Cc: 'Brett Russ' <bruss@netezza.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Jun 2010 11:53:40 -0400
"Graham Mitchell" <gmitch@woodlea.com> wrote:

> > This is a worthwhile addition, I think.  However, one concern we have is there
> > appears to be no distinction between media errors (i.e. bad
> > blocks) and other SCSI errors.
> 
> One thing I'd like to see would be being able to import a list of bad blocks from badblocks, and also have the ability for mdadm to be able to run a 'destructive' badblocks on the drives in the array, either at create/grow time, or on demand.

Importing a list of bad blocks would be quite trivial - you could write a
perl script to do it, though it might be nice to include it in mdadm.

> 
> I say 'destructive' since it would be a bad thing (tm) if it truly were destructive on a live array, but it would be nice for mdadm to do the full destructive aa/55/ff/00 write/read/compare cycle on each disk, without actually being destructive to the data that's there. I am slightly paranoid (having been bitten in the bum in the past), so I do a full destructive badblocks on every disk BEFORE I add It to an array (and yes, it can take days when I have 3 or 4 1TB drives to add). It would be nice to be able to add the disks to the server untested, and let mdadm do the testing when it was doing the grow.

I think it would be a mistake to incorporate bad-block detection
functionality into md or mdadm.  We already have a program which does that
and probably does it better than I could code.  Best to try to leverage what
already exists.

I'm not sure I see the logic though.  Surely if a drive has any errors when
new, then you don't want to trust it at all and cascading failure is likely
and tomorrow there will be more errors.  So t would be best to do the
badblock scan first and only add it to the array if it were completely
successful.

However if you really want to you could tell md that all blocks were bad,
then have the badblock scan run and after if finishes with some section, tell
md that section was OK and move on.
The current badblock list format allows ranges of blocks, but it is currently
limited to 512 ranges each of at most 512 blocks.  I could probably relax
that without too much effort, so that a single range could cover the whole
device... if we really thought that was a good idea.

Not convinced....

NeilBrown
