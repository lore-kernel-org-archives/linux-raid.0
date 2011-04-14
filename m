From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RAID-6 check standalone code cleanup
Date: Thu, 14 Apr 2011 17:32:27 +1000
Message-ID: <20110414173227.75c9fede@notabene.brown>
References: <20110221204551.GA15675@lazy.lzy>
	<20110321140244.2314b4b4@notabene.brown>
	<20110321104007.GA15379@lazy.lzy>
	<20110321220457.29d52f5c@notabene.brown>
	<20110321115440.GA15635@lazy.lzy>
	<20110322095905.737fb1d5@notabene.brown>
	<20110404175242.GA3411@lazy.lzy>
	<20110405091242.3427e0b1@notabene.brown>
	<20110406180202.GA3267@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110406180202.GA3267@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 6 Apr 2011 20:02:02 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi Neil,
> 
> On Tue, Apr 05, 2011 at 09:12:42AM +1000, NeilBrown wrote:
> > On Mon, 4 Apr 2011 19:52:42 +0200 Piergiorgio Sartor
> > <piergiorgio.sartor@nexgo.de> wrote:
> > 
> > > Hi Neil,
> > > 
> > > please find below a second patch to "raid6check.c".
> > > This applies on top of the previous one.
> > > 
> > > Major change is code cleanup and simplification.
> > > Furthermore, a better error handling and a couple
> > > of bug fixes.
> > > Last but not least, the command line parameters are
> > > changed from "bytes" to "stripes", which is more
> > > convenient, I guess.
> > 
> > Thanks - I've applied this.
> 
> please find attached very below the fix for the
> component list scanning. Taking care, hopefully,
> to skip/avoid spare drives.
> Furthermore, I added also a check for degraded
> array, which should not be checked.
> 
> > I'm not sure about using 'stripes', though it would be hard to argue in
> > favour of 'bytes'.
> > Possibly the best number to use would be 'sectors' as that is how the kernel
> > would report an inconsistency.
> > 
> > Once the code settles and you work out what the expected usage pattern would
> > be, it might then be obvious what the best number is.  i.e. try to document
> > how it would be use and if you find yourself describing complex calculations,
> > then change the program so it does the the calculations and you document can
> > avoid the complexity.
> 
> I switched to "stripes" because the code is using theme
> all over and because I was continuosly calculating from
> stripe to bytes.
> 
> I guess you're right, later it will be possible to decided
> which is the better unit for command line and for the
> error reporting.
> 
> > > 
> > > If you prefer, I can send a single patch, including
> > > in one shot the last one and this one.
> > 
> > no, multiple patches are much better - thanks.
> > 
> > As for the granularity for suspend/check/fix/unsuspend, I suspect that 
> > per-stripe would be best.
> > A smaller size wouldn't work, and a bigger size would only be helpful if
> > there were lots and lots of fixes needed ... which hopefully won't be the
> > case.
> 
> The suspend story might be a bit more complex than
> I was considering.
> 
> For example, what will happen if the user hits ctrl-c
> while the array is suspended?
> Maybe the signals will have to be blocked or re-routed
> to a proper cleanup function.
> How about kill -9?

Definitely catch signals like SIGTERM SIGINT SIGQUIT.

There is nothing you can do about SIGKILL - if someone sends that, it is
their own fault if things break.

> 
> Second issue, the stripe in the array should be suspend
> also in case the user wants a correction to happen.
> In this situation, the suspend should include read, check
> and write, since it will not be possible to allow some
> other access in between the operations.
> Could it be this is too long time for the stripe to be
> blocked?
> 
> Maybe it would be simpler to require the arrays is in
> read only mode....
> 
> What do you think?
> 

Certainly encouraging - in the documentation - the array to not be in active
use while you check/fix it would be a good thing.
But a read/check/write should not take more than a few dozen milliseconds.
Suspending IO for that long shouldn't be a problem.

NeilBrown

