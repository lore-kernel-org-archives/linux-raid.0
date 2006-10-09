From: Neil Brown <neilb@suse.de>
Subject: Re: avoiding the initial resync on --create
Date: Tue, 10 Oct 2006 07:33:16 +1000
Message-ID: <17706.49180.270321.212774@cse.unsw.edu.au>
References: <20061009125700.GA10191@piper.madduck.net>
	<20061009134946.GA26122@harddisk-recovery.com>
	<1160411520.2917.76.camel@fc6.xsintricity.com>
	<37950.192.168.0.1.1160421056.squirrel@bymeinc.com>
	<1160423139.2917.112.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Monday October 9
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Rob Bray <raid@bymeinc.com>, martin f krafft <madduck@madduck.net>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday October 9, dledford@redhat.com wrote:
> 
> The original email was about raid1 and the fact that reads from
> different disks could return different data.

To be fair, the original mail didn't mention "raid1" at all.  It did
mention raid5 and raid6 as a possible contrast so you could reasonably
get the impression that it was talking about raid1.  But that wasn't
stated.

Otherwise I agree.  There is no real need to perform the sync of a
raid1 at creation.
However it seems to be a good idea to regularly 'check' an array to
make sure that all blocks on all disks get read to find sleeping bad
blocks early.  If you didn't sync first, then every check will find
lots of errors.  Ofcourse you could 'repair' instead of 'check'.  Or
do that once.  Or something.

For raid6 it is also safe to not sync first, though with the same
caveat as raid1.  Raid6 always updates parity by reading all blocks in
the stripe that aren't known and calculating P and Q.  So the first
write to a stripe will make P and Q correct for that stripe.
This is current behaviour.  I don't think I can guarantee it will
never changed.

For raid5 it is NOT safe to skip the initial sync.  It is possible for
all updates to be "read-modify-write" updates which assume the parity
is correct.  If it is wrong, it stays wrong.  Then when you lose a
drive, the parity blocks are wrong so the data you recover using them
is wrong.

In summary, it is safe to use --assume-clean on a raid1 or raid1o,
though I would recommend a "repair" before too long.  For other raid
levels it is best avoided.

> 
> Probably the best thing to do would be on create of the array, setup a
> large all 0 block of mem and repeatedly write that to all blocks in the
> array devices except parity blocks and use a large all 1 block for that.

No, you would want 0 for the parity block too.  0 + 0 = 0.

> Then you could just write the entire array at blinding speed.  You could
> call that the "quick-init" option or something.  You wouldn't be able to
> use the array until it was done, but it would be quick. 

I doubt you would notice it being faster than the current
resync/recovery that happens on creation.  We go at device-speed -
either the buss device or the storage device depending on which is
slower.


>                                                          If you wanted
> to be *really* fast, at least for SCSI drives you could write one large
> chunk of 0's and one large chunk of 1's at the first parity block, then
> use the SCSI COPY command to copy the 0 chunk everywhere it needs to go,
> and likewise for the parity chunk, and avoid transferring the data over
> the SCSI bus more than once.

Yes, that might be measurably faster.  It is the sort of thing you might
do in a "hardware" RAID controller but I doubt it would ever get done
in md (there is a price for being very general).

NeilBrown
