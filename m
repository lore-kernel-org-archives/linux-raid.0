From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 14:42:59 +1100
Message-ID: <16858.4291.816499.371678@cse.unsw.edu.au>
References: <l1nna2-e9i.ln1@news.it.uc3m.es>
	<200501031846.42950.maarten@ultratux.net>
	<200501032052.21459.maarten@ultratux.net>
	<a9noa2-o12.ln1@news.it.uc3m.es>
	<fh0pa2-kvp.ln1@news.it.uc3m.es>
	<16857.55609.534526.297577@cse.unsw.edu.au>
	<jh4pa2-pi.ln1@news.it.uc3m.es>
	<16857.64086.362458.177296@cse.unsw.edu.au>
	<6d5bedd80501031816eb8f296@mail.gmail.com>
	<16857.65024.745883.752981@cse.unsw.edu.au>
	<20050104024108.GK99565@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andy Smith on Tuesday January 4
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 4, andy@strugglers.net wrote:
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
> Whether it is true or not it's clear to me that it's not obvious to
> everyone.

If Peter says that, then Peter is WRONG.

ext3 journals are much safer on mirrored devices than on non-mirrored
devices just the same as any other data is safer on mirrored than on
non-mirrored. 
In the case in question, it is raid5, not mirrored, but still raid5 is
safer than raid0 or single devices (possibly not quite as safe was raid1).

NeilBrown
