From: Neil Brown <neilb@suse.de>
Subject: Re: accessing mirrired lvm on shared storage
Date: Mon, 17 Apr 2006 08:53:49 +1000
Message-ID: <17474.51965.988298.906463@cse.unsw.edu.au>
References: <44355BC9.4020608@mailing.kaufland-informationssysteme.com>
	<20060407134636.2bce1917@mwdsp001>
	<17468.32144.316047.478627@cse.unsw.edu.au>
	<170fa0d20604130757s22407500ude1bcc16d499273@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Thursday April 13
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: Chris Osicki <osk@admin.swisscom-mobile.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 13, snitzer@gmail.com wrote:
> On 4/12/06, Neil Brown <neilb@suse.de> wrote:
> 
> > One thing that is on my todo list is supporting shared raid1, so that
> > several nodes in the cluster can assemble the same raid1 and access it
> > - providing that the clients all do proper mutual exclusion as
> > e.g. OCFS does.
> 
> Very cool... that would be extremely nice to have.  Any estimate on
> when you might get to this?
> 

I'm working on it, but there are lots of distractions....

The first step is getting support into the kernel for various
operations like suspending and resuming IO and resync.
That is progressing nicely.

The next step is writing a user-space app which co-ordinates
everything.  e.g. makes sure device-failed and device-added events
happen everywhere before they are acknowledged anywhere and stuff like
that.  I don't know how that will progress.
I hope to have something to demonstrate early in the second half of
the year.

NeilBrown

