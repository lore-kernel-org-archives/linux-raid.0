From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [OT] best tape backup system?
Date: Wed, 23 Feb 2005 21:28:31 +0300
Message-ID: <421CCB4F.2020301@tls.msk.ru>
References: <200502230126.j1N1Q5923933@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200502230126.j1N1Q5923933@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> I know a thing or 2 about SCSI.  I know I had it correct.  1 config was all
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
> each case.  I also tried a 2940UW, no LVD, all SE.  All configs worked if I
> only used the disks or the tape drives, but failed if I used disks and tape
> at the same time.

Well, this is weird.  We have numerous configurations with mixed tapes and
disks (and other stuff) and had no single problem so far, everything just
works (except of that obvious LVD vs SE issue).  Including 2940UW and other
controllers.

/mjt
