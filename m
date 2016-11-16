From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 3/4] md/bitmap: add blktrace event for writes to the
 bitmap.
Date: Wed, 16 Nov 2016 11:31:31 -0800
Message-ID: <20161116193131.vacrprgi6jz4hkd7@kernel.org>
References: <147910131504.27168.6566119701315109161.stgit@noble>
 <147910142125.27168.1639109067364223445.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147910142125.27168.1639109067364223445.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 14, 2016 at 04:30:21PM +1100, Neil Brown wrote:
> We trace wheneven bitmap_unplug() finds that it needs to write
> to the bitmap, or when bitmap_daemon_work() find there is work
> to do.
> 
> This makes it easier to correlate bitmap updates with data writes.

Looks good. This reminds me if we should do similar thing for md_write_start if
we write superblock. Especially for raid5-cache, as we write superblock regularly.

Thanks,
Shaohua
