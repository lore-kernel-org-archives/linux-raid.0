From: Shaohua Li <shli@kernel.org>
Subject: Re: [V2 PATCH 00/13] The latest patches for md-cluster
Date: Mon, 2 May 2016 10:49:58 -0700
Message-ID: <20160502174958.GA118736@kernel.org>
References: <1462203200-1375-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462203200-1375-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 02, 2016 at 11:33:07AM -0400, Guoqing Jiang wrote:
> Changes:
> 1. delete no_hijack parameter from bitmap_get_counter
> 2. add one patch from kbuild test robot to remove checkpatch warning
> 3. md-set-MD_CHANGE_PENDING-in-a-spinlocked-region.patch is removed
> from the patchset and it will be post later.
> 
> For cluster raid1, we found some issues and some codes need to be
> improved during the past months, and all the patches are based on
> for-next branch of md tree.
> 
> The patchset also available in github as follows:
> 
> https://github.com/GuoqingJiang/linux/tree/md-for-next

Applied, thanks!
