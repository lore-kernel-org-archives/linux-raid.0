From: Shaohua Li <shli@kernel.org>
Subject: Re: [V2 PATCH] md/bitmap: clear bitmap if bitmap_create failed
Date: Fri, 1 Apr 2016 13:04:56 -0700
Message-ID: <20160401200456.GA23256@kernel.org>
References: <1458903614-21498-1-git-send-email-gqjiang@suse.com>
 <1459501729-19224-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459501729-19224-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: neilb@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 01, 2016 at 05:08:49PM +0800, Guoqing Jiang wrote:
> If bitmap_create returns an error, we need to call
> either bitmap_destroy or bitmap_free to do clean up,
> and the selection is based on mddev->bitmap is set
> or not.
> 
> And the sysfs_put(bitmap->sysfs_can_clear) is moved
> from bitmap_destroy to bitmap_free, and the comment
> of bitmap_create is changed as well.

Applied, thanks!
