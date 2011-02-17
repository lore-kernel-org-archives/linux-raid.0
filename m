From: NeilBrown <neilb@suse.de>
Subject: Re: Single-drive RAID0
Date: Thu, 17 Feb 2011 11:38:48 +1100
Message-ID: <20110217113848.17673231@notabene.brown>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
	<20110209134557.4e607451@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068C4429D@irsmsx503.ger.corp.intel.com>
	<20110214131149.7f0655a3@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB2C6E@irsmsx503.ger.corp.intel.com>
	<20110215110141.30d28302@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB347B@irsmsx503.ger.corp.intel.com>
	<20110216114234.0311d27b@notabene.brown>
	<BE2BFE91933D1B4089447C644860408069028F47@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408069028F47@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 16:57:06 +0000 "Wojcik, Krzysztof"
<krzysztof.wojcik@intel.com> wrote:

> > 
> > It looks like the 'bdev' passed to md_open keeps changing, which it
> > shouldn't.
> > 
> > If the above doesn't help, please add:
> > 
> > 	printk("bdev=%p, mddev=%p, disk=%p dev=%x\n", bdev, mddev, mddev-
> > >gendisk, bdev->bd_dev);
> > 
> > at the top of 'md_open', and see what it produces.
> 
> I tried this also but I can't see any useful information that can make me some idea.
> Could you look at logs in attachment?
> 

Thanks.

That at-least confirms that the bdev is often changing while the mddev and
disk stay unchanged.  Having that confirmation is useful..

I didn't think that could happen - the bdev should remain pinned while the
mddev exists.  Obviously it doesn't.

I'll see what I can find out.

NeilBrown

