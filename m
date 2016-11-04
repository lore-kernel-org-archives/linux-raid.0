From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/bitmap: call bitmap_file_unmap once
 bitmap_storage_alloc returns -ENOMEM
Date: Fri, 4 Nov 2016 13:19:54 -0700
Message-ID: <20161104201954.e4vjcsopggm5s53z@kernel.org>
References: <1477880340-23036-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477880340-23036-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 31, 2016 at 10:19:00AM +0800, Guoqing Jiang wrote:
> It is possible that bitmap_storage_alloc could return -ENOMEM,
> and some member inside store could be allocated such as filemap.
> 
> To avoid memory leak, we need to call bitmap_file_unmap to free
> those members in the bitmap_resize.
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

thanks, applied.
