From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: reconstructing raid5 with bad sectors
Date: Mon, 4 Aug 2003 11:36:32 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0308041128110.21796@twinlark.arctic.org>
References: <Pine.LNX.4.53.0308041002360.21796@twinlark.arctic.org>
 <20030804181415.GA3575@willow.seitz.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030804181415.GA3575@willow.seitz.com>
To: Ross Vandegrift <ross@willow.seitz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 4 Aug 2003, Ross Vandegrift wrote:

> On Mon, Aug 04, 2003 at 10:08:15AM -0700, dean gaudet wrote:
> > is there an offline tool which can reconstruct such an array?  or even an
> > offline tool which already has the parity calculation code and such which
> > i could extend to support such reconstruction?
> >
> > i considered copying the two bad disks with "dd conv=noerror,sync", which
> > would stop the kernel from marking the drives as bad, but that seems a bit
> > less than ideal because i really would like to reconstruct the bad stripes
> > using the 3 valid copies and not include an all-zeroes copy created by dd.
>
> dd_rescue sounds like your friend - it'll let you make raw backups of
> the partitions, but instead of quitting on errors, it'll keep going
> until it passes the bad areas.  You'll probably need a few disks to use
> as dd_rescue targets, but once you have images of the needed partitions,
> rebuild should work fine (assuming of course, that you're correct in saying
> the errors never overlap).


hmm i don't see what dd_rescue does which "dd conv=noerror,sync" doesn't
do.

i did use "dd conv=noerror,sync" to copy the dead disks to other new disks
-- and with that i can bring up the array (in degraded mode because i
don't want reconstruction to occur).

but the problem is that this doesn't help me recover my data from the
stripes which had errors.

i.e. my sitation is like this, for some stripes i've got:

	{ good, good, unreadable, good }

dd or dd_rescue create this situation:

	{ good, good, all zeros, good }

which doesn't help recovery... knowing which sectors are unreadable in the
first case i can recover the entire stripe by redoing the parity
calculation -- which would let me write out the proper data to a new disk.

this is basically what the online raid recovery does, but the online
recovery only supports "good/bad" on a per-disk granularity, rather than
on a per-stripe granularity.

-dean
