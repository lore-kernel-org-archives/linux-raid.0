From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: mdadm-grow-continue service crashing (similiar to "raid5 reshape
 is stuck" thread from May)
Date: Mon, 13 Jul 2015 16:38:58 -0500
Message-ID: <CACsGCyTEEEX-nLGVhCzoLwTOWgaJv8kS6QNwK8V=VZCOsfqtSw@mail.gmail.com>
References: <CACsGCySTbrEYddSNfi7+9KnxWeddkBGDbxTsBSJkkvGHOaJwKg@mail.gmail.com>
	<55A26F65.5020703@turmel.org>
	<CACsGCyT5vgFkQEc1zgKCGgT_rO5V4cmuFmo9K4vwiqN4JsPLJA@mail.gmail.com>
	<55A3C30F.404@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55A3C30F.404@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On Mon, Jul 13, 2015 at 8:54 AM, Phil Turmel <philip@turmel.org> wrote:
> Hi Eddie,
> On older kernels without support for --replace, the correct
> operation is --add spare then --fail, --remove.

Makes sense.  That was my original plan, since I didn't know about the
replace option.  Doing otherwise was a bad decision on my part.

To make sure I understand this: 1) If you start out with a 4-drive
healthy raid5 array and do add / fail / remove, the "fail" step
immediately removes that drive from being an active participant in the
array and causes the new drive to be populated with data recalculated
from parity, right?  2) The new drive will sit in the array as a
"spare" until it is needed, which doesn't happen until the "fail"
step?  And, 3)  The "replace" option, instead, does the logical
equivalent of moving all the data off one drive onto a spare but
doesn't involve the other drives in a parity recalculation?

>> it shouldn't risk the actual data stored on the RAID,should it?
>
> In theory, no.  But the --grow operation has to move virtually every
> data block to a new location, and in your case, then back to its
> original location.  Lots of unnecessary data movement that has a
> low but non-zero error-rate.
>
> Also, the complex operations in --grow have produced somewhat
> more than its fair share of mdadm bugs.  Stuck reshapes are usually
> recoverable, but typically only with assistance from this list.  Drive
> failures during reshapes can be particularly sticky, especially when
> the failure is of the device holding a critical section backup.

That all makes perfect sense, thanks.

> I don't use systemd so can't advise on this.  Without systemd, mdadm
> just runs mdmon in the background and it all just works.

I can't exactly say I use it by choice.  I'd change distros but that
would only delay the inevitable.

> Growing and shrinking didn't do anything to replace your suspect drive.
> It just moved the data blocks around on your other drives, all while
> not redundant.

I'm confused here.  I started the grow 4->5 with a healthy raid5 with
4 drives.  One of the four drives was "suspect" in that I expect it to
fail at some point in the near future -- but it hadn't yet failed.  I
thought this grow would give me a raid with four data drives + one
parity drive, all working.  (And it seemed to.)  And then I could fail
the suspect drive and go back down to three data drives + one parity.
The final output of the shrink certainly agrees with what you say, but
I clearly don't understand it.  I don't understand how going from 4
healthy drives to 5 healthy drives, and then failing and removing one
of them and shrinking back down to 4 drives, ended up with 3 good and
one spare.  But that is what happened.

> It seems there is a corner case where at completion of shrink where one
> device becomes a spare, the new spare doesn't trigger the recovery code
> to pull it into service.
>
> Probably never noticed because reshaping a degraded array is *uncommon*.
>  :-)

It would be nice if my error in judgement helps save someone else in
the future!  If there is any data I can gather from my server that
will help, I can get it.  Although I won't be reproducing this
experiment any time in the future on a server that has any data I care
about.  But note that I didn't reshape a degraded array.  I reshaped a
healthy array and ended up with a degraded one.

                   Eddie
