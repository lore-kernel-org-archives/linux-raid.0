From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and I/O
	sizes
Date: Wed, 24 Jun 2009 14:05:18 +1000
Message-ID: <19009.42494.925771.283731@notabene.brown>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Tuesday June 23
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org, snitzer@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Tuesday June 23, snitzer@gmail.com wrote:
> On Tue, Jun 23, 2009 at 12:54 AM, Martin K.
> Petersen<martin.petersen@oracle.com> wrote:
> >
> > Neil,
> >
> > Looks like this one missed the boat on the first MD pull request.
> > Here's an updated patch that applies to Linus' current tree in case you
> > are planning a second round...
> >
> >
> > Switch MD over to the new disk_stack_limits() function which checks for
> > aligment and adjusts preferred I/O sizes when stacking.
> >
> > Also indicate preferred I/O sizes where applicable.
> 
> Given that Linus has not yet pulled in the DM changes for 2.6.31
> (which includes DM's topology support) I'd imagine it shouldn't be a
> problem to get this patch in.  In fact it would be a real shame if
> this somehow missed 2.6.31 seeing as MD is the only consumer of the
> topology infrastructure's disk_stack_limits().
> 
> Neil, please push to Linus for 2.6.31, thanks!
> 

It looks mostly OK and can now be pulled from
   git://neil.brown.name/md/ for-linus
though I'll send a more formal pull request later (if necessary)

But while I have your collective attention:

1/ Is there any documentation on exactly what "io_min" etc mean?
  I can guess that "io_opt" means "try to use this size, or a multiple
  of this size, whenever possible" and does not differentiate between
  read and write (despite the fact that I probably care a lot more
  about write than read).
  But when io_min is larger than physical_block_size, what does it
  mean?
  Maybe I just didn't look hard enough for the documentation??

2/ Is it too late to discuss moving the sysfs files out of the 'queue'
  subdirectory?
  'queue' has a lot of values the are purely related to the request
  queue used in the elevator algorithm, and are completely irrelevant
  to md and other virtual devices (I look forward to the day when md
  devices don't have a 'queue' at all).
  However these new fields are part of the interface between the block
  device and the filesystem (or other client) and so are of a very
  different character and should - I think - be in a very different
  place.
  I'm not sure where that place should be yet.  One idea I has was in
  the bdi, but that isn't completely convincing.
  However a separate directory like bdi but called e.g. topology might
  make a lot of sense.
  I would probably like to move the fields out of struct request_queue
  too, but as that is purely of internal interest, it doesn't matter
  if that is delayed a release or two.  The interface through sysfs
  is more important to get 'right'.

  So: can this be open for discussion?

Thanks,
NeilBrown
