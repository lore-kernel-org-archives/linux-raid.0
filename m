From: "Scott T. Smith" <scott@gelatinous.com>
Subject: Re: 3Ware 7506-8, anyone have any luck?  I don't...
Date: Fri, 15 Oct 2004 11:21:47 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097864507.13828.70.camel@tinny.home.foo>
References: <ckoj1a$pls$1@sea.gmane.org>
	 <Pine.CYG.4.58.0410151323230.2068@buggz4>
	 <1097862002.13597.57.camel@tinny.home.foo>
	 <20041015181205.GB3035@inara.maison.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041015181205.GB3035@inara.maison.net>
To: KELEMEN Peter <Peter.Kelemen@cern.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2004-10-15 at 11:12, KELEMEN Peter wrote:
> * Scott T. Smith (scott@gelatinous.com) [20041015 10:40]:
> 
> > On Fri, 2004-10-15 at 10:27, buggz wrote:
> > > Anyone use the 3ware 7506-8 card in ANY motherboard? [...]
> 
> > We used three successfully in one motherboard.  We have since
> > switched to RocketRaid 1820A's for performance reasons though.
> 
> It's only fair to mention that the 3ware 7506 is a 64-bit/66MHz
> PCI PATA card

You know what, I think I was wrong -- we have the 8506.  Sorry, my bad. 
And ours is SATA, not PATA (is that the difference between the 7xxx and
8xxx?)

> , while the HighPoint RocketRAID 1820A is a
> 64-bit/133MHz PCI-X SATA card, so comparing their performance is
> comparing apples to oranges.

There are other reasons the Highpoint is better than the 3ware,
including the fact that it instantly recognizes when you yank a disk,
unlike the 3ware which sits there for a while, and then hard resets the
entire controller (thus halting all disk io to that controller for a
couple of seconds).  3ware wrote me back and told me it's supposed to do
that!

> In the SATA PCI-X league HighPoint is not such a shiny player
> performance-wise but has attractive pricing, see:
> http://www.tomshardware.com/storage/20040831/sata-raid-controller-16.html

Is the 9500 a PCI-X card?  We have three of the 9xxx (don't know exactly
which one, might be the 9000-8ML) in another chassis (using multilane,
which basically bundles 4 SATA cables on one monster cable), and we get
the same crappy performance from that one too.  Worse yet, the 9xxx
series wants to hijack your disks unless you go out of your way to
enable 'export JBOD' mode.  You can't take a disk from a 9xxx controller
and put it in a box with an 8506 -- the controller won't recognize it!

BTW I'm not talking about RAID or filesystem performance, I'm talking
about direct disk access, JBOD mode, using rather large blocks.  So
really all I want is multiple controllers on a single card.  To that
end, the 1820a works great.  I figure we'd all be running software RAID
anyways ;-)

	Scott


