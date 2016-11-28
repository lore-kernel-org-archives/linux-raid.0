From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v5] md/r5cache: handle alloc_page failure
Date: Sun, 27 Nov 2016 21:34:50 -0800
Message-ID: <20161128053450.rbilhgupusdmb42k@kernel.org>
References: <20161124065039.2151784-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161124065039.2151784-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Wed, Nov 23, 2016 at 10:50:39PM -0800, Song Liu wrote:
> RMW of r5c write back cache uses an extra page to store old data for
> prexor. handle_stripe_dirtying() allocates this page by calling
> alloc_page(). However, alloc_page() may fail.
> 
> To handle alloc_page() failures, this patch adds an extra page to
> disk_info. When alloc_page fails, handle_stripe() trys to use these
> pages. When these pages are used by other stripe (R5C_EXTRA_PAGE_IN_USE),
> the stripe is added to delayed_list.

Thanks, Applied!
