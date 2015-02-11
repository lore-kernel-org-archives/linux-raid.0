From: Phil Turmel <philip@turmel.org>
Subject: Re: Wierd: Degrading while recovering raid5
Date: Wed, 11 Feb 2015 09:28:23 -0500
Message-ID: <54DB6707.5030901@turmel.org>
References: <CAP7a4URzYsvw9aEd117FAs9_AE4fk1FuHQAmQQqreb3Y1yvOdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAP7a4URzYsvw9aEd117FAs9_AE4fk1FuHQAmQQqreb3Y1yvOdg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kyle Logue <teque5@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/11/2015 01:23 AM, Kyle Logue wrote:
> Phil:
> 
> For a while I really thought that was going to work. I swapped out the
> sata cable and set the timeout to 10 minutes. At about 70% rebuilt I
> got the following dmesg which seems to indicate the death of my sdc
> drive.

Ten minutes is way overkill.  The three minutes I suggested is already
extreme, and most drives will only need two minutes.

> Here is my question: I still have this sde that I manually failed and
> hasn't been touched. Can i force re-add it to the array and just take
> the data corruption hit?

No, sde is being replaced by sda, so it's no help for sdc.  If you put
it back into service, it would have to take the role of sda.  (Forced
assembly, though, not a re-add.)  If the array was in use during your
first replacement attempt, the differences could be substantial.

I'm not sure how MD will handle the rebuild status in this case.
Hopefully, it will take you back to a working, non-rebuilding array.  If
you try this, you should test with a set of overlay devices as described
on the wiki.

> I'd rather have to revert part of my data than all of it. The drive
> counts are significantly different now, but I haven't mounted the
> drives since the beginning. I haven't tried it but I saw someone else
> online get a message like 'raid has failed so using --add cannot work
> and might destroy data'. Is there a force add? What are my chances?

The right answer here depends on whether the array was in use.  If it
wasn't, I'd try to use sde in place of sda to get back to a
non-rebuilding array.  If the test run succeeds, undo the overlays and
do it for real.  Then zero the superblock on sda, add it back as a
spare, then --replace sdc.

If the trial doesn't work (or the changes to sda too great), the
alternative is to ddrescue sdc onto a spare disk (sde would be available
at that point, if it's useless for assembly).  Then manually reassemble
and let the rebuild finish.  If you run into more errors on the other
members, you may have to repeat the ddrescue process for each.

Whichever path you take, when done, consider switching to raid6 using
the extra drive.  That's far more secure than a hot spare (if a little
slower).

I did notice one other issue in your posted dmesg:  misaligned
partitions.  This cripples MD's ability to fix UREs on the fly or during
a scrub.  You *must* rebuild your array with properly aligned partitions
before you quit.

Phil
