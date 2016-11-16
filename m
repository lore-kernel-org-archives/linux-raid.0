From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v6 11/11] md/r5cache: handle alloc_page failure
Date: Tue, 15 Nov 2016 22:54:57 -0800
Message-ID: <20161116065457.ci3aga5dckl4ox7o@kernel.org>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-12-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161110204623.3484694-12-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Thu, Nov 10, 2016 at 12:46:23PM -0800, Song Liu wrote:
> RMW of r5c write back cache uses an extra page to store old data for
> prexor. handle_stripe_dirtying() allocates this page by calling
> alloc_page(). However, alloc_page() may fail.
> 
> To handle alloc_page() failures, this patch adds a small mempool
> in r5l_log. When alloc_page fails, the code tries to allocate a
> page from the mempool.

this is too complicated. Can we just do rcw instead of rmw if page allocation
fails? This way we don't need allocate the memory. This will cause more IO but
since this a rare memory allocation failure case, I think it should be ok.

Thanks,
Shaohua
