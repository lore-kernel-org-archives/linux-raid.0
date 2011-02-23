From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix over-zealous flush_disk when changing device size.
Date: Wed, 23 Feb 2011 21:01:00 +1100
Message-ID: <20110223210100.6d8b95f7@notabene.brown>
References: <20110217165057.5c50e566@notabene.brown>
	<x494o82wq2z.fsf@segfault.boston.devel.redhat.com>
	<905EDD02F158D948B186911EB64DB3D178FAB804@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D178FAB804@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 23 Feb 2011 08:48:09 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> > > This regression was introduced by commit 608aeef17a
> > > which causes check_disk_size_change to call
> > > flush_disk.
> > 
> > This makes sense to me.  Nice write-up, Neil.
> > 
> > Acked-by: Jeff Moyer <jmoyer@redhat.com>
> 
> 
> Neil, Is this fix is ready? If yes, where can I find it?

http://neil.brown.name/git?p=md;a=commitdiff;h=a12b63b6f3f60736aace22259a076dfc0ad84b4a

I'll probably submit it to Linus tomorrow.   Whether or not he accepts it is
a different question - it is not specific to md so he will probably review it
more closely (at least I will ask him to).

NeilBrown

