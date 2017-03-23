From: Shaohua Li <shli@kernel.org>
Subject: Re: REALLY Fix bug in [md PATCH 02/15] md/raid5: simplfy delaying of
 writes while metadata is updated.
Date: Wed, 22 Mar 2017 19:22:01 -0700
Message-ID: <20170323022201.xuwtjxpkrffny6vy@kernel.org>
References: <148954692173.18641.1294690639716682540.stgit@noble>
 <148954711228.18641.2048575896322496918.stgit@noble>
 <87tw6may1v.fsf@notabene.neil.brown.name>
 <87inn2avsj.fsf@notabene.neil.brown.name>
 <87a88eavi3.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87a88eavi3.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

On Wed, Mar 22, 2017 at 01:35:48PM +1100, Neil Brown wrote:
> On Wed, Mar 22 2017, NeilBrown wrote:
> 
> > Using r1_bio->sector in call_bio_endio is more
> > obviously-correct than bio->bi_iter.bi_sector,
> > though both should have the same value.
> >
> > The inc_pending() call in handle_read_error() was missing.
> > One should always accompany a bio_inc_remaining.
> >
> > Signed-off-by: NeilBrown <neilb@suse.com>
> > ---
> >
> > Sorry, I left an unused variable...
> > NeilBrown
> 
> Sorry again - I replied to the wrong email (not a good day...)
> and gave the wrong subject.
> This should be
>   REALLY Fix bugs in [md PATCH 10/15] md/raid1: stop using bi_phys_segment
> 
> :-(

Thanks, applied all the patches except the 'trace completion' patch.

Thanks,
Shaohua
