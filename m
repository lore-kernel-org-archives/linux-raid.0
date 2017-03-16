From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 00/15 v2] remove all abuse of bi_phys_segments
Date: Wed, 15 Mar 2017 18:12:12 -0700
Message-ID: <20170316011212.ekibeyjc33vesb2t@kernel.org>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

On Wed, Mar 15, 2017 at 02:05:11PM +1100, Neil Brown wrote:
> This is a revised version of my series to remove all abuse of
> bi_phys_segments from md/raid.
> 
> Most of the effort is for raid5 - raid1 and raid10 are
> comparatively straight forward.
> 
> I've also include some optimization of md_write_start() which is now
> used more heavily.  This now uses percpu-refcount, which needed a
> small modification.

looks quite good, there are some minor issues I replied separately.
 
> As noted in some of these changelogs, a couple of bugs are fixed
> in raid1/raid10.  We should probably create fixes suitable for
> -stable.

At first glance, it seems not easy to create a stable fix. The
bio_inc_remaining only exists in several kernel versions. There isn't easy way
to fix the issue without the per-bio accounting mechanism.

> In this series there is a 'block' patch and a 'percpu-refcount' patch,
> which should probably go in through other trees.  I might send those
> off as appropriate soonish.

Please do. The block patch could go other tree, as it's mostly separately. The
percpu-refcount patch could be a problem if it goes other tree.

Thanks,
Shaohua
