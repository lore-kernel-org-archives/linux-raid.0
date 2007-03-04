From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt questions
Date: Mon, 5 Mar 2007 09:30:32 +1100
Message-ID: <17899.18568.523543.478792@notabene.brown>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>
	<17898.45673.573800.56474@notabene.brown>
	<45EB3867.8050907@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eyal Lebedinsky on Monday March 5
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 5, eyal@eyal.emu.id.au wrote:
> Neil Brown wrote:
> > On Sunday March 4, pernegger@gmail.com wrote:
> >>I have a mismatch_cnt of 384 on a 2-way mirror.
> [trim]
> >>3) Is the "repair" sync action safe to use on the above kernel? Any
> >>other methods / additional steps for fixing this?
> > 
> > "repair" is safe, though it may not be effective.
> > "repair" for raid1 was did not work until Jan 26th this year.
> > Before then it was identical in effect to 'check'.
> 
> How is "repair" safe but not effective? When it finds a mismatch, how does
> it know which part is correct and which should be fixed (which copy of
> raid1, or which block in raid5)?

It is not 'effective' in that before 26jan2007 it did not actually
copy the chosen data on to the other drives.  i.e. a 'repair' had the
same effect as a 'check', which is 'safe'.

> 
> When a disk fails we know what to rewrite, but when we discover a mismatch
> we do not have this knowledge. It may corrupt the good copy of a raid1.

If a block differs between the different drives in a raid1, then no
copy is 'good'.  It is possible that one copy is the one you think you
want, but you probably wouldn't know by looking at it.
The worst situation is the have inconsistent data. If you read and get
one value, then later read and get another value, that is really bad.

For raid1 we 'fix' and inconsistency by arbitrarily choosing one copy
and writing it over all other copies.
For raid5 we assume the data is correct and update the parity.

You might be able to imagine a failure scenario where this produces
the 'wrong' result, but I'm confident that is the majority of cases it
is as good as any other option.

If we had something like ZFS which tracks checksums for all blocks,
and could somehow get that information usefully into the md level,
than maybe we could do something better.

I suspect that it would be very rare for raid5 to detect a mismatch
during a 'check', and raid1 would only see them when a write was
aborted, such as swap can do, and filesystems might do occasionally
(e.g. truncate a file that was recently written to).

NeilBrown
