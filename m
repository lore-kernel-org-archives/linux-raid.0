From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 00/10] Simplify bio splitting and related code.
Date: Tue, 11 Apr 2017 10:01:12 -0700
Message-ID: <20170411170112.4txdyjdat63qpsi6@kernel.org>
References: <149136485390.25893.1797855041954158826.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <149136485390.25893.1797855041954158826.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 05, 2017 at 02:05:50PM +1000, Neil Brown wrote:
> This is part of my little project to make bio splitting
> in Linux uniform and dead-lock free, in a way that will mean
> that we can get rid of all the bioset threads.
> 
> The basic approach is that when a bio needs to be split, we call
> bio_split(), bio_chain() and then generic_make_request().
> We then proceed to handle the remainder without further splitting.
> Recent changes to generic_make_request() ensure that this will
> be safe from deadlocks, providing each bioset is used only once
> in the stack.
> 
> This leads to simpler code in various places.  In particular, the
> splitting of bios that is needed to work around known bad blocks
> is now much less complex.  There is only ever one r1bio per bio.
> 
> As you can see from
>  10 files changed, 335 insertions(+), 540 deletions(-)
> there is a net reduction in code.

Looks good and makes code simpler, applied, thanks Neil! The patch 1 and 6 need
comments in the code to explain how deadlock is avoided though. Care to send a
new patch?

Thanks,
Shaohua

> 
> Thanks,
> NeilBrown
> 
> ---
> 
> NeilBrown (10):
>       md/raid1: simplify the splitting of requests.
>       md/raid1: simplify alloc_behind_master_bio()
>       Revert "block: introduce bio_copy_data_partial"
>       md/raid1: simplify handle_read_error().
>       md/raid1: factor out flush_bio_list()
>       md/raid10: simplify the splitting of requests.
>       md/raid10: simplify handle_read_error()
>       md/raid5: make chunk_aligned_read() split bios more cleanly.
>       md/linear: improve bio splitting.
>       md/raid0: fix up bio splitting.
> 
> 
>  block/bio.c         |   60 ++-------
>  drivers/md/linear.c |   75 +++++------
>  drivers/md/raid0.c  |   73 +++++------
>  drivers/md/raid1.c  |  346 ++++++++++++++++++++-------------------------------
>  drivers/md/raid1.h  |    2 
>  drivers/md/raid10.c |  282 ++++++++++++++----------------------------
>  drivers/md/raid10.h |    1 
>  drivers/md/raid5.c  |   33 +++--
>  drivers/md/raid5.h  |    1 
>  include/linux/bio.h |    2 
>  10 files changed, 335 insertions(+), 540 deletions(-)
> 
> --
> Signature
> 
