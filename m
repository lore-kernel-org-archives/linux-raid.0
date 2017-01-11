From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4] md/r5cache: enable chunk_aligned_read with write back
 cache
Date: Wed, 11 Jan 2017 14:00:12 -0800
Message-ID: <20170111220012.xg2l42exbself2tp@kernel.org>
References: <20170111213914.2429024-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111213914.2429024-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

On Wed, Jan 11, 2017 at 01:39:14PM -0800, Song Liu wrote:
> Chunk aligned read significantly reduces CPU usage of raid456.
> However, it is not safe to fully bypass the write back cache.
> This patch enables chunk aligned read with write back cache.
> 
> For chunk aligned read, we track stripes in write back cache at
> a bigger granularity, "big_stripe". Each chunk may contain more
> than one stripe (for example, a 256kB chunk contains 64 4kB-page,
> so this chunk contain 64 stripes). For chunk_aligned_read, these
> stripes are grouped into one big_stripe, so we only need one lookup
> for the whole chunk.
> 
> For each big_stripe, struct big_stripe_info tracks how many stripes
> of this big_stripe are in the write back cache. We count how many
> stripes of this big_stripe are in the write back cache. These
> counters are tracked in a radix tree (big_stripe_tree).
> r5c_tree_index() is used to calculate keys for the radix tree.
> 
> chunk_aligned_read() calls r5c_big_stripe_cached() to look up
> big_stripe of each chunk in the tree. If this big_stripe is in the
> tree, chunk_aligned_read() aborts. This look up is protected by
> rcu_read_lock().
> 
> It is necessary to remember whether a stripe is counted in
> big_stripe_tree. Instead of adding new flag, we reuses existing flags:
> STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE. If either of these
> two flags are set, the stripe is counted in big_stripe_tree. This
> requires moving set_bit(STRIPE_R5C_PARTIAL_STRIPE) to
> r5c_try_caching_write(); and moving clear_bit of
> STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE to
> r5c_finish_stripe_write_out().
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

applied, thanks!
