From: Phil Turmel <philip@turmel.org>
Subject: Re: some general questions on RAID
Date: Thu, 04 Jul 2013 18:07:40 -0400
Message-ID: <51D5F22C.70007@turmel.org>
References: <1372962602.8716.56.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372962602.8716.56.camel@heisenberg.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/04/2013 02:30 PM, Christoph Anton Mitterer wrote:

> 1) I plan to use dmcrypt and LUKS and had the following stacking in
> mind:
> physical devices -> MD -> dmcrypt -> LVM (with multiple LVs) ->
> filesystems
> 
> Basically I use LVM for partitioning here ;-)
> 
> Are there any issues with that order? E.g. I've heard rumours that
> dmcrypt on top of MD performs much worse than vice versa...

Last time I checked, dmcrypt treated barriers as no-ops, so filesystems
that rely on barriers for integrity can be scrambled.  As such, where I
mix LVM and dmcrypt, I do it selectively on top of each LV.

I believe dmcrypt is single-threaded, too.

If either or both of those issues have been corrected, I wouldn't expect
the layering order to matter.  I'd be nice if a lurking dmcrypt dev or
enthusiast would chime in here.

> But when looking at potential disaster recovery... I think not having MD
> directly on top of the HDDs (especially having it above dmcrypt) seems
> stupid.

I don't know that layering matters much in that case, but I can think of
many cases where it could complicate things.

> 2) Chunks / Chunk size
> a) How does MD work in that matter... is it that it _always_ reads
> and/or writes FULL chunks?

No.  It does not.  It doesn't go below 4k though.

> Guess it must at least do so on _write_ for the RAID levels with parity
> (5/6)... but what about read?

No, not even for write.  If an isolated 4k block is written to a raid6,
the corresponding 4k blocks from the other data drives in that stripe
are read, both corresponding parity blocks are computed, and the three
blocks are written.

> And what about read/write with the non-parity RAID levels (1, 0, 10,
> linear)... is the chunk size of any real influence here (in terms of
> reading/writing)?

Not really.  At least, I've seen nothing on this list that shows any
influence.

> b) What's the currently suggested chunk size when having a undetermined
> mix of file sizes? Well it's obviously >= filesystem block size...
> dm-crypt blocksize is always 512B so far so this won't matter... but do
> the LVM physical extents somehow play in (I guess not,... and LVM PEs
> are _NOT_ always FULLY read and/or written - why should they? .. right?)
> From our countless big (hardware) RAID systems at the faculty (we run a
> Tier-2 for the LHC Computing Grid)... experience seems that 256K is best
> for an undetermined mixture of small/medium/large files... and the
> biggest possible chunk size for mostly large files.
> But does the 256K apply to MD RAIDs as well?

For parity raid, large chunk sizes are crazy, IMHO.  As I pointed out in
another mail, I use 16k for all of mine.

> 3) Any extra benefit from the parity?
> What I mean is... does that parity give me kinda "integrity check"...
> I.e. when a drive fails completely (burns down or whatever)... then it's
> clear... the parity is used on rebuild to get the lost chunks back.
>
> But when I only have block errors... and do scrubbing... a) will it tell
> me that/which blocks are damaged... it will it be possible to recover
> the right value by the parity? Assuming of course that block
> error/damage doesn't mean the drive really tells me an error code for
> "BLOCK BROKEN"... but just gives me bogus data?

This capability exists as a separate userspace utility "raid6check" that
is in the process of acceptance into the mdadm toolkit.  It is not built
into the kernel, and Neil Brown has a long blog post explaining why it
shouldn't ever be.  Built-in "check" scrubs will report such mismatches,
and the built-in "repair" scrub fixes them by recomputing all parity
from the data blocks.

Phil
