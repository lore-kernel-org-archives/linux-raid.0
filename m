From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 00/18] Assorted minor fixes, particularly RCU
 protection.
Date: Fri, 3 Jun 2016 15:28:48 -0700
Message-ID: <20160603222848.GA1898@kernel.org>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 02, 2016 at 04:19:52PM +1000, Neil Brown wrote:
> The 'rdev' fields in each personality's config data are often accessed
> under rcu_read_lock() protection to avoid races with
> ->hot_remove_disk() removing the rdev.
> 
> Originally this was not necessary during resync/recovery etc because
> ->hot_remove_disk() was only called from md_check_recovery(), and it
> would only make the call if there was no resync etc happening.
> 
> However we now call ->hot_remove_disk() (from
> remove_and_add_spares()) from other contexts, so there could be a race
> in the resync code.
> 
> So this patch set adds a lot of extra rcu_read_lock protection and
> clean up some other bits and pieces on the way.
> 
> My goal was the final patch.  If you have a large raid10 array and
> fail half of the devices at once (e.g. unplug a rack with half of the
> mirrors) then synchronize_rcu() will be called once for each device,
> which can add up to a big delay.  A single call should suffice.
> The final patch makes that change.

Thanks, make a lot of sense. Actually there is bug report related to RCU.
https://bugzilla.kernel.org/show_bug.cgi?id=116021
I had the same patch of your patch 3 and the bug submitter is trying.

I only had some minor issues, will reply separated. Otherwise this patch set is
great.

Thanks,
Shaohua
