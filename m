From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RAID-6 check standalone suspend array V2.0
Date: Tue, 26 Jul 2011 15:25:23 +1000
Message-ID: <20110726152523.54433754@notabene.brown>
References: <20110321140244.2314b4b4@notabene.brown>
	<20110321104007.GA15379@lazy.lzy>
	<20110321220457.29d52f5c@notabene.brown>
	<20110321115440.GA15635@lazy.lzy>
	<20110322095905.737fb1d5@notabene.brown>
	<20110404175242.GA3411@lazy.lzy>
	<20110405091242.3427e0b1@notabene.brown>
	<20110508185408.GA25378@lazy.lzy>
	<20110509114500.116926ba@notabene.brown>
	<20110509184333.GA28743@lazy.lzy>
	<20110515211515.GA30260@lazy.lzy>
	<20110516200857.3a009a64@notabene.brown>
	<4E2716EF.1050509@nexgo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E2716EF.1050509@nexgo.de>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 20 Jul 2011 19:57:03 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi Neil,
> 
> sorry for the very late answer.
> 
> On 05/16/2011 12:08 PM, NeilBrown wrote:
> > On Sun, 15 May 2011 23:15:15 +0200 Piergiorgio Sartor
> > <piergiorgio.sartor@nexgo.de> wrote:
> > 
> >> Hi Neil,
> >>
> >> reminder for the suspend patch.
> >>
> >> Thank you so much for the code review.
> >>
> >> I modified it in order to fix, hopefully, all the flaws.
> >>
> >> New patch attached below.
> >>
> >> Please note that "sigblock()" cannot be used, since it is
> >> declared, at least on my system, as "deprecated".
> >> Furthermore, I noticed that "Grow.c" is not checking the
> >> return value of "sysfs_set_num()" while suspending the
> >> array, maybe you'll need to look at this.
> >>
> >> Finally, please check the new patch too, while I can
> >> confirm the software is doing what is supposed to do,
> >> I still need support in order to confirm the suspend
> >> and resume code.
> >>
> >> Thanks again for your help, again let me know what
> >> is the next expected step.
> > 
> > That all looks fine thank.  I've applied it and pushed it out.
> > 
> > I'm not sure what you mean exactly by the 'next expected step'... 
> 
> Well, is there anything than should be done, like
> documentation or code cleanup?
> 
> At the moment, it seems to me, the check itself it is
> fine, maybe performance is not at best (anyone wants
> to help, here?).
> 
> So, I was thinking about the "repair" process, that is
> fixing the chunks which seem corrupted, instead of just
> the parity.
> 
> Before I go that way, I would like to close pending issues,
> if any, with the actual software.

Very sensible - thanks.

I haven't actually used it or tested it at all so I don't know of any issues
in that regard.
I agree with an earlier reply that a man-page would be a good idea.
You could start by looking at "mdadm.8.in" and basing your man page on that.
It doesn't have to be very long - just explain what it does and how to use
it, and maybe how to interpret the results.
Often writing a man page is enough to flush out any serious usability issues
- if you find it hard to explain how to use it, it is probably because it is
hard to use :-)

If you aren't familiar with the troff -man markup language don't let it worry
you - I am happy to fix up any markup issues before including it.

It might be good to create a test script too - something that can go in the
tests/ directory would be ideal.
e.g. create and initialise a RAID6, deliberately corrupt one block, then run
your program an check that it reports the right thing.
Probably corrupt a different blocks (randomly?) on each device and test that
it reports all of the errors correctly... something like that.

NeilBrown
