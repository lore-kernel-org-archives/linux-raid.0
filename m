From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 10:46:48 +0100
Message-ID: <895qa2-0qa.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <6d5bedd80501031816eb8f296@mail.gmail.com> <16857.65024.745883.752981@cse.unsw.edu.au> <20050104024108.GK99565@caffreys.strugglers.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy Smith <andy@strugglers.net> wrote:
> [-- text/plain, encoding quoted-printable, charset: us-ascii, 20 lines --]
> 
> On Tue, Jan 04, 2005 at 01:22:56PM +1100, Neil Brown wrote:
> > On Monday January 3, ewan.grantham@gmail.com wrote:
> > > I've setup a RAID-5 array using two internal 250 Gig HDs and two
> > > external 250 Gig HDs through a USB-2 interface. Each of the externals
> > > is on it's own card, and the internals are on seperate IDE channels.
> > > 
> > > I "thought" I was doing a good thing by doing all of this and then
> > > setting them up using an ext3 filesystem.
> > 
> > Sounds like a perfectly fine setup (providing always that external
> > cables are safe from stray feet etc).
> > 
> > No need to change anything.
> 
> Except that Peter says that the ext3 journals should be on separate
> non-mirrored devices and the reason this is not mentioned in any
> documentation (md / ext3) is that everyone sees it as obvious.

No, I dont say the "SHOULD BE" is obvious.  I say the issues are
obvious.  The "should be" is up to you to decide, based on the obvious
issues involved :-).

> Whether it is true or not it's clear to me that it's not obvious to
> everyone.

It's not obvious to anyone, where by "it" I mean whether or not you
"should" put a journal on the same raid device.  There are pros and
cons.  I would not.  My reasoning is that I don't want data in the
journal to be subject to the same kinds of creeping invisible corruption
on reboot and resync that raid is subject to.  But you can achieve that
by simply not putting data in the journal at all. But what good does
the journal do you then? Well, it helps you avoid an fsck on reboot. 
But do you wantto avoid an fsck?

And reason onwards ... I won't rehash the arguments.

Peter

