From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 4/4] md/bitmap: Don't write bitmap while earlier
 writes might be in-flight
Date: Fri, 4 Nov 2016 17:33:25 -0700
Message-ID: <20161105003325.qnmcu363ocbli74x@kernel.org>
References: <147823807607.6764.8460942745584467311.stgit@noble>
 <147823836359.6764.7855525110697020696.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147823836359.6764.7855525110697020696.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 04, 2016 at 04:46:03PM +1100, Neil Brown wrote:
> As we don't wait for writes to complete in bitmap_daemon_work, they
> could still be in-flight when bitmap_unplug writes again.  Or when
> bitmap_daemon_work tries to write again.
> This can be confusing and could risk the wrong data being written last.

Applied the first 3 patches, thanks!

This one seems not completely solving the race condition. It's still possible
bitmap_daemon_work clears BITMAP_PAGE_NEEDWRITE but hasn't dispatch the IO yet,
bitmap_unplug then does nothing and thinks bitmap is updated to disk. Why don't
we add locking here?

Thanks,
Shaohua 
