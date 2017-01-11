From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3] md/r5cache: enable chunk_aligned_read with write back
 cache
Date: Wed, 11 Jan 2017 11:55:46 -0800
Message-ID: <20170111195546.ud5pwzdzqagygsps@kernel.org>
References: <20170111184903.1938960-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111184903.1938960-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

On Wed, Jan 11, 2017 at 10:49:03AM -0800, Song Liu wrote:
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

Hmm, this is still not fixed yet. Need the spin_lock to protect the look up.

Also correct commnets should be :
	/*
	 * something
	 */
There are several places you didn't get it right, please fix

Thanks,
Shaohua
