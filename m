From: Neil Brown <neilb@suse.de>
Subject: Re: raid6 rebuild
Date: Wed, 11 Apr 2007 11:43:20 +1000
Message-ID: <17948.15672.420527.629228@notabene.brown>
References: <20070404194638.GB3712@xi.wantstofly.org>
	<e9c3a7c20704042022p6088bdcdl97740d2a95818caf@mail.gmail.com>
	<20070405055030.GA6978@xi.wantstofly.org>
	<4614FF86.3020007@tmr.com>
	<20070405140626.GA8726@xi.wantstofly.org>
	<e9c3a7c20704050959t7a1866b3j8e3bcc64a893854c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Thursday April 5
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, Bill Davidsen <davidsen@tmr.com>, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 5, dan.j.williams@intel.com wrote:
> On 4/5/07, Lennert Buytenhek <buytenh@wantstofly.org> wrote:
> > On Thu, Apr 05, 2007 at 09:54:14AM -0400, Bill Davidsen wrote:
> >
> > > I confess, I would feel safer with my data if the rebuild started
> > > over, I would like to be sure that when it (finally) finishes the
> > > data are valid.
> >
> > With disk #3 about to die, I'd have felt safer if it first finished
> > rebuilding the replacement disk for failed disk #1 (that rebuild had
> > almost completed at that point), safeguarding the array against a
> > third disk failure.
> >
> I agree, the current arrangement seems to throw away a significant
> amount of work.  Yes, you will need to resync when re-adding the
> second disk, but in the meantime might as well try to get a redundant
> mode at all costs.

Yes, I think you are right.
If you want it to restart from the beginning you can alway abort the
current resync by 'echo idle > sync_action'.
The question is: is it really as simple to do as it sounds.
I seem to remember that aborting the recovery on any error was any
easy way to avoid some nasty race, but I have no idea what the race
was.
One would need the enumerate all the interesting cases and make sure
they will all work as expected.  I cannot think of an problems
immediately but that doesn't mean there aren't any...

It is now on my todo list...

NeilBrown
