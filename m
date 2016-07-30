From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid5: fix incorrectly counter of
 conf->empty_inactive_list_nr
Date: Sat, 30 Jul 2016 14:02:16 -0700
Message-ID: <20160730210216.GC9149@kernel.org>
References: <1469686934-1937-1-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469686934-1937-1-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: ZhengYuan Liu <liuzhengyuan@kylinos.cn>
Cc: neilb@suse.com, liuzhengyuang521@gmail.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 28, 2016 at 02:22:14PM +0800, ZhengYuan Liu wrote:
> The counter conf->empty_inactive_list_nr is only used for determine if the
> raid5 is congested which is deal with in function raid5_congested().
> It was increased in get_free_stripe() when conf->inactive_list got to be
> empty and decreased in release_inactive_stripe_list() when splice
> temp_inactive_list to conf->inactive_list. However, this may have a
> problem when raid5_get_active_stripe or stripe_add_to_batch_list was called,
> because these two functions may call list_del_init(&sh->lru) to delete sh from
> "conf->inactive_list + hash" which may cause "conf->inactive_list + hash" to
> be empty when atomic_inc_not_zero(&sh->count) got false. So a check should be
> done at these two point and increase empty_inactive_list_nr accordingly.
> Otherwise the counter may get to be negative number which would influence
> async readahead from VFS.
> 
> Signed-off-by: ZhengYuan Liu <liuzhengyuan@kylinos.cn>
Applied, thanks!
