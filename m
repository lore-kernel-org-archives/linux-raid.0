From: NeilBrown <neilb@suse.de>
Subject: Re: Single-drive RAID0
Date: Wed, 16 Feb 2011 11:42:34 +1100
Message-ID: <20110216114234.0311d27b@notabene.brown>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
	<20110209134557.4e607451@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068C4429D@irsmsx503.ger.corp.intel.com>
	<20110214131149.7f0655a3@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB2C6E@irsmsx503.ger.corp.intel.com>
	<20110215110141.30d28302@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB347B@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408068FB347B@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 15 Feb 2011 16:30:05 +0000 "Wojcik, Krzysztof"
<krzysztof.wojcik@intel.com> wrote:

> > It might help to put a "WARN_ON(1)" in the place where it prints
> > "detected
> > capacity change ..." so we get a stack trace and can see how it got
> > there.
> > That might git a hint to what is looping.
> > Also a printk in md_open if it returns ERESTARTSYS would be
> > interesting.
> 
> In attachment part of logs from kernel with WARN_ON(1) and value returned by md_open() 
> (line preceded with "##### KW: err= x").
> 
> I am trying to look for in new areas. I've run:
> Udevd --debug --dedug-traces
> 
> Logs from udev and kernel in attachment.
> Maybe it will help to find solution...
> It seems to udev adds and removes device in loop...

Thanks for the extra logs.... it helps a bit, but I'm not a lot closer.

I've seen something a little bit like this which was fixed by adding

TEST!="md/array_state", GOTO="md_end"

just after

# container devices have a metadata version of e.g. 'external:ddf' and
# never leave state 'inactive'

in /lib/udev/rules.d/64-md-raid.rules


Could you try that??

It looks like the 'bdev' passed to md_open keeps changing, which it shouldn't.

If the above doesn't help, please add:

	printk("bdev=%p, mddev=%p, disk=%p dev=%x\n", bdev, mddev, mddev->gendisk, bdev->bd_dev);

at the top of 'md_open', and see what it produces.

Thanks,
NeilBrown

