From: NeilBrown <neilb@suse.de>
Subject: Re: Single-drive RAID0
Date: Tue, 15 Feb 2011 11:01:41 +1100
Message-ID: <20110215110141.30d28302@notabene.brown>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
	<20110209134557.4e607451@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068C4429D@irsmsx503.ger.corp.intel.com>
	<20110214131149.7f0655a3@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB2C6E@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408068FB2C6E@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 17:04:38 +0000 "Wojcik, Krzysztof"
<krzysztof.wojcik@intel.com> wrote:
> > It is possible that there is something subtle about the precise device
> > geometry.
> > Could you send me
> >    sfdisk -l /dev/sda
> > (or whatever device you are using)

You didn't include this information...







> > This patch should fix that particular problem.  Let me know if you
> > can still produce any of these errors with the patch applied.
> 
> 
> Unfortunately issue is reproducible with path applied.
> I tried to reproduce it on other setup (other PC and disks) also... issue exists :(
> 
> Interesting observation is that when I stop array just after creation and then reassemble it again, everything work fine.
> On older kernel version (I tried 2.6.34) issue is NOT reproducible also.
> 

All very strange.  And as I cannot reproduce it, it is very hard to debug.

Maybe some daemon is accessing the array at some awkward time and causing
different behaviour for you...

If it is repeatable enough that you could try 'git bisect' to find which
commit introduced the problem, that would be helpful but I suspect it would
be very time-consuming.

It might help to put a "WARN_ON(1)" in the place where it prints "detected
capacity change ..." so we get a stack trace and can see how it got there.
That might git a hint to what is looping.
Also a printk in md_open if it returns ERESTARTSYS would be interesting.

Thanks,
NeilBrown
