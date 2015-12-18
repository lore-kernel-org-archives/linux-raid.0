From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] raid5: allow r5l_io_unit allocations to fail
Date: Fri, 18 Dec 2015 12:25:35 +0100
Message-ID: <20151218112535.GB28224@lst.de>
References: <1450390197-19479-1-git-send-email-hch@lst.de> <1450390197-19479-4-git-send-email-hch@lst.de> <20151217234748.GA1860175@devbig084.prn1.facebook.com> <874mfg8qyc.fsf@notabene.neil.brown.name> <20151218015847.GA2146501@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151218015847.GA2146501@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: NeilBrown <neilb@suse.com>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[can you trim your replies please?  I had to trim almost 150 lines of
 junk before getting to your reply!]

> >  	spin_unlock_irqrestore(&log->io_list_lock, flags);
> > 
> > or is that too simplistic?
> 
> maybe add a new list and run the list at the begining of r5l_do_reclaim().

What's the advantage of another list?
