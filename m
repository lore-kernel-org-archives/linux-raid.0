From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: [OT] best tape backup system?
Date: Wed, 23 Feb 2005 14:46:13 -0500
Message-ID: <200502231946.j1NJkI927144@www.watkins-home.com>
References: <421CCB4F.2020301@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <421CCB4F.2020301@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Tokarev' <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We must be in 2 different worlds!!!

I can have wide LVD and narrow SE on the same card (2940U2W).  And wide
ultra and narrow SE on the same card (2940UW).  That is why the card is so
good.  IMO.  Just not with linux.  The OS that must not be named, supports
the above.  :(  In fact, I have a PC with a 2940UW with 2 disks (UW), 2 CDs,
1 DDS3 and a zip drive.  All happy with OS to not be named 98.  Maybe I
should try knopix, and see if that system likes Linux.

However, as I said before.  I did not swap out every component.  I used the
same disks every time, but did swap the data cables, tape drives, SCSI cards
and terminators.  But those disks still work today in U2W (LVD-80) mode.

My last attempt to mix SCSI disks and tapes was over 1 year ago, using RH9.
On previous attempts I would have used RH7.  I don't recall ever using RH8.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Michael Tokarev
Sent: Wednesday, February 23, 2005 1:29 PM
To: linux-raid@vger.kernel.org
Subject: Re: [OT] best tape backup system?

Guy wrote:
> I know a thing or 2 about SCSI.  I know I had it correct.  1 config was
all
> wide LVD (2940U2W).  My card has a LVD and a SE port on the same logical
> SCSI bus.

I was surprized once when I noticied such "logical SCSI bus" really isn't
"logical" per se.  I mean, if I plug ANY device into the "SE port", all
devices, including the ones attached to "LVD port" switches to SE mode.
Another channel - yes, sure, but not another port (connector) on the
same channel.  Well, I can't say for all vendors and all cards, but the
ones we have here (mostly adaptec and ncr/sym) works this way.  For example,
Adaptec AHA-3940U2x controller: it's 2-channel card with 3 ports, two
68pin LVD/SE (one per channel) and one older "scsi-like-ide" connector
attached to 1st channel -- any device attached to this last connector
forces the whole 1st channel to go into SE mode, and no LVD-only device
works (in fact, it does not work at all in this case with any LVD-only
device attached).

>   Another config was wide LVD disks and a narrow SE tape.  Another,
> my disks support SE, I had all SE wide and narrow.  Correct terminators in
> each case.  I also tried a 2940UW, no LVD, all SE.  All configs worked if
I
> only used the disks or the tape drives, but failed if I used disks and
tape
> at the same time.

Well, this is weird.  We have numerous configurations with mixed tapes and
disks (and other stuff) and had no single problem so far, everything just
works (except of that obvious LVD vs SE issue).  Including 2940UW and other
controllers.

/mjt
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

