From: "A.J.Dawson" <A.J.Dawson@Bradford.ac.uk>
Subject: Re: RAID5 over Serial-ATA success stories?
Date: Thu, 8 Jan 2004 11:48:43 +0000 (GMT Standard Time)
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <Pine.WNT.4.44.0401081137060.2020-100000@ender>
References: <20040108085711.A2500@nettis.grimsta>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20040108085711.A2500@nettis.grimsta>
To: Daniel Brahneborg <basic@wtnord.net>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mru@kth.se>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 8 Jan 2004, Daniel Brahneborg wrote:

> > Which Adaptec card?  The 12xx cards are fakeraid, but are supported as
> > normal cards.  The 24xx cards are true hardware RAID cards.  Linux
> > drivers exist for these, too.

I've used a couple of the 2400A cards for a while under Linux (SuSE 8.2)
with mixed results - one works fine in RAID 5 mode (4x 120Gb disks),
though it is very slow (typical sustained transfer on about 10Mb/s).  The
other is a completely different story.  It keeps dropping disks from the
array that subsequently test out to be perfectly okay.  It also has a
nasty habit of not letting me rebuild the array even after putting a new
disk in.  I get a 'missing component' error that even Adaptec seem to know
nothing about (well, they've not bothered answering any of my e-mails
about it*).  This means that I have to rebuild the array again from
scratch (build + verify = a complete day) and then restore the data from
backup.  Out of four disks that have been dropped from the array recently,
three tested fine.  On more than one occasion it has also given me a
double disk failure within a couple of hours, not enough time to complete
the rebuild for the first drive before the second one 'fails'.  Again,
drives subsequently tested out fine.

The end result is that I got so fed up with it happening that I took the
card out and dropped it into a drawer.  I've replaced it with a couple of
software mirroed 250Gb drives which (so far) seem to be working fine and
give me a lot fewer headaches!

I'd not recommend this card to *anyone* any more.

* I'm pretty annoyed with Adaptec about this one - I've not even had a 'we
don't know the answer' e-mail from them.  I've tried eveything that I
could think of including replacing all of the cables, updating the
firmware on the drives (WD), hard resetting the 2400A, updating the
firmware and SMOR (twice) and replacing the cache memory.  I've
told Adaptec about everything that I have tried and they have not
even had the courtesy to reply to me.

Anyone at Adaptec care to comment?

Regards

Dr. Andy Dawson
A.J.Dawson@Bradford.ac.uk
http://www.mossie.org
http://www.museum-explorer.org.uk

 Never attribute to malice that which is adequately explained by stupidity.

